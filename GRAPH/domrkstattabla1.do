
clear all
cd "E:\tsis\inespaña1\GRAPH"
*ssc install markstat, replace
whereis pandoc "E:\archivos de programa\Pandoc\pandoc.exe"
markstat using "E:\tsis\inespaña1\GRAPH\tabla1.stmd",docx


*foreach A in 2007 2010 2013 {
*qui sum PESON if ANOPAR==`A'
*scalar define `A'=r(mean)

*}
