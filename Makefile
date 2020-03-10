


.DELETE_ON_ERROR:

CARD = /media/card/sd/Allt-Breagaireach

all: $(patsubst %.dxf,%.jpg,$(wildcard *.dxf))
all: $(patsubst %.txt,%.3d,$(wildcard *.txt))

%.jpg: %.dxf
	libreoffice --headless --convert-to jpg $<

%.svx: %.txt
	caveconverter $< $@ p s lrud

%.3d: %.svx
	cavern -s $<

upload:
	cp -uv $(CARD)/*.txt $(CARD)/*.dxf .


.PHONY: upload
.PRECIOUS: %.svx
