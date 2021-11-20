set encoding utf8
reset
# set terminal qt enhanced size 1300,1000
set terminal epslatex color solid size 13.5cm,9cm header "\\sffamily\\sansmath"
set output "power_optimization_triplexes2.tex"

fn_01mW  = 'pUIt_01mW.dat'
fn_02mW  = 'pUIt_02mW.dat'
fn_10mW  = 'pUIt_10mW.dat'
lw = 2
ps = 2

decay(x, p1, p2, p3) = p1 * exp(-p2 * x) + p3;

set macros
ranges = "[0:26][-0.05:0.9]"

set xlabel 'time (min)'
set ylabel 'intensity (a. u.)'
set xtics 5
unset ytics

set lmargin at screen 0.05

# 1mw  6.374570e-01, 1.427717e-02
# 2mW  4.877022e-01, 2.531160e-02
# 10mW 1.601716e-01, 1.399611e-01, 4.026313e-03

plot @ranges\
	fn_01mW w p title "1\\,mW" pt 2 ps ps lw lw lc 'red',\
	decay(x, 6.374570e-01, 1.427717e-02, 0) w l lc 'black' notitle, \
	fn_02mW w p title "2\\,mW" pt 4 ps ps lw lw lc 'green',\
	decay(x, 4.877022e-01, 2.531160e-02, 0) w l lc 'black' notitle, \
	fn_10mW w p title "10\\,mW" pt 6 ps ps lw lw lc 'blue',\
	decay(x, 1.601716e-01, 1.399611e-01, 0) w l lc 'black' notitle

set output
