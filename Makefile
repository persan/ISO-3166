#SOURCES?=../../ISO-3166-Countries-with-Regional-Codes/all/all.xml
all:
	gprbuild -p -P iso_3166-tool.gpr -gnatwA
	./bin/iso_3166-generator ${SOURCES}
	gprbuild -p -P iso_3166.gpr

javac:
	eclipse -noSplash \
                -data "${CURDIR}" \
                -application org.eclipse.jdt.apt.core.aptBuild
