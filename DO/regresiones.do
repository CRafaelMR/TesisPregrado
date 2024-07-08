clear all
set more off
capture log 
set matsize 800

*Definimos directorios: asignamos un nombre
global DTA "E:\tsis\inespaña1\DTA"
global LOG "E:\tsis\inespaña1\LOG"
global OUT "E:\tsis\inespaña1\OUT"
global GRA "E:\tsis\inespaña1\GRAPH"

use "$DTA\baseFinal", clear
tab age_category, gen(age_category_)
tab escuela, gen(escuela_)
tab parity, gen(parity_)
tab ESTUDIOM, gen(ESTUDIOM)

*2.- Estadistica descriptiva*
*i.escuela esta en stand by mientras no los pueda replicar desde 2005-2006
local demograficos age_category_1-age_category_7 parity_1-parity_10 escuela_2-escuela_4 partner desemp NACIOEM
local trimestresHP ultimo medio primer
local temporalesBase i.MESPAR i.CCAA i.ANOPAR
local graficos PESON pib


*3.-Regresiones*

eststo: reg PESON CTL `temporalesBase',robust cluster(PROPAR)
eststo: reg PESON CTL `temporalesBase' `demograficos',robust cluster(PROPAR)
eststo: reg PESON CTL CTF `temporalesBase' `demograficos' , robust cluster(PROPAR)
eststo: reg PESON CTL CTF `temporalesBase' i.CCAAYOB `demograficos' ,robust cluster(PROPAR)
eststo: reg PESON CTL CTF `temporalesBase' i.CCAAYOB i.CCAAMOB `demograficos' ,robust cluster(PROPAR)
eststo: reg malnut CTL `temporalesBase',robust cluster(PROPAR)
eststo: reg malnut CTL `temporalesBase' `demograficos',robust cluster(PROPAR)
eststo: reg malnut CTL CTF `temporalesBase' `demograficos' , robust cluster(PROPAR)
eststo: reg malnut CTL CTF `temporalesBase' i.CCAAYOB `demograficos' ,robust cluster(PROPAR)
eststo: reg malnut CTL CTF `temporalesBase' i.CCAAYOB i.CCAAMOB `demograficos' ,robust cluster(PROPAR)


*eststo xi: reg PESON `trimestresHP' `demograficos', cluster(PROPAR)
*test `demograficos'
esttab est1 est2 est3 est4 est5 est6 est7 est8 est9 est10 using "$OUT\tabla1.rtf", keep(CTL CTF partner desemp  escuela_2 escuela_3 escuela_4 parity_1 parity_2 parity_3 NACIOEM) se(%3.2f) b(3) star(* 0.1 ** 0.05 *** 0.01) unstack nonum replace

*esttab eq1 eq2 eq3 eq4 eq5, b(%10.3f) se(%10.3f) r2 k(CTL CTF SEXO EDADM edadm2 uknwnweek escuela) order(CTL CTF SEXO EDADM edadm2 uknwnweek escuela)
local demograficos age_category_1-age_category_7 parity_1-parity_10 escuela_2-escuela_4 partner desemp NACIOEM
local trimestresHP ultimo medio primer
local temporalesBase i.MESPAR i.CCAA i.ANOPAR
local graficos PESON pib



eststo: reg PESON `trimestresHP' `temporalesBase' ,robust cluster(PROPAR)
eststo: reg PESON `trimestresHP' `temporalesBase' `demograficos',robust cluster(PROPAR)
eststo: reg PESON `trimestresHP' CTF `temporalesBase' `demograficos' , robust cluster(PROPAR)
eststo: reg PESON `trimestresHP' CTF `temporalesBase' i.CCAAYOB `demograficos' ,robust cluster(PROPAR)
eststo: reg PESON `trimestresHP' CTF `temporalesBase' i.CCAAYOB i.CCAAMOB `demograficos' ,robust cluster(PROPAR)
eststo: reg malnut `trimestresHP' `temporalesBase',robust cluster(PROPAR)
eststo: reg malnut `trimestresHP' `temporalesBase' `demograficos',robust cluster(PROPAR)
eststo: reg malnut `trimestresHP' CTF `temporalesBase' `demograficos' , robust cluster(PROPAR)
eststo: reg malnut `trimestresHP' CTF `temporalesBase' i.CCAAYOB `demograficos' ,robust cluster(PROPAR)
eststo: reg malnut `trimestresHP' CTF `temporalesBase' i.CCAAYOB i.CCAAMOB `demograficos' ,robust cluster(PROPAR)
esttab est11 est12 est13 est14 est15 est16 est17 est18 est19 est20 using "$OUT\tabla3.rtf", keep(ultimo medio primer CTF partner desemp escuela_2 escuela_3 escuela_4 parity_1 parity_2 parity_3 NACIOEM) se(%3.2f) b(3) star(* 0.1 ** 0.05 *** 0.01) unstack nonum replace

local demograficos age_category_1-age_category_7 parity_1-parity_10 escuela_2-escuela_4 partner desemp NACIOEM
local trimestresHP ultimo medio primer
local temporalesBase i.MESPAR i.CCAA i.ANOPAR
local graficos PESON pib
foreach var of var PESON malnut{
	foreach i of num 1/4{
	eststo: reg `var' `trimestresHP' CTF `temporalesBase' i.CCAAYOB i.CCAAMOB age_category_1-age_category_7 parity_1-parity_10 partner desemp NACIOEM if escuela_`i'==1 ,robust cluster(PROPAR)
		}
}

esttab est21 est22 est23 est24 est25 est26 est27 est28 using "$OUT\tabla5.rtf", keep(ultimo medio primer CTF partner desemp NACIOEM) se(%3.2f) b(3) star(* 0.1 ** 0.05 *** 0.01) unstack nonum replace







local demograficos age_category_1-age_category_7 parity_1-parity_10 escuela_2-escuela_4 partner desemp NACIOEM
local trimestresHP ultimo medio primer
local temporalesBase i.MESPAR i.CCAA i.ANOPAR
local graficos PESON pib
foreach var of var PESON malnut{
eststo: reg `var' hamiltonT1 hamiltonT2 hamiltonT3 hamiltonF `temporalesBase' i.CCAAYOB i.CCAAMOB `demograficos',robust cluster(PROPAR)
	foreach i of num 1/4{
	eststo: reg `var' hamiltonT1 hamiltonT2 hamiltonT3 hamiltonF `temporalesBase' i.CCAAYOB i.CCAAMOB age_category_1-age_category_7 parity_1-parity_10 partner desemp NACIOEM if escuela_`i'==1 ,robust cluster(PROPAR)
	}
}

esttab  est1 est2 est3 est4 est5 est6 est7 est8 est9 est10 using "$OUT\tabla6.rtf", keep(hamiltonT1 hamiltonT2 hamiltonT3 hamiltonF partner desemp NACIOEM) se(%3.2f) b(3) star(* 0.1 ** 0.05 *** 0.01) unstack nonum replace

*esttab  est29 est30 est31 est32 est33 est34 est35 est36 est37 est38 using "$OUT\tabla6.rtf", keep(hamiltonT1 hamiltonT2 hamiltonT3 hamiltonF partner desemp NACIOEM) se(%3.2f) b(3) star(* 0.1 ** 0.05 *** 0.01) unstack nonum replace
*esttab  est39 est40 est41 est42 est43 est44 est45 est46 using "$OUT\tabla6.rtf", keep(hamiltonT1 hamiltonT2 hamiltonT3 hamiltonF partner desemp NACIOEM) se(%3.2f) b(3) star(* 0.1 ** 0.05 *** 0.01) unstack nonum replace


*Clusters Mesano
local demograficos age_category_1-age_category_7 parity_1-parity_10 escuela_2-escuela_4 partner desemp NACIOEM
local trimestresHP ultimo medio primer
local temporalesBase i.MESPAR i.CCAA i.ANOPAR
local graficos PESON pib
foreach var of var PESON malnut{
	eststo: reg `var' `trimestresHP' CTF `temporalesBase' i.CCAAYOB i.CCAAMOB age_category_1-age_category_7 parity_1-parity_10 partner desemp NACIOEM,robust cluster(mesano)
		
	foreach i of num 1/4{
	eststo: reg `var' `trimestresHP' CTF `temporalesBase' i.CCAAYOB i.CCAAMOB age_category_1-age_category_7 parity_1-parity_10 partner desemp NACIOEM if escuela_`i'==1 ,robust cluster(mesano)
		}
}
esttab  est1 est2 est3 est4 est5 est6 est7 est8 est9 est10 using "$OUT\tabla7.rtf", keep(ultimo medio primer CTF partner desemp NACIOEM) se(%3.2f) b(3) star(* 0.1 ** 0.05 *** 0.01) unstack nonum replace

*esttab est21 est22 est23 est24 est25 est26 est27 est28 using "$OUT\tabla5.rtf", keep(ultimo medio primer CTF partner desemp NACIOEM) se(%3.2f) b(3) star(* 0.1 ** 0.05 *** 0.01) unstack nonum replace
*Clusters HP
local trimestresHP ultimo medio primer
local temporalesBase i.MESPAR i.CCAA i.ANOPAR
local graficos PESON pib
foreach var of var PESON malnut{
	foreach i of num 1/4{
	eststo: reg `var' hamiltonT1 hamiltonT2 hamiltonT3 hamiltonF `temporalesBase' i.CCAAYOB i.CCAAMOB age_category_1-age_category_7 parity_1-parity_10 partner desemp NACIOEM if escuela_`i'==1 ,robust cluster(mesano)
		}
}
esttab  est1 est2 est3 est4 est5 est6 est7 est8 using "$OUT\tabla8.rtf", keep(hamiltonT1 hamiltonT2 hamiltonT3 hamiltonF partner desemp NACIOEM) se(%3.2f) b(3) star(* 0.1 ** 0.05 *** 0.01) unstack nonum replace



*robustez: una regresuion por cada categoria de educacion del censo
local trimestresHP ultimo medio primer
local temporalesBase i.MESPAR i.CCAA i.ANOPAR
local graficos PESON pib
foreach i of num 1/10{
eststo: reg PESON `trimestresHP' CTF `temporalesBase' i.CCAAYOB i.CCAAMOB age_category_1-age_category_7 parity_1-parity_10 partner desemp NACIOEM if ESTUDIOM_`i'==1 ,robust cluster(mesano)
}	
esttab  est1 est2 est3 est4 est5 est6 est7 est8 est9 est10 using "$OUT\robustez ESTUDIOM.rtf", keep(ultimo medio primer CTF partner desemp NACIOEM) se(%3.2f) b(3) star(* 0.1 ** 0.05 *** 0.01) unstack nonum replace

local trimestresHP ultimo medio primer
local temporalesBase i.MESPAR i.CCAA i.ANOPAR
local graficos PESON pib
foreach i of num 1/7{
eststo: reg PESON `trimestresHP' CTF `temporalesBase' i.CCAAYOB i.CCAAMOB age_category_1-age_category_7 parity_1-parity_10 partner desemp NACIOEM if ESTUDIOM_3==1 & age_category_`i'==1 ,robust cluster(mesano)
}	
esttab  est1 est2 est3 est4 est5 est6 est7 est8 est9 est10 using "$OUT\robustez ESTUDIOM.rtf", keep(ultimo medio primer CTF partner desemp NACIOEM) se(%3.2f) b(3) star(* 0.1 ** 0.05 *** 0.01) unstack nonum replace

*HP+Hamilton
local trimestresHP ultimo medio primer
local temporalesBase i.MESPAR i.CCAA i.ANOPAR
local graficos PESON pib
foreach var of var PESON malnut{
	foreach i of num 1/4{
	eststo: reg `var' `trimestresHP' hamiltonT1 hamiltonT2 hamiltonT3 hamiltonF `temporalesBase' i.CCAAYOB i.CCAAMOB age_category_1-age_category_7 parity_1-parity_10 partner desemp NACIOEM if escuela_`i'==1 ,robust cluster(mesano)
		}
}
esttab  est1 est2 est3 est4 est5 est6 est7 est8 using "$OUT\robustez H+HP.rtf", keep(hamiltonT1 hamiltonT2 hamiltonT3 ultimo medio primer hamiltonF partner desemp NACIOEM) se(%3.2f) b(3) star(* 0.1 ** 0.05 *** 0.01) unstack nonum replace

