var contadorPestanias=2,
    arregloPestanias=new Array(),
    arregloSalidasJS=new Array(),
    arregloSalidasPy=new Array(),
    tabActual=1;

function addTab(){
    var nombre="Pestaña "+contadorPestanias;
    var id="Pestaña"+contadorPestanias;
    var elemento=document.getElementById('pestaniasT').insertAdjacentHTML('beforeend','\
    <li class="nav-item">\
          <a id="'+id+'"class="nav-link" data-toggle="tab" href="#home" onclick="changeTab('+contadorPestanias+')">'+nombre+'</a>\
        </li>');
    contadorPestanias++;
    saveTab(tabActual);
    var pestActual=document.getElementById(id);
    pestActual.click();
    editor.setValue("");
    salJS.setValue("");
    salPy.setValue("");
}

function leerArchivo(e) {
    var archivo = e.target.files[0];
    if (!archivo) {
      return;
    }
    var lector = new FileReader();
    lector.onload = function(e) {
      var contenido = e.target.result;
      mostrarContenido(contenido);
    };
    lector.readAsText(archivo);
  }
  function mostrarContenido(contenido) {
    editor.setValue(contenido);
  }
document.getElementById('fileInput')
  .addEventListener('change', leerArchivo, false);

function changeTab(id){
    saveTab(tabActual);
    loadTab(id);
    tabActual=id;
}

function saveTab(id){
    var index=arregloPestanias[id-1];
    if (index!=undefined){
        arregloPestanias[id-1]=editor.getValue();
        arregloSalidasJS[id-1]=salJS.getValue();
        arregloSalidasPy[id-1]=salPy.getValue();
    }else{
        var session= editor.getValue();
        var session2= salJS.getValue();
        var session3= salPy.getValue();
        arregloPestanias.push(session);
        arregloSalidasJS.push(session2);
        arregloSalidasPy.push(session3);
    }
    
}

function saveEntryFile()
{  
    var textToWrite = editor.getValue();
    var textFileAsBlob = new Blob([textToWrite], {type:'text/plain'});
    var downloadLink = document.createElement("a");
    downloadLink.download = "entrada.java";
    downloadLink.href = window.webkitURL.createObjectURL(textFileAsBlob);
    downloadLink.click();
}

function saveJSOutput()
{  
    var textToWrite = salJS.getValue();
    var textFileAsBlob = new Blob([textToWrite], {type:'text/plain'});
    var downloadLink = document.createElement("a");
    downloadLink.download = "JSOutput.js";
    downloadLink.href = window.webkitURL.createObjectURL(textFileAsBlob);
    downloadLink.click();
}

function savePyOutput()
{  
    var textToWrite = salPy.getValue();
    var textFileAsBlob = new Blob([textToWrite], {type:'text/plain'});
    var downloadLink = document.createElement("a");
    downloadLink.download = "PyOutput.py";
    downloadLink.href = window.webkitURL.createObjectURL(textFileAsBlob);
    downloadLink.click();
}

function saveBoth(){
  saveJSOutput();
  savePyOutput();
}

function loadTab(id){
    var index=arregloPestanias[id-1];
    var index2=arregloSalidasJS[id-1];
    var index3=arregloSalidasPy[id-1];
    if(index!=undefined){
        editor.setValue(index);
        salJS.setValue(index2);
        salPy.setValue(index3);
    }
}