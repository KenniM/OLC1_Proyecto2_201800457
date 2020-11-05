export class token{
    constructor(valor,fila,columna,tipo){
        this.valor=valor;
        this.fila=fila;
        this.columna=columna;
        this.tipo=tipo;
    }

    getValor(){
        return this.valor;
    }
    getFila() {
        return this.fila;
    }
    getColumna() {
        return this.columna;
    }

    getTipo() {
        return this.tipo;
    }

    getToken(){
        switch (this.tipo){
            case Tipo.desconocido:
                return Tipo.desconocido;
            case Tipo.cadena:
                return Tipo.cadena;
            case Tipo.numero:
                return Tipo.numero;
            case Tipo.caracter:
                return Tipo.caracter;
            case Tipo.cadena:
                return Tipo.cadena;
            case Tipo.id:
                return Tipo.id;
            case Tipo.public:
                return Tipo.public;
            case Tipo.class:
                return Tipo.class;
            case Tipo.interface:
                return Tipo.interface;
            case Tipo.int:
                return Tipo.int;
            case Tipo.boolean:
                return Tipo.boolean;
            case Tipo.double:
                return Tipo.double;
            case Tipo.String:
                return Tipo.String;
            case Tipo.char:
                return Tipo.char;
            case Tipo.true:
                return Tipo.true;
            case Tipo.false:
                return Tipo.false;
            case Tipo.static:
                return Tipo.static;
            case Tipo.void:
                return Tipo.void;
            case Tipo.main:
                return Tipo.main;
            case Tipo.for:
                return Tipo.for;
            case Tipo.while:
                return Tipo.while;
            case Tipo.System:
                return Tipo.System;
            case Tipo.out:
                return Tipo.out;
            case Tipo.print:
                return Tipo.print;
            case Tipo.println:
                return Tipo.println;
            case Tipo.do:
                return Tipo.do;
            case Tipo.if:
                return Tipo.if;
            case Tipo.else:
                return Tipo.else;
            case Tipo.break:
                return Tipo.break;
            case Tipo.continue:
                return Tipo.continue;
            case Tipo.return:
                return Tipo.return;
            case Tipo.and:
                return Tipo.and;
            case Tipo.or:
                return Tipo.or;
            case Tipo.not:
                return Tipo.not;
            case Tipo.xor:
                return Tipo.xor;
            case Tipo.mayorigual:
                return Tipo.mayorigual;
            case Tipo.menorigual:
                return Tipo.menorigual;
            case Tipo.mayor:
                return Tipo.mayor;
            case Tipo.menor:
                return Tipo.menor;
            case Tipo.dobleigual:
                return Tipo.dobleigual;
            case Tipo.noigual:
                return Tipo.noigual;
            case Tipo.punto:
                return Tipo.punto;
            case Tipo.ptcoma:
                return Tipo.ptcoma;
            case Tipo.coma:
                return Tipo.coma;
            case Tipo.paraper:
                return Tipo.paraper;
            case Tipo.parcerr:
                return Tipo.parcerr;
            case Tipo.coraper:
                return Tipo.coraper;
            case Tipo.corcierre:
                return Tipo.corcierre;
            case Tipo.llaveaper:
                return Tipo.llaveaper;
            case Tipo.llavecierre:
                return Tipo.llavecierre;
            case Tipo.incremento:
                return Tipo.incremento;
            case Tipo.decremento:
                return Tipo.decremento;
            case Tipo.mas:
                return Tipo.mas;
            case Tipo.menos:
                return Tipo.menos;
            case Tipo.por:
                return Tipo.por;
            case Tipo.dividido:
                return Tipo.dividido;
            case Tipo.igual:
                return Tipo.igual;
            case Tipo.comentariol:
                return Tipo.comentariol;
            case Tipo.comentariom:
                return Tipo.comentariom;
        }
    }

    
}
export class Identificador{
    constructor(tipo,id,linea){
        this.tipo=tipo;
        this.id=id;
        this.linea=linea;
    }
}
export const Tipo={
        numero:'NUMERO',
        decimal:'DECIMAL',
        caracter:'CARACTER',
        cadena:'CADENA_DE_TEXTO',
        id:'IDENTIFICADOR',
        public:'RES_PUBLIC',
        class:'RES_CLASS',
        main:'RES_MAIN',
        interface:'RES_INTERFACE',
        int:'RES_INT',
        boolean:'RES_BOOLEAN',
        double:'RES_DOUBLE',
        String:'RES_STRING',
        char:'RES_CHAR',
        true:'RES_TRUE',
        false:'RES_FALSE',
        static:'RES_STATIC',
        void:'RES_VOID',
        for:'RES_FOR',
        while:'RES_WHILE',
        System:'RES_SYSTEM',
        out:'RES_OUT',
        println:'RES_PRTLN',
        print:'RES_PRINT',
        do:'RES_DO',
        if:'RES_IF',
        else:'RES_ELSE',
        break:'RES_BREAK',
        continue:'RES_CONTINUE',
        return:'RES_RETURN',
        and:'RES_AND',
        or:'RES_OR',
        not:'RES_NOT',
        xor:'RES_XOR',
        mayorigual:'RES_MAYOR_IGUAL',
        menorigual:'RES_MENOR_IGUAL',
        mayor:'RES_MAYOR_QUE',
        menor:'RES_MENOR_QUE',
        dobleigual:'RES_DOBLE_IGUAL',
        noigual:'RES_NO_IGUAL',
        punto:'PUNTO',
        ptcoma:'PUNTO_COMA',
        coma:'COMA',
        paraper:'PARENTESIS_APERTURA',
        parcerr:'PARENTESIS_CIERRE',
        coraper:'CORCHETE_APERTURA',
        corcierre:'CORCHETE_CIERRE',
        llaveaper:'LLAVE_APERTURA',
        llavecierre:'LLAVE_CIERRE',
        incremento:'INCREMENTO',
        decremento:'DECREMENTO',
        mas:'SIGNO_MAS',
        menos:'SIGNO_MENOS',
        por:'SIGNO_POR',
        dividido:'SIGNO_DIV',
        igual:'SIGNO_IGUAL',
        comentariol:'COMENTARIO_LINEAL',
        comentariom:'COMENTARIO_MULTILINEA',
        desconocido:'DESCONOCIDO'

}