%{
import java.io.*;
import java.util.*;
import java.text.*;
%}

%token ID NUM ASSIGN PLUS MINUS BEGIN END PROGRAM INT FLOAT STRING REL_OP TEXT PRINT OPEN_PAREN CLOSE_PAREN
%start program

%%

program      : PROGRAM ID ';'
               prog_lines
               subprograms
               compound_stmt 
               '.'

prog_lines   : stmt_list            { $$ = $1; 

                                    pushScope(); 
                                    if (isDebug) {
                                        System.out.println("\n\n"); 
                                        printNode($$); 
                                        printSymbolTable();
                                        }
                                    }
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
                                    // textSection.add("# type=" + $1.token + " ID=" + $2.token + " ASSIGN=" + $3.token + " expr=" + $4.token);
                                    // dataSection.add("# type=" + $1.token + " ID=" + $2.token + " ASSIGN=" + $3.token + " expr=" + $4.token);
                                    Node id = $2;
                                    id.type = $1.token;
                                    Node node = makeNode($3.token, id, $4); 
                                    String type = postOrderIterative(node);
                                    node.type = type;
                                    $$ = node;

                                    /** MODIFY AS APPROPRIATE **/
                                    
                                    if ($4.operation.equals("NONE")) {
                                        // update assembly here
                                        if (type.equals("INT")) {
                                            int reg = getIntRegister();
                                            String name = $2.token.trim();
                                            setRegister(name,"$t" + reg );
                                            // $4.assembly = ".data\n" + $4.assembly.replace("P1", name);
                                            dataSection.add($4.assembly.replace("P1", name));
                                            // $4.assembly = $4.assembly + "\n.text\nlw " + getRegister(name) + ", " + $2.token;
                                            textSection.add("lw " + getRegister(name) + ", " + $2.token);
                                        } else if (type.equals("FLOAT")) {
                                            int reg = getFloatRegister();
                                            setRegister($2.token,"$f" + reg );
                                            $4.assembly = $4.assembly.replace("P1", $2.token);
                                            // $4.assembly = ".data\n" + $4.assembly.replace(".word", ".float");
                                            dataSection.add($4.assembly.replace(".word", ".float"));
                                            // $4.assembly += "\n.text\nl.s " + getRegister($2.token) + " " + $2.token;
                                            textSection.add("l.s " + getRegister($2.token) + " " + $2.token);
                                        } else if (type.equals("STRING")) {
                                            // $4.assembly = ".data\n" + $4.assembly.replace("P1", $2.token);
                                            dataSection.add($4.assembly.replace("P1", $2.token));
                                        }
                                        // dataSection.add($4.assembly);
                                    } else if ($4.operation.equals("ADD")) {
                                        if (type.equals("INT")) {
                                            String varName1 = $4.assembly.split(",")[1].trim();
                                            // setRegister(varName1,  "$t" +getIntRegister());
                                            String outreg = "$t" + getIntRegister();
                                            setRegister($2.token, outreg);
                                            $4.assembly = $4.assembly.replace("$OUT", getRegister($2.token) );
                                            //find in hashmap, which register has the value of this variable name
                                            // replace $tX
                                            $4.assembly = $4.assembly.replace(varName1, getRegister(varName1));

                                            String varName2 = $4.assembly.split(",")[2].trim();
                                            // setRegister(varName2, "$t"+getIntRegister());
                                            //find in hashmap, which register has the value of this variable name
                                            // replace $tY
                                            $4.assembly =  $4.assembly.replace(varName2, getRegister(varName2));
                                        } else if (type.equals("FLOAT")) {
                                            String newReg = "$f" + getFloatRegister();
                                            setRegister($2.token, newReg);
                                            String varName1 = $4.assembly.split(",")[1].trim();
                                            // setRegister(varName1,  "$t" +getIntRegister());
                                            $4.assembly = $4.assembly.replace("$OUT", getRegister(varName1) );
                                            //find in hashmap, which register has the value of this variable name
                                            // replace $tX
                                            $4.assembly = $4.assembly.replace(varName1, getRegister(varName1));

                                            String varName2 = $4.assembly.split(",")[2].trim();
                                            // setRegister(varName2, "$t"+getIntRegister());
                                            //find in hashmap, which register has the value of this variable name
                                            // replace $tY
                                            $4.assembly = "add.s " + newReg + ", " + getRegister(varName1)+ ", " + getRegister(varName2);
                                        }
                                        textSection.add($4.assembly);
                                    }
                                    //print the assembly code
                                    // System.out.println($4.assembly);


                                    if(isDeclaredLocally($2) && !canRetrieveSymbol($2)) { 
                                        yyerror("Duplicate variable: "+$2);
                                    } else { 
                                        enterSymbol($2, $4);
                                        saveTypeSymbol($2);
                                    } 
                                  }
        |   ID ASSIGN expr        { /*** YOUR CODE HERE ***/
                                    $$ = makeNode($2.token, $1, $3);
                                    if (!isDeclaredLocally($1) && !canRetrieveSymbol($1)) { 
                                            yyerror($1.token + " is not declared!");
                                        }
                                    }
        | PRINT OPEN_PAREN expr CLOSE_PAREN     
                                    {
                                        /*** YOUR CODE HERE ***/
                                        //print the expr
                                        //if string, generate assembly 
                                        //to print string
                                        //same for int and float.
                                        // Node node = makeNode($3.token,$1,$4);
                                        Node node = $3;
                                        String type = postOrderIterative(node);
                                        // textSection.add("# Print expr " + $3 + " of type " + type);
                                        if (type.equals("INT")){
                                            
                                            $3.assembly = "# print INT name=" + node.token + "\n";
                                            $3.assembly += "li $v0, 1\n";
                                            $3.assembly += "move $a0, " + getRegister(node.token) + "\nsyscall\n";
                                        }
                                        else if (type.equals("FLOAT")){
                                            $3.assembly = "# PRINT FLOAT name=" + node.token + "\n";
                                            $3.assembly += "li $v0, 2\n";
                                            $3.assembly += "mov.s $f12, " + getRegister(node.token) + "\nsyscall\n";
                                        }
                                        else if (type.equals("STRING")){
                                            $3.assembly = "# PRINT STRING name=" + node.token + "\n";
                                            $3.assembly += "li $v0, 4\n";
                                            $3.assembly += "la $a0, " + node.token + "\nsyscall\n";
                                        }
                                        // System.out.println(".data\nNEWLINE: .asciiz \"\\n\"\nli $v0, 4\nla $a0, NEWLINE\nsyscall");
                                        // System.out.println(".text\n");
                                        // System.out.println($3.assembly);
                                        textSection.add($3.assembly);
                                    }
        ;

type    :    INT                    { $$ = $1; }
        |    STRING                 { $$ = $1; }
        |    FLOAT                  { $$ = $1; }
        ;

expr    :   expr PLUS expr          { Node node = makeNode("+", $1, $3); 
                                      node.operation = "ADD";
                                      node.assembly = "add $OUT, "  + $1.token + ", " + $3.token;
                                      $$ = node;
                                    }
        |   expr MINUS expr         { Node node = makeNode("-", $1, $3); 
                                      node.operation = "SUB";
                                      /*** Your code here for node.assembly ***/
                                      node.assembly = "sub $OUT, "  + $1.token + ", " + $3.token;
                                      $$ = node;
                                    }
        |   ID                      {  
                                      $$ = $1;
                                        if (!isDeclaredLocally($1) && !canRetrieveSymbol($1)) { 
                                            yyerror($1.token + " is not declared!");
                                        }
                                    }
        |   NUM                     {
                                        Node node = $1;
                                        node.operation = "NONE";
                                        node.assembly = "P1: .word "+$1.token;
                                        $$ = node;
                                    }
        |   TEXT                    {
                                        Node node = $1;
                                        node.operation = "NONE";
                                        node.assembly = "P1: .asciiz "+$1.token;
                                        $$ = node;
                                    }
        ;


%%

/***************************************
 ***** YOUR CODE HERE ******************
 ***************************************/
ArrayList<String> textSection = new ArrayList<>();
ArrayList<String> dataSection = new ArrayList<>();

int intRegisters[] = new int[8];
int floatRegisters[] = new int[8];
/*** YOUR CODE for floatRegisters ***/

// 0 means free
// 1 means occupied
public int getIntRegister() {
    for (int i = 0; i < 7; i++) {
        if (intRegisters[i] == 0) {
            intRegisters[i] = 1;
            return i;
        }
    }
    return 0;
}

public int getFloatRegister() {
    for (int i = 0; i < 7; i+=2) {
        if (floatRegisters[i] == 0) {
            floatRegisters[i] = 1;
            return i;
        }
    }
    return 0;
}


public void freeIntRegister(int r) {
    intRegisters[r] = 0;
}

public void freeFloatRegister(int r) {
    floatRegisters[r] = 0;
}
/*** YOUR CODE HERE ***/
//maintain a table that maps IDENTIFIER to REGISTER USED.
//implement appropriate methods to store the mapping 
//and retrieve register for any given identifier from this table.
    

HashMap<String, String> registerTable = new HashMap<>();
public void setRegister(String id, String register) {
    textSection.add("# Load into register id="+id + " register="+register);
    registerTable.put(id, register);
}

public String getRegister(String id) {
    // System.out.println("Looking up id="+id);
    return registerTable.get(id);
}



//You will generate 2 sections of assembly: .data and .text
//Store your assembly into appropriate section.
//Choose any datastructure to store your assembly.

public void printAssembly(){
    /*** YOUR CODE HERE ***/
    //call this at the end, to print out the final output
    System.out.println("# Final output");
    System.out.println("# ========== DATA ==========");
    System.out.println(".data");
    for (String s : dataSection){
        System.out.println(s);
    }
    System.out.println("# ========== TEXT ==========");
    System.out.println(".text");
    for (String s : textSection){
        System.out.println(s);
    }
}

Stack<HashMap<String, String>> scopesStack = new Stack<HashMap<String, String>>();
Stack<HashMap<String, String>> typesStack = new Stack<HashMap<String, String>>();

HashMap<String, String> curSymbolTable = new HashMap<String, String>();
HashMap<String, String> curTypeSymbolTable = new HashMap<String, String>();

public void saveTypeSymbol(Node node) {
    curTypeSymbolTable.put(node.token, node.type);
}

public String postOrderIterative(Node root) {
    if( root == null ) {
        return "";
    }

    Stack<Node> s1 = new Stack<Node>();
    Stack<Node> s2 = new Stack<Node>();
 
    s1.push(root);
    Node node;
 
    while (!s1.isEmpty( )) {
        // Pop an item from s1 and push it to s2
        node = s1.pop();
        s2.push(node);
 
        // Push left and right children of removed item to s1
        if (node.left != null) {
            s1.push(node.left);        
        }
        if (node.right != null) {
            s1.push(node.right);     
        }
    }
 
    // Process all elements of second stack

    // Get the type of the variable at the top of stack
    String existingType = s2.peek().type;
    if (existingType == null) {
        existingType = lookUpType(s2.peek().token);
    }

    while (!s2.isEmpty()) {
        node = s2.pop();
        if (node.type == null && node.token.equals("=")) {
            //this should only happen when we are at the last entry of the stack
            //so we want to return the type "existingType"
            continue;
        }
        if (node.token.equals("+") || node.token.equals("-")) {
            node.type = existingType;
        }
        if (node.type == null) {
            //lookup type information from symbol table
            node.type = lookUpType(node.token);
        }
        if (!existingType.equals(node.type)) {
            yyerror("***TYPE MISMATCH*** "+node.type + " type found when expected: "+existingType + ", expr: "+printInOrder(root));
        }
    }
    return existingType;
}

public String printInOrder(Node root) {
    String out ="";
    if(root == null) {
        return out;
    }
    Stack<Node> stack = new Stack<Node>( );
    while( ! stack.isEmpty( ) || root != null ) {
        if( root != null ) {
        stack.push( root );
        root = root.left;
    } else {
        root = stack.pop( );
        out += root.token + " " ;
        root = root.right;
    }
    }
    return out;
}


public void pushScope() {
    scopesStack.push(curSymbolTable);
    typesStack.push(curTypeSymbolTable);
    curSymbolTable = new HashMap<String, String>();
    curTypeSymbolTable = new HashMap<String, String>();
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

private String lookUpType(String id) {
    //curTypeSymbolTable may not have been pushed into the stack yet, so check it first
    if (curTypeSymbolTable.get(id) != null) {
        return curTypeSymbolTable.get(id);
    }
    
    for(int i = typesStack.size() - 1; i >= 0; i--){
        HashMap<String,String> typeTable = typesStack.get(i);
        if (typeTable.get(id) != null) {
            return typeTable.get(id);
        }
    }
    return null;
}

public void exitScope(){
    typesStack.pop();
    scopesStack.pop();
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
    for (HashMap<String,String> symTable : scopesStack) {
        System.out.println("---printing symbol table---");
        for (Map.Entry<String, String> entry : symTable.entrySet()) {
            String key = entry.getKey();
            String value = entry.getValue();
            System.out.println("K: " + key + " , V: " + value);
        }
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

public static boolean isDebug = false;

public static void main (String [] args) throws IOException {
    
    /*** YOUR CODE HERE TO ALLOW DEBUG OPTION -d ***/

    int filePosition = 0;
    if (args[0].equals("-d")){
        isDebug = true;
        filePosition = 1;
    }

    Parser yyparser = new Parser(new FileReader(args[filePosition]));
    yyparser.yyparse();
    yyparser.printAssembly();
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
