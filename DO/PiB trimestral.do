clear all
set more off
cd "E:\tsis\inespaña1\"

import excel "E:\tsis\inespaña1\PiBEs.xlsx", sheet("Hoja2") firstrow
 drop if Año==.
gen quarter=yq(Año, Trimestre)
format %tq quarter
rename Andalucía pib
encode comuna, gen(CCAA)
xtset CCAA quarter
tsfilter hp float Cat=pib, s(1600)
gen Cbt1=L.Cat
gen Cbt2=L2.Cat
gen Cat1=F.Cat
gen Cat2=F2.Cat
save PiBq.dta, replace
