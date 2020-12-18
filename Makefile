



CARD = /media/survey/Allt-Breagaireach

all: $(patsubst %.dxf,%.jpg,$(wildcard *.dxf))
all: $(patsubst %.txt,%.3d,$(wildcard *.txt))

%.jpg: %.dxf
	dia $< -e $@

CONVERT_ARGS = p s lrud

%.svx: %.txt
	caveconverter $< $@ $(CONVERT_ARGS)

surface2.svx: CONVERT_ARGS = p s

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
	if ! test -d $(CARD);								\
	then pmount -r /dev/disk/by-label/survey survey && trap 'pumount survey' EXIT;	\
	fi;										\
	cp -uv $(CARD)/*.txt $(CARD)/*.dxf .


.DELETE_ON_ERROR:
.PHONY: import
.PRECIOUS: %.svx
