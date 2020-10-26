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
caracter ('.')                      // ER PARA RECONOCER UN SOLO CARACTER
cadena (\"[^"]*\")                  // ER PARA RECONOCER CADENAS DE TEXTO
identificador ([a-zA-Z_])[a-zA-Z0-9_]*  // ER PARA RECONOCER IDENTIFICADORES

%%
"//".*						        /* IGNORAR COMENTARIOS */
[/][*][^*]*[*]+([^/*][^*]*[*]+)*[/] /* IGNORAR COMENTARIOS */
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
"&&"                    return 'RES_AND';
"||"                    return 'RES_OR';
"!"                     return 'RES_NOT';
"^"                     return 'RES_XOR'
">="                    return '>=';
"<="                    return '<=';
">"                     return '>';
"<"                     return '<';
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

INICIO:                 DEFINICION_CLASE EOF {return $1;}
                    ;
DEFINICION_CLASE:       'RES_PUBLIC' 'RES_CLASS' 'ID' '{' INSTRUCCIONES_CLASE '}'           {$$=API.nuevaClase($3,$5);}
                    |   'RES_PUBLIC' 'RES_CLASS' 'ID' '{'  '}'                              {$$=API.nuevaClase($3,[]);}
                    ;
INSTRUCCIONES_CLASE:     INSTRUCCIONES_CLASE INSTRUCCION_CLASE                              {$1.push($2);$$=$1;}
                    |   INSTRUCCION_CLASE                                                   {$$=[$1];}
                    ;
INSTRUCCION_CLASE:      'RES_PUBLIC' 'RES_VOID' 'ID' '(' ')' BLOQUE_INSTRUCCIONES                       {$$=API.nuevoVoid($2,$5);}
                    |   'RES_PUBLIC' 'RES_VOID' 'ID' '(' LISTA_PARAM ')' BLOQUE_INSTRUCCIONES           {$$=API.nuevoVoidParametrizado($2,$4,$6);}
                    |   'RES_PUBLIC' TIPO 'ID' '(' ')' BLOQUE_INSTRUCCIONES                             {$$=API.nuevoMetodo($1,$2,$5);}
                    |   'RES_PUBLIC' TIPO 'ID' '(' LISTA_PARAM ')' BLOQUE_INSTRUCCIONES                 {$$=API.nuevoMetodoParametrizado($1,$2,$4,$6);}
                    |   'RES_PUBLIC' 'RES_STATIC' 'RES_VOID' 'RES_MAIN' '(' 'RES_STRING' '[' ']' 'ID' ')' BLOQUE_INSTRUCCIONES {$$=API.nuevoMain($9,$11);}
                    |   LLAMADA_FUNCION ';'
                    |   DECLARACION                                                         {$$=$1;}
                    |   ASIGNACION                                                          {$$=$1;}
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
                    ;