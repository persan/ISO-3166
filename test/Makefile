export PATH:= $(dir $(shell readlink `which javac` -f)):${PATH}
all:
	javac -cp ../src/main/java:${CURDIR} Main.java
	java -cp ../src/main/java:${CURDIR} Main
