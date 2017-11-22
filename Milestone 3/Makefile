parser: Parser.java Scanner.java Node.java
	javac -classpath "" *.java

Parser.java: m3.y
	byaccj -Jsemantic=Node m3.y

Scanner.java: m3.jflex
	jflex m3.jflex

clean:
	rm *.class Parser.java Scanner.java
