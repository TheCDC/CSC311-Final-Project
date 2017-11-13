parser: Parser.java Scanner.java Node.java
	javac -classpath "" *.java

Parser.java: calc.y
	byaccj -Jsemantic=Node calc.y

Scanner.java: calc.jflex
	jflex calc.jflex

clean:
	rm *.class Parser.java Scanner.java
