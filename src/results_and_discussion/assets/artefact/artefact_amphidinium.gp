set encoding utf8
reset
# set terminal qt enhanced size 1300,1000
set terminal epslatex color solid size 13.5cm,9cm header "\\sffamily\\sansmath"
set output "artefact_amphidinium.tex"

fn = 'amphidinium_spc.dat'
fn_bands = 'amphidinium_bands.dat'
lw = 2

du = .06  # band assignment line segment length
zu1 = .02  # first break of the segment - y distance from the beginning
zu2 = .04  # second break of the segment - y distance from the beginning
cyu = .05  # identation of the beginning of the segment from spectrum
cxt = .0  # text shift in x axis
cyt3 = cyu + du + .094  # y shift of text from the band from 3-digit numbers
cyt4 = cyu + du + .12  # y shift of text from the band from 3-digit numbers

# settings
set macros
ranges = "[400:3000][-0.1:1.3]"

set xlabel '$\tilde{\nu}$ (\icm)'
set ylabel 'intensity (a. u.)'
set xtics 500
unset ytics

set lmargin at screen 0.05


set style arrow 1 nohead ls 1 lw 1.2 lc rgb 'black'
set style line 1 lc rgb '#0060ad' lt 1 lw lw  # spectrum

plot @ranges\
	fn w l notitle ls 1,\
	fn_bands u 1:($2 + $5 + cyu):(0):(zu1) w vectors arrowstyle 1 notitle,\
	fn_bands u 1:($2 + $5 + cyu + zu1):($3):($4 + zu2 - zu1) w vectors arrowstyle 1 notitle,\
	fn_bands u ($1 + $3):($2 + $4 + $5 + cyu + zu2):(0):(du - zu2) w vectors arrowstyle 1 notitle,\
	fn_bands u ($1 + $3 + cxt):((($1 + 0.5) / 1000 < 1) ? ($2 + $4 + $5 + cyt3):\
		($2 + $4 + $5 + cyt4)):(sprintf("\\\\scriptsize %d",$1 + 0.5)) with labels rotate right notitle,\

set output
