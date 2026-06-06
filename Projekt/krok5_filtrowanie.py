# ============================================================
# KROK 5 - Filtrowanie progiem
# ============================================================
# Rysujemy graf pomijając węzły i strzałki,
# które wystąpiły rzadziej niż podany próg.
#
# prog_zdarzenia - minimalna liczba wystąpień węzła
# prog_przejscia - minimalna liczba wystąpień strzałki
#
# Generujemy 3 wersje:
#   graf_prog_0_0.png   - bez filtrowania
#   graf_prog_500_200.png - średni próg
#   graf_prog_700_500.png - wysoki próg (tylko główna ścieżka)
# ============================================================

import graphviz
from krok2_siec_heurystyczna import w_net
from krok4_graf_czestotliwosci import ev_counter, edge_counter, color_min, color_max, edge_min, edge_max

# --- FUNKCJA FILTRUJĄCA ---

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
            if edge_count < prog_przejscia:                         # pomiń rzadkie strzałki
                continue
            if ev_counter.get(successor, 0) < prog_zdarzenia:      # pomiń jeśli cel ukryty
                continue
            width = 1 + 7 * (edge_count - edge_min) / (edge_max - edge_min)
            G.edge(event, successor,
                   label=str(edge_count),
                   penwidth=str(round(width, 2)))

    nazwa = f'graf_prog_{prog_zdarzenia}_{prog_przejscia}'
    G.render(nazwa, format='png', cleanup=True)
    print(f'Zapisano: {nazwa}.png')



rysuj_z_progiem(0, 0)      
rysuj_z_progiem(500, 200)  
rysuj_z_progiem(700, 500)  
