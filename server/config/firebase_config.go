package config

import (
	"context"
	"os"

	"cloud.google.com/go/firestore"
	firebase "firebase.google.com/go"
	"github.com/joho/godotenv"
	"google.golang.org/api/option"
)

var (
	ctx    context.Context
	client *firestore.Client
)

func init() {
	ctx = context.Background()
	godotenv.Load(".env")

	config := &firebase.Config{
		ProjectID: os.Getenv("FIREBASE_PROJECT_ID"),
	}
	opt := option.WithCredentialsFile(os.Getenv("GOOGLE_APPLICATION_CREDENTIALS"))

	var err error
	app, err := firebase.NewApp(ctx, config, opt)
	if err != nil {
		panic(err)
	}

	client, err = app.Firestore(ctx)
	if err != nil {
		panic(err)
	}
}

func GetFirestoreClient() *firestore.Client {
	return client
}