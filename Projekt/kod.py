# ============================================================
# MINI PROJEKT - Process Mining
# ============================================================
# Process Mining to analiza logów zdarzeń (event logs).
# Mamy plik .xes z zapisem 1104 napraw telefonów.
# Naszym celem jest odtworzyć z tych danych schemat procesu
# i narysować go jako graf.
# ============================================================

# --- IMPORTY ---
# opyenxes - biblioteka do czytania plików .xes
# graphviz - biblioteka do rysowania grafów
from opyenxes.data_in.XUniversalParser import XUniversalParser
import graphviz
import os
os.chdir(os.path.dirname(os.path.abspath(__file__)))

# --- WCZYTANIE PLIKU ---
# Otwieramy plik .xes i parsujemy go.
# parse() zwraca listę logów - bierzemy pierwszy ([0])
with open('repairexample.xes') as f:
    log = XUniversalParser().parse(f)[0]

print('Wczytano plik!')
print('Liczba przypadków (traces):', len(log))
# --- BUDOWANIE WORKFLOW LOG ---
# Każde zadanie w pliku XES ma dwa wpisy: "start" i "complete".
# Bierzemy tylko "complete" żeby nie liczyć każdego zadania dwa razy.
# workflow_log = lista przypadków, każdy przypadek to lista nazw zdarzeń

workflow_log = []

for trace in log:                          # dla każdego przypadku naprawy
    workflow_trace = []
    for event in trace:                    # dla każdego zdarzenia
        attrs = event.get_attributes()
        transition = attrs.get('lifecycle:transition')
        if transition and transition.get_value() == 'complete':
            name = attrs['concept:name'].get_value()
            workflow_trace.append(name)
    workflow_log.append(workflow_trace)

print('\nPrzykładowe ślady:')
for i, trace in enumerate(workflow_log[:3]):
    print(f'  Przypadek {i+1}:', ' -> '.join(trace))
    # --- BUDOWANIE SIECI HEURYSTYCZNEJ ---
# w_net to słownik: dla każdego zdarzenia przechowuje zbiór jego następników.
# Np. w_net['Register'] = {'AnalyzeDefect'}
# Czyli: "po Register zawsze następuje AnalyzeDefect"
# Przechodzimy przez każdy ślad i patrzymy co po czym następuje.

w_net = dict()

for w_trace in workflow_log:
    for i in range(len(w_trace) - 1):    # dla każdej pary sąsiadujących zdarzeń
        ev_i = w_trace[i]                # zdarzenie obecne
        ev_j = w_trace[i + 1]            # zdarzenie następne

        if ev_i not in w_net:
            w_net[ev_i] = set()          # utwórz pusty zbiór jeśli jeszcze nie ma
        w_net[ev_i].add(ev_j)            # dodaj następnik

print('\nSieć heurystyczna:')
for event, successors in sorted(w_net.items()):
    print(f'  {event} -> {sorted(successors)}')

    # --- RYSOWANIE GRAFU ---
# Tworzymy graf skierowany (Digraph) - strzałki pokazują kolejność zdarzeń.
# rankdir='LR' = układ lewo->prawo (Left to Right)
# shape='Mrecord' = zaokrąglone prostokąty

G = graphviz.Digraph()
G.graph_attr['rankdir'] = 'LR'
G.node_attr['shape'] = 'Mrecord'

for event in w_net:
    G.node(event, style='rounded,filled', fillcolor='#ffffcc')  # żółte węzły
    for successor in w_net[event]:
        G.edge(event, successor)                                 # strzałka do następnika

# render() zapisuje plik - 'graf' to nazwa pliku wynikowego
# format='png' = zapisz jako obrazek
# cleanup=True = usuń pliki tymczasowe
G.render('graf', format='png', cleanup=True)
print('\nGraf zapisany jako graf.png!')

# --- LICZENIE CZĘSTOTLIWOŚCI ---
# ev_counter - ile razy każde zdarzenie wystąpiło
# edge_counter - ile razy wystąpiło każde przejście (strzałka A->B)

ev_counter = dict()
for w_trace in workflow_log:
    for ev in w_trace:
        ev_counter[ev] = ev_counter.get(ev, 0) + 1

edge_counter = dict()
for w_trace in workflow_log:
    for i in range(len(w_trace) - 1):
        edge = (w_trace[i], w_trace[i + 1])
        edge_counter[edge] = edge_counter.get(edge, 0) + 1

print('\nCzestotliwosci zdarzen:')
for ev, count in sorted(ev_counter.items(), key=lambda x: -x[1]):
    print(f'  {ev}: {count}x')

    # --- RYSOWANIE GRAFU Z CZĘSTOTLIWOŚCIAMI ---
# Węzły: im częstsze zdarzenie, tym bardziej pomarańczowy kolor
# Strzałki: im częstsze przejście, tym grubsza linia + etykieta z liczbą

color_min = min(ev_counter.values())
color_max = max(ev_counter.values())
edge_min  = min(edge_counter.values())
edge_max  = max(edge_counter.values())

G = graphviz.Digraph()
G.graph_attr['rankdir'] = 'LR'
G.node_attr['shape'] = 'Mrecord'

for event in w_net:
    count = ev_counter[event]

    # Kolor: liczymy jak bardzo "nasycony" ma być kolor (0-200)
    intensity = int((count - color_min) / (color_max - color_min) * 200 + 55)
    # Im wyższa intensywność, tym ciemniejszy pomarańcz
    hex_val = format(255 - intensity, '02x')
    color = f'#ff{hex_val}00'

    label = f'{event}\n({count}x)'
    G.node(event, label=label, style='rounded,filled', fillcolor=color)

    for successor in w_net[event]:
        edge_count = edge_counter.get((event, successor), 0)

        # Grubość strzałki: od 1 do 8 proporcjonalnie do częstotliwości
        width = 1 + 7 * (edge_count - edge_min) / (edge_max - edge_min)

        G.edge(event, successor,
               label=str(edge_count),
               penwidth=str(round(width, 2)))

G.render('graf_z_czestotliwosciami', format='png', cleanup=True)
print('\nGraf zapisany jako graf_z_czestotliwosciami.png!')

# --- FILTROWANIE PROGIEM ---
# Funkcja rysuje graf ale pomija zdarzenia i strzałki
# które wystąpiły rzadziej niż podany próg.
# prog_zdarzenia - minimalna liczba wystąpień węzła
# prog_przejscia - minimalna liczba wystąpień strzałki

def rysuj_z_progiem(prog_zdarzenia, prog_przejscia):
    G = graphviz.Digraph()
    G.graph_attr['rankdir'] = 'LR'
    G.node_attr['shape'] = 'Mrecord'

    for event in w_net:
        if ev_counter[event] < prog_zdarzenia:  # pomiń rzadkie węzły
            continue

        intensity = int((ev_counter[event] - color_min) / (color_max - color_min) * 200 + 55)
        hex_val = format(255 - intensity, '02x')
        color = f'#ff{hex_val}00'
        label = f'{event}\n({ev_counter[event]}x)'
        G.node(event, label=label, style='rounded,filled', fillcolor=color)

        for successor in w_net[event]:
            edge_count = edge_counter.get((event, successor), 0)
            if edge_count < prog_przejscia:     # pomiń rzadkie strzałki
                continue
            if ev_counter.get(successor, 0) < prog_zdarzenia:  # pomiń jeśli cel ukryty
                continue
            width = 1 + 7 * (edge_count - edge_min) / (edge_max - edge_min)
            G.edge(event, successor,
                   label=str(edge_count),
                   penwidth=str(round(width, 2)))

    nazwa = f'graf_prog_{prog_zdarzenia}_{prog_przejscia}'
    G.render(nazwa, format='png', cleanup=True)
    print(f'Zapisano: {nazwa}.png')

# Generujemy 3 wersje z różnymi progami
rysuj_z_progiem(0, 0)      # bez filtrowania (taki sam jak poprzedni)
rysuj_z_progiem(500, 200)  # średni próg
rysuj_z_progiem(700, 500)  # wysoki próg - tylko główna ścieżka