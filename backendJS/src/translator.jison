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
numero [0-9]+                       // ER PARA RECONOCER NUMEROS ENTEROS
decimal {numero}("."{numero})       // ER PARA RECONOCER NUMEROS DECIMALES
caracter \'.\'                       // ER PARA RECONOCER UN SOLO CARACTER
cadena (\"[^"]*\")                  // ER PARA RECONOCER CADENAS DE TEXTO
identificador ([a-zA-ZñÑ_])[a-zA-Z0-9ñÑ_]*  // ER PARA RECONOCER IDENTIFICADORES

%%
"//".*						        return 'COMENTARIO_LINEAL';
[/][*][^*]*[*]+([^/*][^*]*[*]+)*[/] return 'COMENTARIO_MULTILINEA';
\s+                                 // IGNORAR ESPACIOS EN BLANCO
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
"&&"                    return '&&';
"||"                    return '||';
"!="                    return '!=';
"!"                     return '!';
"^"                     return '^'
">="                    return '>=';
"<="                    return '<=';
">"                     return '>';
"<"                     return '<';
"=="                    return '==';
"."                     return '.';
";"                     return ';';
","                     return ',';
"("                     return '(';
")"                     return ')';
"["                     return '[';
"]"                     return ']';
"{"                     return '{';
"}"                     return '}';
"++"                    return '++';
"--"                    return '--';
"+"                     return '+';
"-"                     return '-';
"*"                     return '*';
"/"                     return '/';
"="                     return '=';
{decimal}               return 'DECIMAL';
{numero}                return 'NUMERO';
{identificador}         return 'ID';
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

INICIO:                 SET_INSTRUCCIONES EOF {return $1;}
                    ;

SET_INSTRUCCIONES:      SET_INSTRUCCIONES DEFINICION_CLASE{$$=`${$1}${$2}`;}
                    |   DEFINICION_CLASE {$$=`${$1}`;}
                    ;
DEFINICION_CLASE:       'RES_PUBLIC' 'RES_CLASS' 'ID' '{' INSTRUCCIONES_CLASE '}'           {$$=`class ${$3}{\n\t${$5}\n}\n`;}
                    |   'RES_PUBLIC' 'RES_CLASS' 'ID' '{'  '}'                              {$$=`class ${$3}{ }`;}
                    |   'RES_PUBLIC' 'RES_INTERFACE' 'ID' '{' DEFINICIONES_INTERFAZ '}'     {$$=`/* La interfaz '${$3}' fue omitida junto con sus instrucciones */\n`;}
                    |   'RES_PUBLIC' 'RES_INTERFACE' 'ID' '{' '}'                           {$$=`/* La interfaz '${$3}' fue omitida */\n`;}
                    |   'COMENTARIO_LINEAL'                                                 {$$=`${$1}\n`;}
                    |   'COMENTARIO_MULTILINEA'                                             {$$=`${$1}`;}
                    ;
DEFINICIONES_INTERFAZ:  DEFINICIONES_INTERFAZ DEFINICION_INTERFAZ                           
                    |   DEFINICION_INTERFAZ                                                 
                    ;
DEFINICION_INTERFAZ:    'RES_PUBLIC' 'RES_VOID' 'ID' '(' ')' ';'                            
                    |   'RES_PUBLIC' 'RES_VOID' 'ID' '(' LISTA_PARAM ')' ';'                
                    |   'RES_PUBLIC' TIPO 'ID' '(' ')' ';'                                  
                    |   'RES_PUBLIC' TIPO 'ID' '(' LISTA_PARAM ')' ';'          
                    |   'RES_VOID' 'ID' '(' ')' ';'                            
                    |   'RES_VOID' 'ID' '(' LISTA_PARAM ')' ';'                
                    |   TIPO 'ID' '(' ')' ';'                                  
                    |   TIPO 'ID' '(' LISTA_PARAM ')' ';'     
                    |   'COMENTARIO_LINEAL'                                                 {$$=`${$1}\n`;}
                    |   'COMENTARIO_MULTILINEA'                                             {$$=`${$1}`;}            
                    ;    
INSTRUCCIONES_CLASE:     INSTRUCCIONES_CLASE INSTRUCCION_CLASE                              {$$=`${$1}${$2}`;}
                    |   INSTRUCCION_CLASE                                                   {$$=`${$1}`;}
                    ;
INSTRUCCION_CLASE:      'RES_PUBLIC' 'RES_VOID' 'ID' '(' ')' BLOQUE_INSTRUCCIONES                       {$$=`function ${$3}()${$6}`;}
                    |   'RES_PUBLIC' 'RES_VOID' 'ID' '(' LISTA_PARAM ')' BLOQUE_INSTRUCCIONES           {$$=`function ${$3}(${$5})${$7}`;}
                    |   'RES_PUBLIC' TIPO 'ID' '(' ')' BLOQUE_INSTRUCCIONES                             {$$=`function ${$3}()${$6}`;}
                    |   'RES_PUBLIC' TIPO 'ID' '(' LISTA_PARAM ')' BLOQUE_INSTRUCCIONES                 {$$=`function ${$3}(${$5})${$7}`;}
                    |   'RES_VOID' 'ID' '(' ')' BLOQUE_INSTRUCCIONES                       {$$=`function ${$2}()${$5}`;}
                    |   'RES_VOID' 'ID' '(' LISTA_PARAM ')' BLOQUE_INSTRUCCIONES           {$$=`function ${$2}(${$4})${$6}`;}
                    |   TIPO 'ID' '(' ')' BLOQUE_INSTRUCCIONES                             {$$=`function ${$2}()${$5}`;}
                    |   TIPO 'ID' '(' LISTA_PARAM ')' BLOQUE_INSTRUCCIONES                 {$$=`function ${$2}(${$4})${$6}`;}
                    |   'RES_PUBLIC' 'RES_STATIC' 'RES_VOID' 'RES_MAIN' '(' 'RES_STRING' '[' ']' 'ID' ')' BLOQUE_INSTRUCCIONES {$$=`function main()${$11}`;}
                    |   LLAMADA_FUNCION ';'
                    |   DECLARACION                                                         {$$=`${$1}\n`;}
                    |   ASIGNACION                                                          {$$=`${$1}\n`;}
                    |   'COMENTARIO_LINEAL'                                                 {$$=`${$1}\n`;}
                    |   'COMENTARIO_MULTILINEA'                                             {$$=`${$1}`;}
                    ;
                    
LISTA_PARAM:            LISTA_PARAM ',' PARAMETRO                                           {$$=`${$1},${$3}`;}
                    |   PARAMETRO                                                           {$$=`${$1}`;}
                    ;
PARAMETRO:              TIPO 'ID'                                                           {$$=`${$2}`;}
                    ;
ASIGNACION:             'ID' '=' EXPRESION ';'                                              {$$=`${$1} = ${$3};`;}
                                                                                            //{$$=`${$1} = ${$3}`}
                    ;
/*DECLARACION:            TIPO LISTA_ID ';'                                                   {$$=`${$1} ${$2};`;}
                    |   TIPO LISTA_ID '=' EXPRESION ';'                                     {$$=`${$1} ${$2} = ${$4};`}*/
DECLARACION:            DECLARACIONES ';'                                                   {$$=`${$1};`;/*$$=API.nuevaDeclaracion($1,$2);*/}
                    //|   TIPO LISTA_ID '=' EXPRESION ';'                                     {$$=API.nuevaDeclaracionExp($1,$2,$4);}
                    ;
DECLARACIONES:          TIPO DECLARADORES                                                         {$$=`var ${$2}`;}
                    ;
DECLARADORES:           DECLARADOR                                                                {$$=`${$1}`;}
                    |   DECLARADORES ',' DECLARADOR                                         {$$=`${$1}, ${$3}`;}
                    ;
DECLARADOR:             ID_VAR                                                                {$$=`${$1}`;}    
                    |   INCIALIZADOR                                                          {$$=`${$1}`;}
                    ;
ID_VAR:                 'ID'                                                                 {$$=`${$1}`;}
                    ;
INCIALIZADOR:           ID_VAR '=' EXPRESION                                                {$$=`${$1} = ${$3}`;}
                    ;        

                    
LISTA_ID:               LISTA_ID ',' 'ID'                                                   {$$=`${$1},${$3}`;}
                    |   'ID'                                                                {$$=`${$1}`;}
                    ;
TIPO:                   'RES_INT'                                                           {$$=`var`;}
                    |   'RES_STRING'                                                        {$$=`var`;}
                    |   'RES_CHAR'                                                          {$$=`var`;}
                    |   'RES_DOUBLE'                                                        {$$=`var`;}
                    |   'RES_BOOLEAN'                                                       {$$=`var`;}
                    ;
BLOQUE_INSTRUCCIONES:   '{' INSTRUCCIONES '}'                                               {$$=`{\n\t ${$2}\n}\n `;}
                    |   '{' '}'                                                             {$$=`{ }`;}
                    ;
INSTRUCCIONES:          INSTRUCCIONES INSTRUCCION                                           {$$=`${$1}${$2}\n`;}
                    |   INSTRUCCION                                                         {$$=`${$1}\n`;}
                    |   INSTRUCCIONES INSTRUCCION ERROR_INSTRUCCIONES ';'                   
                    |   INSTRUCCION ERROR_INSTRUCCIONES ';'                                 
                    ;
ERROR_INSTRUCCIONES:error
{
    if($1!=';' && !modoPanico){
			let row = this._$.first_line;
			let column = this._$.first_column + 1;
			let newError = "<td><center>" + contador.toString() + "</center></td>\n" +
                "<td><center>Sintáctico</center></td>\n" +
                "<td><center>" + row + "</center></td>\n" +
                "<td><center>" + column + "</center></td>\n" +
                "<td><center>Se esperaba el inicio de una instrucción valida pero se obtuvo \"" + $1 + "\" </center></td>\n" +
                "</tr>\n" +
                "</center>\n";
			contador+=1;
			errores.push(newError);
			console.log('Este es un error sintactico: ' + $1 + '. En la linea: '+ this._$.first_line + ', columna: '+this._$.first_column);
			modoPanico = true;
        }
		else if($1==';'){
			modoPanico = false;
		}
};

INSTRUCCION:            DECLARACION                                                         {$$=`${$1}`;}
                    |   ASIGNACION                                                          {$$=`${$1}`;}
                    |   IF                                                                  {$$=`${$1}`;}
                    |   FOR                                                                 {$$=`${$1}`;}
                    |   WHILE                                                               {$$=`${$1}`;}
                    |   DO                                                                  {$$=`${$1}`;}
                    |   PRINT                                                               {$$=`${$1}`;}
                    |   'RES_CONTINUE' ';'                                                  {$$=`continue;`;}
                    |   'RES_BREAK' ';'                                                     {$$=`break`;}
                    |   'RES_RETURN' ';'                                                    {$$=`return;`;}
                    |   'RES_RETURN' EXPRESION ';'                                          {$$=`return ${$2};`;}
                    |   LLAMADA_FUNCION ';'                                                 {$$=`${$1}`;}
                    |   INCR_DECR
                    |   'COMENTARIO_LINEAL'                                                 {$$=`${$1}\n`;}
                    |   'COMENTARIO_MULTILINEA'                                             {$$=`${$1}`;}
                    ;
IF:                     'RES_IF' '(' EXPRESION ')' BLOQUE_INSTRUCCIONES                                 {$$=`if(${$3})${$5}`;}
                    |   'RES_IF' '(' EXPRESION ')' BLOQUE_INSTRUCCIONES 'RES_ELSE' BLOQUE_INSTRUCCIONES {$$=`if(${$3})${$5} else${$7}`;}
                    |   'RES_IF' '(' EXPRESION ')' BLOQUE_INSTRUCCIONES 'RES_ELSE' IF                   {$$=`if(${$3})${$5} else ${$7}`;}
                    ;
WHILE:                  'RES_WHILE' '(' EXPRESION ')' BLOQUE_INSTRUCCIONES                  {$$=`while (${$3})${$5}`;}
                    ;
DO:                     'RES_DO' BLOQUE_INSTRUCCIONES 'RES_WHILE' '(' EXPRESION ')' ';'     {$$=`do ${$2} while (${$5});\n`;}
                    ;        
FOR:                    'RES_FOR' '(' DECLARACION EXPRESION ';' INCR_DECR ')' BLOQUE_INSTRUCCIONES      {$$=`for(${$3} ${$4};${$6})${$8}`;}
                    |   'RES_FOR' '(' ASIGNACION EXPRESION ';' INCR_DECR ')' BLOQUE_INSTRUCCIONES       {$$=`for(${$3} ${$4};${$6})${$8}`;}
                    ;
INCR_DECR:              'ID' '++'                                                           {$$=`${$1}++`;}
                    |   'ID' '--'                                                           {$$=`${$1}--`;}
                    ;
PRINT:                  'RES_SYSTEM' '.' 'RES_OUT' '.' 'RES_PRINT' '(' EXPRESION ')' ';'     { $$ =`console.log(${$7});`; }
                    |   'RES_SYSTEM' '.' 'RES_OUT' '.' 'RES_PRINTLN' '(' EXPRESION ')' ';'   { $$ = `console.log(${$7});`; }
                    ;
LLAMADA_FUNCION:        'ID' '(' ')'                                                         {$$=`${$1}()`;}
                    |   'ID' '(' LISTA_EXPR ')'                                              {$$=`${$1}(${$3})`;}
                    ;
LISTA_EXPR:             LISTA_EXPR ',' EXPRESION                                             {$$=`${$1},${$3}`;}
                    |   EXPRESION                                                            {$$=`${$1}`;}
                    ;
EXPRESION:              EXPRESION '+' EXPRESION   { $$ =`${$1} + ${$3}` ; }
                    |   EXPRESION '-' EXPRESION   { $$ =`${$1} - ${$3}` ; }
                    |   EXPRESION '*' EXPRESION   { $$ =`${$1} * ${$3}` ; }
                    |   EXPRESION '/' EXPRESION   { $$ =`${$1} / ${$3}` ; }
                    |   EXPRESION '<=' EXPRESION  { $$ =`${$1} <= ${$3}` ; }
                    |   EXPRESION '>=' EXPRESION  { $$ =`${$1} >= ${$3}` ; }
                    |   EXPRESION '>' EXPRESION   { $$ =`${$1} > ${$3}` ; }
                    |   EXPRESION '<' EXPRESION   { $$ =`${$1} < ${$3}` ; }
                    |   EXPRESION '==' EXPRESION  { $$ =`${$1} == ${$3}` ; }
                    |   EXPRESION '!=' EXPRESION  { $$ =`${$1} != ${$3}` ; }
                    |   EXPRESION '&&' EXPRESION  { $$ =`${$1} && ${$3}` ; }
                    |   EXPRESION '||' EXPRESION  { $$ =`${$1} || ${$3}` ; }
                    |   EXPRESION '^' EXPRESION  { $$ =`${$1} ^ ${$3}` ; }
                    |   EXPRESION '++'             { $$ = `${$1}++`; }
                    |   EXPRESION '--'             { $$ = `${$1}--`; }
                    |   '!' EXPRESION              { $$ = `!${$2}`; }
                    |   '-' EXPRESION %prec UMENOS { $$ = `-${$2}`; }
                    |   'ID'                        { $$ = `${$1}`; }
                    |   'NUMERO'                    { $$ = `${$1}`; }
                    |   'DECIMAL'                   { $$ = `${$1}`; }
                    |   'CADENA_TEXTO'              { $$ = `${$1}`; }
                    |   'CHAR'                      { $$ = `${$1}`; }
		            |  	'RES_TRUE'					{ $$ = `${$1}`; }
		            |  	'RES_FALSE'					{ $$ = `${$1}`; }
                    |   '(' EXPRESION ')'           { $$ = `(${$2})`; }
                    |   LLAMADA_FUNCION               { $$ = `${$1}`; }
                    ;