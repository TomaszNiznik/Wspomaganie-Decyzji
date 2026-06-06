
# KROK 3 - Rysowanie prostego grafu (bez częstotliwości)

import graphviz
from krok2_siec_heurystyczna import w_net

# --- RYSOWANIE GRAFU ---
# rankdir='LR' = układ lewo->prawo (Left to Right)
# shape='Mrecord' = zaokrąglone prostokąty

G = graphviz.Digraph()
G.graph_attr['rankdir'] = 'LR'
G.node_attr['shape'] = 'Mrecord'

for event in w_net:
    G.node(event, style='rounded,filled', fillcolor='#ffffcc')  # żółte węzły
    for successor in w_net[event]:
        G.edge(event, successor)                                 # strzałka do następnika


G.render('graf', format='png', cleanup=True)
print('Graf zapisany jako graf.png!')
