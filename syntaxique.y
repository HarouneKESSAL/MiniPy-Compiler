%{
#include <stdlib.h>
#include<stdio.h>
#include <stdbool.h>
#include<string.h>
extern nb_ligne; 
int  Col =1;
char sauvType[50];
char sauvOpr[5];
char sauvOpr2[5];
char sauvOpL[10];
char etiquette[10];
float sauvVal;
float sauvVal2;
char sauvType2[20];
int sauvTypeVal;
int sauvTypeVal2;
float sauvTypeVall;
int tricher=0;
char sauveIdf[10];
char sauveIdf2[10];
int cptIDF=0;
char* tabIDF[50][10];
int choix;
float resultat;
int Fin_if=0,deb_else=0,deb_while=0,fin_while=0,deb_instfor=0,fin_instfor=0;
int qc=0,qc2=0;
char tmp [20]; 

int cc=0;
char NomIdf[8], NomIdf2[8];
int tailletab1,tailletab2, tailletab3,borne_sup,borne_inf;
float  sauvopd1,sauvopd2,sauvopd3;
%}

%union
{
   int entier ;
   float reel;
   char* str;
   bool boolConstant;
}

%token 
<str>mc_int 
<str>mc_float 
<str>mc_char 
<str>mc_bool 
<str>idf 
add 
sub 
mult 
divi 
aff 
po 
pf 
co 
ind 
mc_in  
mc_range 
mc_while 
mc_if 
vrg 
or 
and 
not 
l 
le 
g 
ge 
egg 
negg 
<car>charp 
<bool>boolp 
<entier>intp 
<reel>floatp 
ao 
af 
cf 
mc_idf 
dpoint 
mc_for 
mc_else 
point
comment
pfloat_s
pint_s
saut
space
%start S
%left add sub
%left divi mult
%%
S: DEC INST{printf("syntaxe correcte\n"); YYACCEPT;} ;
//----------------------------------------DECLARATION---------------------------------------------------------------------;
DEC:TYPE idf LIST_VAR saut DEC
 {if(doubleDeclaration($2)==0){ 
                                insererTYPE($2,sauvType);
                                strcpy(NomIdf,$2);
                }

                else{
                printf("\nErreur semantique: Double declaration  de {{%s}} a la ligne [%d] et a la colonne [%d]\n",$2,nb_ligne,Col);
                }}
|TYPE TAB
|
;
//---dec-var---
LIST_VAR:vrg idf LIST_VAR
{if(doubleDeclaration($2)==0){
                insererTYPE($2,sauvType);
                strcpy(NomIdf2,$2);

                }
                else{
                printf("\nErreur semantique: Double declaration  de {{%s}} a la ligne [%d] et a la colonne [%d]\n",$2,nb_ligne,Col);
                }
                }
|aff CST{           sprintf(tmp,"%lf",sauvTypeVall); 
                    quadr("=",tmp,"vide",NomIdf);
                    }
|
;
//--types--
TYPE:mc_int {strcpy(sauvType,$1);}
    |mc_float {strcpy(sauvType,$1);}
    |mc_char {strcpy(sauvType,$1);}
    |mc_bool {strcpy(sauvType,$1);}
;
//---dec-tab---
TAB:idf co BORNE A vrg idf co BORNE B saut DEC
    {if (sauvTypeVal>=0){
        if(doubleDeclaration($1)==0 || doubleDeclaration($6)==0){
        insererTYPE($1,sauvType);strcpy(NomIdf,$1);
        insererTYPE($7,sauvType);strcpy(NomIdf2,$7);
        }
        else{
            printf("\nErreur semantique: Double declaration  de {{%s}} ou {{%s}} a la ligne [%d] et a la colonne [%d]\n\n",$1,$7,nb_ligne,Col);
        }
    sprintf(tmp,"%d",tailletab1); 
    quadr("BOUNDS","0",tmp,"Vide");
    quadr("ADEC",$1,"vide","vide");    
    sprintf(tmp,"%d",tailletab2); 
    quadr("BOUNDS","0",tmp,"Vide");
    quadr("ADEC",$7,"vide","vide");

      }
      else
        printf("\nErreur semantique: (%d)taille negative du tableau a la ligne [%d] a la colonne [%d] \n\n ",sauvTypeVal,nb_ligne, Col); 
    }
|idf co BORNE C saut DEC
    {if (sauvTypeVal>=0){
        if(doubleDeclaration($1)==0)
            insererTYPE($1,sauvType); 
        else{
            printf("\nErreur semantique: Double declaration  de {{%s}} a la ligne [%d] et a la colonne [%d]\n\n",$1,nb_ligne,Col);
        }
    sprintf(tmp,"%d",tailletab3); 
    quadr("BOUNDS","0",tmp,"Vide");
    quadr("ADEC",$1,"vide","vide");

      }
      else
        printf("\nErreur semantique: (%d)taille negative du tableau a la ligne [%d] a la colonne [%d] \n\n ",sauvTypeVal,nb_ligne, Col); 

    }
;
C: cf {tailletab3=sauvTypeVal;};
A: cf {tailletab1=sauvTypeVal;};
B: cf {tailletab2=sauvTypeVal;};
BORNE:intp {sauvTypeVal=$1;}
|pint_s {sauvTypeVal=$1;}
;
//---dec-aff--- 
//---const---
CST:intp  {sauvTypeVall=$1;strcpy(sauvType2,"int");}
|pint_s   {sauvTypeVall=$1;strcpy(sauvType2,"int");}
|floatp   {sauvTypeVall=$1;strcpy(sauvType2,"float");}
|pfloat_s {sauvTypeVall=$1;strcpy(sauvType2,"float");}
|charp    {strcpy(sauvType2,"char");}
|boolp    {strcpy(sauvType2,"bool");}
;
//----------------------------------------INSTRUCTIONS---------------------------------------------------------------------
INST :List_Inst ;
List_Inst:IF List_Inst 
|INST_AFF List_Inst
|WHILE_LOOP List_Inst
|FOR_LOOP List_Inst
|;
INST_AFF :idf aff INST_ARITH
                {
                    if(doubleDeclaration($1)==0){
                        insererTYPE($1,sauvType);
                    }

                    if(cc==1)
                        {
                            printf("\nErreur semantique: Non declaration de {{%s}} a la ligne [%d]\n\n",NomIdf2,nb_ligne);
                            cc=0;
                        }    

                }
|idf aff OPERANDE saut
                {
                    if(doubleDeclaration($1)==0){
                        insererTYPE($1,sauvType2);
    /*else{
			if(){
					printf("Erreur Semantique : erreur dincompatibilé de type a la ligne %d et a la colonne %d\n",nb_ligne,Col);
								 }
    }*/
                        if(strcmp(sauvType2,"int")==0)
    {
                    sprintf(tmp,"%lf",sauvVal); 
                    quadr("=",tmp,"vide",$1);
    }
    else{
                quadr("=",NomIdf,"vide",$1);
    }

                    }
    

                    if(cc==1)
                        {
                            printf("\nErreur semantique: Non declaration de {{%s}} a la ligne [%d]\n\n",NomIdf2,nb_ligne);
                            cc=0;

                }
            }
|idf aff idf co OPERANDE cf saut 
                {
                    if(doubleDeclaration($1)==0){
                        insererTYPE($1,sauvType2);
                    sprintf(tmp,"[%lf]",sauvVal);
                    strcpy(tmp,strcat($3,tmp)) ;
                    quadr("=",tmp,"vide",$1);
                    }

                    if(cc==1)
                        {
                            printf("\nErreur semantique: Non declaration de {{%s}} a la ligne [%d]\n\n",NomIdf2,nb_ligne);
                            cc=0;

                }


}
|idf co OPERANDE cf aff idf saut 
                {
                    if(doubleDeclaration($1)==0){
                        insererTYPE($1,sauvType2);
                    sprintf(tmp,"[%lf]",sauvVal);
                    strcpy(tmp,strcat($1,tmp)) ;
                    quadr("=",$6,"vide",tmp);
                    }

                    if(cc==1)
                        {
                            printf("\nErreur semantique: Non declaration de {{%s}} a la ligne [%d]\n\n",NomIdf2,nb_ligne);
                            cc=0;

                }


}
;
OPERATION :add {strcpy(sauvOpr,"+");}
| sub  {strcpy(sauvOpr,"-");}
| divi {strcpy(sauvOpr,"/");}
| mult {strcpy(sauvOpr,"*");}
;
INST_ARITH : ARITH | po INST_ARITH pf 
|ARITH OPERATION OPERANDE 
{        if(strcmp(sauvOpr,"/")==0)
            {
                if (sauvVal==0.00)
                    printf("\nErreur semantique: Division par 0 a la ligne [%d]\n\n ", nb_ligne); 
            }
        
        if((tricher==1) && (cc==0)){
            if(doubleDeclaration(NomIdf)==0){
                cc=1;tricher=0;
                strcpy(NomIdf2,NomIdf);
            }
        }
        sauvopd3=sauvVal;

    if(strcmp(sauvType2,"int")==0)
    {
                sprintf(tmp,"%lf",sauvVal);
                sprintf(tmp,"%lf",sauvVal); 
                quadr(sauvOpr,tmp,tmp,"t2");
                strcpy(tmp,"t2");
    }
    else{ 
                quadr(sauvOpr,NomIdf,NomIdf2,"t2");
                strcpy(tmp,"t2");
    }
}
| po INST_ARITH pf OPERATION OPERANDE 
{        if(strcmp(sauvOpr,"/")==0)
            {
                if (sauvVal==0.00)
                    printf("\nErreur semantique: Division par 0 a la ligne [%d]\n\n ", nb_ligne); 
            }
        
        if((tricher==1) && (cc==0)){
            if(doubleDeclaration(NomIdf)==0){
                cc=1;tricher=0;
                strcpy(NomIdf2,NomIdf);
            }
        }
}
| ARITH OPERATION INST_ARITH 
| po INST_ARITH pf OPERATION INST_ARITH;
ARITH: OPERANDE D OPERANDE
{        if(strcmp(sauvOpr,"/")==0)
            {
                if (sauvVal==0.00)
                    printf("\nErreur semantique: Division par 0 a la ligne [%d]\n\n ", nb_ligne); 
            }
        
        if((tricher==1) && (cc==0)){
            if(doubleDeclaration(NomIdf)==0){
                cc=1;tricher=0;
                strcpy(NomIdf2,NomIdf);
            }
        }

 if(strcmp(sauvType2,"int")==0)
    {
                sprintf(tmp,"%lf",sauvopd1);
                sprintf(tmp,"%lf",sauvVal); 
                quadr(sauvOpr,tmp,tmp,"t1");
    }
    else{ 
                quadr(sauvOpr,NomIdf,NomIdf2,"t1");

}
}
;
D: OPERATION {strcpy(NomIdf2,NomIdf); sauvopd1=sauvVal;};
OPERANDE:idf  {tricher=1; strcpy(NomIdf,$1);}
|intp      {choix=1; sauvVal=$1;strcpy(sauvType2,"int");}
|pint_s   {sauvVal=$1;   strcpy(sauvType2,"int");}
|floatp   {choix=1; sauvVal=$1; strcpy(sauvType2,"int");}
|pfloat_s {sauvVal=$1;   strcpy(sauvType2,"float");}
|charp    {strcpy(sauvType2,"char");}
|boolp    {strcpy(sauvType2,"bool");}
;
//---if---
IF : E mc_else dpoint saut LIST_SPACE INST saut {
    sprintf(tmp,"%d",qc);  
    ajour_quad(Fin_if,1,tmp);
	printf("pgm juste");
}
;
E:F INST saut{
    			Fin_if=qc;
                quadr("BR", "","vide", "vide"); 
				sprintf(tmp,"%d",qc); 
                ajour_quad(deb_else,1,tmp);
};
F:mc_if po LOGICAL_EXPRESSIONS pf dpoint saut space{
            if(strcmp(sauvType2,"int")==0)
    {           deb_else=qc;
                sprintf(tmp,"%lf",sauvVal);
                sprintf(tmp,"%lf",sauvVal); 
                quadr(etiquette,"",tmp,tmp);
    }
    else{           deb_else=qc;
                quadr(etiquette,"",NomIdf,NomIdf2);
    } 
};
LOGICAL_EXPRESSIONS: LOGICAL_EXPRESSION|LOGICAL_EXPRESSION and LOGICAL_EXPRESSION | LOGICAL_EXPRESSION or LOGICAL_EXPRESSION;
LOGICAL_EXPRESSION : OPERANDE LOGICAL_OPERATIONS OPERANDE;
|INST_ARITH LOGICAL_OPERATIONS INST_ARITH{
        if(strcmp(sauvType2,"int")==0)
    {
                sprintf(tmp,"%lf",sauvopd1);
                sprintf(tmp,"%lf",sauvVal); 
                quadr(sauvOpr,tmp,tmp,"t2");
    }
    else{ 
                quadr(sauvOpr,NomIdf,NomIdf2,"t2");
    }
                    }
|not OPERANDE;
LOGICAL_OPERATIONS : g {strcpy(sauvOpL,">"); strcpy(etiquette,"BLE");}
|ge {strcpy(sauvOpL,">="); strcpy(etiquette,"BL");}
|l  {strcpy(sauvOpL,"<"); strcpy(etiquette,"BGE");}
|le {strcpy(sauvOpL,">="); strcpy(etiquette,"BG");}
|egg  {strcpy(sauvOpL,"=="); strcpy(etiquette,"BNE");}
|negg  {strcpy(sauvOpL,"!="); strcpy(etiquette,"BE");}
; 
//---while----
WHILE_LOOP:G INST saut{
            fin_while=qc;
            quadr("BR","","vide", "vide"); 
			sprintf(tmp,"%d",qc); 
            ajour_quad(deb_while,1,tmp);
            sprintf(tmp,"%d",qc2); 
            ajour_quad(fin_while,1,tmp);
};
G:H po LOGICAL_EXPRESSIONS pf dpoint saut LIST_SPACE{
            if(strcmp(sauvType2,"int")==0)
    {           deb_while=qc;
                sprintf(tmp,"%lf",sauvVal);
                sprintf(tmp,"%lf",sauvVal); 
                quadr(etiquette,"",tmp,tmp);
    }
    else{   deb_while=qc;
            quadr(etiquette,"",NomIdf,NomIdf2);
    }  

}
;
H: mc_while{qc2=qc;}
;
//----for-----
FOR_LOOP :K dpoint saut space INST saut{
        quadr("+","1",NomIdf,NomIdf);
        fin_instfor=qc;
         quadr("BR","","vide", "vide");
         sprintf(tmp,"%d",qc-3);
         ajour_quad(fin_instfor,1,tmp);
         sprintf(tmp,"%d",qc); 
         ajour_quad(deb_instfor,1,tmp);
         

};
K:mc_for idf mc_in idf {
                strcpy(NomIdf,$2);
                strcpy(tmp,strcat($4,"[0]")) ;
                quadr("=",$2,tmp,$2);
                sprintf(tmp,"%d",tailletab3);
                deb_instfor=qc;
                quadr("BG","",$2,tmp);
}
|P vrg CONST_1 pf{
              borne_sup=sauvTypeVal;
              sprintf(tmp,"%d",borne_sup);
              deb_instfor=qc;
              quadr("BG","",NomIdf,tmp);
};
P:mc_for idf mc_in mc_range po CONST_1{
            strcpy(NomIdf,$2);
            borne_inf=sauvTypeVal;
            sprintf(tmp,"%d",borne_inf);
            quadr("=",tmp,"vide",$2);
            
            
};
CONST_1:intp {sauvTypeVal=$1;}
|pint_s {sauvTypeVal=$1;}
LIST_SPACE: space LIST_SPACE|;
%%
main()
{
yyparse();
afficher();
afficher_qdr();
}
yywrap()
{}
int yyerror ( char*  msg )  
{
    printf ("\nErreur Syntaxique: a ligne %d a colonne %d \n", nb_ligne,Col); 
}

