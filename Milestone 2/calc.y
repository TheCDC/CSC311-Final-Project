%{
import java.io.*;
import java.util.*;
import java.text.*;
%}

%token ID NUM ASSIGN PLUS MINUS BEGIN END PROGRAM INT FLOAT STRING REL_OP
%start program

%%

program      : PROGRAM ID ';'
               prog_lines
               subprograms
               compound_stmt 
               '.'

prog_lines   : stmt_list            { $$ = $1; System.out.println("\n\n"); printNode($$); pushScope(); printSymbolTable(); }
             | {/* empty */}
             ;

stmt_list   :   stmt                 { $$ = $1; }
            |   stmt_list ';' stmt   { $$ = makeNode(";", $1, $3);  }
            ;

subprograms     :  subprograms compound_stmt     
                |  {/* empty */}
                ;

compound_stmt   :  BEGIN prog_lines compound_stmt END  {  exitScope(); }
                |  {/* empty */}
                ;

stmt    :   type ID ASSIGN expr   { $$ = makeNode($3.token, $2, $4); 
                                    if(isDeclaredLocally($2)) { 
                                        yyerror("Duplicate variable: "+$2.token);
                                    } else { 
                                        enterSymbol($2, $4);
                                    } 
                                  }
        |   ID ASSIGN expr        {
                                    $$ = makeNode($2.token, $1, $3);
                                    if (!isDeclaredLocally($1) && !canRetrieveSymbol($1)) { 
                                            yyerror($1.token + " is not declared!");
                                        }
                                    }       
        ;

type    :    INT                    { $$ = $1; }
        |    STRING                 { $$ = $1; }
        |    FLOAT                  { $$ = $1; }
        ;

expr    :   expr PLUS term          { $$ = makeNode("+", $1, $3); }
        |   expr MINUS term         { $$ = makeNode("-", $1, $3); }
        |   term                    { $$ = $1; }
        |   expr REL_OP expr        {  
                                      $$ = makeNode($2.token, $1, $3); }
        |   ID                      { $$ = $1;

                                      /** YOUR CODE HERE **/

                                    }
        ;

term    :   ID                      { $$ = $1;
                                      
                                      /** YOUR CODE HERE **/ 

                                    }
        |   NUM                     { $$ = $1; }
        ;


%%

    /***************************************
     ***** YOUR CODE HERE ******************
     ***************************************/

    
    HashMap<String, String> curSymbolTable = new HashMap<String, String>();
    
    public void pushScope() {
	//YOUR CODE HERE
    }

    public boolean canRetrieveSymbol(Node id) {
	//YOUR CODE HERE
	return false;
    }

    public void exitScope(){
	//YOUR CODE HERE
    }

    
    public void enterSymbol(Node id, Node value) {
        curSymbolTable.put(id.token, value.token);
    }

    public boolean isDeclaredLocally(Node id) {
        if ((curSymbolTable).get(id.token) != null) {
            return true;
        }
        return false;
    }

    public void printSymbolTable() {
	//YOUR CODE HERE
    }


    /***************************************
     ***** END OF YOUR CODE HERE ***********
     ***************************************/


    /* Byacc/J expects a member method int yylex(). We need to provide one
   through this mechanism. See the jflex manual for more information. */

    /* reference to the lexer object */
    private Scanner lexer;

    /* interface to the lexer */
    private int yylex() {
        int retVal = -1;
        try {
            retVal = lexer.yylex();
        } catch (IOException e) {
            System.err.println("IO Error:" + e);
        }
        return retVal;
    }
    
    /* error reporting */
    public void yyerror (String error) {
        System.err.println("Error : " + error + " at line " + lexer.getLine() + " column: " + lexer.getColumn());
        System.err.println("String rejected");
    }

    /* constructor taking in File Input */
    public Parser (Reader r) {
        lexer = new Scanner (r, this);
    }

    public static void main (String [] args) throws IOException {
        Parser yyparser = new Parser(new FileReader(args[0]));
        yyparser.yyparse();
    } 


    Node makeNode(String token, Node left, Node right) {
        Node newNode = new Node(token);
        newNode.left = left;
        newNode.right = right;
        return newNode;
    }

    void printTree(Node tree)
    {
        int i;

        if (tree.left!=null || tree.right!=null) {
            System.out.print("( ");
        }

        System.out.print(tree.token + " ");

        if (tree.left!=null) {
            printTree(tree.left);
        }
        if (tree.right!=null) {
            printTree(tree.right);
        }

        if (tree.left!=null || tree.right!=null) {
            System.out.print(")");
        }
    }


    public void printNode(Node root) {
        System.out.println("--------Structured View of Tree----------");
        int maxLevel = maxLevel(root);
        printNodeInternal(Collections.singletonList(root), 1, maxLevel);
    }

    private void printNodeInternal(List<Node> nodes, int level, int maxLevel) {
        if (nodes.isEmpty() || isAllElementsNull(nodes))
            return;

        int floor = maxLevel - level;
        int endgeLines = (int) Math.pow(2, (Math.max(floor - 1, 0)));
        int firstSpaces = (int) Math.pow(2, (floor)) - 1;
        int betweenSpaces = (int) Math.pow(2, (floor + 1)) - 1;

        printWhitespaces(firstSpaces);

        List<Node> newNodes = new ArrayList<Node>();
        for (Node node : nodes) {
            if (node != null) {
                System.out.print(node.token);
                newNodes.add(node.left);
                newNodes.add(node.right);
            } else {
                newNodes.add(null);
                newNodes.add(null);
                System.out.print(" ");
            }

            printWhitespaces(betweenSpaces);
        }
        System.out.println("");

        for (int i = 1; i <= endgeLines; i++) {
            for (int j = 0; j < nodes.size(); j++) {
                printWhitespaces(firstSpaces - i);
                if (nodes.get(j) == null) {
                    printWhitespaces(endgeLines + endgeLines + i + 1);
                    continue;
                }

                if (nodes.get(j).left != null)
                    System.out.print("/");
                else
                    printWhitespaces(1);

                printWhitespaces(i + i - 1);

                if (nodes.get(j).right != null)
                    System.out.print("\\");
                else
                    printWhitespaces(1);

                printWhitespaces(endgeLines + endgeLines - i);
            }

            System.out.println("");
        }

        printNodeInternal(newNodes, level + 1, maxLevel);
    }

    private void printWhitespaces(int count) {
        for (int i = 0; i < count; i++)
            System.out.print(" ");
    }

    private int maxLevel(Node node) {
        if (node == null)
            return 0;

        return Math.max(maxLevel(node.left), maxLevel(node.right)) + 1;
    }

    private boolean isAllElementsNull(List list) {
        for (Object object : list) {
            if (object != null)
                return false;
        }

        return true;
    }

