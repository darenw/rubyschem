#!/usr/bin/env  ruby  
#
# Simple test file for dswschem.rb


require 'dswschem'  

transistorwidth=0.73*partsp

x1 =  0.7*inch
x2,x3,x4 = bunch(3, x1 + partsp, minsp*1.25)
x5 = x4+minsp
x9 = x5+partsp*1.45
x6,x7,x8 = tween(3, x5, x9, 0.5*minsp)
xleds123=bunch(3, x9+0.2*inch, 1.3*minsp)
xleds456=bunch(3, xleds123.last+0.24*inch, 1.27*minsp)
xleds789=bunch(3, xleds456.last+0.24*inch, 1.27*minsp)
x11 = xleds789.last + minsp*0.7
x10 = xleds123.first - minsp*0.7
x13 = xleds789.last + minsp
x12 = x11+minsp*1.5
x14=x12+partsp*0.4
x15=x14+partsp*0.7
x16=x15+0.21*inch
x17=x16+0.4*inch
x18=x17+transistorwidth
x19=x18+0.32*inch
x20=x19+0.45*inch
x21=x20+transistorwidth+0.11*inch
x22=x21+transistorwidth + 0.2*inch
x23=x22+partsp+4
x24=x23+0.35*inch
x25=x24+transistorwidth
x26=x25+0.25*inch
x27=x26+0.3*inch


y1=7.75*inch-minsp
y2=y1-minsp
y3=y2-partsp-0.1*inch
chipmargin=0.1*partsp
interchip=0.75*inch
y4=y3-0.5*inch
dyDAC=0.66*partsp
y5,y6,y7=bunch(3,y4-chipmargin, -dyDAC)
y8=y7-chipmargin
y9=y8-interchip+0.1*inch
y10,y11,y12=bunch(3,y9-chipmargin, -dyDAC)
y13=y12-chipmargin
y14=y13-interchip
y15,y16,y17=bunch(3,y14-chipmargin,-dyDAC)
y18=y17-chipmargin
y19=y18-0.25*inch
y20=y19-minsp
y21=y20-1.7*minsp
y50=y21-0.3*inch
y22=y50-0.72*inch
y23=(y50+y22)/2
# y24 comes later
y25=y5+0.6*partsp
y26=y10+0.4*inch
y28=y10-0.4*inch
y27=y25-transistorwidth  # Q4 base
y29=y15+2*partsp
y30=nil  # defined later in Q3 circuitry
y31=nil  # see y30



if false
print "\nTWEEN FUNCTION TEST!!   \n"
xxx=[10,60]
print "#{xxx}\n"
ttt=tween(4, xxx, 10) 
print "TWEEN  #{ttt}  DONE\n\n"   # should be space by 10 units
end



sch=Schematic.new("stereo888.ps", [8.5,11.0])


xx555 = [x5+0.1*inch, x9-0.1*inch]  
sch.box( ["IC1","555","clock"], xx555, [y2,y3])
xpins = tween(3, xx555,  margin=0.1*inch)
y=y3-0.22*inch
sch.switch("Run/Stop","V", [x1,x4], y)
sch.line([x4, xpins[0]], y)
sch.line(xpins[0], [y,y3])
sch.gnd [ x1,y]
xleft = xpins.first - partsp
sch.resistor "10k", "^",  [xleft,xpins[0]], y1
sch.resistor "10k", "^",  [xpins[0],xpins[2]], y1
sch.line  xpins.first, [y1,y2]
sch.line  xpins.last, [y1,y2]
sch.dot xpins.first, y1
sch.dot xpins.last, y1
sch.inarrow "+", "^", [xpins.last, y1],  [xpins.last, y1+0.2*inch]
yy1,yy2=bunch(2,y2-0.1*inch, -0.14*inch)
sch.line xleft,  [y1,yy2]
sch.line [xleft,xx555.first], yy1
sch.line [xleft,xx555.first], yy2
ycapbot=yy2-partsp*0.55
sch.cap "1n ", "<",   xleft,  [yy2,ycapbot]
sch.dot xleft, yy1
sch.dot xleft, yy2
sch.gnd  xleft, ycapbot

xx = [x5, x9]
sch.box ["IC2","74177","y counter"],  xx, [y4,y8]
sch.box ["IC3","74177","x counter"],  xx, [y9,y13]
sch.box ["IC4a","74177","z counter"],  xx, [y14,y18]
sch.box ["IC4b","left/right"], xx, [y19,y21]
sch.line [x9,x21], y20
sch.resistor ["R17","L/R seperation","24k"], "^", [x21,x23],y20
y=y20-0.22*inch
y32=y
xmid = (x21+x23)/2
sch.line x21, [y,y20]
sch.line x23, [y,y20]
sch.resistor ["R18", "82k"], "V", [x21, xmid],  y
sch.resistor ["    R19", "    24k"],  "V", [xmid, x23],  y
ycapbot = y32-0.7*partsp
sch.cap ["", "", "C5", "10u"], ">", xmid, [y,ycapbot]
sch.gnd [xmid, ycapbot], [xmid,ycapbot]
sch.dot x21, y20
sch.dot xmid, y

yswtop=y21-1.75*minsp
yswbot =yswtop -partsp*0.95   # used to by y24
sch.line [x2,x4], yswbot
sch.line x2, [yswtop, y5]
sch.line x3, [yswtop, y6]
sch.line x4, [yswtop, y7]
sch.line [x2,x5], y5
sch.line [x3,x5], y6
sch.line [x4,x5], y7
sch.line [x2,x5], y10
sch.line [x3,x5], y11
sch.line [x4,x5], y12
sch.line [x2,x5], y15
sch.line [x3,x5], y16
sch.line [x4,x5], y17
sch.dot x2, y10
sch.dot x3, y11
sch.dot x4, y12
sch.dot x2, y15
sch.dot x3, y16
sch.dot x4, y17
sch.switch " ","", x2, [yswbot, yswtop]
sch.switch " ","", x3, [yswbot, yswtop]
sch.switch " ","", x4, [yswbot, yswtop]
sch.gnd  x3, yswbot

dyunder = 0.16*inch
y = y8-dyunder
x2p = x2 - 0.145*inch
sch.line x1, [y, yswbot]
sch.gnd x1, yswbot
sch.line [x2p,x6],y
sch.line x6, [y,y8]
sch.switch "Load Y",  "^", [x1,x2p], y
y = y13-dyunder
sch.line [x2p,x6],y
sch.line x6, [y,y13]
sch.switch "  Load X",  "^", [x1,x2p], y
sch.dot x1, y
y = y21-dyunder
sch.line [x2p,x6],y
sch.line x6, [y,y21]
sch.switch "  Load Z",  "^", [x1,x2p], y
sch.dot x1, y

sch.box ["IC5   2102", "Static RAM"],  [x10,x11], [y50,y22]
yled3 = y4+0.1*inch
yled2 = yled3+partsp
yled1 = yled2+partsp
sch.line [xleds123.first, xleds789.last+minsp], yled1
sch.gnd  xleds789.last+minsp, yled1
for i in 0..2
	x = xleds123[i]
	sch.line x,  [y50, yled3]
	sch.resistor "","",  x, [yled2, yled3]
	sch.led   "", "", x, [yled1, yled2]
	x = xleds456[i]
	sch.line x,  [y50, yled3]
	sch.resistor "","",  x, [yled2, yled3]
	sch.led   "","", x, [yled1, yled2]
	x = xleds789[i]
	sch.line x,  [y50, yled3]
	sch.resistor "","",  x, [yled2, yled3]
	sch.led  "","",  x, [yled1, yled2]
end
sch.line [x9,x13],y5
sch.line [x9,x13],y6
sch.line [x9,x13],y7
sch.line [x9,x13],y10
sch.line [x9,x13],y11
sch.line [x9,x13],y12
sch.line [x9,x13],y15
sch.line [x9,x13],y16
sch.line [x9,x13],y17
sch.dot xleds123[0], y5
sch.dot xleds123[1], y6
sch.dot xleds123[2], y7
sch.dot xleds456[0], y10
sch.dot xleds456[1], y11
sch.dot xleds456[2], y12
sch.dot xleds789[0], y15
sch.dot xleds789[1], y16
sch.dot xleds789[2], y17
sch.text "LED resistors all 1k", xleds789.last+6,yled2-0.3*inch, fontsize=11
sch.text "LEDs: X,Y,Z addresses", xleds789.last+9,yled2+0.26*inch, fontsize=11
# DAC networks
sch.text ["Digital to ", "Analog Conv.", "all resistors 10k"], 
   x16-4, y17+0.33*inch, fontsize=11.0, dy=11.0
# DAC for Y
sch.resistor  "","",  [x13,x14], y5
sch.resistor  "","",  [x13,x14], y6
sch.resistor  "","",  [x13,x14], y7
sch.resistor  "","",  [x15,x14], y5
sch.resistor  "","",  [x15,x14], y6
sch.resistor  "","",  [x15,x14], y7
sch.resistor  "","",  x15,  [y5,y6]
sch.resistor  "","",  x15,  [y6,y7]
y = y7-0.37*partsp
sch.resistor "","", [x13,x14],y
sch.resistor "","", [x14,x15],y
sch.gnd  x13,y
sch.line  x15, [y, y7]
sch.dot x15, y5
sch.dot x15, y6
sch.dot x15, y7


# DAC for X
sch.resistor  "","",  [x13,x14], y10
sch.resistor  "","",  [x13,x14], y11
sch.resistor  "","",  [x13,x14], y12
sch.resistor  "","",  [x15,x14], y10
sch.resistor  "","",  [x15,x14], y11
sch.resistor  "","",  [x15,x14], y12
sch.resistor  "","",  x15,  [y10,y11]
sch.resistor  "","",  x15,  [y11,y12]
y = y12-0.37*partsp
sch.resistor "","", [x13,x14],y
sch.resistor "","", [x14,x15],y
sch.gnd  x13,y
sch.line  x15, [y, y12]
sch.dot x15, y10
sch.dot x15, y11
sch.dot x15, y12

# DAC for Z
sch.resistor  "","",  [x13,x14], y15
sch.resistor  "","",  [x13,x14], y16
sch.resistor  "","",  [x13,x14], y17
sch.resistor  "","",  [x15,x14], y15
sch.resistor  "","",  [x15,x14], y16
sch.resistor  "","",  [x15,x14], y17
sch.resistor  "","",  x15,  [y15,y16]
sch.resistor  "","",  x15,  [y16,y17]
y = y17-0.305*partsp
sch.resistor "","", [x13,x14],y
sch.resistor "","", [x14,x15],y
sch.gnd  x13,y
sch.line  x15, [y, y17]
sch.dot x15, y15
sch.dot x15, y16
sch.dot x15, y17


sch.line [x15,x16], y5
sch.resistor "1k", ">",  x16, [y5, y5-partsp]
sch.gnd  x16, y5-partsp
sch.cap ["C1", "10u"], "^",  [x16, x19], y5
sch.resistor ["R1","100k", "shrink","with dist"], "<",  x19, [y5, y5-partsp]
sch.line  x19, [y5-partsp, y29]
sch.line [x19,x20], y5
sch.resistor ["R2", "100k"],  "<",  x20, [y5, y5-partsp]
sch.dot x16, y5
sch.dot x19,y5
sch.dot x20,y5
ye=y5-transistorwidth*0.8
yc=y25
sch.npn ["Q1","Y coord","shrink"], ">",  [x20,y5], [x21,ye], [x21,y25]  #B,E,C
sch.diode "D1", "<", x21, [y7,ye]
sch.gnd    x21, y7
sch.gnd x20, y5-partsp
sch.resistor  ["R3","7.5k"], ">", x21, [y25,y25+partsp]
sch.inarrow "+", "^",  [x21,y25+partsp], [x21,y25+partsp*1.1]
sch.cap ["C2","10u"], "^", [x21,x24],  y25
ye=y25-partsp
sch.npn  ["Q4", "dot/blank"], "<", [x25,y27],[x24,ye],[x24,y25]
sch.gnd [x24,ye]
sch.resistor ["R4","24k"], ">", x24,  [y25, y25+partsp]
sch.inarrow  "+",  "^",  [x24, y25+partsp], [x24,y25+1.1*partsp]
sch.outarrow "VERT", "^",  [x24,y25], [x27,y25]
sch.resistor ["R5","10k"], "<", x25, [y27,y27-partsp]
sch.line  x25, [y27-partsp, y23]
sch.line [x25,x11], y23
x=x12
y=y23-0.8*partsp
sch.resistor "1k", ">", x, [y23,y]
sch.led  ["dot state","LED"," ", " ", ""],  ">",  [x+partsp, x], y
sch.gnd [x+partsp,y], [x+partsp, y-0.2*inch]
sch.dot x21, y25
sch.dot x24,y25
sch.dot x12,y23
y=y50-0.15*inch
ygnd=y22-minsp
sch.line [xpins[1],x10], y
sch.switch ["", "Write", "N.O.P.B."], "<", xpins[1], [ygnd,y]
sch.gnd xpins[1],ygnd
y=y-minsp
x=x10-minsp
sch.line [x,x10],y
sch.switch ["Data"], "<", x, [ygnd,y]
sch.gnd x,ygnd

# goes with Q3 but must be drawn before C3 for proper gap/overlap
y=y10+minsp/2
sch.line x18, [y29,y]
sch.resistor ["R12","1k"], "<",  x18, [y, y+partsp]
sch.inarrow "+", "^", [x18,y+partsp],  [x18, y+partsp+3]

sch.line [x15,x16],y10
y=y10-partsp*0.8
sch.resistor ["R6", "1k"], ">", x16, [y10,y]
sch.gnd  [x16, y], [x16, y]
sch.cap ["C3","10u"], "^",  [x16,x18-8],y10
sch.line [x18-8,x21], y10
ye=y10-transistorwidth*0.8
sch.npn ["Q2", "X coord","shrink"], ">", [x21,y10],[x22,ye],[x22,y26]
sch.diode "D2", ">", x22,  [y29,ye]
sch.gnd  x22, y29
y=y29+0.1*inch
sch.resistor ["R8", "100k"], ">", x21, [y10, y]
sch.gnd x21,y
sch.resistor ["R7", "100k", "shrnk"], ">", x20, [y10, y29]
sch.resistor ["R9", "7.5k"], "<", x22, [y26+partsp, y26]
sch.outarrow "+", "^",   [x22, y26+partsp], [x22,y26+partsp*1.1]
sch.cap ["C4","10u"], "^", [x22,x23], y26
sch.line x23, [y26,y20]
sch.outarrow "Horiz", "^", [x23,y26], [x23+0.5*inch, y26]
sch.dot x22,y26
sch.dot x23,y26
sch.dot x23,y20
sch.dot x16, y10

sch.line [x15,x20],  y15
sch.line [x17,x20], y29
ymid=(y29+y15)/2
pemit = [x18,y15+0.5*partsp]
sch.npn  ["Q3"], "^", [x17,ymid],pemit,[x18,y29]
sch.gnd pemit
sch.line [x17,x20], y29
sch.resistor ["", "R10","220k"], "<", x17, [y29,ymid]
sch.resistor ["R11","220k"], "<", x17, [y15,ymid]

# no potentiometer symbol!  must fake it with resistor and outarrow
ypot= [ y29, (2*y29+y15)/3.0, (y29+2*y15)/3.0, y15]
sch.line   x19, [ypot[2],ypot[3]]
sch.line   x20, [ypot[0],ypot[1]]
sch.resistor ["", "R13", "100k"], "LR", x19, [ypot[0],ypot[2]]
sch.resistor [" ", "R14","100k"], "LR", x20, [ypot[1],ypot[3]]
y30=ypot[1]
y31=ypot[2]
potwiper_pullback = 4
sch.outarrow "","", [x22,y30], [x19+potwiper_pullback, y30]
sch.outarrow "","", [x26,y31], [x20+potwiper_pullback, y31]
sch.resistor ["R16","100k", "Y persp", "shear"], ">",    x26, [y25,y31]
sch.dot x26, y25
sch.resistor ["R15", "100k"], "V", [x22,x23], y30
sch.dot x23,y30
sch.dot x19, y29
sch.dot x20, y10
sch.dot x21,y10
sch.dot x20,y29
sch.dot x19,y15


sch.dot x17, y15
sch.dot x17, ymid
sch.dot x18,y29



sch.line xpins[1], [y3,y4]
sch.line xpins[1], [y8,y9]
sch.line xpins[1], [y13,y14]
sch.line xpins[1], [y18,y19]

#sch.text(["Test this text", "writing feature"], 8*inch, y1)
#sch.text(["Test this text", "writing feature"], 5*inch, y1, fontsize=19, dy=10.6)

sch.text  "Stereoscopic 8x8x8 Scope Display", 
         4.9*inch, 7.5*inch, fontsize=22
sch.text "All transistors are 2N2222", 
		6.6*inch,  2.55*inch, fontsize=11
sch.text "Horiz. Rotate",  7.34*inch, 3.61*inch, fontsize=12
sch.text "Vert. Rotate",  7.5*inch, 3.17*inch, fontsize=12
sch.text  ["Daren Scot Wilson", "June 8th, 1979", "redrawn in 2009"],
		  x21, y22, fontsize=10, dy=9
sch.text ["LPF for L/R","perspective","difference"], 6.54*inch, y20-0.21*inch
sch.text  ["stereo888xy.rb", "dswschem.rb","dswschem.ps"], 
		x24-8, y22,  fontsize=10, dy=9
sch.done

print "Really, Totally: Done!\n\n"