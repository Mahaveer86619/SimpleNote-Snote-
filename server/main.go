package main

import (
	"fmt"
	"net/http"

	"github.com/Mahaveer86619/SimpleNote-Snote-/features/auth"
)

var welcomeString = `
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
                                        
Serving at: http://192.168.29.150:3030

Running in development mode`

func main() {
	mux := http.NewServeMux()
	fmt.Println("Server Started...")

	handleFunctions(mux)

	if err := http.ListenAndServe(":3030", mux); err != nil {
		fmt.Println("Error starting server:", err)
	}
}

func handleFunctions(mux *http.ServeMux) {
	mux.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprint(w, welcomeString)
	})

	//* Authentication
	mux.HandleFunc("/auth/signup", auth.SignUp)
	mux.HandleFunc("/auth/signin", auth.SignIn)
}
