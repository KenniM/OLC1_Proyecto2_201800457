package main

import (
	"fmt"
	"html/template"
	"net/http"
)

func indexHandler(w http.ResponseWriter, r *http.Request) {
	t := template.Must(template.ParseFiles("index.html"))
	t.Execute(w, nil)

}

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
