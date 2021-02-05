export PATH:= $(dir $(shell readlink `which javac` -f)):${PATH}
all:
	@javac -cp ../src/main/java:${CURDIR} Main.java
	@java -cp ../src/main/java:${CURDIR} Main
	@gprbuild -q -p test_ada.gpr
	@./main
	@gprbuild -q -p test_c.gpr
	@./Main
	@python test.py


