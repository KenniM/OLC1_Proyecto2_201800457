var contadorPestanias=2,
    arregloPestanias=new Array(),
    tabActual=1;
    var EditSession = ace.require(["src/edit_session"]).EditSession;

function addTab(){
    var nombre="Pestaña "+contadorPestanias;
    var elemento=document.getElementById('pestaniasT').insertAdjacentHTML('beforeend','\
    <li class="nav-item">\
          <a class="nav-link" data-toggle="tab" href="#home" onclick="changeTab('+contadorPestanias+')">'+nombre+'</a>\
        </li>');
    contadorPestanias++;
}

function changeTab(id){
    saveTab(tabActual);
    loadTab(id);
    tabActual=id;
}

function saveTab(id){
    var index=arregloPestanias[id-1];
    if (index!=undefined){
        index.session.setValue(editor.getValue());
    }else{
        var session= new EditSession(editor.getValue());
        arregloPestanias.push(session);
    }
    
}
function loadTab(id){
    var index=arregloPestanias[id-1];
    if(index!=undefined){
        editor.setSession(index);
    }else{
        window.alert('No había una sesión guardada dentro de esta pestaña.');
    }
}