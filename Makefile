#SOURCES?=../../ISO-3166-Countries-with-Regional-Codes/all/all.xml
ECLIPSE_HOME=/usr/lib/eclipse/droplets/eclipse-sdk
LAUNCHER=$(find ${ECLIPSE_HOME} -name org.eclipse.equinox.launcher.source*)
LAUNCHER=/usr/lib/eclipse/droplets/eclipse-sdk/plugins/org.eclipse.equinox.launcher.source_1.5.801.v20200914-0420.jar
all:
	gprbuild -p -P iso_3166-tool.gpr -gnatwA
	./bin/iso_3166-generator ${SOURCES}
	gprbuild -p -P iso_3166.gpr

compile:
	gprbuild -p -P iso_3166_c.gpr
	gprbuild -p -P iso_3166.gpr
	gprbuild -p -P iso_3166_java.gpr
	gprbuild -p -P iso_3166_python.gpr
	gprbuild -p -P iso_3166-tool.gpr
