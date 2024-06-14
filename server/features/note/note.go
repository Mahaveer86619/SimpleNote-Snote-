package note

import (
	"context"
	"encoding/json"
	"net/http"

	firestore "cloud.google.com/go/firestore"
	"github.com/Mahaveer86619/SimpleNote-Snote-/config"
	"google.golang.org/api/iterator"
)

type Note struct {
	ID              string `json:"id"`
	Title           string `json:"title"`
	Content         string `json:"content"`
	Category        string `json:"category"`
	CoverPictureUrl string `json:"coverImagePath"`
	CreationDate    string `json:"createdAt"`
	UpdationDate    string `json:"updatedAt"`
	TileColor       string `json:"noteColorIndex"`
	CreatorId       string `json:"creatorEmail"`
}

var NOTE_COLLECTION_NAME = "notes"

func getNote(noteId string) (Note, error) {
	ctx := context.Background()
	client := config.GetFirestoreClient()

	doc, err := client.Collection(NOTE_COLLECTION_NAME).Doc(noteId).Get(ctx)
	if err != nil {
		return Note{}, err
	}

	var note Note
	if err := doc.DataTo(&note); err != nil {
		return Note{}, err
	}

	return note, nil
}

func getAllUserNotes(userEmail string) ([]Note, error) {
	ctx := context.Background()
	client := config.GetFirestoreClient()

	query := client.Collection(NOTE_COLLECTION_NAME).Where("creatorUid", "==", userEmail)

	var notes []Note
	iter := query.Documents(ctx)

	for {
		doc, err := iter.Next()
		if err == iterator.Done {
			break
		}
		if err != nil {
			return notes, err
		}
		var note Note
		doc.DataTo(&note)
		notes = append(notes, note)
	}

	return notes, nil
}

func createNote(noteData Note) error {
	ctx := context.Background()
	client := config.GetFirestoreClient()

	ref := client.Collection(NOTE_COLLECTION_NAME).NewDoc()
	id := ref.ID

	noteData.ID = id

	_, err := ref.Set(ctx, noteData)
	if err != nil {
		return err
	}

	return nil
}

func updateNote(
	id string,
	updatedNote Note,
) error {
	ctx := context.Background()
	client := config.GetFirestoreClient()

	ref := client.Collection(NOTE_COLLECTION_NAME).Doc(id)

	_, err := ref.Set(ctx, updatedNote, firestore.MergeAll)
	if err != nil {
		return err
	}

	return nil
}

func deleteNote(id string) error {
	ctx := context.Background()
	client := config.GetFirestoreClient()

	_, err := client.Collection(NOTE_COLLECTION_NAME).Doc(id).Delete(ctx)
	if err != nil {
		return err
	}

	return nil
}

func CreateNoteHandler(w http.ResponseWriter, r *http.Request) {
	var note Note
	if err := json.NewDecoder(r.Body).Decode(&note); err != nil {
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte("Invalid request body"))
		return
	}

	err := createNote(note)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.WriteHeader(http.StatusCreated)
	json.NewEncoder(w).Encode(note)
}

func GetNoteHandler(w http.ResponseWriter, r *http.Request) {
	noteId := r.URL.Query().Get("noteId")

	note, err := getNote(noteId)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(note)
}

func GetAllUserNotesHandler(w http.ResponseWriter, r *http.Request) {
	userId := r.URL.Query().Get("userEmail")

	notes, err := getAllUserNotes(userId)
	if err != nil {
		w.WriteHeader(http.StatusBadRequest) 
		w.Write([]byte("Invalid user ID"))
		return
	}

	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(notes)
}

func UpdateNoteHandler(w http.ResponseWriter, r *http.Request) {
	var note Note
	if err := json.NewDecoder(r.Body).Decode(&note); err != nil {
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte("Invalid request body"))
		return
	}

	err := updateNote(note.ID, note)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		w.Write([]byte("Server error"))
		return
	}

	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(note)
}

func DeleteNoteHandler(w http.ResponseWriter, r *http.Request) {
	noteId := r.URL.Query().Get("noteId")

	err := deleteNote(noteId)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		w.Write([]byte("Server error"))
		return
	}

	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(noteId)
}