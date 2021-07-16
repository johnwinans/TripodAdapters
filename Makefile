
SRC=\
	LGG6.scad \
	gopro.scad

STL=$(SRC:.scad=.stl)

.SUFFIX: .scad .stl

%.stl : %.scad
	openscad -o $@ $<


all:: $(STL)

clean::
	rm -f *.stl

world:: clean all
