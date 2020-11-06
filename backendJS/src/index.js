//  Se guarda el modulo 'express' en una constante
const express = require("express");
//  App inicia a express y se guarda en una constante
const app = express();
//  IMPORTANTE ESTO
//  Cross Origin Resource Sharing 'CORS':
//  Resuelve un problema que se da al no poder conectar la
//  informacion con la que se comunican ambos puertos.
var cors = require('cors');
//  Se habilita el cors
app.use(cors());
//  Estableciendo puertos
app.set('port', process.env.PORT || 8080);

//  middlewares
const morgan = require("morgan");
app.use(morgan('dev'));
//  Utilizados para comunicarse con el cliente 
//  por medio de json's y poder leerlos.
app.use(express.urlencoded({ extended: false }));
app.use(express.json());


//  Iniciamos la app
app.listen(app.get('port'), () => {
    console.log(`Servidor de Jison activo en el puerto ${app.get('port')}`);
});

app.get('/', (req, res) => {
    console.log('Just for testing')
    res.send('Hello');
});

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
});

app.post('/GetErrores/', (req,res)=>{
    try{
        const {input} =req.body;
        var parser=require('./grammar');
        var ast;
        try {
            ast=parser.parse(input.toString());
            let errores=require('./grammar').listaErrores;
            require('./grammar').vaciar();
            res.send(errores.join(""));
        } catch (e) {
            
        }
    }catch(e){

    }
});

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