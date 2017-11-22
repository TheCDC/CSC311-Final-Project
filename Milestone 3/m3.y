%{
import java.io.*;
import java.util.*;
import java.text.*;
%}

%token ID NUM ASSIGN PLUS MINUS BEGIN END PROGRAM INT FLOAT STRING REL_OP TEXT
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

compound_stmt   :  BEGIN prog_lines compound_stmt END  { exitScope(); }
                |  {/* empty */}
                ;

stmt    :   type ID ASSIGN expr   { 
                                    Node id = $2;
                                    id.type = $1.token;
                                    Node node = makeNode($3.token, id, $4); 
                                    String type = postOrderIterative(node);
                                    node.type = type;
                                    $$ = node;

                                    if(isDeclaredLocally($2) && !canRetrieveSymbol($2)) { 
                                        yyerror("Duplicate variable: " + $2.token);
                                    } else { 
                                        /*** YOUR CODE HERE ***/
                                        /* Keep a separate symbol table to store type information */
                                        enterSymbol($2, $4);
                                    } 
                                  }
        |   ID ASSIGN expr        { /*** YOUR CODE HERE ***/
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
        |   expr REL_OP expr        { $$ = makeNode($2.token, $1, $3); }
        |   ID                      { 
                                      $$ = $1;
                                        if (!isDeclaredLocally($1) && !canRetrieveSymbol($1)) { 
                                            yyerror($1.token + " is not declared!");
                                        }
                                    }
        ;

term    :   ID                      { $$ = $1; 
                                        if (!isDeclaredLocally($1) && !canRetrieveSymbol($1)) { 
                                            yyerror($1.token + " is not declared!");
                                        }
                                    }
        |   NUM                     { $$ = $1; }
        |   TEXT                    { $$ = $1; }
        ;


%%

    /***************************************
     ***** YOUR CODE HERE ******************
     ***************************************/

    public static boolean isDebug = false;


    public String postOrderIterative(Node root) {
        //System.out.println("POT node: " + root);
        /*** YOUR CODE HERE ***/
        /* Use PostOrder Traversal using iteration to walk the root node */
        /* The code can be found in lecture slides */
        /* PostOrder traversal using iteration uses 2 stacks */
        /* As you pop off the elements in the 2nd stack, do your type checking */

        /* The pseudo code is roughly this: */
        /* 
         * First, get the type of the variable at the top of stack
         * String existingType = s2.peek().type;
         * if (existingType == null) {
         *   existingType = lookUp(s2.peek().token);
         * }
         *
         *
         *  while (2nd stack is not empty) {
         *   pop node
         *   if (node's type == null && node's token is "=") {
         *       //this should only happen when we are at the last entry of the stack
         *       //so we want to return the type "existingType"
         *       continue;
         *   }
         *   if (node.token.equals("+") || node.token.equals("-")) { //for operators
         *       assign this node's type to the same type as existingType
         *   }
         *   if (node.type == null) {
         *       //when node's type cannot be found, what should you do? Where do you get the type info?
         *   }
         *   if (!existingType.equals(node.type)) {
         *       //when there is a type mismatch, what do you do?
         *   }
         * }
         * return existingType;
         */
        
        //perform post order traversal pushing results to s2
        Stack<Node> s1 = new Stack<Node>();
        Stack<Node> s2 = new Stack<Node>();
        s1.push(root);
        while (!s1.empty()){
            Node node = s1.pop();
            if (node != null){
                s2.push(node);
                s1.push(node.left);
                s1.push(node.right);
            
            }
        }
        // 

        String existingType = s2.peek().type;
        if (existingType == null) {
            existingType = lookUp(s2.peek().token);
            if (existingType.equals("")){
                //yyerror("Starting node (" + s2.peek() + ") has no type.");
            }
        }

        while (!s2.empty()) {

            Node node = s2.pop();
            if (existingType.equals("") && node.type != null){
                existingType = node.type;
            }

            //System.out.println("Traversing node: " + node);
            if (node.type == null && node.token.equals( "=")) {
                //this should only happen when we are at the last entry of the stack
                //so we want to return the type "existingType"
                continue;
            }
            if (node.token.equals("+") || node.token.equals("-")) { //for operators
                //assign this node's type to the same type as existingType
                node.type = existingType;
                //continue;
            }
            if (node.type == null) {
                //when node's type cannot be found, what should you do? Where do you get the type info?
                //System.out.println("Setting node " + node + " type to " + lookUp(node.token));
                //node.type=existingType;
                node.type = lookUp(node.token);
            }
            if (!existingType.equals(node.type)) {
                //when there is a type mismatch, what do you do?
                System.out.println("***TYPE MISMATCH***" + " Found type " + node.type + " when expected: " + existingType +  " At: " + node);
                if (node.type != null){
                    //existingType = node.type;
                }
            }
            //System.out.println(node + " -> " + existingType);
        }
        return existingType;
        //return "";
    }


    //This method looks up the variable in the symbol table and returns its type information
    private String lookUp(String x) {
        /*** YOUR CODE HERE ***/
        Stack<HashMap<String,String>> tempStack = new Stack<HashMap<String,String>>();
        if (curTypesTable.get(x) != null){
            return curTypesTable.get(x);
        }
        String found = null;
        while (!typesStack.isEmpty()) {
            HashMap<String,String> tempTypeTable = typesStack.pop();
            tempStack.push(tempTypeTable);
            found = tempTypeTable.get(x);
            if (found != null) {
                break;
            }
        }

        while (!tempStack.isEmpty()) {
            typesStack.push(tempStack.pop());
        }
        if (found != null){

            return found;
        }
        else{
            return "";
        }
    }

    //Given a root node, return its In-Order Traversal output as a string
    public String printInOrder(Node root) {
        /*** YOUR CODE HERE ***/
        /* In order traversal using iteration can be found in Lecture 23 */
        return "";
    }

    
    Stack<HashMap<String, String>> scopesStack = new Stack<HashMap<String, String>>();
    Stack<HashMap<String, String>> typesStack = new Stack<HashMap<String, String>>();
    HashMap<String, String> curSymbolTable = new HashMap<String, String>();
    HashMap<String, String> curTypesTable = new HashMap<String, String>();
    
    public void pushScope() {
        scopesStack.push(curSymbolTable);
        curSymbolTable = new HashMap<String, String>();
        typesStack.push(curTypesTable);
        curTypesTable = new HashMap<String, String>();
    }

    public boolean canRetrieveSymbol(Node id) {
        Stack<HashMap<String,String>> tempStack = new Stack<HashMap<String,String>>();
        boolean isFound = false;
        while (!scopesStack.isEmpty()) {
            HashMap<String,String> tempSymTab = scopesStack.pop();
            tempStack.push(tempSymTab);
            if (tempSymTab.get(id.token) != null) {
                isFound = true;
                break;
            }
        }

        while (!tempStack.isEmpty()) {
            scopesStack.push(tempStack.pop());
        }
        
        return isFound;
    }

    public void exitScope(){
        scopesStack.pop();
        typesStack.pop();
    }

    
    public void enterSymbol(Node id, Node value) {
        curSymbolTable.put(id.token, value.token);
        curTypesTable.put(id.token, value.type);
    }

    public boolean isDeclaredLocally(Node id) {
        if ((curSymbolTable).get(id.token) != null) {
            return true;
        }
        return false;
    }

    public void printSymbolTable() {
        if (!isDebug){
            return;
        }
        HashMap<String, String> symTable = scopesStack.peek();
        for (Map.Entry<String, String> entry : symTable.entrySet()) {
            String key = entry.getKey();
            String value = entry.getValue();
            String type = typesStack.peek().get(key);
            System.out.println("K: " + key + ", V: " + value + ", T: " + type);
        }
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
        
        /*** YOUR CODE HERE TO ALLOW DEBUG OPTION -d ***/
        int filePosition = 0;
        if (args.length > 1){
            if (args[1].equals("-d")){
                isDebug = true;
                System.out.println("Debugging mode enabled.");
            }
        }

        Parser yyparser = new Parser(new FileReader(args[filePosition]));
        
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
        if (!isDebug){
            return;
        }
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

