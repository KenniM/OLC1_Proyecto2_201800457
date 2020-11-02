/* ÁREA DE ANÁLISIS LÉXICO PARA EL LENGUAJE JAVA */

%{
let modoPanico = false,
    contador = 1,
    contadorTokens=1,
    errores = new Array();
    listaTokens = new Array();
module.exports.errores = errores;
module.exports.listaTokens = listaTokens;
exports.vaciar = function () { listaTokens=[];contador=1; };
%}

/* DEFINICIÓN LÉXICA */

%lex
%options case-sensitive
numero [0-9]+                       // ER PARA RECONOCER NUMEROS ENTEROS
decimal {numero}("."{numero})       // ER PARA RECONOCER NUMEROS DECIMALES
caracter ('.')                      // ER PARA RECONOCER UN SOLO CARACTER
cadena (\"[^"]*\")                  // ER PARA RECONOCER CADENAS DE TEXTO
identificador ([a-zA-ZnÑ_])[a-zA-Z0-9ñÑ_]*  // ER PARA RECONOCER IDENTIFICADORES

%%
"//".*						        /* IGNORAR COMENTARIOS */
[/][*][^*]*[*]+([^/*][^*]*[*]+)*[/] /* IGNORAR COMENTARIOS */
\s+                                 // IGNORAR ESPACIOS EN BLANCO
"public"                {listaTokens.push('<tr><th scope="row">'+contadorTokens.toString()+'</th><td>'+yylloc.first_line+'</td><td>'+(parseInt(yylloc.first_column)+1)+'</td><td>RES_PUBLIC</td><td>'+yytext+'</td></tr>\n');contadorTokens++;return 'RES_PUBLIC';}
"class"                 {listaTokens.push('<tr><th scope="row">'+contadorTokens.toString()+'</th><td>'+yylloc.first_line+'</td><td>'+(parseInt(yylloc.first_column)+1)+'</td><td>RES_CLASS</td><td>'+yytext+'</td></tr>\n');contadorTokens++;return 'RES_CLASS';}
"interface"             {listaTokens.push('<tr><th scope="row">'+contadorTokens.toString()+'</th><td>'+yylloc.first_line+'</td><td>'+(parseInt(yylloc.first_column)+1)+'</td><td>RES_INTERFACE</td><td>'+yytext+'</td></tr>\n');contadorTokens++;return 'RES_INTERFACE';}
"int"                   {listaTokens.push('<tr><th scope="row">'+contadorTokens.toString()+'</th><td>'+yylloc.first_line+'</td><td>'+(parseInt(yylloc.first_column)+1)+'</td><td>RES_INT</td><td>'+yytext+'</td></tr>\n');contadorTokens++;return 'RES_INT';}
"boolean"               {listaTokens.push('<tr><th scope="row">'+contadorTokens.toString()+'</th><td>'+yylloc.first_line+'</td><td>'+(parseInt(yylloc.first_column)+1)+'</td><td>RES_BOOLEAN</td><td>'+yytext+'</td></tr>\n');contadorTokens++;return 'RES_BOOLEAN';}
"double"                {listaTokens.push('<tr><th scope="row">'+contadorTokens.toString()+'</th><td>'+yylloc.first_line+'</td><td>'+(parseInt(yylloc.first_column)+1)+'</td><td>RES_DOUBLE</td><td>'+yytext+'</td></tr>\n');contadorTokens++;return 'RES_DOUBLE';}
"String"                {listaTokens.push('<tr><th scope="row">'+contadorTokens.toString()+'</th><td>'+yylloc.first_line+'</td><td>'+(parseInt(yylloc.first_column)+1)+'</td><td>RES_STRING</td><td>'+yytext+'</td></tr>\n');contadorTokens++;return 'RES_STRING';}
"char"                  {listaTokens.push('<tr><th scope="row">'+contadorTokens.toString()+'</th><td>'+yylloc.first_line+'</td><td>'+(parseInt(yylloc.first_column)+1)+'</td><td>RES_CHAR</td><td>'+yytext+'</td></tr>\n');contadorTokens++;return 'RES_CHAR';}
"true"                  {listaTokens.push('<tr><th scope="row">'+contadorTokens.toString()+'</th><td>'+yylloc.first_line+'</td><td>'+(parseInt(yylloc.first_column)+1)+'</td><td>RES_TRUE</td><td>'+yytext+'</td></tr>\n');contadorTokens++;return 'RES_TRUE';}
"false"                 {listaTokens.push('<tr><th scope="row">'+contadorTokens.toString()+'</th><td>'+yylloc.first_line+'</td><td>'+(parseInt(yylloc.first_column)+1)+'</td><td>RES_FALSE</td><td>'+yytext+'</td></tr>\n');contadorTokens++;return 'RES_FALSE';}
"static"                {listaTokens.push('<tr><th scope="row">'+contadorTokens.toString()+'</th><td>'+yylloc.first_line+'</td><td>'+(parseInt(yylloc.first_column)+1)+'</td><td>RES_STATIC</td><td>'+yytext+'</td></tr>\n');contadorTokens++;return 'RES_STATIC';}
"void"                  {listaTokens.push('<tr><th scope="row">'+contadorTokens.toString()+'</th><td>'+yylloc.first_line+'</td><td>'+(parseInt(yylloc.first_column)+1)+'</td><td>RES_VOID</td><td>'+yytext+'</td></tr>\n');contadorTokens++;return 'RES_VOID';}
"main"                  {listaTokens.push('<tr><th scope="row">'+contadorTokens.toString()+'</th><td>'+yylloc.first_line+'</td><td>'+(parseInt(yylloc.first_column)+1)+'</td><td>RES_MAIN</td><td>'+yytext+'</td></tr>\n');contadorTokens++;return 'RES_MAIN';}
"for"                   {listaTokens.push('<tr><th scope="row">'+contadorTokens.toString()+'</th><td>'+yylloc.first_line+'</td><td>'+(parseInt(yylloc.first_column)+1)+'</td><td>RES_FOR</td><td>'+yytext+'</td></tr>\n');contadorTokens++;return 'RES_FOR';}
"while"                 {listaTokens.push('<tr><th scope="row">'+contadorTokens.toString()+'</th><td>'+yylloc.first_line+'</td><td>'+(parseInt(yylloc.first_column)+1)+'</td><td>RES_WHILE</td><td>'+yytext+'</td></tr>\n');contadorTokens++;return 'RES_WHILE';}
"System"                {listaTokens.push('<tr><th scope="row">'+contadorTokens.toString()+'</th><td>'+yylloc.first_line+'</td><td>'+(parseInt(yylloc.first_column)+1)+'</td><td>RES_SYSTEM</td><td>'+yytext+'</td></tr>\n');contadorTokens++;return 'RES_SYSTEM';}
"out"                   {listaTokens.push('<tr><th scope="row">'+contadorTokens.toString()+'</th><td>'+yylloc.first_line+'</td><td>'+(parseInt(yylloc.first_column)+1)+'</td><td>RES_OUT</td><td>'+yytext+'</td></tr>\n');contadorTokens++;return 'RES_OUT';}
"println"               {listaTokens.push('<tr><th scope="row">'+contadorTokens.toString()+'</th><td>'+yylloc.first_line+'</td><td>'+(parseInt(yylloc.first_column)+1)+'</td><td>RES_PRINTLN</td><td>'+yytext+'</td></tr>\n');contadorTokens++;return 'RES_PRINTLN';}
"print"                 {listaTokens.push('<tr><th scope="row">'+contadorTokens.toString()+'</th><td>'+yylloc.first_line+'</td><td>'+(parseInt(yylloc.first_column)+1)+'</td><td>RES_PRINT</td><td>'+yytext+'</td></tr>\n');contadorTokens++;return 'RES_PRINT';}
"do"                    {listaTokens.push('<tr><th scope="row">'+contadorTokens.toString()+'</th><td>'+yylloc.first_line+'</td><td>'+(parseInt(yylloc.first_column)+1)+'</td><td>RES_DO</td><td>'+yytext+'</td></tr>\n');contadorTokens++;return 'RES_DO';}
"if"                    {listaTokens.push('<tr><th scope="row">'+contadorTokens.toString()+'</th><td>'+yylloc.first_line+'</td><td>'+(parseInt(yylloc.first_column)+1)+'</td><td>RES_IF</td><td>'+yytext+'</td></tr>\n');contadorTokens++;return 'RES_IF';}
"else"                  {listaTokens.push('<tr><th scope="row">'+contadorTokens.toString()+'</th><td>'+yylloc.first_line+'</td><td>'+(parseInt(yylloc.first_column)+1)+'</td><td>RES_ELSE</td><td>'+yytext+'</td></tr>\n');contadorTokens++;return 'RES_ELSE';}
"break"                 {listaTokens.push('<tr><th scope="row">'+contadorTokens.toString()+'</th><td>'+yylloc.first_line+'</td><td>'+(parseInt(yylloc.first_column)+1)+'</td><td>RES_BREAK</td><td>'+yytext+'</td></tr>\n');contadorTokens++;return 'RES_BREAK';}
"continue"              {listaTokens.push('<tr><th scope="row">'+contadorTokens.toString()+'</th><td>'+yylloc.first_line+'</td><td>'+(parseInt(yylloc.first_column)+1)+'</td><td>RES_CONTINUE</td><td>'+yytext+'</td></tr>\n');contadorTokens++;return 'RES_CONTINUE';}
"return"                {listaTokens.push('<tr><th scope="row">'+contadorTokens.toString()+'</th><td>'+yylloc.first_line+'</td><td>'+(parseInt(yylloc.first_column)+1)+'</td><td>RES_RETURN</td><td>'+yytext+'</td></tr>\n');contadorTokens++;return 'RES_RETURN';}
"&&"                    {listaTokens.push('<tr><th scope="row">'+contadorTokens.toString()+'</th><td>'+yylloc.first_line+'</td><td>'+(parseInt(yylloc.first_column)+1)+'</td><td>RES_AND</td><td>'+yytext+'</td></tr>\n');contadorTokens++;return 'RES_AND';}
"||"                    {listaTokens.push('<tr><th scope="row">'+contadorTokens.toString()+'</th><td>'+yylloc.first_line+'</td><td>'+(parseInt(yylloc.first_column)+1)+'</td><td>RES_OR</td><td>'+yytext+'</td></tr>\n');contadorTokens++;return 'RES_OR';}
"!"                     {listaTokens.push('<tr><th scope="row">'+contadorTokens.toString()+'</th><td>'+yylloc.first_line+'</td><td>'+(parseInt(yylloc.first_column)+1)+'</td><td>RES_NOT</td><td>'+yytext+'</td></tr>\n');contadorTokens++;return 'RES_NOT';}
"^"                     {listaTokens.push('<tr><th scope="row">'+contadorTokens.toString()+'</th><td>'+yylloc.first_line+'</td><td>'+(parseInt(yylloc.first_column)+1)+'</td><td>RES_XOR</td><td>'+yytext+'</td></tr>\n');contadorTokens++;return 'RES_XOR'}
">="                    {listaTokens.push('<tr><th scope="row">'+contadorTokens.toString()+'</th><td>'+yylloc.first_line+'</td><td>'+(parseInt(yylloc.first_column)+1)+'</td><td>>=</td><td>'+yytext+'</td></tr>\n');contadorTokens++;return '>=';}
"<="                    {listaTokens.push('<tr><th scope="row">'+contadorTokens.toString()+'</th><td>'+yylloc.first_line+'</td><td>'+(parseInt(yylloc.first_column)+1)+'</td><td><=</td><td>'+yytext+'</td></tr>\n');contadorTokens++;return '<=';}
">"                     {listaTokens.push('<tr><th scope="row">'+contadorTokens.toString()+'</th><td>'+yylloc.first_line+'</td><td>'+(parseInt(yylloc.first_column)+1)+'</td><td>></td><td>'+yytext+'</td></tr>\n');contadorTokens++;return '>';}
"<"                     {listaTokens.push('<tr><th scope="row">'+contadorTokens.toString()+'</th><td>'+yylloc.first_line+'</td><td>'+(parseInt(yylloc.first_column)+1)+'</td><td><</td><td>'+yytext+'</td></tr>\n');contadorTokens++;return '<';}
"=="                    {listaTokens.push('<tr><th scope="row">'+contadorTokens.toString()+'</th><td>'+yylloc.first_line+'</td><td>'+(parseInt(yylloc.first_column)+1)+'</td><td>==</td><td>'+yytext+'</td></tr>\n');contadorTokens++;return '==';}
"!="                    {listaTokens.push('<tr><th scope="row">'+contadorTokens.toString()+'</th><td>'+yylloc.first_line+'</td><td>'+(parseInt(yylloc.first_column)+1)+'</td><td>!=</td><td>'+yytext+'</td></tr>\n');contadorTokens++;return '!=';}
"."                     {listaTokens.push('<tr><th scope="row">'+contadorTokens.toString()+'</th><td>'+yylloc.first_line+'</td><td>'+(parseInt(yylloc.first_column)+1)+'</td><td>.</td><td>'+yytext+'</td></tr>\n');contadorTokens++;return '.';}
";"                     {listaTokens.push('<tr><th scope="row">'+contadorTokens.toString()+'</th><td>'+yylloc.first_line+'</td><td>'+(parseInt(yylloc.first_column)+1)+'</td><td>;</td><td>'+yytext+'</td></tr>\n');contadorTokens++;return ';';}
","                     {listaTokens.push('<tr><th scope="row">'+contadorTokens.toString()+'</th><td>'+yylloc.first_line+'</td><td>'+(parseInt(yylloc.first_column)+1)+'</td><td>,</td><td>'+yytext+'</td></tr>\n');contadorTokens++;return ',';}
"("                     {listaTokens.push('<tr><th scope="row">'+contadorTokens.toString()+'</th><td>'+yylloc.first_line+'</td><td>'+(parseInt(yylloc.first_column)+1)+'</td><td>(</td><td>'+yytext+'</td></tr>\n');contadorTokens++;return '(';}
")"                     {listaTokens.push('<tr><th scope="row">'+contadorTokens.toString()+'</th><td>'+yylloc.first_line+'</td><td>'+(parseInt(yylloc.first_column)+1)+'</td><td>)</td><td>'+yytext+'</td></tr>\n');contadorTokens++;return ')';}
"["                     {listaTokens.push('<tr><th scope="row">'+contadorTokens.toString()+'</th><td>'+yylloc.first_line+'</td><td>'+(parseInt(yylloc.first_column)+1)+'</td><td>[</td><td>'+yytext+'</td></tr>\n');contadorTokens++;return '[';}
"]"                     {listaTokens.push('<tr><th scope="row">'+contadorTokens.toString()+'</th><td>'+yylloc.first_line+'</td><td>'+(parseInt(yylloc.first_column)+1)+'</td><td>]</td><td>'+yytext+'</td></tr>\n');contadorTokens++;return ']';}
"{"                     {listaTokens.push('<tr><th scope="row">'+contadorTokens.toString()+'</th><td>'+yylloc.first_line+'</td><td>'+(parseInt(yylloc.first_column)+1)+'</td><td>{</td><td>'+yytext+'</td></tr>\n');contadorTokens++;return '{';}
"}"                     {listaTokens.push('<tr><th scope="row">'+contadorTokens.toString()+'</th><td>'+yylloc.first_line+'</td><td>'+(parseInt(yylloc.first_column)+1)+'</td><td>}</td><td>'+yytext+'</td></tr>\n');contadorTokens++;return '}';}
"++"                    {listaTokens.push('<tr><th scope="row">'+contadorTokens.toString()+'</th><td>'+yylloc.first_line+'</td><td>'+(parseInt(yylloc.first_column)+1)+'</td><td>++</td><td>'+yytext+'</td></tr>\n');contadorTokens++;return '++';}
"--"                    {listaTokens.push('<tr><th scope="row">'+contadorTokens.toString()+'</th><td>'+yylloc.first_line+'</td><td>'+(parseInt(yylloc.first_column)+1)+'</td><td>--</td><td>'+yytext+'</td></tr>\n');contadorTokens++;return '--';}
"+"                     {listaTokens.push('<tr><th scope="row">'+contadorTokens.toString()+'</th><td>'+yylloc.first_line+'</td><td>'+(parseInt(yylloc.first_column)+1)+'</td><td>+</td><td>'+yytext+'</td></tr>\n');contadorTokens++;return '+';}
"-"                     {listaTokens.push('<tr><th scope="row">'+contadorTokens.toString()+'</th><td>'+yylloc.first_line+'</td><td>'+(parseInt(yylloc.first_column)+1)+'</td><td>-</td><td>'+yytext+'</td></tr>\n');contadorTokens++;return '-';}
"*"                     {listaTokens.push('<tr><th scope="row">'+contadorTokens.toString()+'</th><td>'+yylloc.first_line+'</td><td>'+(parseInt(yylloc.first_column)+1)+'</td><td>*</td><td>'+yytext+'</td></tr>\n');contadorTokens++;return '*';}
"/"                     {listaTokens.push('<tr><th scope="row">'+contadorTokens.toString()+'</th><td>'+yylloc.first_line+'</td><td>'+(parseInt(yylloc.first_column)+1)+'</td><td>/</td><td>'+yytext+'</td></tr>\n');contadorTokens++;return '/';}
"="                     {listaTokens.push('<tr><th scope="row">'+contadorTokens.toString()+'</th><td>'+yylloc.first_line+'</td><td>'+(parseInt(yylloc.first_column)+1)+'</td><td>=</td><td>'+yytext+'</td></tr>\n');contadorTokens++;return '=';}
{decimal}               {listaTokens.push('<tr><th scope="row">'+contadorTokens.toString()+'</th><td>'+yylloc.first_line+'</td><td>'+(parseInt(yylloc.first_column)+1)+'</td><td>DECIMAL</td><td>'+yytext+'</td></tr>\n');contadorTokens++;return 'DECIMAL';}
{numero}                {listaTokens.push('<tr><th scope="row">'+contadorTokens.toString()+'</th><td>'+yylloc.first_line+'</td><td>'+(parseInt(yylloc.first_column)+1)+'</td><td>NUMERO</td><td>'+yytext+'</td></tr>\n');contadorTokens++;return 'NUMERO';}
{identificador}         {listaTokens.push('<tr><th scope="row">'+contadorTokens.toString()+'</th><td>'+yylloc.first_line+'</td><td>'+(parseInt(yylloc.first_column)+1)+'</td><td>ID</td><td>'+yytext+'</td></tr>\n');contadorTokens++;return 'ID';}
{caracter}              {listaTokens.push('<tr><th scope="row">'+contadorTokens.toString()+'</th><td>'+yylloc.first_line+'</td><td>'+(parseInt(yylloc.first_column)+1)+'</td><td>CHAR</td><td>'+yytext+'</td></tr>\n');contadorTokens++;return 'CHAR';}
{cadena}                {listaTokens.push('<tr><th scope="row">'+contadorTokens.toString()+'</th><td>'+yylloc.first_line+'</td><td>'+(parseInt(yylloc.first_column)+1)+'</td><td>CADENA_TEXTO</td><td>'+yytext+'</td></tr>\n');contadorTokens++;return 'CADENA_TEXTO';}
<<EOF>>                 return 'EOF';

// MANEJO DEL ERROR LEXICO
.   {
    let fila=yylloc.first_line;
    let columna=yylloc.first_column+1;
    let nuevoError= contador.toString() + ". ERROR LÉXICO: El caracter \"" + yytext + "\" no pertenece al lenguaje, en la línea "+fila+", columna "+columna+".\n";
	contador+=1;
	errores.push(nuevoError);
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

SET_INSTRUCCIONES:      SET_INSTRUCCIONES DEFINICION_CLASE{$1.push($2);$$=$1;}
                    |   DEFINICION_CLASE {$$=[$1];}
                    ;
DEFINICION_CLASE:       'RES_PUBLIC' 'RES_CLASS' 'ID' '{' INSTRUCCIONES_CLASE '}'           {$$=API.nuevaClase($3,$5);}
                    |   'RES_PUBLIC' 'RES_CLASS' 'ID' '{'  '}'                              {$$=API.nuevaClase($3,[]);}
                    |   'RES_PUBLIC' 'RES_INTERFACE' 'ID' '{' DEFINICIONES_INTERFAZ '}'     {$$=API.nuevaInterfaz($3,$5);}
                    |   'RES_PUBLIC' 'RES_INTERFACE' 'ID' '{' '}'                           {$$=API.nuevaInterfaz($3,[]);}
                    |   error {let nuevoError=contador.toString()+'. ERROR SINTÁCTICO: Se ha obtenido un error de sintaxis: ' + yytext + ', en la linea: ' + this._$.first_line + ', en la columna: ' + this._$.first_column;errores.push(nuevoError+"\n");}
                    ;
DEFINICIONES_INTERFAZ:  DEFINICIONES_INTERFAZ DEFINICION_INTERFAZ                           {$1.push($2);$$=$1;}
                    |   DEFINICION_INTERFAZ                                                 {$$=[$1];}
                    ;
DEFINICION_INTERFAZ:    'RES_PUBLIC' 'RES_VOID' 'ID' '(' ')' ';'                            {$$=API.nuevaDefVoid($3);}
                    |   'RES_PUBLIC' 'RES_VOID' 'ID' '(' LISTA_PARAM ')' ';'                {$$=API.nuevaDefVoidParametrizado($3,$5);}
                    |   'RES_PUBLIC' TIPO 'ID' '(' ')' ';'                                  {$$=API.nuevaDefMetodo($2,$3);}
                    |   'RES_PUBLIC' TIPO 'ID' '(' LISTA_PARAM ')' ';'                      {$$=API.nuevaDefMetodoParametrizado($2,$3,$5);}
                    |   error {let nuevoError=contador.toString()+'. ERROR SINTÁCTICO: Se ha obtenido un error de sintaxis: ' + yytext + ', en la linea: ' + this._$.first_line + ', en la columna: ' + this._$.first_column;errores.push(nuevoError+"\n");}
                    ;    
INSTRUCCIONES_CLASE:     INSTRUCCIONES_CLASE INSTRUCCION_CLASE                              {$1.push($2);$$=$1;}
                    |   INSTRUCCION_CLASE                                                   {$$=[$1];}
                    ;
INSTRUCCION_CLASE:      'RES_PUBLIC' 'RES_VOID' 'ID' '(' ')' BLOQUE_INSTRUCCIONES                       {$$=API.nuevoVoid($3,$6);}
                    |   'RES_PUBLIC' 'RES_VOID' 'ID' '(' LISTA_PARAM ')' BLOQUE_INSTRUCCIONES           {$$=API.nuevoVoidParametrizado($3,$5,$7);}
                    |   'RES_PUBLIC' TIPO 'ID' '(' ')' BLOQUE_INSTRUCCIONES                             {$$=API.nuevoMetodo($2,$3,$6);}
                    |   'RES_PUBLIC' TIPO 'ID' '(' LISTA_PARAM ')' BLOQUE_INSTRUCCIONES                 {$$=API.nuevoMetodoParametrizado($2,$3,$5,$7);}
                    |   'RES_PUBLIC' 'RES_STATIC' 'RES_VOID' 'RES_MAIN' '(' 'RES_STRING' '[' ']' 'ID' ')' BLOQUE_INSTRUCCIONES {$$=API.nuevoMain($9,$11);}
                    |   LLAMADA_FUNCION ';'
                    |   DECLARACION                                                         {$$=$1;}
                    |   ASIGNACION                                                          {$$=$1;}
                    |   error {let nuevoError=contador.toString()+'. ERROR SINTÁCTICO: Se ha obtenido un error de sintaxis: ' + yytext + ', en la linea: ' + this._$.first_line + ', en la columna: ' + this._$.first_column;errores.push(nuevoError+"\n");}
                    ;
                    
LISTA_PARAM:            LISTA_PARAM ',' PARAMETRO                                           {$1.push($3);$$=$1;}
                    |   PARAMETRO                                                           {$$=[$1];}
                    ;
PARAMETRO:              TIPO 'ID'                                                           {$$=API.nuevoParametro($1,$2);}
                    ;
ASIGNACION:             'ID' '=' EXPRESION ';'                                              {$$=API.nuevaAsignacion($1,$3);}
                                                                                            //{$$=`${$1} = ${$3}`}
                    ;
DECLARACION:            TIPO LISTA_ID ';'                                                   {$$=API.nuevaDeclaracion($1,$2);}
                    |   TIPO LISTA_ID '=' EXPRESION ';'                                     {$$=API.nuevaDeclaracionExp($1,$2,$4);}

                    ;
LISTA_ID:               LISTA_ID ',' 'ID'                                                   {$1.push($3);$$=$1;}
                    |   'ID'                                                                {$$=[$1];}
                    ;
TIPO:                   'RES_INT'                                                           {$$=$1;}
                    |   'RES_STRING'                                                        {$$=$1;}
                    |   'RES_CHAR'                                                          {$$=$1;}
                    |   'RES_DOUBLE'                                                        {$$=$1;}
                    |   'RES_BOOLEAN'                                                       {$$=$1;}
                    ;
BLOQUE_INSTRUCCIONES:   '{' INSTRUCCIONES '}'                                               {$$=$2;}
                    |   '{' '}'                                                             {$$=[];}
                    ;
INSTRUCCIONES:          INSTRUCCIONES INSTRUCCION                                           {$1.push($2);$$=$1;}
                    |   INSTRUCCION                                                         {$$=[$1];}
                    |   INSTRUCCIONES INSTRUCCION ERROR_INSTRUCCIONES ';'                   {$1.push($2);$$=$1;}
                    |   INSTRUCCION ERROR_INSTRUCCIONES ';'                                 {$$=[$1];}
                    ;
ERROR_INSTRUCCIONES:error
{
    if($1!=';' && !modoPanico){
			let row = this._$.first_line;
			let column = this._$.first_column + 1;
			let newError = contador.toString() + ". Se esperaba el inicio de una instrucción valida pero se obtuvo \"" + $1 + "\" en la línea "+row+", columna "+column+".\n";
			contador+=1;
			errores.push(newError);
			modoPanico = true;
        }
		else if($1==';'){
			modoPanico = false;
		}
};

INSTRUCCION:            DECLARACION                                                         {$$=$1;}
                    |   ASIGNACION                                                          {$$=$1;}
                    |   IF                                                                  {$$=$1;}
                    |   FOR                                                                 {$$=$1;}
                    |   WHILE                                                               {$$=$1;}
                    |   DO                                                                  {$$=$1;}
                    |   PRINT                                                               {$$=$1;}
                    |   'RES_CONTINUE' ';'                                                  {$$=API.nuevoContinue(this._$first_line,this.$first_column+1);}
                    |   'RES_BREAK' ';'                                                     {$$=API.nuevoBreak(this._$first_line,this.$first_column+1);}
                    |   'RES_RETURN' ';'                                                    {$$=API.nuevoReturn(null,this._$first_line,this.$first_column+1);}
                    |   'RES_RETURN' EXPRESION ';'                                          {$$=API.nuevoContinue($2,this._$first_line,this.$first_column+1);}
                    |   LLAMADA_FUNCION ';'                                                 {$$=$1;}
                    |   INCR_DECR
                    ;
IF:                     'RES_IF' '(' EXPRESION ')' BLOQUE_INSTRUCCIONES                                 {$$=API.nuevoIf($3,$5,[]);}
                    |   'RES_IF' '(' EXPRESION ')' BLOQUE_INSTRUCCIONES 'RES_ELSE' BLOQUE_INSTRUCCIONES {$$=API.nuevoIf($3,$5,$7);}
                    |   'RES_IF' '(' EXPRESION ')' BLOQUE_INSTRUCCIONES 'RES_ELSE' IF                   {$$=API.nuevoIf($3,$5,[$7]);}
                    ;
WHILE:                  'RES_WHILE' '(' EXPRESION ')' BLOQUE_INSTRUCCIONES                  {$$=API.nuevoWhile($3,$5);}
                    ;
DO:                     'RES_DO' BLOQUE_INSTRUCCIONES 'RES_WHILE' '(' EXPRESION ')' ';'     {$$=API.nuevoDoWhile($2,$5);}
                    ;        
FOR:                    'RES_FOR' '(' DECLARACION EXPRESION ';' INCR_DECR ')' BLOQUE_INSTRUCCIONES      {$$=API.nuevoFor($3,$4,$6,$8);}
                    |   'RES_FOR' '(' ASIGNACION EXPRESION ';' INCR_DECR ')' BLOQUE_INSTRUCCIONES       {$$=API.nuevoFor($3,$4,$6,$8);}
                    ;
INCR_DECR:              'ID' '++'                                                           {$$=API.nuevaOperUnitaria($1,TIPO_OPERACION.INCREMENTO);}
                    |   'ID' '--'                                                           {$$=API.nuevaOperUnitaria($1,TIPO_OPERACION.DECREMENTO);}
                    ;
PRINT:                  'RES_SYSTEM' '.' 'RES_OUT' '.' 'RES_PRINT' '(' EXPRESION ')' ';'     { $$ = API.nuevoPrint($7); }
                    |   'RES_SYSTEM' '.' 'RES_OUT' '.' 'RES_PRINTLN' '(' EXPRESION ')' ';'   { $$ = API.nuevoPrintLn($7); }
                    ;
LLAMADA_FUNCION:        'ID' '(' ')'                                                         {$$=API.nuevaLlamadaFuncion($1,[]);}
                    |   'ID' '(' LISTA_EXPR ')'                                              {$$=API.nuevaLlamadaFuncion($1,$3);}
                    ;
LISTA_EXPR:             LISTA_EXPR ',' EXPRESION                                             {$1.push($3);$$=$1;}
                    |   EXPRESION                                                            {$$=[$1];}
                    ;
EXPRESION:              EXPRESION '+' EXPRESION   { $$ = API.nuevaOperBinaria($1, $3, TIPO_OPERACION.SUMA); }
                    |   EXPRESION '-' EXPRESION   { $$ = API.nuevaOperBinaria($1, $3, TIPO_OPERACION.RESTA); }
                    |   EXPRESION '*' EXPRESION   { $$ = API.nuevaOperBinaria($1, $3, TIPO_OPERACION.MULTIPLICACION);}
                    |   EXPRESION '/' EXPRESION   { $$ = API.nuevaOperBinaria($1, $3, TIPO_OPERACION.DIVISION);}
                    |   EXPRESION '<=' EXPRESION  { $$ = API.nuevaOperBinaria($1, $3, TIPO_OPERACION.MENOR_IGUAL_QUE); }
                    |   EXPRESION '==' EXPRESION  { $$ = API.nuevaOperBinaria($1, $3, TIPO_OPERACION.DOBLE_IGUAL); }
                    |   EXPRESION '!=' EXPRESION  { $$ = API.nuevaOperBinaria($1, $3, TIPO_OPERACION.NO_IGUAL); }
                    |   EXPRESION '>' EXPRESION   { $$ = API.nuevaOperBinaria($1, $3, TIPO_OPERACION.MAYOR_QUE); }
                    |   EXPRESION '>=' EXPRESION  { $$ = API.nuevaOperBinaria($1, $3, TIPO_OPERACION.MAYOR_IGUAL_QUE); }
                    |   EXPRESION '<' EXPRESION   { $$ = API.nuevaOperBinaria($1, $3, TIPO_OPERACION.MENOR_IGUAL); }
                    |   EXPRESION '&&' EXPRESION  { $$ = API.nuevaOperBinaria($1, $3, TIPO_OPERACION.AND); }
                    |   EXPRESION '||' EXPRESION  { $$ = API.nuevaOperBinaria($1, $3, TIPO_OPERACION.OR); }
                    |   EXPRESION '++'             { $$ = API.nuevaOperUnitaria($1, TIPO_OPERACION.INCREMENTO); }
                    |   EXPRESION '--'             { $$ = API.nuevaOperUnitaria($1, TIPO_OPERACION.DECREMENTO); }
                    |   '!' EXPRESION              { $$ = API.nuevaOperUnitaria($2, TIPO_OPERACION.NOT); }
                    |   '-' EXPRESION %prec UMENOS { $$ = API.nuevaOperUnitaria($2, TIPO_OPERACION.NEGATIVO); }
                    |   'ID'                        { $$ = API.nuevoValor($1, TIPO_VALOR.IDENTIFICADOR); }
                    |   'NUMERO'                    { $$ = API.nuevoValor($1, TIPO_VALOR.NUMERO); }
                    |   'DECIMAL'                   { $$ = API.nuevoValor($1, TIPO_VALOR.DECIMAL); }
                    |   'CADENA_TEXTO'                    { $$ = API.nuevoValor($1, TIPO_VALOR.STRING); }
                    |   'CHAR'                      { $$ = API.nuevoValor($1, TIPO_VALOR.CHAR); }
		            |  	'RES_TRUE'					{ $$ = API.nuevoValor($1, TIPO_VALOR.TRUE); }
		            |  	'RES_FALSE'					{ $$ = API.nuevoValor($1, TIPO_VALOR.FALSE); }
                    |   '(' EXPRESION ')'          { $$ = $2; }
                    |   LLAMADA_FUNCION               { $$ = $1; }
                    |   error {let nuevoError=contador.toString()+'. ERROR SINTÁCTICO: Se ha obtenido un error de sintaxis: ' + yytext + ', en la linea: ' + this._$.first_line + ', en la columna: ' + this._$.first_column;errores.push(nuevoError+"\n");}
                    ;