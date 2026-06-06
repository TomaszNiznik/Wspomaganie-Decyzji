# KROK 2 - Budowanie sieci heurystycznej (w_net)
# ============================================================
# Na podstawie workflow_log budujemy słownik następników.
# w_net['Register'] = {'AnalyzeDefect'}
# Czyli: "po Register zawsze następuje AnalyzeDefect"
# ============================================================

from krok1_wczytanie import workflow_log

# --- BUDOWANIE SIECI HEURYSTYCZNEJ ---


w_net = dict()

for w_trace in workflow_log:
    for i in range(len(w_trace) - 1):    
        ev_i = w_trace[i]                
        ev_j = w_trace[i + 1]            

        if ev_i not in w_net:
            w_net[ev_i] = set()          
        w_net[ev_i].add(ev_j)            

print('Sieć heurystyczna:')
for event, successors in sorted(w_net.items()):
    print(f'  {event} -> {sorted(successors)}')
