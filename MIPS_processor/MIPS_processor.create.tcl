cd C:/Users/sondree/Desktop/assignment1SimpleProc_new/MIPS_processor
if { [xload new MIPS_processor.xmp] != 0 } {
  exit -1
}
xset arch aspartan6
xset dev xa6slx16
xset package csg324
xset speedgrade -3
if { [xset hier sub] != 0 } {
  exit -1
}
set bMisMatch false
set xpsArch [xget arch]
if { ! [ string equal -nocase $xpsArch "aspartan6" ] } {
   set bMisMatch true
}
set xpsDev [xget dev]
if { ! [ string equal -nocase $xpsDev "xa6slx16" ] } {
   set bMisMatch true
}
set xpsPkg [xget package]
if { ! [ string equal -nocase $xpsPkg "csg324" ] } {
   set bMisMatch true
}
set xpsSpd [xget speedgrade]
if { ! [ string equal -nocase $xpsSpd "-3" ] } {
   set bMisMatch true
}
if { $bMisMatch == true } {
   puts "Settings Mismatch:"
   puts "Current Project:"
   puts "	Family: aspartan6"
   puts "	Device: xa6slx16"
   puts "	Package: csg324"
   puts "	Speed: -3"
   puts "XPS File: "
   puts "	Family: $xpsArch"
   puts "	Device: $xpsDev"
   puts "	Package: $xpsPkg"
   puts "	Speed: $xpsSpd"
   exit 11
}
#default language
xset hdl vhdl
xset intstyle ise
save proj
exit
