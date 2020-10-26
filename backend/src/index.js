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

app.post('/Analizar/', (req, res) => {
    try {
        //  input es el texto que se encuentra en el textarea con el id 'javaText'
        const { input } = req.body;
        //  file stream (i guess...)
        var fs = require('fs');
        //  se instancia al analizador o gramatica
        var parser = require('./grammar');
        var ast;
        try {
            //  y se ejecuta el metodo parse() para analizar la entrada devolviendo el ast
            ast = parser.parse(input.toString());
            //  se convierte el ast en un json y se exporta como 'ast.json'
            fs.writeFileSync('./ast.json', JSON.stringify(ast, null, 2));
        } catch (e) {
            console.log("No se pudo recuperar del ultimo error");
            console.error(e);
        }
        //  Si durante el análisis encuentra errores léxicos o sintácticos se recuperan...
        let errors = require('./grammar').errores;
        //  El ast no puede estar vacío
        /*if (ast != undefined) {
            let interpreter = require('../analyzer/interpreter');
            interpreter.processAST(ast, errors, errors.length);
            //console.log(errors);
        }*/
        //  ... y se envian como respuesta.
        res.send(errors);
        console.log("xd");
    } catch (e) {
        console.error(e);
    }
});