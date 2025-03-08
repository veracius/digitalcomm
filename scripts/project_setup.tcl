set partnumber XC7A35TICSG324-1L

set outputdir ./output
file mkdir $outputdir
set files [glob -nocomplain "$outputdir/*"]
if {[llength $files] != 0}{
   #clear folder contents
   puts "Deleting contents of $outputdir"
   file delete -force {*}[glob -directory $outputdir *];
} else {
   puts "$outputdir is empty"
}
