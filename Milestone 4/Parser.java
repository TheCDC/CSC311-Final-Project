//### This file created by BYACC 1.8(/Java extension  1.15)
//### Java capabilities added 7 Jan 97, Bob Jamison
//### Updated : 27 Nov 97  -- Bob Jamison, Joe Nieten
//###           01 Jan 98  -- Bob Jamison -- fixed generic semantic constructor
//###           01 Jun 99  -- Bob Jamison -- added Runnable support
//###           06 Aug 00  -- Bob Jamison -- made state variables class-global
//###           03 Jan 01  -- Bob Jamison -- improved flags, tracing
//###           16 May 01  -- Bob Jamison -- added custom stack sizing
//###           04 Mar 02  -- Yuval Oren  -- improved java performance, added options
//###           14 Mar 02  -- Tomas Hurka -- -d support, static initializer workaround
//### Please send bug reports to tom@hukatronic.cz
//### static char yysccsid[] = "@(#)yaccpar	1.8 (Berkeley) 01/20/90";






//#line 1 "m4-solution.y"

import java.io.*;
import java.util.*;
import java.text.*;
//#line 22 "Parser.java"




public class Parser
{

boolean yydebug;        //do I want debug output?
int yynerrs;            //number of errors so far
int yyerrflag;          //was there an error?
int yychar;             //the current working character

//########## MESSAGES ##########
//###############################################################
// method: debug
//###############################################################
void debug(String msg)
{
  if (yydebug)
    System.out.println(msg);
}

//########## STATE STACK ##########
final static int YYSTACKSIZE = 500;  //maximum stack size
int statestk[] = new int[YYSTACKSIZE]; //state stack
int stateptr;
int stateptrmax;                     //highest index of stackptr
int statemax;                        //state when highest index reached
//###############################################################
// methods: state stack push,pop,drop,peek
//###############################################################
final void state_push(int state)
{
  try {
		stateptr++;
		statestk[stateptr]=state;
	 }
	 catch (ArrayIndexOutOfBoundsException e) {
     int oldsize = statestk.length;
     int newsize = oldsize * 2;
     int[] newstack = new int[newsize];
     System.arraycopy(statestk,0,newstack,0,oldsize);
     statestk = newstack;
     statestk[stateptr]=state;
  }
}
final int state_pop()
{
  return statestk[stateptr--];
}
final void state_drop(int cnt)
{
  stateptr -= cnt; 
}
final int state_peek(int relative)
{
  return statestk[stateptr-relative];
}
//###############################################################
// method: init_stacks : allocate and prepare stacks
//###############################################################
final boolean init_stacks()
{
  stateptr = -1;
  val_init();
  return true;
}
//###############################################################
// method: dump_stacks : show n levels of the stacks
//###############################################################
void dump_stacks(int count)
{
int i;
  System.out.println("=index==state====value=     s:"+stateptr+"  v:"+valptr);
  for (i=0;i<count;i++)
    System.out.println(" "+i+"    "+statestk[i]+"      "+valstk[i]);
  System.out.println("======================");
}


//########## SEMANTIC VALUES ##########
//## **user defined:Node
String   yytext;//user variable to return contextual strings
Node yyval; //used to return semantic vals from action routines
Node yylval;//the 'lval' (result) I got from yylex()
Node valstk[] = new Node[YYSTACKSIZE];
int valptr;
//###############################################################
// methods: value stack push,pop,drop,peek.
//###############################################################
final void val_init()
{
  yyval=new Node();
  yylval=new Node();
  valptr=-1;
}
final void val_push(Node val)
{
  try {
    valptr++;
    valstk[valptr]=val;
  }
  catch (ArrayIndexOutOfBoundsException e) {
    int oldsize = valstk.length;
    int newsize = oldsize*2;
    Node[] newstack = new Node[newsize];
    System.arraycopy(valstk,0,newstack,0,oldsize);
    valstk = newstack;
    valstk[valptr]=val;
  }
}
final Node val_pop()
{
  return valstk[valptr--];
}
final void val_drop(int cnt)
{
  valptr -= cnt;
}
final Node val_peek(int relative)
{
  return valstk[valptr-relative];
}
final Node dup_yyval(Node val)
{
  return val;
}
//#### end semantic value section ####
public final static short ID=257;
public final static short NUM=258;
public final static short ASSIGN=259;
public final static short PLUS=260;
public final static short MINUS=261;
public final static short BEGIN=262;
public final static short END=263;
public final static short PROGRAM=264;
public final static short INT=265;
public final static short FLOAT=266;
public final static short STRING=267;
public final static short REL_OP=268;
public final static short TEXT=269;
public final static short PRINT=270;
public final static short OPEN_PAREN=271;
public final static short CLOSE_PAREN=272;
public final static short YYERRCODE=256;
final static short yylhs[] = {                           -1,
    0,    1,    1,    4,    4,    2,    2,    3,    3,    5,
    5,    5,    6,    6,    6,    7,    7,    7,    7,    7,
};
final static short yylen[] = {                            2,
    7,    1,    0,    1,    3,    2,    0,    4,    0,    4,
    3,    4,    1,    1,    1,    3,    3,    1,    1,    1,
};
final static short yydefred[] = {                         0,
    0,    0,    0,    0,    0,   13,   15,   14,    0,    7,
    0,    4,    0,    0,    0,    0,    0,    0,   18,   19,
   20,    0,    0,    0,    0,    5,    0,    0,    0,   12,
    0,    1,    0,    0,    0,    0,    8,
};
final static short yydgoto[] = {                          2,
   10,   16,   25,   11,   12,   13,   22,
};
final static short yysindex[] = {                      -263,
 -254,    0,  -54, -241, -252,    0,    0,    0, -261,    0,
  -47,    0, -243, -230, -230, -244, -241, -239,    0,    0,
    0, -227, -229, -241,  -16,    0, -230, -230, -230,    0,
 -244,    0, -227, -227, -227, -228,    0,
};
final static short yyrindex[] = {                         0,
    0,    0,    0,  -35,    0,    0,    0,    0,    0,    0,
  -38,    0,    0,    0,    0,   -8,    0,    0,    0,    0,
    0,  -42,    0, -226, -222,    0,    0,    0,    0,    0,
 -221,    0,  -40,  -46,  -44,    0,    0,
};
final static short yygindex[] = {                         0,
   17,    0,   13,    0,   28,    0,   -6,
};
final static int YYTABLESIZE=228;
static short yytable[];
static { yytable();}
static void yytable(){
yytable = new short[]{                         16,
    1,   17,    3,   11,    4,   10,   14,    2,   23,   15,
    3,   17,   16,   18,   17,    5,   11,   24,   10,   27,
   33,   34,   35,    6,    7,    8,   19,   20,    9,   32,
   28,   29,   28,   29,   37,    3,    3,    9,   21,    6,
   31,    9,   30,   36,   26,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,   16,   16,   17,   17,   11,
   11,   10,   10,    2,    2,   16,    3,   17,
};
}
static short yycheck[];
static { yycheck(); }
static void yycheck() {
yycheck = new short[] {                         46,
  264,   46,  257,   46,   59,   46,  259,   46,   15,  271,
   46,   59,   59,  257,   59,  257,   59,  262,   59,  259,
   27,   28,   29,  265,  266,  267,  257,  258,  270,   46,
  260,  261,  260,  261,  263,  262,  263,   46,  269,  262,
   24,  263,  272,   31,   17,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,  262,  263,  262,  263,  262,
  263,  262,  263,  262,  263,  272,  262,  272,
};
}
final static short YYFINAL=2;
final static short YYMAXTOKEN=272;
final static String yyname[] = {
"end-of-file",null,null,null,null,null,null,null,null,null,null,null,null,null,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,
"'.'",null,null,null,null,null,null,null,null,null,null,null,null,"';'",null,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,
null,null,null,null,"ID","NUM","ASSIGN","PLUS","MINUS","BEGIN","END","PROGRAM",
"INT","FLOAT","STRING","REL_OP","TEXT","PRINT","OPEN_PAREN","CLOSE_PAREN",
};
final static String yyrule[] = {
"$accept : program",
"program : PROGRAM ID ';' prog_lines subprograms compound_stmt '.'",
"prog_lines : stmt_list",
"prog_lines :",
"stmt_list : stmt",
"stmt_list : stmt_list ';' stmt",
"subprograms : subprograms compound_stmt",
"subprograms :",
"compound_stmt : BEGIN prog_lines compound_stmt END",
"compound_stmt :",
"stmt : type ID ASSIGN expr",
"stmt : ID ASSIGN expr",
"stmt : PRINT OPEN_PAREN expr CLOSE_PAREN",
"type : INT",
"type : STRING",
"type : FLOAT",
"expr : expr PLUS expr",
"expr : expr MINUS expr",
"expr : ID",
"expr : NUM",
"expr : TEXT",
};

//#line 199 "m4-solution.y"


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
//#line 645 "Parser.java"
//###############################################################
// method: yylexdebug : check lexer state
//###############################################################
void yylexdebug(int state,int ch)
{
String s=null;
  if (ch < 0) ch=0;
  if (ch <= YYMAXTOKEN) //check index bounds
     s = yyname[ch];    //now get it
  if (s==null)
    s = "illegal-symbol";
  debug("state "+state+", reading "+ch+" ("+s+")");
}





//The following are now global, to aid in error reporting
int yyn;       //next next thing to do
int yym;       //
int yystate;   //current parsing state from state table
String yys;    //current token string


//###############################################################
// method: yyparse : parse input and execute indicated items
//###############################################################
int yyparse()
{
boolean doaction;
  init_stacks();
  yynerrs = 0;
  yyerrflag = 0;
  yychar = -1;          //impossible char forces a read
  yystate=0;            //initial state
  state_push(yystate);  //save it
  val_push(yylval);     //save empty value
  while (true) //until parsing is done, either correctly, or w/error
    {
    doaction=true;
    if (yydebug) debug("loop"); 
    //#### NEXT ACTION (from reduction table)
    for (yyn=yydefred[yystate];yyn==0;yyn=yydefred[yystate])
      {
      if (yydebug) debug("yyn:"+yyn+"  state:"+yystate+"  yychar:"+yychar);
      if (yychar < 0)      //we want a char?
        {
        yychar = yylex();  //get next token
        if (yydebug) debug(" next yychar:"+yychar);
        //#### ERROR CHECK ####
        if (yychar < 0)    //it it didn't work/error
          {
          yychar = 0;      //change it to default string (no -1!)
          if (yydebug)
            yylexdebug(yystate,yychar);
          }
        }//yychar<0
      yyn = yysindex[yystate];  //get amount to shift by (shift index)
      if ((yyn != 0) && (yyn += yychar) >= 0 &&
          yyn <= YYTABLESIZE && yycheck[yyn] == yychar)
        {
        if (yydebug)
          debug("state "+yystate+", shifting to state "+yytable[yyn]);
        //#### NEXT STATE ####
        yystate = yytable[yyn];//we are in a new state
        state_push(yystate);   //save it
        val_push(yylval);      //push our lval as the input for next rule
        yychar = -1;           //since we have 'eaten' a token, say we need another
        if (yyerrflag > 0)     //have we recovered an error?
           --yyerrflag;        //give ourselves credit
        doaction=false;        //but don't process yet
        break;   //quit the yyn=0 loop
        }

    yyn = yyrindex[yystate];  //reduce
    if ((yyn !=0 ) && (yyn += yychar) >= 0 &&
            yyn <= YYTABLESIZE && yycheck[yyn] == yychar)
      {   //we reduced!
      if (yydebug) debug("reduce");
      yyn = yytable[yyn];
      doaction=true; //get ready to execute
      break;         //drop down to actions
      }
    else //ERROR RECOVERY
      {
      if (yyerrflag==0)
        {
        yyerror("syntax error");
        yynerrs++;
        }
      if (yyerrflag < 3) //low error count?
        {
        yyerrflag = 3;
        while (true)   //do until break
          {
          if (stateptr<0)   //check for under & overflow here
            {
            yyerror("stack underflow. aborting...");  //note lower case 's'
            return 1;
            }
          yyn = yysindex[state_peek(0)];
          if ((yyn != 0) && (yyn += YYERRCODE) >= 0 &&
                    yyn <= YYTABLESIZE && yycheck[yyn] == YYERRCODE)
            {
            if (yydebug)
              debug("state "+state_peek(0)+", error recovery shifting to state "+yytable[yyn]+" ");
            yystate = yytable[yyn];
            state_push(yystate);
            val_push(yylval);
            doaction=false;
            break;
            }
          else
            {
            if (yydebug)
              debug("error recovery discarding state "+state_peek(0)+" ");
            if (stateptr<0)   //check for under & overflow here
              {
              yyerror("Stack underflow. aborting...");  //capital 'S'
              return 1;
              }
            state_pop();
            val_pop();
            }
          }
        }
      else            //discard this token
        {
        if (yychar == 0)
          return 1; //yyabort
        if (yydebug)
          {
          yys = null;
          if (yychar <= YYMAXTOKEN) yys = yyname[yychar];
          if (yys == null) yys = "illegal-symbol";
          debug("state "+yystate+", error recovery discards token "+yychar+" ("+yys+")");
          }
        yychar = -1;  //read another
        }
      }//end error recovery
    }//yyn=0 loop
    if (!doaction)   //any reason not to proceed?
      continue;      //skip action
    yym = yylen[yyn];          //get count of terminals on rhs
    if (yydebug)
      debug("state "+yystate+", reducing "+yym+" by rule "+yyn+" ("+yyrule[yyn]+")");
    if (yym>0)                 //if count of rhs not 'nil'
      yyval = val_peek(yym-1); //get current semantic value
    yyval = dup_yyval(yyval); //duplicate yyval if ParserVal is used as semantic value
    switch(yyn)
      {
//########## USER-SUPPLIED ACTIONS ##########
case 2:
//#line 18 "m4-solution.y"
{ yyval = val_peek(0); 

                                    pushScope(); 
                                    if (isDebug) {
                                        System.out.println("\n\n"); 
                                        printNode(yyval); 
                                        printSymbolTable();
                                        }
                                    }
break;
case 3:
//#line 27 "m4-solution.y"
{/* empty */}
break;
case 4:
//#line 30 "m4-solution.y"
{ yyval = val_peek(0); }
break;
case 5:
//#line 31 "m4-solution.y"
{ yyval = makeNode(";", val_peek(2), val_peek(0));  }
break;
case 7:
//#line 35 "m4-solution.y"
{/* empty */}
break;
case 8:
//#line 38 "m4-solution.y"
{ exitScope(); }
break;
case 9:
//#line 39 "m4-solution.y"
{/* empty */}
break;
case 10:
//#line 42 "m4-solution.y"
{ 
                                    /* textSection.add("# type=" + $1.token + " ID=" + $2.token + " ASSIGN=" + $3.token + " expr=" + $4.token);*/
                                    /* dataSection.add("# type=" + $1.token + " ID=" + $2.token + " ASSIGN=" + $3.token + " expr=" + $4.token);*/
                                    Node id = val_peek(2);
                                    id.type = val_peek(3).token;
                                    Node node = makeNode(val_peek(1).token, id, val_peek(0)); 
                                    String type = postOrderIterative(node);
                                    node.type = type;
                                    yyval = node;

                                    /** MODIFY AS APPROPRIATE **/
                                    
                                    if (val_peek(0).operation.equals("NONE")) {
                                        /* update assembly here*/
                                        if (type.equals("INT")) {
                                            int reg = getIntRegister();
                                            String name = val_peek(2).token.trim();
                                            setRegister(name,"$t" + reg );
                                            /* $4.assembly = ".data\n" + $4.assembly.replace("P1", name);*/
                                            dataSection.add(val_peek(0).assembly.replace("P1", name));
                                            /* $4.assembly = $4.assembly + "\n.text\nlw " + getRegister(name) + ", " + $2.token;*/
                                            textSection.add("lw " + getRegister(name) + ", " + val_peek(2).token);
                                        } else if (type.equals("FLOAT")) {
                                            int reg = getFloatRegister();
                                            setRegister(val_peek(2).token,"$f" + reg );
                                            val_peek(0).assembly = val_peek(0).assembly.replace("P1", val_peek(2).token);
                                            /* $4.assembly = ".data\n" + $4.assembly.replace(".word", ".float");*/
                                            dataSection.add(val_peek(0).assembly.replace(".word", ".float"));
                                            /* $4.assembly += "\n.text\nl.s " + getRegister($2.token) + " " + $2.token;*/
                                            textSection.add("l.s " + getRegister(val_peek(2).token) + " " + val_peek(2).token);
                                        } else if (type.equals("STRING")) {
                                            /* $4.assembly = ".data\n" + $4.assembly.replace("P1", $2.token);*/
                                            dataSection.add(val_peek(0).assembly.replace("P1", val_peek(2).token));
                                        }
                                        /* dataSection.add($4.assembly);*/
                                    } else if (val_peek(0).operation.equals("ADD")) {
                                        if (type.equals("INT")) {
                                            String varName1 = val_peek(0).assembly.split(",")[1].trim();
                                            /* setRegister(varName1,  "$t" +getIntRegister());*/
                                            String outreg = "$t" + getIntRegister();
                                            setRegister(val_peek(2).token, outreg);
                                            val_peek(0).assembly = val_peek(0).assembly.replace("$OUT", getRegister(val_peek(2).token) );
                                            /*find in hashmap, which register has the value of this variable name*/
                                            /* replace $tX*/
                                            val_peek(0).assembly = val_peek(0).assembly.replace(varName1, getRegister(varName1));

                                            String varName2 = val_peek(0).assembly.split(",")[2].trim();
                                            /* setRegister(varName2, "$t"+getIntRegister());*/
                                            /*find in hashmap, which register has the value of this variable name*/
                                            /* replace $tY*/
                                            val_peek(0).assembly =  val_peek(0).assembly.replace(varName2, getRegister(varName2));
                                        } else if (type.equals("FLOAT")) {
                                            String newReg = "$f" + getFloatRegister();
                                            setRegister(val_peek(2).token, newReg);
                                            String varName1 = val_peek(0).assembly.split(",")[1].trim();
                                            /* setRegister(varName1,  "$t" +getIntRegister());*/
                                            val_peek(0).assembly = val_peek(0).assembly.replace("$OUT", getRegister(varName1) );
                                            /*find in hashmap, which register has the value of this variable name*/
                                            /* replace $tX*/
                                            val_peek(0).assembly = val_peek(0).assembly.replace(varName1, getRegister(varName1));

                                            String varName2 = val_peek(0).assembly.split(",")[2].trim();
                                            /* setRegister(varName2, "$t"+getIntRegister());*/
                                            /*find in hashmap, which register has the value of this variable name*/
                                            /* replace $tY*/
                                            val_peek(0).assembly = "add.s " + newReg + ", " + getRegister(varName1)+ ", " + getRegister(varName2);
                                        }
                                        textSection.add(val_peek(0).assembly);
                                    }
                                    /*print the assembly code*/
                                    /* System.out.println($4.assembly);*/


                                    if(isDeclaredLocally(val_peek(2)) && !canRetrieveSymbol(val_peek(2))) { 
                                        yyerror("Duplicate variable: "+val_peek(2));
                                    } else { 
                                        enterSymbol(val_peek(2), val_peek(0));
                                        saveTypeSymbol(val_peek(2));
                                    } 
                                  }
break;
case 11:
//#line 122 "m4-solution.y"
{ /*** YOUR CODE HERE ***/
                                    yyval = makeNode(val_peek(1).token, val_peek(2), val_peek(0));
                                    if (!isDeclaredLocally(val_peek(2)) && !canRetrieveSymbol(val_peek(2))) { 
                                            yyerror(val_peek(2).token + " is not declared!");
                                        }
                                    }
break;
case 12:
//#line 129 "m4-solution.y"
{
                                        /*** YOUR CODE HERE ***/
                                        /*print the expr*/
                                        /*if string, generate assembly */
                                        /*to print string*/
                                        /*same for int and float.*/
                                        /* Node node = makeNode($3.token,$1,$4);*/
                                        Node node = val_peek(1);
                                        String type = postOrderIterative(node);
                                        /* textSection.add("# Print expr " + $3 + " of type " + type);*/
                                        if (type.equals("INT")){
                                            
                                            val_peek(1).assembly = "# print INT name=" + node.token + "\n";
                                            val_peek(1).assembly += "li $v0, 1\n";
                                            val_peek(1).assembly += "move $a0, " + getRegister(node.token) + "\nsyscall\n";
                                        }
                                        else if (type.equals("FLOAT")){
                                            val_peek(1).assembly = "# PRINT FLOAT name=" + node.token + "\n";
                                            val_peek(1).assembly += "li $v0, 2\n";
                                            val_peek(1).assembly += "mov.s $f12, " + getRegister(node.token) + "\nsyscall\n";
                                        }
                                        else if (type.equals("STRING")){
                                            val_peek(1).assembly = "# PRINT STRING name=" + node.token + "\n";
                                            val_peek(1).assembly += "li $v0, 4\n";
                                            val_peek(1).assembly += "la $a0, " + node.token + "\nsyscall\n";
                                        }
                                        /* System.out.println(".data\nNEWLINE: .asciiz \"\\n\"\nli $v0, 4\nla $a0, NEWLINE\nsyscall");*/
                                        /* System.out.println(".text\n");*/
                                        /* System.out.println($3.assembly);*/
                                        textSection.add(val_peek(1).assembly);
                                    }
break;
case 13:
//#line 162 "m4-solution.y"
{ yyval = val_peek(0); }
break;
case 14:
//#line 163 "m4-solution.y"
{ yyval = val_peek(0); }
break;
case 15:
//#line 164 "m4-solution.y"
{ yyval = val_peek(0); }
break;
case 16:
//#line 167 "m4-solution.y"
{ Node node = makeNode("+", val_peek(2), val_peek(0)); 
                                      node.operation = "ADD";
                                      node.assembly = "add $OUT, "  + val_peek(2).token + ", " + val_peek(0).token;
                                      yyval = node;
                                    }
break;
case 17:
//#line 172 "m4-solution.y"
{ Node node = makeNode("-", val_peek(2), val_peek(0)); 
                                      node.operation = "SUB";
                                      /*** Your code here for node.assembly ***/
                                      node.assembly = "sub $OUT, "  + val_peek(2).token + ", " + val_peek(0).token;
                                      yyval = node;
                                    }
break;
case 18:
//#line 178 "m4-solution.y"
{  
                                      yyval = val_peek(0);
                                        if (!isDeclaredLocally(val_peek(0)) && !canRetrieveSymbol(val_peek(0))) { 
                                            yyerror(val_peek(0).token + " is not declared!");
                                        }
                                    }
break;
case 19:
//#line 184 "m4-solution.y"
{
                                        Node node = val_peek(0);
                                        node.operation = "NONE";
                                        node.assembly = "P1: .word "+val_peek(0).token;
                                        yyval = node;
                                    }
break;
case 20:
//#line 190 "m4-solution.y"
{
                                        Node node = val_peek(0);
                                        node.operation = "NONE";
                                        node.assembly = "P1: .asciiz "+val_peek(0).token;
                                        yyval = node;
                                    }
break;
//#line 1012 "Parser.java"
//########## END OF USER-SUPPLIED ACTIONS ##########
    }//switch
    //#### Now let's reduce... ####
    if (yydebug) debug("reduce");
    state_drop(yym);             //we just reduced yylen states
    yystate = state_peek(0);     //get new state
    val_drop(yym);               //corresponding value drop
    yym = yylhs[yyn];            //select next TERMINAL(on lhs)
    if (yystate == 0 && yym == 0)//done? 'rest' state and at first TERMINAL
      {
      if (yydebug) debug("After reduction, shifting from state 0 to state "+YYFINAL+"");
      yystate = YYFINAL;         //explicitly say we're done
      state_push(YYFINAL);       //and save it
      val_push(yyval);           //also save the semantic value of parsing
      if (yychar < 0)            //we want another character?
        {
        yychar = yylex();        //get next character
        if (yychar<0) yychar=0;  //clean, if necessary
        if (yydebug)
          yylexdebug(yystate,yychar);
        }
      if (yychar == 0)          //Good exit (if lex returns 0 ;-)
         break;                 //quit the loop--all DONE
      }//if yystate
    else                        //else not done yet
      {                         //get next state and push, for next yydefred[]
      yyn = yygindex[yym];      //find out where to go
      if ((yyn != 0) && (yyn += yystate) >= 0 &&
            yyn <= YYTABLESIZE && yycheck[yyn] == yystate)
        yystate = yytable[yyn]; //get new state
      else
        yystate = yydgoto[yym]; //else go to new defred
      if (yydebug) debug("after reduction, shifting from state "+state_peek(0)+" to state "+yystate+"");
      state_push(yystate);     //going again, so push state & val...
      val_push(yyval);         //for next action
      }
    }//main loop
  return 0;//yyaccept!!
}
//## end of method parse() ######################################



//## run() --- for Thread #######################################
/**
 * A default run method, used for operating this parser
 * object in the background.  It is intended for extending Thread
 * or implementing Runnable.  Turn off with -Jnorun .
 */
public void run()
{
  yyparse();
}
//## end of method run() ########################################



//## Constructors ###############################################
/**
 * Default constructor.  Turn off with -Jnoconstruct .

 */
public Parser()
{
  //nothing to do
}


/**
 * Create a parser, setting the debug to true or false.
 * @param debugMe true for debugging, false for no debug.
 */
public Parser(boolean debugMe)
{
  yydebug=debugMe;
}
//###############################################################



}
//################### END OF CLASS ##############################
