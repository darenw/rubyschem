# dswschem.rb defines resistors, capacitors, FETs etc as postscript commands
#
# coords: ultimately in postscript's points, which are 72 per inch
#  X from left to right
#  Y from bottom of page upward
#  (0,0) is bottom left corner of margin

require "dswschemextras.rb"    # pieces of PS code that may be needed


$inch = 72.0
$cm   = $inch/2.5400
$minsp  = 0.125*$inch       # default smallest spacing between parallel lines
$partsp  = 0.615*$inch     # typical part size with a little margin


# Avoid typing the annoying '$' all the time
def inch 
	return $inch
end

def cm
	return $cm
end

def minsp
	return $minsp
end

def partsp
	return $partsp
end




def bunch(n, x0, dx)
	# create (n) values starting at x0 spaced by dx
	xx=[ ]
	n.times { |i|  xx+=[x0+i*dx] }
	return xx
end


def  tween(n, x1, x2=nil , margin=0)
	# create (n) values spread evenly between two values given in array xx,
	# minus a margin at each end.  
	# If the margin is negative, the produced values spread beyond 
	# the given xx range.
	# Get average between two values with n=1; margin is ignored
	if n<=0
		print "ERROR: tween(n<=0, ...) "
		exit
	end
	#print "tween given class of x1 #{x1.class}, of x2 is #{x2.class}\n"
	if x1.class==Array  
		#print "need to dissect.  x2=#{x2} "
		#print " margin is #{margin}\n"
		if x2!=nil
			margin=x2
		end
		x1,x2=x1[0],x1[1]
		#print "tween dissected class of x1 #{x1.class}, of x2 is #{x2.class}\n"
	end
	if n==1
		return (x1+x2)/2
	end
	s = x1<x2 ?  1 : -1
	x1mod = x1 + margin*s
	x2mod = x2 - margin*s
	return bunch(n, x1mod, (x2mod-x1mod)/(n-1.0))
end



class Schematic

	def initialize(psfilename, pagesize, margins=0.75)
		@psfile = File.open(psfilename, "w")
		partfile = File.open("dswschem.ps", "r")
		while line=partfile.gets
			@psfile.write(line)
		end
		@psfilename=psfilename   # to print when done
	end
	

	def writelabel(label)
		if label==nil or (label.class==String and label=="")
			return
			# hope that idiot human has remembered labpos must also be nil or ""
		else
			if label.class==String
				label=[label]
			end
			r = "["
			label.each {|t|  r+="(#{t})"}
			r = r + "] "
			@psfile.print "#{r} "
		end
	end

	
	def  labelpos(labpos)
		# convert "<" etc used in .rb to keyword used in .ps
		if labpos==nil or labpos==""   # if there's no label, is ok to have no labpos
			return " "
		elsif labpos=="^"
			return "PartLabelAbove"
		elsif labpos=="V" or labpos=="v"
			return "PartLabelBelow"
		elsif labpos=="<"
			return "PartLabelLeft"
		elsif labpos==">"
			return "PartLabelRight"
		elsif labpos=="LR"
			return "PartLabelLowerRight"   # new! added July 2009
		elsif labpos=="C" or labpos=='c'
			return "PartLabelCenter"
		else
			print "ERROR: goofy label position \"labpos\"\n"
			return " "
		end
	end
	
	
	def wrpoint(p,y=nil)
		# write x, y  either from one point given as an array [x,y] or from two args x, y 
		if y   # then args are scalars x, y
			@psfile.write "#{p} #{y} "
		else
			@psfile.write "#{p[0]} #{p[1]} "
		end
	end
	
	
	# standard way to draw most parts
	def typicalpart(label,labpos, xx, yy,  psproc, extrastuff=nil)
		# label is ["firstline", "2nd line" ... ]
		# label pos is '<'  '>'  '^'  'V' to point where it goes
		# 'C' for center
		# xx, yy are normally two coords, but one or other can be scalar
		# if an x or y value is repeated in q, use $same
		
		if xx.class!=Array
			xx=[xx,xx]
		elsif yy.class!=Array
			yy=[yy,yy]
		end
		writelabel(label)
		@psfile.write "#{xx[0]} #{yy[0]} "
		@psfile.write "#{xx[1]} #{yy[1]} "
		if extrastuff
			@psfile.write extrastuff
		end
		@psfile.write " #{psproc} #{labelpos(labpos)} \n"
	end
	
	
	def box(label, xx,yy)
		# label goes only in center
		writelabel(label)
		if xx.class!=Array or (xx.class==Array and xx.size<=1)
			print "ERROR: need Array of two x coords for box"
		end
		if yy.class!=Array or (yy.class==Array and yy.size<=1)
			print "ERROR: need Array of two y coords for box"
		end
		@psfile.print "#{yy[0]} #{yy[1]} #{xx[0]} #{xx[1]} Box  PartLabelCenter\n"
	end
	

	
	def resistor(label, labpos, xx, yy)
		typicalpart(label,labpos,xx,yy,"Res")
	end
	
	
	def diode(label, labpos, xx,yy)
		typicalpart(label,labpos,xx,yy, "Diode")
	end
	
	
	def led(label, labpos, xx,yy)
		typicalpart(label,labpos,xx,yy, "LED")
	end
	
	
	def crystal(label, labpos, xx,yy)
		typicalpart(label,labpos,xx,yy, "Crystal")
	end
	
	
	def cap(label, labpos, xx,yy)
		typicalpart(label,labpos,xx,yy, "Cap")
	end
	
	
	def electrocap(label, labpos, xx,yy)
		typicalpart(label,labpos,xx,yy, "ElectroCap")
	end
	
	
	def varcap(label, labpos, xx,yy)
		typicalpart(label,labpos,xx,yy, "VarCap")
	end
	
	
	def coil(label, labpos, xx,yy,  iron=false)
		# we write indication of iron core symbol with "true" or "false"
		#lucky that ruby's text form "true" and "false" also work in PS
		typicalpart(label,labpos, xx,yy, "VarCap", extrastuff="#{iron}")
	end
	
	
	def vtranformer(label, p1,p2, s1,s2, iron=false)
		# points must be in right order, two (x,y) for primary, then sec.
		# leads to coils extended as needed  ((needs testing!))
		writelabel(label)
		wrpoint(p1)
		wrpoint(p2)
		wrpoint(s1)
		wrpoint(s2) 
		@psfile.print  " 3  3 #{iron} VTransformer PartLabelAbove\n"
	end
	
	
	def opamp(label,labpos, pplus, pminus, pout)
		writelabel(label)
		wrpoint pminus
		wrpoint pplus
		wrpoint pout
		@psfile.write " OpAmp  #{labelpos(labpos)} \n"
		
	end 
	
	
	def nfet(label, labpos,pgate,psrc,pdrain, wantcircle=true)
		writelabel(label)
		wrpoint pdrain
		wrpoint psrc
		wrpoint pgate
		@psfile.write " FetN  #{labelpos(labpos)} \n"
		
	end
	
	
	def pfet(label, labpos,pgate,psrc,pdrain, wantcircle=true)
		writelabel(label)
		wrpoint pdrain
		wrpoint psrc
		wrpoint pgate
		@psfile.write " FetP  #{labelpos(labpos)} \n"		
	end
	
	
	def npn(label, labpos, pB,pE,pC, wantcircle=true)
		writelabel(label)
		wrpoint pE
		wrpoint pB
		wrpoint pC
		@psfile.write " BipNPN  #{labelpos(labpos)} \n"		
	end
	
	
	def pnp
		writelabel(label)
		wrpoint pE
		wrpoint pB
		wrpoint pC
		@psfile.write " BipPNP  #{labelpos(labpos)} \n"		
	end
	
	
	def battery(label, labpos,xx,yy)
		typicalpart(label,labpos,xx,yy,"Battery")
	end
	
	
	def zener(label, labpos, xx,yy)
		typicalpart(label,labpos,xx,yy,"Zener")
	end
	
	
	def tunnel(label, labpos, xx,yy)
		typicalpart(label,labpos,xx,yy,"Tunnel")
	end
	 
	
	def switch(label, labpos, xx,yy, closed=false, swappoints=false)
		if yy.class!=Array 
			yy=[yy,yy]
		elsif xx.class!=Array
			xx=[xx,xx]
		end
		if yy[0]==yy[1] and xx[1]<xx[0]
			xx =xx.reverse
		end
		if swappoints
			xx=xx.reverse
			yy=yy.reverse
		end
		c = closed ?  "1 " : "0 "
		typicalpart(label,labpos, xx,yy, "Switch",  extrastuff=c)
	end
	
	
	def dot(a,b=nil)
		wrpoint(a,b)
		@psfile.write " Dot\n"
	end


	def outarrow(label, labpos, pcircuit, psymbol=nil)
		# endsymbol may be nil (nothing), "arrow", or "bigdot"  (more later...)
		# points where to attach to circuit, and where to put the 3-bars symbol
		if psymbol==nil
			psymbol=pcircuit
		end
		writelabel(label)
		wrpoint pcircuit
		wrpoint psymbol
		@psfile.write " OutArrow #{labelpos(labpos)}\n"
		
	end
	

	def inarrow(label, labpos, pcircuit, psymbol=nil)
		# same as outarrow, except it's an InArrow
		if psymbol==nil
			psymbol=pcircuit
		end
		writelabel(label)
		wrpoint pcircuit
		wrpoint psymbol
		@psfile.write " InArrow #{labelpos(labpos)}\n"
		
	end
	

	def text(text, x,y,  fontsize=12, dy=0)
		# text is array of strings, one per line
		# this is left-just, no other choices possible yet (july 2009)
		# fontsize is points 
		if dy==0
			dy=fontsize*1.2
		end
		if text.class==String
			text=[text]
		end
		@psfile.write "/Times-Roman findfont #{fontsize} scalefont setfont\n"
		text.each do  |t|
			@psfile.write "#{x} #{y} moveto (#{t}) show\n"
			y-=dy
		end
	end
	
	
	def gnd(pcircuit, psymbol=nil)
		# print "CHK gnd pcircuit #{pcircuit}    sym #{psymbol.class}  \\n \n"
		if pcircuit.class!=Array   # we were given two scalars: x,y
			pcircuit=[pcircuit, psymbol]
			psymbol=nil
		end
		if psymbol==nil
			# default placement of gnd symbol is just below the pcircuit point
			psymbol=[pcircuit[0], pcircuit[1]-0.1*inch]
		end
		# points where to attach to circuit, and where exactly to put the 3-bars symbol
		wrpoint pcircuit
		wrpoint psymbol
		@psfile.write "   Gnd \n"
	end
	
	
	def earthgnd(pcircuit, psymbol)
		if psymbol==nil
			psymbol=pcircuit
			psymbol[1]-=0.1*inch
		end
		# points where to attach to circuit, and where exactly to put the 3-bars symbol
		wrpoint pcircuit
		wrpoint psymbol
		@psfile.write " EarthGnd\n "
	end



	def writetext(txt, x, y)
	end
	
	
	def line(xx,yy)
		if xx.class!=Array
			xx=[xx,xx]
		elsif yy.class!=Array
			yy=[yy,yy]
		end
		wrpoint xx[0],yy[0]
		wrpoint xx[1],yy[1]
		@psfile.write " Line\n"
	end
	
	
	def pot(label,labpos, p1, p2, pwiper)
		# .ps part defs doesn't include any pot symbol
		# so we fake it with resistor + outarrow
		# first, calculate where R should go, depending on pwiper;
		# can't just let it default to halfway between p1, p2
		
		# TO BE WRITTEN...
		
	end
	
	
	def done
		@psfile.write "\n\nshowpage\n"
		@psfile.close
		print "\nDone!  wrote #{@psfilename}\n"
	end
end