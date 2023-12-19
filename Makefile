



CARD = /media/survey/Allt-Breagaireach

all: $(patsubst %.dxf,%.jpg,$(wildcard */*.dxf))
all: $(patsubst %.txt,%.3d,$(filter-out %.th.txt, $(wildcard */*.txt)))
all: main.kml

%.jpg: %.dxf
	dia $< -e $@

CONVERT_ARGS = p s lrud

%.svx: %.txt
	caveconverter $< $@ $(CONVERT_ARGS)

# Don't generate LRUD for surface legs
surface2/surface2.svx: CONVERT_ARGS = p s

%.3d: %.svx
	chronic cavern -q $<
#>$(patsubst %.3d,%.log,$@)

main.3d: $(wildcard */*.svx)
main.3d: $(wildcard *.svxm)

EXPORT_ARGS += --legs
EXPORT_ARGS += --splays
EXPORT_ARGS += --entrances

%.kml: %.3d
	~/survex/src/survexport --kml $(EXPORT_ARGS) $<

import:
	@set -eu;									\
	if ! test -d $(CARD);								\
	then pmount -r /dev/disk/by-label/survey survey && trap 'pumount survey' EXIT;	\
	fi;										\
	echo Copying from survey card...;						\
	for i in ashery-pot flake-pot uamh-breagair brindles-rift the-gills surface2;	\
	do cp -uv $(CARD)/$$i.top $(CARD)/$$i.txt $(CARD)/$$i?.dxf $$i/;		\
	done

clean:
	$(RM) $(patsubst %.txt,%.svx,$(wildcard */*.txt))
	$(RM) $(patsubst %.dxf,%.jpg,$(wildcard */*.dxf))
	$(RM) */*.err */*.log */*.3d *.3d

.DELETE_ON_ERROR:
.PHONY: import all clean
.PRECIOUS: %.svx
