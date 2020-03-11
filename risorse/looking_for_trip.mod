#INSIEMI
set B; #insieme dei box
set D; #insieme delle destinazioni
set E; #insieme degli extra
#PARAMETRI
param N {B, D}; #notti incluse 
param Di {B}; #disponibilità dei box (capacità)
param Ex {B, E}; #extra inclusi
param C {B}; #costo di ogni box
param T {D}; #tassa per notte di ogni hotel
param R {D}; #recensione di ogni hotel
param G; #costante grande almeno quanto il min numero di notti della vacanza
#VARIABILI
var x {B, D} >= 0 integer; #box acquistati
var y {B, D} binary; #variabile logica: vale 1 se si compra un tipo di box, 0 altrimenti
var z binary;
var w {B} binary;
#FUNZIONE OBIETTIVO
minimize costo_totale: sum {i in B} (C[i] * sum {j in D} (x[i, j]) + 
sum {j in D} (x[i, j] * N[i, j] * T[j])) - 100 * z - 0.35 * sum {i in B} (w[i] * C[i] * sum {j in D} (x[i, j])) - 
5 * sum {j in D} (x['blue', j] * N['blue', j]); 
#VINCOLI
s.t. disponibilita {i in B}: sum {j in D} x[i, j] <= Di[i]; 
s.t. notti: sum {i in B, j in D} N[i, j] * x[i, j] >= G - 1;
s.t. recensioni: sum {j in D} (R[j] * sum {i in B} (N[i,j]*x[i, j])) >= 3 * sum {i in B, j in D} (N[i,j]*x[i, j]);
s.t. 5notti: sum {i in B} N[i, 'cagliari'] * x[i, 'cagliari'] >= 5;
s.t. completo {j in D}: sum {i in B} x[i, j] >= 1;
s.t. pasti {i in B, j in D}: y[i, j] <= Ex[i, 'colazione'] + Ex[i, 'cena']; 
s.t. attivazione {i in B, j in D}: x[i, j] <= Di[i] * y[i, j];
s.t. voloF {i in B}: y[i, 'foggia'] <= Ex[i, 'volo'];
s.t. voloC {i in B}: y[i, 'cagliari'] <= Ex[i, 'volo'];
s.t. parkV {i in B}: y[i, 'venezia'] <= Ex[i, 'parcheggio'];
s.t. parkT {i in B}: y[i, 'torino'] <= Ex[i, 'parcheggio'];
s.t. 3extra {i in B}: y[i, 'venezia'] <= sum {k in E} (Ex[i, k]) / 3;
s.t. nocena {i in B}: y[i, 'cagliari'] <= 1 - Ex[i, 'cena'];
s.t. sconto1: z <= sum {j in D} x['red', j];
s.t. sconto2: z <= sum {j in D} x['black', j];
s.t. sconto3 {i in B}: N[i, 'foggia'] * x[i, 'foggia'] >= 6 * w[i];
s.t. nofoggiarino: y['white', 'foggia'] + y['white','torino'] <= 1;
