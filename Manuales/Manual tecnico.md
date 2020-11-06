# MANUAL TÉCNICO "TRANSLATOR IN DOCKER"
Para la elaboración de este proyecto, fue necesario la implementación de tres servidores, uno basado en *Golang*, que está dedicado a servir el frontend de la apliación, mientras que los otros dos se encuentran basados en *Node-JS*, para el funcionamiento de la traducción al lenguaje **JavaScript** y **Python**, respectivamente.

## Servidor del frontend

Para la creación del servidor en Go, fueron necesarias las importaciones de las librerías `fmt`, `html/template` y `net/http`.

```go
import (
	"fmt"
	"html/template"
	"net/http"
)
```
Se crea una función `indexHandler`, la cual será lanzada al inciar el servidor, montando inicialmente el archivo *index.html* ubicado dentro de la misma carpeta.

```go
func indexHandler(w http.ResponseWriter, r *http.Request) {
	t := template.Must(template.ParseFiles("index.html"))
	t.Execute(w, nil)

}
```
Finalmente, dentro de la función `main` se incluyen los directorios adicionales donde se encuentren estilos de css o módulos de JavaScript, en caso contrario, el servidor no permitirá la conexión con los mismos, adicionalmente se indica el puerto en el que se alojará el servicio:

```go
func main() {

	http.Handle("/js/", http.StripPrefix("/js/", http.FileServer(http.Dir("js/"))))
	http.Handle("/dist/", http.StripPrefix("/dist/", http.FileServer(http.Dir("dist/"))))
	http.Handle("/src/", http.StripPrefix("/src/", http.FileServer(http.Dir("src/"))))
	http.Handle("/src/decorator/", http.StripPrefix("/src/decorator/", http.FileServer(http.Dir("src/decorator/"))))
	http.Handle("/src/layout/", http.StripPrefix("/src/layout/", http.FileServer(http.Dir("src/layout/"))))
	http.Handle("/src/node/", http.StripPrefix("/src/node/", http.FileServer(http.Dir("src/node/"))))
	http.Handle("/src/reader/", http.StripPrefix("/src/reader/", http.FileServer(http.Dir("src/reader/"))))
	http.Handle("/js/src/", http.StripPrefix("/js/src/", http.FileServer(http.Dir("js/src/"))))
	http.Handle("/css/", http.StripPrefix("/css/", http.FileServer(http.Dir("css/"))))

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		http.ServeFile(w, r, r.URL.Path[1:])
	})
	fmt.Printf("Iniciando servidor en el puerto 1500")
	http.ListenAndServe(":1500", nil)

}
```
## Servidor para el traductor a JavaScript y Python

Como se mencionó anteriormente, los servidores dedicados a la traducción se encuentran bajo un proyecto de Node-JS, por lo que para iniciar un nuevo proyecto, haremos lo siguiente:

+ Crear una carpeta para cada traductor, dentro de cada una ejecutar: `npm init --yes`, para iniciar un nuevo proyecto de Node, al incluir el parámetro `--yes` nos ahorramos tiempo al realizar algunas configuraciones dentro de la creación del mismo.
+ Ejecutar `npm install express morgan cors`, de esta forma se instalarán los módulos necesarios para iniciar los servidores.
+ Opcional:
    * Ejecutar: `npm install nodemon -D`  y en "package.json" asegurarse que en el espacio para "scripts" exista un objeto llamado "dev" (tal y como aparece en el archivo del repositorio, si no se instala modificarlo).

### Levantando los servidores
>+ El paso opcional realizado facilita la ejecución de los archivos creados dentro de las carpetas de cadad servidor, de esta forma, al guardar los cambios en un archivo, este se compila y ejecuta automáticamente, en caso de que el servidor se detuviera, vuelve a iniciarse automáticamente, para eso basta ingresar el comando `npm run dev`.
+ En caso de que no se haya realizado el paso opcional, cada vez que se guarden cambios dentro de los archivos será necesario ejecutar `node index.js`.

### Contenido de los archivos de los servidores

```javascript
/* Se solicitan las librerías que instalamos anteriormente */
const express = require("express");
const app = express();
var cors = require('cors');
app.use(cors());
/* Establecemos el puerto en el que deseamos que el servidor esté escuchando, en este caso, se empleará el 8080 */
app.set('port', process.env.PORT || 8080);

const morgan = require("morgan");
app.use(morgan('dev'));
/* Utilizados para comunicarse con el cliente 
 por medio de json y poder leerlos. */
app.use(express.urlencoded({ extended: false }));
app.use(express.json());


//  Iniciamos la app
app.listen(app.get('port'), () => {
    console.log(`Servidor de Jison activo en el puerto ${app.get('port')}`);
});
// Solicitud de prueba
app.get('/', (req, res) => {
    console.log('Just for testing')
    res.send('Hello');
});
/* Consulta que ejecuta la traducción del lenguaje por medio de la herramienta Jison */
app.post('/Traducir/',(req,res)=>{
    try {
        console.log("------- TRADUCCION ------");
        const { input } = req.body;
        var fs = require('fs');
        var traductor = require('./translator');
        var traduccion;
        try {
            traduccion = traductor.parse(input.toString());
            fs.writeFileSync('./traduccion.txt', traduccion);
            res.send(traduccion);
        } catch (e) {
            console.log("No se pudo recuperar del ultimo error");
            console.error(e);
        }
        console.log("Traducción finalizada");
    } catch (e) {
        console.error(e);
    }
});
/* Consulta que extrae la lista de tokens del lenguaje por medio de la herramienta Jison */
app.post('/GetTokens/',(req,res)=>{
    try {
        const { input } = req.body;
        var parser1 = require('./grammar');
        var ast1;
        try {

            ast1 = parser1.parse(input.toString());
            let tokens = require('./grammar').listaTokens;
            require('./grammar').vaciar();
            res.send(tokens.join(""));

        } catch (e) {
            console.log("No se pudo recuperar del ultimo error");
            console.error(e);
        }
        
        
    } catch (e) {
        console.error(e);
    }
});
/* Consulta que obtiene el AST del lenguaje por medio de la herramienta Jison */
app.post('/GetAST/',(req,res)=>{
    try{
        const {input}=req.body;
        var fs=require('fs');
        var parser=require('./grammar');
        var ast;
        try{
            ast=parser.parse(input.toString());
        }catch (e){
            console.log("Se ha producido un error al generar el AST");
            console.error(e);
        }
        res.send(ast);
    }catch (e) {
        console.error(e);
    }
})
/* Consulta que ejecuta el análisis léxico y sintáctico del lenguaje por medio de la herramienta Jison */
app.post('/Analizar/', (req, res) => {
    try {
        console.log("------- ANALISIS ------");
        const { input } = req.body;
        var fs = require('fs');
        var parser = require('./grammar');
        var ast;
        try {

            ast = parser.parse(input.toString());
            fs.writeFileSync('./ast.json', JSON.stringify(ast, null, 2));
        } catch (e) {
            console.log("No se pudo recuperar del ultimo error");
            console.error(e);
        }
        let errors = require('./grammar').errores;
        try{
            fs.writeFileSync('./errores.txt', errors.join(""));
        }catch(e){
            console.error("No se ha podido guardar el archivo de errores.")
        }
        res.send(errors.join(""));
        console.log("Análisis finalizado");
        
    } catch (e) {
        console.error(e);
    }
});
```

# La herramienta Jison

Jison es una herramienta de análisis léxico y sintáctico, prácticamente es considerada una adaptación de Bison para JavaScript, dentro de esta se realizar la definición léxica y sintáctica, la ventaja es que adicionalmente se puede implementar código de JavaScript para maximizar la utilidad de la herramienta, permitiendo de esta manera, generar dentro del mismo analizador el AST, lista de tokens e incluso la traducción.

### Instalación

Si la aplicación se desarrolla en Windows, será necesario instalar Jison para poder compilar los archivos correspondientes, para ello, dentro de la carpeta de cada servidor ingresamos el comando `npm install jison`. En caso alternativo, uno puede compilarlo directamente a través de Git Bash.

>En el caso de usar Linux, será necesario instalar Jison, si se usa Ubuntu, es necesario ingresar a la terminal e ingresar `sudo apt install jison`.

### Definiendo el lenguaje

Creamos un archivo `grammar.jison` (el nombre puede variar), dentro de él declaramos toda la defición léxica (palabras reservadas y expresiones regulares)

Inicialmente crearemos unos objetos que nos ayudarán a guardar la información obtenida dentro del análisis.

```jison
%{
let modoPanico = false,
    contador = 1,
    contadorTokens=1,
    errores = new Array();
	listaTokens = new Array();
//Los siguientes nos permiten hacer uso de require para acceder a estos elementos desde otros archivos
module.exports.errores = errores;
module.exports.listaTokens = listaTokens;
exports.vaciar = function () { listaTokens=[];contador=1; };
%}
```
La definición léxica se elaboró de la siguiente manera:
```jison
/* DEFINICIÓN LÉXICA */

%lex
%options case-sensitive
numero [0-9]+                       // ER PARA RECONOCER NUMEROS ENTEROS
decimal {numero}("."{numero})       // ER PARA RECONOCER NUMEROS DECIMALES
caracter \'.\'                      // ER PARA RECONOCER UN SOLO CARACTER
cadena (\"[^"]*\")                  // ER PARA RECONOCER CADENAS DE TEXTO
identificador ([a-zA-ZñÑ_])[a-zA-Z0-9ñÑ_]*  // ER PARA RECONOCER IDENTIFICADORES

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
"&&"                    {listaTokens.push('<tr><th scope="row">'+contadorTokens.toString()+'</th><td>'+yylloc.first_line+'</td><td>'+(parseInt(yylloc.first_column)+1)+'</td><td>RES_AND</td><td>'+yytext+'</td></tr>\n');contadorTokens++;return '&&';}
"||"                    {listaTokens.push('<tr><th scope="row">'+contadorTokens.toString()+'</th><td>'+yylloc.first_line+'</td><td>'+(parseInt(yylloc.first_column)+1)+'</td><td>RES_OR</td><td>'+yytext+'</td></tr>\n');contadorTokens++;return '||';}
"!"                     {listaTokens.push('<tr><th scope="row">'+contadorTokens.toString()+'</th><td>'+yylloc.first_line+'</td><td>'+(parseInt(yylloc.first_column)+1)+'</td><td>RES_NOT</td><td>'+yytext+'</td></tr>\n');contadorTokens++;return '!';}
"^"                     {listaTokens.push('<tr><th scope="row">'+contadorTokens.toString()+'</th><td>'+yylloc.first_line+'</td><td>'+(parseInt(yylloc.first_column)+1)+'</td><td>RES_XOR</td><td>'+yytext+'</td></tr>\n');contadorTokens++;return '^'}
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
```
Como se puede apreciar, al lado de cada definición léxica, se puede incluir código en JavaScript.

Como se desea realizar el AST correspondiente a este análisis, creamos un archivo `instructions.js`, dentro del cual estableceremos las operaciones que se pueden hacer dentro del AST:

```javascript
// CONSTANTES PARA LOS TIPOS DE DATOS SOPORTADOS POR EL LENGUAJE
const TIPO_VALOR = {
    NUMERO:     'NUMERO',
    DECIMAL:    'DECIMAL',
    IDENTIFICADOR:         'ID',
    STRING:     'STRING',
    CHAR:       'CHAR',
    TRUE:       'TRUE',
    FALSE:      'FALSE',
    FUNCTION:   'FUNCION'
}

// CONSTANTES PARA LOS TIPOS DE OPERACIONES SOPORTADAS
const TIPO_OPERACION = {
    SUMA:                     'OPER_SUMA',
    RESTA:                    'OPER_RESTA',
    MULTIPLICACION:           'OPER_MULTIPLICACION',
    DIVISION:                 'OPER_DIVISION',
    NEGATIVO:                 'OPER_NEGATIVO',
    INCREMENTO:               'OPER_INCREMENTO',
    DECREMENTO:               'OPER_DECREMENTO',
    MAYOR_QUE:                'OPER_MAYOR_QUE',
    MENOR_QUE:                'OPER_MENOR_QUE',
    MAYOR_IGUAL_QUE:          'OPER_MAYOR_IGUAL_QUE',
    MENOR_IGUAL_QUE:          'OPER_MENOR_IGUAL_QUE',
    DOBLE_IGUAL:              'OPER_IGUAL',
    NO_IGUAL:                 'OPER_NO_IGUAL',
    AND:                      'OPER_AND',
    OR:                       'OPER_OR',
    NOT:                      'OPER_NOT',
    XOR:                      'OPER_XOR',
    CONCATENACION:            'OPER_CONCATENACION'
}

const TIPO_INSTRUCCION ={
    PRINTLN:                    'INSTR_PRINTLN',
    PRINT:                      'INSTR_PRINT',
    WHILE:                   'INSTR_WHILE',
    DO:                      'INSTR_DO',
    DECLARACION:                'INSTR_DECLARACION',
    ASIGNACION:                 'INSTR_ASIGNACION',
    IF:                         'INSTR_IF',
    ELSE_IF:                    'INSTR_ELSE_IF',
    ELSE:                       'INSTR_ELSE',
    FOR:                        'INSTR_FOR',
    CLASS:                      'INSTR_DECLARACION_CLASE',
    INTERFACE:                  'INSTR_DECLARACION_INTERFACE',
    VOID:                       'INSTR_DECLARACION_FUNCION',
    METHOD:                     'INSTR_DECLARACION_METODO',
    MAIN:                       'INSTR_DECLARACION_MAIN',
    BREAK:                      'INSTR_BREAK',
    CONTINUE:                   'INSTR_CONTINUE',
    LLAMADA_FUNCION:            'INSTR_LLAMADA_FUNCION',
    RETURN:                     'INSTR_RETURN'
}
// CREACION DEL OBJETO TIPO 'OPERACION'
function nuevaOperacion(izquierda,derecha,tipo){
    return{
        Tipo: tipo,
        Operador_izquierda:izquierda,
        Operador_derecha:derecha
    }
}
// CREACION DE CONSTANTE QUE CONTIENE LAS DISTINTAS OPERACIONES E INSTRUCCIONES
const INSTRUCCIONES_API = {
    nuevaOperBinaria:function(izquierda,derecha,tipo){
        return nuevaOperacion(izquierda,derecha,tipo);
    },

    nuevaOperUnitaria:function(operador,tipo){
        return nuevaOperacion(operador,undefined,tipo);
    },
    nuevoValor:function(valor,tipo){
        return{
            Tipo:tipo,
            Valor: valor
        }
    },
    nuevaClase:function(idClase,instrucciones){
        return{
            Tipo:TIPO_INSTRUCCION.CLASS,
            ID_Clase:idClase,
            Lista_Instrucciones:instrucciones
        }
    },
    nuevaInterfaz:function(idInterfaz,definiciones){
        return{
            Tipo:TIPO_INSTRUCCION.INTERFACE,
            ID_Interfaz:idInterfaz,
            Lista_Definiciones:definiciones
        }
    },
    nuevaDefVoid:function(idVoid){
        return{
            Tipo:TIPO_INSTRUCCION.VOID,
            ID_Funcion:idVoid
        }
    },
    nuevaDefVoidParametrizado:function(idVoid,parametros){
        return{
            Tipo:TIPO_INSTRUCCION.VOID,
            ID_Funcion:idVoid,
            Lista_parametros:parametros
        }
    },
    nuevaDefMetodo:function(tipo,idMetodo){
        return{
            Tipo:TIPO_INSTRUCCION.METHOD,
            Tipo_dato:tipo,
            ID_Funcion:idMetodo
        }
    },
    nuevaDefMetodoParametrizado:function(tipo,idMetodo,parametros){
        return{
            Tipo:TIPO_INSTRUCCION.METHOD,
            Tipo_dato:tipo,
            ID_Funcion:idMetodo,
            Lista_parametros:parametros
        }
    },
    nuevoVoid:function(idVoid,instrucciones){
        return{
            Tipo:TIPO_INSTRUCCION.VOID,
            ID_Funcion:idVoid,
            Lista_instrucciones:instrucciones
        }
    },
    nuevoVoidParametrizado:function(idVoid,parametros,instrucciones){
        return{
            Tipo:TIPO_INSTRUCCION.VOID,
            ID_Funcion:idVoid,
            Lista_parametros:parametros,
            Lista_instrucciones:instrucciones
        }
    },
    nuevoMetodo:function(tipoRetorno,idMetodo,instrucciones){
        return{
            Tipo:TIPO_INSTRUCCION.METHOD,
            Tipo_retorno:tipoRetorno,
            ID_Metodo:idMetodo,
            Lista_instrucciones:instrucciones
        }
    },
    nuevoMetodoParametrizado:function(tipoRetorno,idMetodo,parametros,instrucciones){
        return{
            Tipo:TIPO_INSTRUCCION.METHOD,
            Tipo_retorno:tipoRetorno,
            ID_Metodo:idMetodo,
            Lista_parametros:parametros,
            Lista_instrucciones:instrucciones
        }
    },
    nuevoParametro:function(tipo,id){
        return{
            Tipo_dato:tipo,
            ID_Parametro:id
        }
    },
    nuevaListaParametros:function(tipo,id,listaParametros){
        return{
            Parametro:this.nuevoParametro(tipo,id),
            Lista_parametros:listaParametros
        }
    },
    nuevaDeclaracionExp:function(tipo,id,expresion){
        return{
            Tipo:TIPO_INSTRUCCION.DECLARACION,
            Tipo_dato:tipo,
            ID_Declaracion:id,
            Expresion:expresion
        }
    },
    nuevaDeclaracion:function(tipo,id){
        return{
            Tipo:TIPO_INSTRUCCION.DECLARACION,
            Tipo_dato:tipo,
            ID_Declaracion:id
        }
    },
    nuevaAsignacion:function(id,expresion){
        return{
            Tipo:TIPO_INSTRUCCION.ASIGNACION,
            ID:id,
            Expresion:expresion
        }
    },
    nuevoMain:function(parametro,instrucciones){
        return{
            Tipo:TIPO_INSTRUCCION.MAIN,
            Nombre_Paramatero:parametro,
            Lista_Instrucciones:instrucciones
        }
    },
    nuevoIf:function(condicion,instruccionesThen,instruccionesElse){
        return{
            Tipo:TIPO_INSTRUCCION.IF,
            Expresion_Logica:condicion,
            Then:instruccionesThen,
            Else:instruccionesElse
        }
    },
    nuevoWhile:function(expresion,instrucciones){
        return{
            Tipo:TIPO_INSTRUCCION.WHILE,
            Expresion:expresion,
            Lista_Instrucciones:instrucciones
        }
    },
    nuevoDoWhile:function(instrucciones,expresion){
        return{
            Tipo:TIPO_INSTRUCCION.DO,
            Lista_Instrucciones:instrucciones,
            Condicion:expresion
        }
    },
    nuevoFor:function(declaracion,expresion,unario,instrucciones){
        return{
            Tipo:TIPO_INSTRUCCION.FOR,
            Operacion:declaracion,
            Expresion:expresion,
            Operacion_Unaria:unario,
            Lista_Instrucciones:instrucciones
        }
    },
    nuevoPrint:function(expresion){
        return{
            Tipo:TIPO_INSTRUCCION.PRINT,
            Expresion:expresion
        }
    },
    nuevoPrintLn:function(expresion){
        return{
            Tipo:TIPO_INSTRUCCION.PRINTLN,
            Expresion:expresion
        }
    },
    nuevoContinue:function(fila,columna){
        return{
            Tipo:TIPO_INSTRUCCION.CONTINUE,
            Fila:fila,
            Columna:columna
        }
    },
    nuevoBreak:function(fila,columna){
        return{
            Tipo:TIPO_INSTRUCCION.BREAK,
            Fila:fila,
            Columna:columna
        }
    },
    nuevoReturn:function(expresion,fila,columna){
        return{
            Tipo:TIPO_INSTRUCCION.RETURN,
            Valor_Retorno:expresion,
            Fila:fila,
            Columna:columna
        }
    },
    nuevaLlamadaFuncion:function(id,listaExpresiones){
        return{
            Tipo:TIPO_INSTRUCCION.LLAMADA_FUNCION,
            ID:id,
            listaExpresiones:listaExpresiones
        }
    }



}

// Esto permite exportar las constantes e implementarlas dentro del archivo Jison
module.exports.TIPO_INSTRUCCION=TIPO_INSTRUCCION;
module.exports.TIPO_OPERACION=TIPO_OPERACION;
module.exports.TIPO_VALOR=TIPO_VALOR;
module.exports.INSTRUCCIONES_API=INSTRUCCIONES_API;
```
Ahora ya que tenemos la definición de instrucciones para el AST, podemos proceder con la definición sintáctica:

```jison
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
                    |   error {var nuevoError=contador.toString()+'. ERROR SINTÁCTICO: Se ha obtenido un error de sintaxis: ' + yytext + ', se esperaba una declaración de clase o interfaz, en la linea: ' + this._$.first_line + ', en la columna: ' + this._$.first_column;errores.push(nuevoError+"\n");contador++;}
                    ;
DEFINICIONES_INTERFAZ:  DEFINICIONES_INTERFAZ DEFINICION_INTERFAZ                           {$1.push($2);$$=$1;}
                    |   DEFINICION_INTERFAZ                                                 {$$=[$1];}
                    ;
DEFINICION_INTERFAZ:    'RES_PUBLIC' 'RES_VOID' 'ID' '(' ')' ';'                            {$$=API.nuevaDefVoid($3);}
                    |   'RES_PUBLIC' 'RES_VOID' 'ID' '(' LISTA_PARAM ')' ';'                {$$=API.nuevaDefVoidParametrizado($3,$5);}
                    |   'RES_PUBLIC' TIPO 'ID' '(' ')' ';'                                  {$$=API.nuevaDefMetodo($2,$3);}
                    |   'RES_PUBLIC' TIPO 'ID' '(' LISTA_PARAM ')' ';'                      {$$=API.nuevaDefMetodoParametrizado($2,$3,$5);}
                    |   'RES_VOID' 'ID' '(' ')' ';'                            {$$=API.nuevaDefVoid($2);}
                    |   'RES_VOID' 'ID' '(' LISTA_PARAM ')' ';'                {$$=API.nuevaDefVoidParametrizado($2,$4);}
                    |   TIPO 'ID' '(' ')' ';'                                  {$$=API.nuevaDefMetodo($1,$2);}
                    |   TIPO 'ID' '(' LISTA_PARAM ')' ';'                      {$$=API.nuevaDefMetodoParametrizado($1,$2,$4);}
                    |   error {var nuevoError=contador.toString()+'. ERROR SINTÁCTICO: Se ha obtenido un error de sintaxis: ' + yytext + ', se esperaba la declaración de un método, en la linea: ' + this._$.first_line + ', en la columna: ' + this._$.first_column;errores.push(nuevoError+"\n");contador++;}
                    ;    
INSTRUCCIONES_CLASE:     INSTRUCCIONES_CLASE INSTRUCCION_CLASE                              {$1.push($2);$$=$1;}
                    |   INSTRUCCION_CLASE                                                   {$$=[$1];}
                    ;
INSTRUCCION_CLASE:      'RES_PUBLIC' 'RES_VOID' 'ID' '(' ')' BLOQUE_INSTRUCCIONES                       {$$=API.nuevoVoid($3,$6);}
                    |   'RES_PUBLIC' 'RES_VOID' 'ID' '(' LISTA_PARAM ')' BLOQUE_INSTRUCCIONES           {$$=API.nuevoVoidParametrizado($3,$5,$7);}
                    |   'RES_PUBLIC' TIPO 'ID' '(' ')' BLOQUE_INSTRUCCIONES                             {$$=API.nuevoMetodo($2,$3,$6);}
                    |   'RES_PUBLIC' TIPO 'ID' '(' LISTA_PARAM ')' BLOQUE_INSTRUCCIONES                 {$$=API.nuevoMetodoParametrizado($2,$3,$5,$7);}
                    |   'RES_VOID' 'ID' '(' ')' BLOQUE_INSTRUCCIONES                       {$$=API.nuevoVoid($2,$5);}
                    |   'RES_VOID' 'ID' '(' LISTA_PARAM ')' BLOQUE_INSTRUCCIONES           {$$=API.nuevoVoidParametrizado($2,$4,$6);}
                    |   TIPO 'ID' '(' ')' BLOQUE_INSTRUCCIONES                             {$$=API.nuevoMetodo($1,$2,$5);}
                    |   TIPO 'ID' '(' LISTA_PARAM ')' BLOQUE_INSTRUCCIONES                 {$$=API.nuevoMetodoParametrizado($1,$2,$4,$6);}
                    |   'RES_PUBLIC' 'RES_STATIC' 'RES_VOID' 'RES_MAIN' '(' 'RES_STRING' '[' ']' 'ID' ')' BLOQUE_INSTRUCCIONES {$$=API.nuevoMain($9,$11);}
                    |   LLAMADA_FUNCION ';'
                    |   DECLARACION                                                         {$$=$1;}
                    |   ASIGNACION                                                          {$$=$1;}
                    |   error {var nuevoError=contador.toString()+'. ERROR SINTÁCTICO: Se ha obtenido un error de sintaxis: ' + yytext + ', se esperaba:declaración de método o función, declaración, asignación o llamada a una función, en la linea: ' + this._$.first_line + ', en la columna: ' + this._$.first_column;errores.push(nuevoError+"\n");contador++;}
                    ;
                    
LISTA_PARAM:            LISTA_PARAM ',' PARAMETRO                                           {$1.push($3);$$=$1;}
                    |   PARAMETRO                                                           {$$=[$1];}
                    ;
PARAMETRO:              TIPO 'ID'                                                           {$$=API.nuevoParametro($1,$2);}
                    ;
ASIGNACION:             'ID' '=' EXPRESION ';'                                              {$$=API.nuevaAsignacion($1,$3);}
                                                                                            //{$$=`${$1} = ${$3}`}
                    ;
DECLARACION:            DECLARACIONES ';'                                                   {$$=$1;/*$$=API.nuevaDeclaracion($1,$2);*/}
                    //|   TIPO LISTA_ID '=' EXPRESION ';'                                     {$$=API.nuevaDeclaracionExp($1,$2,$4);}
                    ;
DECLARACIONES:          TIPO DECLARADORES                                                         {$$=API.nuevaDeclaracion($1,$2);}
                    ;
DECLARADORES:           DECLARADOR                                                                {$$=[$1];}
                    |   DECLARADORES ',' DECLARADOR                                         {$1.push($3);$$=$1;}
                    ;
DECLARADOR:             ID_VAR                                                                {$$=API.nuevoValor($1,TIPO_VALOR.IDENTIFICADOR);}    
                    |   INCIALIZADOR                                                          {$$=$1;}
                    ;
ID_VAR:                 'ID'                                                                 {$$=$1;}
                    ;
INCIALIZADOR:           ID_VAR '=' EXPRESION                                                {$$=API.nuevaAsignacion($1,$3);}
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
			var newError = contador.toString() + ". Se esperaba el inicio de una instrucción valida pero se obtuvo \"" + $1 + "\" en la línea "+row+", columna "+column+".\n";
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
                    |   EXPRESION '^' EXPRESION  { $$ = API.nuevaOperBinaria($1, $3, TIPO_OPERACION.XOR); }
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
```
Una vez finalizado el contenido del archivo Jison, procedemos a compilarlo con el comando `jison grammar.jison`
