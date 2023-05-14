%{
    #include <stdio.h>                  //INCLUDES
    #include <stdlib.h>
    #include <stdbool.h>
    #include <string.h>

    #include "hash_table.h"             //HASH
    extern HashTable* ht;

    extern char* yytext;                //VARIÁVEIS GLOBAIS
    extern FILE *yyin;

    int yylex(void);                    //METODOS GLOBAIS
    int yyparse(void);
    void yyerror(char *);

    char* id_name;                      //VARIAVEIS E METODOS DO ARQUIVO
    void true_or_false(bool i);         
%}

%token T_INICIO T_FIM T_PROGRAMA T_IDENTIF T_LOGICO T_INTEIRO T_LEIA T_ESCREVA T_ENQTO T_FACA T_FIMENQTO
%token T_SE T_ENTAO T_SENAO T_FIMSE T_ATRIB T_VEZES T_DIV T_MAIS T_MENOS T_MAIOR T_MENOR T_IGUAL T_E T_OU
%token T_NUMERO T_V T_F T_NAO T_ABRE T_FECHA

%left '+' '-'
%left '*' '/'
%nonassoc UMINUS

%%

programa:
    cabecalho variaveis T_INICIO lista_comandos T_FIM
    ;

cabecalho:
    T_PROGRAMA T_IDENTIF
    ;

variaveis:
    //vazio
    | declaracao_variaveis
    ;

declaracao_variaveis:
    tipo lista_variaveis declaracao_variaveis 
    | tipo lista_variaveis
    ;

tipo:
    T_LOGICO                                
    | T_INTEIRO                             
    ;

lista_variaveis:
    T_IDENTIF lista_variaveis               
    | T_IDENTIF                             
    ;

lista_comandos:
    comando lista_comandos
    | //vazio
    ;

comando:
    entrada_saida
    | repeticao
    | selecao
    | atribuicao
    ;

entrada_saida:
    leitura
    | escrita
    ;

leitura: 
    T_LEIA T_IDENTIF
    ;

escrita:
    T_ESCREVA expressao                 { 
                                            //printf("%d\n", $$); 
                                        }
    ;

repeticao:
    T_ENQTO expressao T_FACA lista_comandos T_FIMENQTO
    ;

selecao:
    T_SE expressao T_ENTAO lista_comandos T_SENAO lista_comandos T_FIMSE
    | T_SE expressao T_ENTAO lista_comandos T_FIMSE
    ;

atribuicao:
    T_IDENTIF T_ATRIB expressao             {
                                                /*
                                                Não está pegando nome_variável
                                                Fazer o T_IDENTIF retornar uma 
                                                %union{int ival; bool bval; char* name;}
                                                */

                                                char* id_name = strdup("$1");
                                                //printf("%s", id_name);
                                                //printf("%d %d", $$, $3);
                                                
                                                if (get_bool(ht, id_name) != NULL) {
                                                    int bool_value = ($3 != 0);
                                                    set_bool(ht, id_name, bool_value);
                                                } else {
                                                    int int_value = $3;
                                                    set_int(ht, "A", int_value);
                                                }
                                                $$ = $3;
                                            }          
    ;


expressao:
    expressao T_VEZES expressao             { 
                                                $$ = $1 * $3; 
                                                printf("%d * %d = %d\n", $1, $3, $$); 
                                            }
    | expressao T_DIV expressao             {
                                                if($3==0){
                                                    yyerror("divisão por zero");
                                                }
                                                else{
                                                    $$ = $1 / $3;
                                                    printf("%d / %d = %d\n", $1, $3, $$);
                                                } 
                                            }
    | expressao T_MAIS expressao            { 
                                                $$ = $1 + $3; 
                                                printf("%d + %d = %d\n", $1, $3, $$); }
    | expressao T_MENOS expressao           { 
                                                $$ = $1 - $3; 
                                                printf("%d - %d = %d\n", $1, $3, $$); }
    | expressao T_MAIOR expressao           { 
                                                $$ = $1 > $3; 
                                                //true_or_false($$);
                                            }
    | expressao T_MENOR expressao           { 
                                                $$ = $1 < $3; 
                                                //true_or_false($$); 
                                            }
    | expressao T_IGUAL expressao           { 
                                                if($1 == $3)$$ = true;
                                                else $$ = false;
                                                //true_or_false($$);
                                            }
    | expressao T_E expressao               { 
                                                $$ = $1 && $3; 
                                                //true_or_false($$);
                                            }
    | expressao T_OU expressao              { 
                                                $$ = $1 || $3; 
                                                //true_or_false($$);
                                            }
    | T_MENOS expressao %prec UMINUS        { $$ = -$2; /*printf("%d\n",$$);*/ }
    | termo                                
    ;

termo:
    T_IDENTIF                               
    | T_NUMERO
    | T_V
    | T_F
    | T_NAO termo
    | T_ABRE expressao T_FECHA
    ;

%%

void yyerror(char *s){
    extern int yylineno; 
    extern char * yytext; 
    printf("Erro (%s): '%s' (linha: %d)\n", s, yytext, yylineno);
}

void true_or_false(bool i){
    //if(i)printf("true"); else printf("false"); printf("\n");
}

int main(void){
    FILE *f_in = fopen("./testes/testeEnquanto.simples", "r");
    yyin = f_in;

    ht = create_hash_table(100);

    if(f_in == NULL){printf("Erro ao ler arquivo!\n");return 0;}

    yyparse();

    print_hash_table(ht);

    free_hash_table(ht);
    fclose(f_in);
    return 0;
}
