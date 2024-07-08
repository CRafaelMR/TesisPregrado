clear all
set more off
capture log 
set matsize 800

*Definimos directorios: asignamos un nombre
global DTA "E:\tsis\inespaña1\DTA"
global LOG "E:\tsis\inespaña1\LOG"
global OUT "E:\tsis\inespaña1\OUT"
global GRA "E:\tsis\inespaña1\GRAPH"

*instalacion de comandos relevantes
foreach ado in coefplot scheme-burd estout {
    cap which `ado'
    if _rc!=0 ssc install `ado'
}

set scheme burd4 

log using "$LOG/bebes.log", replace

*decodificacion de formato ASCII*
cd "$DTA"

foreach i of num 2005 2006{
infile using "$DTA\dic_1996.dct", using("$DTA\A`i'.TXT") clear
save `i'.dta,replace
}
*decodificacion de 2007-2017
foreach i of num 2007/2017 {
infile using "$DTA\dic_2007.dct", using("$DTA\A`i'.TXT") clear
save `i'.dta,replace
}

foreach i of num 2007/2017 {
use `i', clear
keep MESPAR ANOPAR PROPAR MULTIPLI CESAREA SEMANAS NACIOEM ESTUDIOM ECIVM NACIOEP ESTUDIOP EDADM EDADP SEXO PESON NACVN ANOREL NUMHVT CAUTOM PHECHO ECIVM
gen mesano=ym(ANOPAR, MESPAR)
format %tm mesano
*rename V24HN v24h
*replace v24h=0 if v24==2
*rename NACVN nacvivo
*replace nacvivo=0 if nacvivo==2
*keep if nacvivo==1
keep if NACVN==1
rename NUMHVT parity

rename EDADM age
gen age_category=1 if age>=15 & age<=19
replace age_category=2 if age>=20 & age<=24
replace age_category=3 if age>=25 & age<=29
replace age_category=4 if age>=30 & age<=34
replace age_category=5 if age>=35 & age<=39
replace age_category=6 if age>=40 & age<=44
replace age_category=7 if age>=45 & age<=49
/*01= No sabe leer o escribir; 
02=Sabe leer y escribir pero fue menos de 5 años a al escuela; 
03=Fue a la escuela 5 años o mas pero sin completar EGB, ESO  o Bachillerato Elemental; 
04= Bachiller Elemental, EGB o ESO completa (Graduado Escolar); 
05= Bachiller Superior, BUP, Bachiller LOGSE, COU, PREU; 
06= FPI, FP grado medio, Oficialia Industrial o equivalente; 
07= FPII, FP superior, Maestría industrial o equivalente; 
08= Diplomatura, Arquitectura o Ingeniería Técnica; 3 cursos aprobados de Licenciatura, Ingeniería o Arquitectura; 
09= Arquitectura, Ingeniería, Licenciatura o equivalente; 
10= Doctorado ; 
00 o blanco= no consta
*/
gen escuela=1 if ESTUDIOM<=3
replace escuela=2 if ESTUDIOM==4 | ESTUDIOM==5 | ESTUDIOM==6
replace escuela=3 if ESTUDIOM>=7
replace escuela=0 if ESTUDIOM==.
replace PHECHO=0 if PHECHO==2
gen malnut=0
replace malnut=1 if PESON<=2500
gen partner=0
replace partner=1 if PHECHO==1 | ECIVM==1
gen cohabest=0
replace cohabest=1 if escuela>=2 & partner==1
replace SEXO=0 if SEXO==6
gen sinsemana=1 if SEMANAS==0
replace sinsemana=0 if SEMANAS!=0
replace sinsemana=1 if SEMANAS==.
/*
01= Fuerzas armadas; 
02= Dirección de las empresas y de las administraciones públicas; 
03= Técnicos y profesionales científicos e intelectuales; 
04=Técnicos y profesionales de apoyo; 
05= Empleados de tipo administrativo; 06= Trabajadores de los servicios de restauración; 
07= Trabajadores cualificados en la agricultura y la pesca; 
08= Artesanos y trabajadores cualificados de las industrias manufactureras, la construcción, y la minería, excepto los operadores de instalaciones y maquinaria; 
09= Operadores de instalaciones y maquinaria y montadores; 
10= Trabajadores no cualificados;
 11= Estudiantes; 
12= Personas que realizan o comparten las tareas del hogar;
 13= Pensionistas/rentistas; 
 00 o blanco = No consta o Personas que no pueden ser clasificadas
*/

replace CAUTOM=0 if CAUTOM==.
gen desemp=0
replace desemp=1 if CAUTOM==0
gen jovendesemp=0
replace jovendesemp=1 if (age_category==1 |age_category==2 | age_category==3) & desemp==1
drop CAUTOM

*generacion de trimestres
gen trimestre=1 if MESPAR==1 |MESPAR==2 | MESPAR==3
replace trimestre=2 if MESPAR==4 |MESPAR==5 | MESPAR==6
replace trimestre=3 if MESPAR==7 |MESPAR==8 | MESPAR==9
replace trimestre=4 if MESPAR==10 |MESPAR==11 | MESPAR==12
gen quarter=yq(ANOPAR, trimestre)
format %tq quarter
*generacion de comunidades
gen CCAA=1 if PROPAR==4 |PROPAR==11|PROPAR==14	|PROPAR==18	|PROPAR==21	|PROPAR==23	|PROPAR==29	|PROPAR==41	
replace CCAA=2 if PROPAR==22 |PROPAR==44 |PROPAR==50
replace CCAA=3 if PROPAR==33
replace CCAA=4 if PROPAR==7
replace CCAA=5 if PROPAR==35 |PROPAR==38
replace CCAA=6 if PROPAR==39
replace CCAA=7 if PROPAR==05 |PROPAR==09 |PROPAR==24	|PROPAR==34	|PROPAR==37	|PROPAR==40	|PROPAR==42	|PROPAR==47	|PROPAR==49
replace CCAA=8 if PROPAR==02 |PROPAR==13 |PROPAR==16	|PROPAR==19	|PROPAR==45
replace CCAA=9 if PROPAR==08 |PROPAR==17 |PROPAR==25	|PROPAR==43
replace CCAA=10 if PROPAR==3 |PROPAR==12 |PROPAR==46
replace CCAA=11 if PROPAR==6 |PROPAR==10
replace CCAA=12 if PROPAR==15 |PROPAR==27 |PROPAR==32 |PROPAR==36
replace CCAA=13 if PROPAR==28
replace CCAA=14 if PROPAR==30
replace CCAA=15 if PROPAR==31
replace CCAA=16 if PROPAR==1 |PROPAR==48 |PROPAR==20
replace CCAA=17 if PROPAR==26
*drop if CCAA==.
replace CCAA=18 if PROPAR==51
replace CCAA=19 if PROPAR==52
save `i', replace
}

*generacion de base de PIB trimestral
clear
import excel "$DTA\PiBEs.xlsx", sheet("Hoja2") firstrow
 drop if Año==.
gen quarter=yq(Año, Trimestre)
format %tq quarter
rename Andalucía pib
encode comuna, gen(CCAA)
xtset CCAA quarter
drop H
drop E
drop F
drop G
drop I
drop J
drop K
*aqui usamos el filtro HP para separar el sesgo
tsfilter hp float Ct0=pib, s(1600)
gen Ctl1=L.Ct0
gen Ctl2=L2.Ct0
gen Ctl3=L3.Ct0
gen Ctf1=F.Ct0
gen Ctf2=F2.Ct0
gen Ctf3=F3.Ct0
*generacion del filtro diseñado por Hamilton
qui: reg pib L.pib L2.pib L3.pib L4.pib
predict hamilton, residuals
gen hamiltonL1=L1.hamilton
gen hamiltonL2=L2.hamilton
gen hamiltonL3=L3.hamilton
gen hamiltonF1=F1.hamilton
gen hamiltonF2=F2.hamilton
gen hamiltonF3=F3.hamilton

save PiBq.dta, replace


*pib de toda españa
clear
import excel "$DTA\PiBEs.xlsx", sheet("Hoja1") firstrow
drop if Año==.
gen quarter=yq(Año, Trimestre)
format %tq quarter
tsset quarter
rename pibes PIBES
tsfilter hp float pibes0=PIBES
gen pibesl1=L.pibes0
gen pibesl2=L2.pibes0
gen pibesl3=L3.pibes0
gen pibesf1=F.pibes0
gen pibesf2=F2.pibes0
gen pibesf3=F3.pibes0
save pibes.dta, replace


*fusion de bases de bebes entre si
use "$DTA\2007", clear
append using 2006
append using 2005
foreach i of num 2008/2017{
append using `i'
}

*fusion de bases del pib y de los nacidos, usando la comunidad aislada y el semestre como ejes de union
merge m:1 CCAA quarter using PiBq.dta
rename _merge merge1
merge m:1 quarter using pibes.dta
rename _merge merge2
gen CCAAYOB=CCAA*ANOPAR
gen CCAAMOB=CCAA*MESPAR
gen m=(MESPAR/3)-(trimestre-1)
gen ultimo=m*Ct0+(1-m)*Ctl1
gen medio=m*Ctl1+(1-m)*Ctl2
gen primer=m*Ctl2+(1-m)*Ctl3
gen CTL=(primer+medio+ultimo)/3
gen post1=(1-m)*Ct0+m*Ctf1
gen post2=(1-m)*Ctf1+m*Ctf2
gen post3=(1-m)*Ctf2+m*Ctf3
gen CTF=(post1+post2+post3)/3
gen CTLes=(m*pibes0+pibesl1+pibesl2+(1-m)*pibesl3)/3
gen CTFes=((1-m)*pibes0+pibesf1+pibesf2+(m)*pibesf3)/3
gen hamiltonL=(m*hamilton+hamiltonL1+hamiltonL2+(1-m)*hamiltonL3)/3
gen hamiltonF=((1-m)*hamilton+hamiltonF1+hamiltonF2+(1-m)*hamiltonF3)/3
gen hamiltonT3=m*hamilton+(1-m)*hamiltonL1
gen hamiltonT2=m*hamiltonL1+(1-m)*hamiltonL2
gen hamiltonT1=m*hamiltonL2+(1-m)*hamiltonL3

count
drop if PESON==.
count
keep if age>15 & age<=49
drop if PESON<500 & PESON!=.
keep if MULTIPLI==1
count if CCAA==18 | CCAA==19
save baseFinal, replace

clear 
use "$DTA\baseFinal", clear
tab age_category, gen(age_category_)
tab escuela, gen(escuela_)
tab parity, gen(parity_)


*2.- Estadistica descriptiva*
*i.escuela esta en stand by mientras no los pueda replicar desde 2005-2006
local demograficos age_category_1-age_category_7 parity_1-parity_10 escuela_2-escuela_4 partner desemp NACIOEM
local trimestresHP ultimo medio primer
local temporalesBase i.MESPAR i.CCAA i.ANOPAR
local graficos PESON pib

/*
preserve
collapse age EDADP PESON pib Ct0 hamilton, by(quarter)
save "$DTA\colapso.dta.jpg", replace
twoway (tsline  PESON, recast(connected)  yaxis(1)  msymbol(O) lwidth(thin)) (tsline pib, recast(connected) lpattern(dot) yaxis(2) msymbol(Oh) lwidth(medium))
graph save "$GRA\pesonpib.jpg", replace
twoway (tsline  PESON, recast(connected)  yaxis(1) msymbol(O) lwidth(thin)) (tsline Ct0, recast(connected) lpattern(dot) yaxis(2) msymbol(Oh) lwidth(medium))
graph save "$GRA\pesonHP.jpg", replace
twoway (tsline  PESON, recast(connected)  yaxis(1) msymbol(O) lwidth(thin)) (tsline hamilton, recast(connected) lpattern(dot) yaxis(2) msymbol(Oh) lwidth(medium))
graph save "$GRA\pesonHamilton.jpg", replace
twoway (tsline  malnut, recast(connected)  yaxis(1)  msymbol(O) lwidth(thin)) (tsline pib, recast(connected) lpattern(dot) yaxis(2) msymbol(Oh) lwidth(medium))
graph save "$GRA\malnutpib.jpg", replace
twoway (tsline  malnut, recast(connected)  yaxis(1) msymbol(O) lwidth(thin)) (tsline Ct0, recast(connected) lpattern(dot) yaxis(2) msymbol(Oh) lwidth(medium))
graph save "$GRA\malnutHP.jpg", replace
twoway (tsline  malnut, recast(connected)  yaxis(1) msymbol(O) lwidth(thin)) (tsline hamilton, recast(connected) lpattern(dot) yaxis(2) msymbol(Oh) lwidth(medium))
graph save "$GRA\malnutHamilton.jpg", replace
restore

preserve 
collapse PESON, by(ANOPAR escuela)
xtset escuela ANOPAR, y
label variable escuela "Tipo de educación"
label define educación 0 "Sin información" 1 "Primaria completa" 2 "secundaria completa" 3 "Educación superior"
label values escuela educación
twoway (tsline  PESON if escuela==0, recast(connected) legend(sin información educacional) yaxis(1) msymbol(O) lwidth(thin)) (tsline PESON if escuela==1, recast(connected) legend(educación primaria o menos) lpattern(Th) yaxis(1) msymbol(Oh) lwidth(medium))(tsline  PESON if escuela==2, recast(connected) legend(educación secundaria) yaxis(1) msymbol(T) lwidth(thin))(tsline  PESON if escuela==3, recast(connected) legend(educación superior) yaxis(1) msymbol(O) lwidth(thin))
restore
*/

*foreach yvar of partner cohabest jovendesemp sinsemana ppresente {
*graph twoway scatter PESON `yvar' if `yvar'==1, msymbol(Oh) jitter(6) || scatter PESON `yvar' if `yvar'==0, msymbol(X) jitter(6) 
*graph export "$GRA/PESON_`yvar'.png", replace
*}


*twoway tsline age, recast(connected)  msymbol(O) lwidth(thin) leg(label( 1 "Edad de Madre Primeriza")) ||tsline EDADP, recast(connected) leg(label(2 "Edad de Padre Primerizo")) lpattern(dot) msymbol(Oh) lwidth(medium) ttitle(Trimestre)
