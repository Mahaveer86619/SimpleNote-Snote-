package main

import (
	"fmt"
	"net/http"
)

func main() {
	mux := http.NewServeMux()

	handleFunctions(mux)
	
	if err := http.ListenAndServe(":3030", mux); err != nil {
		fmt.Println("Error starting server:", err)
	}
}

func handleFunctions(mux *http.ServeMux) {
	mux.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, `
███████╗██╗███╗   ███╗██████╗ ██╗     ███████╗
██╔════╝██║████╗ ████║██╔══██╗██║     ██╔════╝
███████╗██║██╔████╔██║██████╔╝██║     █████╗  
╚════██║██║██║╚██╔╝██║██╔═══╝ ██║     ██╔══╝  
███████║██║██║ ╚═╝ ██║██║     ███████╗███████╗
╚══════╝╚═╝╚═╝     ╚═╝╚═╝     ╚══════╝╚══════╝
                                              
███╗   ██╗ ██████╗ ████████╗███████╗          
████╗  ██║██╔═══██╗╚══██╔══╝██╔════╝          
██╔██╗ ██║██║   ██║   ██║   █████╗            
██║╚██╗██║██║   ██║   ██║   ██╔══╝            
██║ ╚████║╚██████╔╝   ██║   ███████╗          
╚═╝  ╚═══╝ ╚═════╝    ╚═╝   ╚══════╝          
                                          


Serving at: http://127.0.0.1:3030

Running in development mode
		`)
	})
}
