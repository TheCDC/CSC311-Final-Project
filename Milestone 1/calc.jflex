%%

%class Scanner
%unicode
%line
%column
%byaccj

%{
	/* store a reference to the parser object */
	private Parser yyparser;

	/* constructor taking an additional parser */
	public Scanner (java.io.Reader r, Parser yyparser) {
		this (r);	
		this.yyparser = yyparser;
	}

	/* return the current line number.*/
	public int getLine() {
		return yyline;
	}

	/* return the current column number.*/
	public int getColumn() {
		return yycolumn;
	}

%}

%%
[a-zA-Z][a-zA-Z0-9]*	{ yyparser.yylval = new Node(yytext()); 
						  return Parser.ID; }
[0-9]+					{ yyparser.yylval = new Node(yytext());
        				  return Parser.NUM; }
\=						{ yyparser.yylval = new Node(yytext());
						  return Parser.ASSIGN; }
\+						{ yyparser.yylval = new Node(yytext()); 
						  return Parser.PLUS; }
\-						{ yyparser.yylval = new Node(yytext());
						  return Parser.MINUS; }
\;						{ yyparser.yylval = new Node(yytext()); 
						  return (int) yycharat(0); }
[ \t\n\r]				{ }

