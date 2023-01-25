%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include <stdbool.h>
#include "ts.h"
#include"pgm.h"
#include "syn.tab.h"
int nb_ligne=1;
extern  Col;
 extern YYSTYPE yylval;
 int cpt;
char cst2[20];

%}

/* regex de base */

num [0-9]
lettre [a-zA-Z]
lettre_maj [A-Z]

/*IDF et CST */

int {num}+ 
pint_s   \(([+]|-)([1-9]{num}*|0)\)
float ({num}*[.]{num}+) 
pfloat_s     \(([+]|-)([1-9]{num}*"."{num}+|0"."{num}+)\)
char \'[^']\'
IDF{lettre_maj}({lettre}|{num})*
ADD "+"
SUB "-"
DID "/"
MUL "*"
%%
"if"    { rechercher(yytext,"Mot cle","",0, 1); printf ("ligne %d : mot cle  reconnue est %s \n", nb_ligne,yytext);  Col=Col+strlen(yytext); return mc_if ;} 
"else"   { rechercher(yytext,"Mot cle","",0, 1); printf ("ligne %d : mot cle  reconnue est %s \n", nb_ligne,yytext);  Col=Col+strlen(yytext); return mc_else;} 
"while"   { rechercher(yytext,"Mot cle","",0, 1); printf ("ligne %d : mot cle  reconnue est %s \n", nb_ligne,yytext);  Col=Col+strlen(yytext); return mc_while;} 
"for"    { rechercher(yytext,"Mot cle","",0, 1); printf ("ligne %d : mot cle  reconnue est %s \n", nb_ligne,yytext);  Col=Col+strlen(yytext); return mc_for;} 
"range"    { rechercher(yytext,"Mot cle","",0, 1); printf ("ligne %d : mot cle  reconnue est %s \n", nb_ligne,yytext); Col=Col+strlen(yytext); return mc_range; } 
"and"    { rechercher(yytext,"Mot cle","",0, 1); printf ("ligne %d : mot cle  reconnue est %s \n", nb_ligne,yytext);  Col=Col+strlen(yytext); return and ; } 
"or"    { rechercher(yytext,"Mot cle","",0, 1); printf ("ligne %d : mot cle  reconnue est %s \n", nb_ligne,yytext);  Col=Col+strlen(yytext); return or; } 
"in"    { rechercher(yytext,"Mot cle","",0, 1); printf ("ligne %d : mot cle  reconnue est %s \n", nb_ligne,yytext);  Col=Col+strlen(yytext); return mc_in; } 
"int"    { rechercher(yytext,"Mot cle","",0, 1); yylval.str=strdup(yytext); printf ("ligne %d : mot cle  reconnue est %s \n", nb_ligne,yytext);  Col=Col+strlen(yytext); return mc_int;} 
"float"    { rechercher(yytext,"Mot cle","",0, 1); yylval.str=strdup(yytext); printf ("ligne %d : mot cle  reconnue est %s \n", nb_ligne,yytext);  Col=Col+strlen(yytext); return mc_float;} 
"bool"    { rechercher(yytext,"Mot cle","",0, 1); yylval.str=strdup(yytext); printf ("ligne %d : mot cle  reconnue est %s \n", nb_ligne,yytext);  Col=Col+strlen(yytext); return mc_bool;} 
"char"    { rechercher(yytext,"Mot cle","",0, 1); yylval.str=strdup(yytext); printf ("ligne %d : mot cle  reconnue est %s \n", nb_ligne,yytext);  Col=Col+strlen(yytext); return mc_char;} 
{int} { yylval.entier=atoi(yytext); 
                       Col = Col + strlen(yytext);
                       if(yylval.entier>32767 || yylval.entier<(-32768)){
						     printf ("Erreur lexicale: depassement de la taille des entiers  a la Ligne %d et a la colonne %d \n", nb_ligne, Col);
					   }
					   else {
						     rechercher (yytext,"Cst entier ","int",atoi(yytext), 0);
						     printf("Entite Lexical reconnue %s \n" , yytext );   return intp; 
					   }
	}
{pint_s}  {yylval.entier=Atoi_v2(yytext); 
            if(yylval.entier>32767 || yylval.entier<-32768){                          
            printf ("Erreur lexicale: depassement de la taille des entiers  a la Ligne %d et a la colonne %d \n", nb_ligne, Col);
                }
            
            else{
                
						     rechercher (yytext,"Cst entier ","int",Atoi_v2(yytext), 0);
						     printf("Entite Lexical reconnue %s \n" , yytext );
             

                }
			 int x=strlen(yytext)-2;
            int i=1;
            int z=1;
            if(yytext[i]!='-')
            {
                i=2;  
                z=2;
            }
            while( i<=x )
            {
                cst2[i-z]=yytext[i];
                i++;
            }
                yylval.entier=atoi(cst2);
                strcpy(cst2,"                ");
                Col= Col+ strlen(yytext);

             return pint_s; 
            }
{float} { rechercher (yytext,"Cst reel ","float",atof(yytext),0); yylval.reel=atof(yytext); printf("Entite Lexical reconnue %s \n" , yytext );  Col = Col + strlen(yytext); return floatp;}
{pfloat_s}  {yylval.reel=Atof_v2(yytext); rechercher (yytext,"Cst reel ","float",Atof_v2(yytext),0); printf("Entite Lexical reconnue %s \n" , yytext );  Col = Col + strlen(yytext);
            int x=strlen(yytext)-2;
            int i=1;
            int z=1;
            if(yytext[i]!='-')
            {
                i=2;  
                z=2;
            }
            while( i<=x )
            {
                cst2[i-z]=yytext[i];
                i++;
            }
                yylval.reel=atoi(cst2);
                strcpy(cst2,"                ");
                Col= Col+ strlen(yytext);

            return pfloat_s; 
            }
{char}  { rechercher (yytext,"caractere","char",0, 0); yylval.str=strdup(yytext); printf("Entite Lexical reconnue %s \n" , yytext );  Col = Col + strlen(yytext); return charp;}
true { printf("ligne %d : boolean reconnue %s \n",nb_ligne,yytext);rechercher(yytext,"bool","bool",0, 0); Col=Col+strlen(yytext);yylval.boolConstant=0; return boolp; }
false { printf("ligne %d : boolean reconnue %s \n",nb_ligne,yytext);rechercher(yytext,"bool","bool",1, 0); Col=Col+strlen(yytext);yylval.boolConstant=1; return boolp; }
{IDF} {   
			       Col= Col+ strlen (yytext); 
                   if (yyleng<=8) {   
				                    rechercher (yytext,"IDF ","",0, 0);
			                        printf("Entite Lexical reconnue %s \n" , yytext ); 
                                    yylval.str=strdup(yytext);									
									return idf;
							      }
                    else printf ("Erreur lexicale: IDF trop long %s a la Ligne %d et a la colonne %d \n",yytext, nb_ligne, Col);
 }
\#(.*\n) {yylval.str=strdup(yytext);nb_ligne++;}
"," { rechercher (yytext,"Virgule"," ",0, 2); printf("ligne %d : separateur reconnu   %s \n" , nb_ligne,yytext ); Col=Col+strlen(yytext);  return vrg; }
"." { rechercher (yytext,"Point"," ",0, 2); printf("ligne %d : separateur reconnu   %s \n" , nb_ligne,yytext );  Col=Col+strlen(yytext); return point; }
":" { rechercher (yytext,"deux_Point"," ",0, 2); printf("ligne %d : separateur reconnu   %s \n" , nb_ligne,yytext );  Col=Col+strlen(yytext);  return dpoint; }
{ADD} { rechercher (yytext,"addition"," ",0, 2); printf("ligne %d : separateur reconnu   %s \n" , nb_ligne,yytext );  Col=Col+strlen(yytext);  return add;}
{SUB} { rechercher (yytext,"substraction"," ",0, 2); printf("ligne %d : separateur reconnu   %s \n" , nb_ligne,yytext );   Col=Col+strlen(yytext); return sub;}
{DID} { rechercher (yytext,"division"," ",0, 2); printf("ligne %d : separateur reconnu   %s \n" , nb_ligne,yytext ); Col=Col+strlen(yytext);  return divi; }
{MUL} { rechercher (yytext,"multiplication"," ",0, 2); printf("ligne %d : separateur reconnu   %s \n" , nb_ligne,yytext );  Col=Col+strlen(yytext);  return mult;}
"=" { rechercher (yytext,"affectation"," ",0, 2); printf("ligne %d : separateur reconnu   %s \n" , nb_ligne,yytext ); Col=Col+strlen(yytext);  return aff;  }
"(" { rechercher (yytext,"parenthese_ouvr"," ",0, 2); printf("ligne %d : separateur reconnu   %s \n" , nb_ligne,yytext ); Col=Col+strlen(yytext);  return po; }
")" { rechercher (yytext,"parenthese_ferm"," ",0, 2); printf("ligne %d : separateur reconnu   %s \n" , nb_ligne,yytext ); Col=Col+strlen(yytext);   return pf;}
"[" { rechercher (yytext,"crocht_ouvr"," ",0, 2); printf("ligne %d : separateur reconnu   %s \n" , nb_ligne,yytext ); Col=Col+strlen(yytext);  return co; }
"]" { rechercher (yytext,"crocht_ferm"," ",0, 2); printf("ligne %d : separateur reconnu   %s \n" , nb_ligne,yytext );  Col=Col+strlen(yytext); return cf; }
"{" { rechercher (yytext,"accolade_ouvr"," ",0, 2); printf("ligne %d : separateur reconnu   %s \n" , nb_ligne,yytext );  Col=Col+strlen(yytext);  return ao;}
"}" { rechercher (yytext,"accolade_ferm "," ",0, 2); printf("ligne %d : separateur reconnu   %s \n" , nb_ligne,yytext ); Col=Col+strlen(yytext);  return af; } 
"<" { rechercher (yytext,"inf "," ",0, 2); printf("ligne %d : separateur reconnu   %s \n" , nb_ligne,yytext );  Col=Col+strlen(yytext); return l ;}
">" { rechercher (yytext,"sup "," ",0, 2); printf("ligne %d : separateur reconnu   %s \n" , nb_ligne,yytext ); Col=Col+strlen(yytext);  return  g;}
">=" { rechercher (yytext,"inf_equal"," ",0, 2); printf("ligne %d : separateur reconnu   %s \n" , nb_ligne,yytext );  Col=Col+strlen(yytext);  return le;}
"<=" { rechercher (yytext,"sup_equal "," ",0, 2); printf("ligne %d : separateur reconnu   %s \n" , nb_ligne,yytext );  Col=Col+strlen(yytext);  return ge;}
"==" { rechercher (yytext,"equal "," ",0, 2); printf("ligne %d : separateur reconnu   %s \n" , nb_ligne,yytext ); Col=Col+strlen(yytext);   return egg;}
"!=" { rechercher (yytext,"not_equal "," ",0, 2); printf("ligne %d : separateur reconnu   %s \n" , nb_ligne,yytext ); Col=Col+strlen(yytext);  return negg; }
"    " { Col=Col+strlen(yytext);  return space; }
[ \t] { Col = Col + strlen(yytext);}

\n {Col =1; nb_ligne++;return saut;}
. printf("Erreur lexicale ligne %d sur l'entite %s\n",nb_ligne,yytext);
%%


