# ============================================================
# KROK 1 - Wczytanie pliku XES i budowa workflow_log
# ============================================================


from opyenxes.data_in.XUniversalParser import XUniversalParser
import os


FOLDER = os.path.dirname(os.path.abspath(__file__))

# --- WYBÓR PLIKU ---
PLIK = os.path.join(FOLDER, 'repairexample.xes')
#PLIK = os.path.join(FOLDER, 'XES_examples', 'BPI_Challenge_2012.xes')
#PLIK = os.path.join(FOLDER, 'XES_examples', 'BPI_Challenge_2013_closed_problems.xes')
#PLIK = os.path.join(FOLDER, 'XES_examples', 'BPI_Challenge_2013_incidents.xes')
#PLIK = os.path.join(FOLDER, 'XES_examples', 'BPI_Challenge_2013_open_problems.xes')

# --- WCZYTANIE PLIKU ---
print(f'Wczytuję: {PLIK} ...')
with open(PLIK) as f:
    log = XUniversalParser().parse(f)[0]

print('Wczytano plik!')
print('Liczba przypadków (traces):', len(log))

# WYKRYCIE TRYBU FILTROWANIA 

wszystkie_transition = set()
for trace in log:
    for event in trace:
        t = event.get_attributes().get('lifecycle:transition')
        if t:
            wszystkie_transition.add(t.get_value().lower())

ma_complete = 'complete' in wszystkie_transition
print(f'Wartości lifecycle:transition: {wszystkie_transition}')
print(f'Tryb filtrowania: {"tylko complete" if ma_complete else "wszystkie zdarzenia"}')

# --- BUDOWANIE WORKFLOW LOG ---
workflow_log = []

for trace in log:
    workflow_trace = []
    for event in trace:
        attrs = event.get_attributes()
        transition = attrs.get('lifecycle:transition')
        
        if ma_complete:
            # pliki z start/complete - bierzemy tylko complete
            if transition and transition.get_value().lower() == 'complete':
                name = attrs['concept:name'].get_value()
                workflow_trace.append(name)
        else:
            # pliki bez complete - bierzemy każde zdarzenie
            name = attrs.get('concept:name')
            if name:
                workflow_trace.append(name.get_value())

    if workflow_trace:
        workflow_log.append(workflow_trace)

print('Liczba przypadków po filtrowaniu:', len(workflow_log))
print('\nPrzykładowe ślady:')
for i, trace in enumerate(workflow_log[:3]):
    print(f'  Przypadek {i+1}:', ' -> '.join(trace))