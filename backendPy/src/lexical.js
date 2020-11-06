import { token,Tipo } from "./token";

export class lexical{
    constructor(){
        this.listaToken=new Array(),
        this.listaErrores=new Array(),
        this.estado=0,
        this.fila=1,
        this.columna=0,
        this.c="",
        this.Token="",
        this.comentario="";
    }

    Analizar(entrada){
        
        entrada+="#";
        for(let i=0;i<entrada.length;i++){
            this.c=entrada[i];

            switch(estado){
                case 0:
                    if(c==="{"){
                        this.Token+=c;
                        this.agregarToken(Tipo.llaveaper);
                    }else if(c==="}"){
                        this.Token+=c;
                        this.agregarToken(Tipo.llavecierre);
                    }else if(c==="("){
                        this.Token+=c;
                        this.agregarToken(Tipo.paraper);
                    }else if(c===")"){
                        this.Token+=c;
                        this.agregarToken(Tipo.parcerr);
                    }else if(c==="["){
                        this.Token+=c;
                        this.agregarToken(Tipo.coraper);
                    }else if(c==="]"){
                        this.Token+=c;
                        this.agregarToken(Tipo.corcierre);
                    }
            }
        }
    }
    agregarToken(tipo) {
        this.listaToken.push(new token(this.Token, this.fila, this.columna, tipo));
        this.Token = "";
        this.estado = 0;
        this.
    }
}