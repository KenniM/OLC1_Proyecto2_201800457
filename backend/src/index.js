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
    console.log(`Server on port ${app.get('port')}`);
});

app.get('/', (req, res) => {
    console.log('Just for testing')
    res.send('Hello');
});