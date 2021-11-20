set encoding utf8
reset
# set terminal qt enhanced size 1300,1000
#set terminal epslatex color solid size 13.5cm,9cm header "\\sffamily\\sansmath"
#set output "power_optimization_triplexes_pU.tex"
set terminal cairolatex pdf color solid size 13.5cm,9cm header "\\sffamily\\sansmath"
set output "power_optimization_triplexes2_pU.tex"

fn = 'pUI1mW_01.dat'
fn_pUfit = 'pUI1mW_01_pUfit.dat'
fn_pUbands = 'pUI1mW_01_pUbands.dat'
lw = 2
lwfit = 4

du = .06  # band assignment line segment length
zu1 = .02  # first break of the segment - y distance from the beginning
zu2 = .04  # second break of the segment - y distance from the beginning
cyu = .05  # identation of the beginning of the segment from spectrum
cxt = .0  # text shift in x axis
cyt3 = cyu + du + .094  # y shift of text from the band from 3-digit numbers
cyt4 = cyu + du + .12  # y shift of text from the band from 3-digit numbers

decay(x, p1, p2, p3) = p1 * exp(-p2 * x) + p3;

# settings
set macros
ranges = "[700:1800][0.0:1.3]"

set xlabel '$\tilde{\nu}$ (\icm)' offset 0,0.0
set ylabel 'intensity (a. u.)' offset 0,0
set tics scale 0.7
set xtics 200 offset 0,0.0
unset ytics

set tmargin at screen 0.95
set bmargin at screen 0.15
set rmargin at screen 0.95
set lmargin at screen 0.05

# cairo terminal somehow makes line spacing larger than eps output.
set key font ',0.8' spacing 2.5

set style arrow 1 nohead ls 1 lw 1.2 lc rgb 'black'
set style fill transparent solid 0.2 noborder
set style line 1 lc rgb '#0060ad' lt 1 lw lw  # spectrum

plot @ranges\
	fn w l notitle ls 1,\
	fn_pUfit u 1:2:3 w filledcurves notitle lw lwfit lc rgb '#228b22',\
	fn_pUfit u 1:2 w l title 'polyU band~~' lw lwfit lc rgb '#88228b22',\
	fn_pUbands u 1:($2 + $5 + cyu):(0):(zu1) w vectors arrowstyle 1 notitle,\
	fn_pUbands u 1:($2 + $5 + cyu + zu1):($3):($4 + zu2 - zu1) w vectors arrowstyle 1 notitle,\
	fn_pUbands u ($1 + $3):($2 + $4 + $5 + cyu + zu2):(0):(du - zu2) w vectors arrowstyle 1 notitle,\
	fn_pUbands u ($1 + $3 + cxt):((($1 + 0.5) / 1000 < 1) ? ($2 + $4 + $5 + cyt3):\
		($2 + $4 + $5 + cyt4)):(sprintf("\\\\scriptsize %d",$1 + 0.5)) with labels rotate right notitle,\

set output
