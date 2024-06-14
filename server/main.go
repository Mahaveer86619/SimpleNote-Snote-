/*


Endpoints:

/auth/signup 					Generates a new token
/auth/signin 					Generates a new token
/auth/refresh 					Refreshes the token

/notes/create 					Creates a new note with a valid token
/notes/get/{noteId}				Returns a note with a valid token and noteId
/notes/getall/{userEmail} 		Returns all notes for a user with a valid token and userEmail
/notes/update 					Updates a note with a valid token and note
/notes/delete/{noteId} 			Deletes a note with a valid token and noteId


*/

package main

import (
	"fmt"
	"net/http"

	"github.com/Mahaveer86619/SimpleNote-Snote-/features/auth"
	"github.com/Mahaveer86619/SimpleNote-Snote-/features/note"
	"github.com/Mahaveer86619/SimpleNote-Snote-/middleware"
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

Running in development mode

`

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
    mux.HandleFunc("/auth/refresh", auth.RefreshToken)

	//* Note operations
    mux.Handle("/notes/create", middleware.AuthMiddleware(http.HandlerFunc(note.CreateNoteHandler)))
    mux.Handle("/notes/get/{noteId}", middleware.AuthMiddleware(http.HandlerFunc(note.GetNoteHandler)))
    mux.Handle("/notes/getall/{userEmail}", middleware.AuthMiddleware(http.HandlerFunc(note.GetAllUserNotesHandler)))
    mux.Handle("/notes/update", middleware.AuthMiddleware(http.HandlerFunc(note.UpdateNoteHandler)))
    mux.Handle("/notes/delete/{noteId}", middleware.AuthMiddleware(http.HandlerFunc(note.DeleteNoteHandler)))
}
