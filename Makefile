SOURCES?=../ISO-3166-Countries-with-Regional-Codes/all/all.xml
all:
	gprbuild -p -P iso_3166-tool.gpr
	./bin/iso_3166-generator ${SOURCES}
	gprbuild -p -P iso_3166.gpr

