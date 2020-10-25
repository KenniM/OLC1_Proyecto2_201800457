/* ÁREA DE ANÁLISIS LÉXICO PARA EL LENGUAJE JAVA */

%{
let modoPanico = false,
    contador = 1,
    errores = new Array();
module.exports.errores = errores;
%}

/* DEFINICIÓN LÉXICA */

%lex
%options case-sensitive
numero [0-9]+
decimal {numero}("."{numero})
caracter ('.')
cadena (\"[^"]*\")
id ([a-zA-Z_])[a-zA-Z0-9_]*
%%
"//".*						        /* IGNORAR COMENTARIOS */
[/][*][^*]*[*]+([^/*][^*]*[*]+)*[/] /* IGNORAR COMENTARIOS */
\s+      
"public"                return 'RES_PUBLIC';
"class"                 return 'RES_CLASS';
"interface"             return 'RES_INTERFACE';
"int"                   return 'RES_INT';
"boolean"               return 'RES_BOOLEAN';
"double"                return 'RES_DOUBLE';
"String"                return 'RES_STRING';
"char"                  return 'RES_CHAR';
"true"                  return 'RES_TRUE';
"false"                 return 'RES_FALSE';
"static"                return 'RES_STATIC';
"void"                  return 'RES_VOID';
"main"                  return 'RES_MAIN';
"for"                   return 'RES_FOR';
"while"                 return 'RES_WHILE';
"System"                return 'RES_SYSTEM';
"out"                   return 'RES_OUT';
"println"               return 'RES_PRINTLN';
"print"                 return 'RES_PRINT';
"do"                    return 'RES_DO';
"if"                    return 'RES_IF';
"else"                  return 'RES_ELSE';
"break"                 return 'RES_BREAK';
"continue"              return 'RES_CONTINUE';
"return"                return 'RES_RETURN';
"&&"                    return 'RES_AND';
"||"                    return 'RES_OR';
"!"                     return 'RES_NOT';
"^"                     return 'RES_XOR'
">"                     return '>';
"<"                     return '<';
">="                    return '>=';
"<="                    return '<=';
"=="                    return '==';
"!="                    return '!=';
"."                     return '.';
";"                     return ';';
","                     return ',';
"("                     return '(';
")"                     return ')';
"["                     return '[';
"]"                     return ']';
"{"                     return '{';
"}"                     return '}';
"+"                     return '+';
"-"                     return '-';
"*"                     return '*';
"/"                     return '/';
"++"                    return '++';
"--"                    return '--';
"="                     return '=';
{decimal}               return 'DECIMAL';
{numero}                return 'NUMERO';
{id}                    return 'ID';
{caracter}              return 'CHAR';
{cadena}                return 'CADENA_TEXTO';
<<EOF>>                 return 'EOF';

// MANEJO DEL ERROR LEXICO
.   {
    let fila=yylloc.first_line;
    let columna=yylloc.first_column+1;
    let nuevoError= "<td><center>" + contador.toString() + "</center></td>\n" +
                "<td><center>Léxico</center></td>\n" +
                "<td><center>" + fila + "</center></td>\n" +
                "<td><center>" + columna + "</center></td>\n" +
                "<td><center>El caracter \"" + yytext + "\" no pertenece al lenguaje</center></td>\n" +
                "</tr>\n" +
                "</center>\n";
	contador+=1;
	errores.push(nuevoError);
	console.log('Error lexico: \'' + yytext + '\'. En fila: ' + fila + ', columna: ' + columna + '.');
}

/lex

// IMPORTACION DE LAS INSTRUCCIONES
%{
const TIPO_OPERACION=require('./instructions').TIPO_OPERACION;
const TIPO_VALOR=require('./instructions').TIPO_VALOR;
const API=require('./instructions').INSTRUCCIONES_API;
%}

// DEFINICION DE PRECEDENCIAS
%left '||'
%left '&&'
%left '==', '!='
%left '>=', '<=', '<', '>'
%left '+' '-'
%left '*' '/'
%left '^'
%left '%'
%left '++' '--'
%left '!' UMENOS

// ESTADO INICIAL DEL ANALISIS SINTACTICO
%start INICIO


// DEFINICION SINTACTICA
%%

INICIO:                 DEFINICION_CLASE EOF {return $1;}
                    ;
DEFINICION_CLASE:       'RES_PUBLIC' 'RES_CLASS' 'ID' '{' INSTRUCCIONES_CLASE '}'           {$$=API.nuevaClase($3,$5);}
                    |   'RES_PUBLIC' 'RES_CLASS' 'ID' '{'  '}'                              {$$=API.nuevaClase($3,[]);}
                    ;
INSTRUCCIONES_CLASE:     INSTRUCCIONES_CLASE INSTRUCCION_CLASE                              {$1.push($2);$$=$1;}
                    |   INSTRUCCION_CLASE                                                   {$$=[$1];}
                    ;
INSTRUCCION_CLASE:       'RES_VOID' 'ID' '(' ')' BLOQUE_INSTRUCCIONES                       {$$=API.nuevoVoid($2,$5);}
                    |   'RES_VOID' 'ID' '(' LISTA_PARAM ')' BLOQUE_INSTRUCCIONES            {$$=API.nuevoVoidParametrizado($2,$4,$6);}
                    |   TIPO 'ID' '(' ')' BLOQUE_INSTRUCCIONES                              {$$=API.nuevoMetodo($1,$2,$5);}
                    |   TIPO 'ID' '(' LISTA_PARAM ')' BLOQUE_INSTRUCCIONES                  {$$=API.nuevoMetodoParametrizado($1,$2,$4,$6);}
                    |   DECLARACION                                                         {$$=$1;}
                    |   ASIGNACION                                                          {$$=$1;}
                    ;
                    
LISTA_PARAM:            LISTA_PARAM ',' PARAMETRO                                           {$1.push($3);$$=$1;}
                    |   PARAMETRO                                                           {$$=[$1];}
                    ;
PARAMETRO:              TIPO 'ID'                                                           {$$=API.nuevoParametro($1,$2);}
                    ;
ASIGNACION:             'ID' '=' EXPRESION ';'                                              {$$=API.nuevaAsignacion($1,$3);}
                    ;
DECLARACION:            TIPO LISTA_ID ';'                                                   {$$=API.nuevaDeclaracion($1,$2);}
                    |   TIPO LISTA_ID '=' EXPRESION ';'                                     {$$=API.nuevaDeclaracionExp($1,$2,$4);}
                    ;
LISTA_ID:               LISTA_ID ',' 'ID'                                                   {$1.push($3);$$=$1;}
                    |   'ID'                                                                {$$=[$1];}

