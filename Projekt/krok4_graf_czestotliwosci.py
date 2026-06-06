# KROK 4 - Liczenie częstotliwości i graf z kolorami
import graphviz
from krok1_wczytanie import workflow_log
from krok2_siec_heurystyczna import w_net

# --- LICZENIE CZĘSTOTLIWOŚCI ---

ev_counter = dict()
for w_trace in workflow_log:
    for ev in w_trace:
        ev_counter[ev] = ev_counter.get(ev, 0) + 1

edge_counter = dict()
for w_trace in workflow_log:
    for i in range(len(w_trace) - 1):
        edge = (w_trace[i], w_trace[i + 1])
        edge_counter[edge] = edge_counter.get(edge, 0) + 1

print('Częstotliwości zdarzeń:')
for ev, count in sorted(ev_counter.items(), key=lambda x: -x[1]):
    print(f'  {ev}: {count}x')

# --- RYSOWANIE GRAFU Z CZĘSTOTLIWOŚCIAMI ---

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
