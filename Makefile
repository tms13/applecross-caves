



CARD = /media/card/sd/Allt-Breagaireach

all: $(patsubst %.dxf,%.jpg,$(wildcard *.dxf))
all: $(patsubst %.txt,%.3d,$(wildcard *.txt))

%.jpg: %.dxf
	dia $< -e $@

%.svx: %.txt
	caveconverter $< $@ p s lrud

%.3d: %.svx
	cavern -q $< >$(patsubst %.3d,%.log,$@)

main.3d: $(wildcard ashery-pot/*.svx)
main.3d: $(wildcard liars-sink/*.svx)

EXPORT_ARGS += --legs
EXPORT_ARGS += --splays
EXPORT_ARGS += --entrances

%.kml: %.3d
	~/survex/src/survexport --kml $(EXPORT_ARGS) $<

import:
	cp -uv $(CARD)/*.txt $(CARD)/*.dxf .


.DELETE_ON_ERROR:
.PHONY: import
.PRECIOUS: %.svx
