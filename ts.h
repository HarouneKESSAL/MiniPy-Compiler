/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~CREATION DE LA TABLE DES SYMBOLES */
//===============================Step 1: Definition des structures de donnees
#include <stdio.h>
#include <stdlib.h>
#include<string.h>


typedef struct
{
   int state;
   char name[50];
   char code[50];
   char type[50];
   float val;
   char cnst[20];
   
 } element;

typedef struct
{
   int state;
   char name[50];
   char type[50];
} elt;

element tab[1000];
elt tabs[70],tabm[70];
extern char sav[50];
char chaine [] = "";
char chcnst [] = "**";
//===============================Step 2: initialisation de l'�tat des cases des tables des symbloles
/*
0: la case est libre    
1: la case est occupee
*/
void initialisation()
{
  int i;
  for (i=0;i<1000;i++)
  {
    tab[i].state=0;
    strcpy(tab[i].type,chaine);
    strcpy(tab[i].cnst,chcnst);
  }
  for (i=0;i<70;i++)
    {tabs[i].state=0;
    tabm[i].state=0;}
}

//===============================Step 3: insertion des entitit�es lexicales dans Ts
void inserer (char entite[], char code[],char type[],float val,int i,int y)
{
  switch (y)
 {
   case 0:/*insertion dans la table des IDF et CONST*/
       tab[i].state=1;
       strcpy(tab[i].name,entite);
       strcpy(tab[i].code,code);
     strcpy(tab[i].type,type);
     tab[i].val=val;
     
     break;

   case 1:/*insertion dans la table des mots cl�s*/
       tabm[i].state=1;
       strcpy(tabm[i].name,entite);
       strcpy(tabm[i].type,code);
       break;

   case 2:/*insertion dans la table des s�parateurs*/
      tabs[i].state=1;
      strcpy(tabs[i].name,entite);
      strcpy(tabs[i].type,code);
      break;
 }

}

//===============================Step 4: La fonction Rechercher permet de verifier si l'entit� existe d�ja dans la Ts
void rechercher (char entite[], char code[],char type[],float val,int y)
{

int j,i;

switch(y)
  {
   case 0:/*verifier si la case dans la tables des IDF et CONST est libre*/
        for (i=0; ((i<1000)&&(tab[i].state==1))&&(strcmp(entite,tab[i].name)!=0);i++);
        if((i<1000)&&(strcmp(entite,tab[i].name)!=0))
        {
      inserer(entite,code,type,val,i,0);
         }
        break;

   case 1:/*verifier si la case dans la tables des mots cl�s est libre*/

       for (i=0;((i<70)&&(tabm[i].state==1))&&(strcmp(entite,tabm[i].name)!=0);i++);
        if(i<70 &&(strcmp(entite,tabm[i].name)!=0))
          inserer(entite,code,type,val,i,1);
        break;

   case 2:/*verifier si la case dans la tables des s�parateurs est libre*/
         for (i=0;((i<70)&&(tabs[i].state==1))&&(strcmp(entite,tabs[i].name)!=0);i++);
        if(i<70&&(strcmp(entite,tabs[i].name)!=0))
         inserer(entite,code,type,val,i,2);
        break;

    case 3:/*verifier si la case dans la tables des IDF et CONST est libre*/
        for (i=0;((i<1000)&&(tab[i].state==1))&&(strcmp(entite,tab[i].name)!=0);i++);

        if (i<1000)
        { inserer(entite,code,type,val,i,0); }
        else
          printf("entit� existe d�j�\n");
        break;
  }

}


//===============================Step 5 L'affichage du contenue de la Ts

void afficher()
{int i;
printf("\n/~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Les Tables des symboles ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~/\n");
printf("\n/================================Table des symboles IDF================================/\n");
printf("_____________________________________________________________________________________________\n");
printf("\t|      Nom_Entite       |   Code_Entite  |  Type_Entite  |   Val_Entite  |\n");
printf("___________________________________________________________________________\n");

for(i=0;i<70;i++)
{
    if(tab[i].state==1)
      {
        printf("\t|%22s |%15s | %12s  | %12f  |\n",tab[i].name,tab[i].code,tab[i].type,tab[i].val);
      }
}

printf("\n/================================Table des symboles mots cl�s================================\n");
printf("_________________________________________\n");
printf("\t| NomEntite       |  CodeEntite | \n");
printf("_________________________________________\n");

for(i=0;i<70;i++)
    if(tabm[i].state==1)
      {
        printf("\t|%16s |%12s | \n",tabm[i].name, tabm[i].type);
      }

printf("\n/================================Table des symboles s�parateurs================================\n");
printf("___________________________________\n");
printf("\t| NomEntite |  CodeEntite | \n");
printf("___________________________________\n");

for(i=0;i<70;i++)
    if(tabs[i].state==1)
      {
        printf("\t|%10s |%12s | \n",tabs[i].name,tabs[i].type );
      }
}


//================================PARTIE_FONCTION======================================


char* Get_TypeEn(char entite[])
{
  int pos=Get_Position(entite);
  return tab[pos].type;
}

float donneVAL(char entite[])
{
  /*int i=0;
  while( strcmp(entite,tab[i].name)!=0 )
    i++;
  return tab[i].val;*/
  int i=Get_Position(entite);
  return  tab[i].val;
}

int Get_Position(char entite[])
{
  int i=0;
  while(i<1000)
  {
  if (strcmp(entite,tab[i].name)==0) return i;
  i++;
  }
  return -1;
}


void insererTYPE(char entite[], char type[])
{
  int pos;
  pos=Get_Position(entite);
  if(pos!=-1)  { strcpy(tab[pos].type,type); }
}

void insererVAL(char entite[], float val)
{
  int pos;
  pos=Get_Position(entite);
  if(pos!=-1)  { tab[pos].val=val; }
}


int doubleDeclaration(char entite[])
{
  int pos;
  pos=Get_Position(entite);
  if(strcmp(tab[pos].type,"")==0) return 0;
  else return -1;
}
  
int GetTaille (char entite[],int cst)
{
  int pos;
  pos=  Get_Position(entite);
  if (tab[pos+1].val>cst)
    return 0;
    else return 1;  
}

int Atoi_v2(char *t){
    int r;
    char* y; 
    int ee;
    
    y=malloc(strlen(t)*sizeof(char));
    strcpy(y,t);
    if(y[0]=='('){
        for(ee=0;ee<strlen(t);ee++){
            y[ee]=y[ee+1];
                 r=atoi(y);};
    }else{
        r=atoi(y);}
        free(y);
    return(r);
}

float Atof_v2(char* t){
    float r;int ee;
    char* y; 
    y=(char*)malloc(strlen(t));
    strcpy(y,t);
    if(y[0]=='('){
        for(ee=0;ee<strlen(t);ee++){
            y[ee]=y[ee+1];
                 r=atof(y);};
    }else{
        r=atof(y);}
        free(y);
    return(r);
}


