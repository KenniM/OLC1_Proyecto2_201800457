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
## Servidor para el traductor a JavaScript

Como se mencionó anteriormente, los servidores dedicados a la traducción se encuentran bajo un proyecto de Node-JS, por lo que para iniciar un nuevo proyecto, haremos lo siguiente:

+ Crear una carpeta para cada traductor, dentro de cada una ejecutar: `npm init --yes`, para iniciar un nuevo proyecto de Node, al incluir el parámetro `--yes` nos ahorramos tiempo al realizar algunas configuraciones dentro de la creación del mismo.
+ Ejecutar `npm install express morgan cors`, de esta forma se instalarán los módulos necesarios para iniciar los servidores.
+ Opcional:
    * Ejecutar: `npm install nodemon -D`