clear all
set more off
cd "C:\Users\AlvaroAndres\Desktop\9 semestre\Tesis\Base\Bases Insumo\txt por año"
**Nota: reemplazar directorio,desde Tesis hacia atrás(les enviaré carpeta "Base" comprimida)
**Nota: realizar Keep antes para cada caso, para disminuir tamaño de Base consolidad **

//--2007--//
infile using "dictionary.dct", using("A2007.txt") clear
//keep
save "C:\Users\AlvaroAndres\Desktop\9 semestre\Tesis\Base\Base salida\Por año\A2007.dta"

//--2008--//
infile using "dictionary.dct", using("A2008.txt") clear
//keep
save "C:\Users\AlvaroAndres\Desktop\9 semestre\Tesis\Base\Base salida\Por año\A2008.dta"

//--2009--//
infile using "dictionary.dct", using("A2009.txt") clear
//keep
save "C:\Users\AlvaroAndres\Desktop\9 semestre\Tesis\Base\Base salida\Por año\A2009.dta"

//--2010--//
infile using "dictionary.dct", using("A2010.txt") clear
//keep
save "C:\Users\AlvaroAndres\Desktop\9 semestre\Tesis\Base\Base salida\Por año\A2010.dta"

//--2011--//
infile using "dictionary.dct", using("A2011.txt") clear
//keep
save "C:\Users\AlvaroAndres\Desktop\9 semestre\Tesis\Base\Base salida\Por año\A2011.dta"

//--2012--//
infile using "dictionary.dct", using("A2012.txt") clear
//keep
save "C:\Users\AlvaroAndres\Desktop\9 semestre\Tesis\Base\Base salida\Por año\A2012.dta"

//--2013--//
infile using "dictionary.dct", using("A2013.txt") clear
//keep
save "C:\Users\AlvaroAndres\Desktop\9 semestre\Tesis\Base\Base salida\Por año\A2013.dta"

//--2014--//
infile using "dictionary.dct", using("A2014.txt") clear
//keep
save "C:\Users\AlvaroAndres\Desktop\9 semestre\Tesis\Base\Base salida\Por año\A2014.dta"

//--2015--//
infile using "dictionary.dct", using("A2015.txt") clear
//keep
save "C:\Users\AlvaroAndres\Desktop\9 semestre\Tesis\Base\Base salida\Por año\A2015.dta"

//--2016--//
infile using "dictionary.dct", using("A2016.txt") clear
//keep
save "C:\Users\AlvaroAndres\Desktop\9 semestre\Tesis\Base\Base salida\Por año\A2016.dta"

//--2017--//
infile using "dictionary.dct", using("A2017.txt") clear
//keep
save "C:\Users\AlvaroAndres\Desktop\9 semestre\Tesis\Base\Base salida\Por año\A2017.dta"


//--Consolidada--//
clear all
cd "C:\Users\AlvaroAndres\Desktop\9 semestre\Tesis\Base\Base salida\Por año"

foreach i in 2007/2017 {
use `i', clear
replace ANOPAR==`i'
gen mesano=ym(ANOPAR, MESPAR)
format %tm mesano
save `i', replace
}

use A2007
append using A2008
append using A2009
append using A2010
append using A2011
append using A2012
append using A2013
append using A2014
append using A2015
append using A2016
append using A2017
save "C:\Users\AlvaroAndres\Desktop\9 semestre\Tesis\Base\Base salida\Consolidada\A2007-17.dta"

