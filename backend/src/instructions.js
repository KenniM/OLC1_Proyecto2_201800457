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
    VOID:                       'INSTR_DECLARACION_FUNCION',
    METHOD:                     'INSTR_DECLARACION_METODO',
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
    nuevoIf:function(condicion,instruccionesThen,instruccionesElse){
        return{
            Tipo:TIPO_INSTRUCCION.IF,
            Expresion:condicion,
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
module.exports.TIPO_INSTRUCCION=TIPO_INSTRUCCION;
module.exports.TIPO_OPERACION=TIPO_OPERACION;
module.exports.TIPO_VALOR=TIPO_VALOR;
module.exports.INSTRUCCIONES_API=INSTRUCCIONES_API;