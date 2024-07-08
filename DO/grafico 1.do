clear all
global DTA "E:\tsis\inespaña1\DTA"
global LOG "E:\tsis\inespaña1\LOG"
global OUT "E:\tsis\inespaña1\OUT"
global GRA "E:\tsis\inespaña1\GRAPH"

cd "$DTA"
use colapso.dta
label variable PESON  "promedio de peso al nacer"
label variable pib "Producto Interno"
label variable quarter "Trimestre"
label variable malnut "Prob. de peso menor a 2500gm"
label variable age "Edad de la madre"
label variable EDADP "Edad del padre"
tsset quarter, q
twoway (tsline  PESON, recast(connected)  yaxis(1) msymbol(t) lwidth(thin)) (tsline pib, recast(connected) lpattern(dot) yaxis(2) msymbol(O) lwidth(medium))
graph export "$GRA\Pibpeso.png", replace
twoway (tsline  malnut, recast(connected)  yaxis(1) msymbol(t) lwidth(thin)) (tsline pib, recast(connected) lpattern(dot) yaxis(2) msymbol(O) lwidth(medium))
graph export "$GRA\LBWpeso.png",replace
twoway (tsline  age, recast(connected)  yaxis(1) msymbol(T) lwidth(thin)) (tsline EDADP, recast(connected) lpattern(D) yaxis(1) msymbol(O) lwidth(medium))
graph export "$GRA\edades padres.png", replace



