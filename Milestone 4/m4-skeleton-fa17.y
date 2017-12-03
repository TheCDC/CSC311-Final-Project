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
                                            $4.assembly = $4.assembly.replace("P1", $2.token);
                                            $4.assembly = "lw $t" + getIntRegister() + ", " + $2.token;
                                        } else if (type.equals("FLOAT")) {
                                            $4.assembly = $4.assembly.replace("P1", $2.token);
                                            $4.assembly = $4.assembly.replace(".word", ".float");
                                        } else if (type.equals("STRING")) {
                                            $4.assembly = $4.assembly.replace("P1", $2.token);
                                        }
                                    } else if ($4.operation.equals("ADD")) {
                                        if (type.equals("INT")) {
                                            $4.assembly = $4.assembly.replace("$OUT", "$t" + getIntRegister());
                                            String varName1 = $4.assembly.split(",")[1];
                                            //find in hashmap, which register has the value of this variable name
                                            $4.assembly = $4.assembly.replace(varName1, "$tX");

                                            String varName2 = $4.assembly.split(",")[2];
                                            //find in hashmap, which register has the value of this variable name
                                            $4.assembly = $4.assembly.replace(varName2, "$tY");
                                        } else if (type.equals("FLOAT")) {

                                        }
                                    }
                                    //print the assembly code
                                    System.out.println($4.assembly);


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
                                    }
        ;

type    :    INT                    { $$ = $1; }
        |    STRING                 { $$ = $1; }
        |    FLOAT                  { $$ = $1; }
        ;

expr    :   expr PLUS term          { $$ = makeNode("+", $1, $3); 
                                      node.operation = "ADD";
                                      node.assembly = "add $OUT, "  + $1.token + ", " + $3.token;
                                      $$ = node;
                                    }
        |   expr MINUS term         { $$ = makeNode("-", $1, $3); 
                                      node.operation = "SUB";
                                      /*** Your code here for node.assembly ***/
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
