parser: Parser.java Scanner.java Node.java
	javac -classpath "" *.java

Parser.java: m4-solution.y
	byaccj -Jsemantic=Node m4-solution.y

Scanner.java: m4.jflex
	jflex m4.jflex

clean:
	rm *.class Parser.java Scanner.java
