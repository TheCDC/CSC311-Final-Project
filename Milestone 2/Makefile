parser: Parser.java Scanner.java Node.java
	javac -classpath "" *.java

Parser.java: calc.y
	../../bin/yacc.exe -Jsemantic=Node calc.y

Scanner.java: calc.jflex
	../../bin/jflex calc.jflex

clean:
	rm *.class Parser.java Scanner.java
