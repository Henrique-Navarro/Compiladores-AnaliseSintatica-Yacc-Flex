%{  
    #include <stdio.h>                  //INCLUDES
    #include <stdlib.h>
    #include <stdbool.h>
    #include <string.h>

    #include "y.tab.h"

    #include "hash_table.h"             //HASH
    extern HashTable* ht;

    extern int yylex(void);
    
    void yyerror(char *);               //METODOS GLOBAIS

    void printar(char *);               //METODOS DO ARQUIVO
    void add_on_tabela_simbolos();

    int first = 1;                      //VARIAVEIS DO ARQUIVO
    int print_tokens = 0;
    bool is_inteiro = true;
    bool first_t = true;
    bool variaveis_declaradas = false;
%}

%option yylineno

DIGITO          [0-9]+                   
ID              [a-zaA-Z]([a-zaA-Z0-9])*
ESPACO          [ \n\t\r]+

%x comentario

%%

inicio                          { variaveis_declaradas = true; printar(yytext); return T_INICIO; }
fimprograma                     { first=2; printar(yytext); return T_FIM; }
programa                        { printar(yytext); return T_PROGRAMA; }
logico                          { is_inteiro=false; printar(yytext); return T_LOGICO; }
inteiro                         { is_inteiro=true; printar(yytext); return T_INTEIRO; }                                
escreva                         { printar(yytext); return T_ESCREVA; }
faca                            { printar(yytext); return T_FACA; }
leia                            { printar(yytext); return T_LEIA; }
enquanto                        { printar(yytext); return T_ENQTO; }
fimenquanto                     { printar(yytext); return T_FIMENQTO; }
se                              { printar(yytext); return T_SE; }
entao                           { printar(yytext); return T_ENTAO; }
senao                           { printar(yytext); return T_SENAO; }
fimse                           { printar(yytext); return T_FIMSE; }
"<-"                            { printar(yytext); return T_ATRIB; }
"*"                             { printar(yytext); return T_VEZES; }
"div"                           { printar(yytext); return T_DIV; }
"+"                             { printar(yytext); return T_MAIS; }
"-"                             { printar(yytext); return T_MENOS; }
">"                             { printar(yytext); return T_MAIOR; }
"<"                             { printar(yytext); return T_MENOR; }
"=="                            { printar(yytext); return T_IGUAL; }
"e"                             { printar(yytext); return T_E; }
"ou"                            { printar(yytext); return T_OU; }
{DIGITO}                        {
                                    yylval = atoi(yytext);
                                    printar(yytext);
                                    return T_NUMERO;
                                }
"V"                             { 
                                    yylval = true;
                                    printar(yytext);
                                    return T_V;
                                }
"F"                             { 
                                    yylval = false;
                                    printar(yytext);
                                    return T_F; 
                                }
"nao"                           { printar(yytext); return T_NAO; }
"("                             { printar(yytext); return T_ABRE; }
")"                             { printar(yytext); return T_FECHA; }
{ID}                            {  
                                    /*Fazer o T_IDENTIF retornar uma 
                                    %union{int ival; bool bval; char* name;}*/

                                    if(!first_t && !variaveis_declaradas)
                                        add_on_tabela_simbolos();
                                     
                                    first_t = false;
                                    yylval = *yytext - 'a';
                                    printar(yytext);
                                    return T_IDENTIF;
                                }


{ESPACO}                        {/*NADA*/}
"//".*                          {/*NADA*/}
"/*" BEGIN(comentario); 
<comentario>"*/" BEGIN(INITIAL);
<comentario>.                   {/*NADA*/}

{DIGITO}+{ID}+                  { 
                                    yyerror("Nome de ID invalido");
                                }
.                               { 
                                    yyerror("Simbolo não reconhecido");
                                }

%%

void add_on_tabela_simbolos(){
    char* id_name = strdup(yytext);

    Node* node_int = get_int(ht, id_name);
    Node* node_bool = get_bool(ht, id_name);

    if (node_int == NULL && node_bool == NULL) {
        if (is_inteiro)
            insert_int(ht, id_name, 0);
        else
            insert_bool(ht, id_name, 0);
    } else {
        extern int yylineno; 
        extern char * yytext; 
        printf("Erro (Variavel já declarada): '%s' (linha: %d)\n", yytext, yylineno);
    }
}

int yywrap(void){
    return 1;
}

void printar(char* s){
    if(print_tokens==1){
        if(first==1){
            printf("Lista Tokens:\n{\n");first=0;
        }
        printf("\t%s,\n", s);
        if(first==2){
            printf("}\n");
        }
    }
}