#SOURCES?=../../ISO-3166-Countries-with-Regional-Codes/all/all.xml
all:
	gprbuild -p -P iso_3166_tool.gpr -gnatwA
	./bin/extendeble_iso3166-generator-main ${SOURCES}
	${MAKE} compile

compile:
	gprbuild -p -P iso_3166_c.gpr
	gprbuild -p -P iso_3166.gpr
	gprbuild -p -P iso_3166_java.gpr
	gprbuild -p -P iso_3166_python.gpr
	gprbuild -p -P iso_3166_tool.gpr
.PHONY: test
test:
	${MAKE} -C $@

