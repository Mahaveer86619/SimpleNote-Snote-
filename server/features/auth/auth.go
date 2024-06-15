package auth

import (
	"context"
	"encoding/json"
	"fmt"
	"net/http"

	"github.com/Mahaveer86619/SimpleNote-Snote-/config"
	"github.com/dgrijalva/jwt-go"
)

type User struct {
	ID       string `json:"id"`
	Username string `json:"username"`
	Email    string `json:"email"`
	Password string `json:"password"`
}

type UserToReturn struct {
	ID              string `json:"id"`
	Username        string `json:"username"`
	Email           string `json:"email"`
	TokenKey        string `json:"tokenKey"`
	RefreshTokenKey string `json:"refreshTokenKey"`
}

type AuthenticatingUser struct {
	Email    string `json:"email"`
	Password string `json:"password"`
}

type RegisteringUser struct {
	Username string `json:"username"`
	Email    string `json:"email"`
	Password string `json:"password"`
}

var USER_COLLECTION = "users"

func registerUser(registeringUser *RegisteringUser) (string, UserToReturn, error) {
	ctx := context.Background()
	client := config.GetFirestoreClient()

	ref := client.Collection(USER_COLLECTION).NewDoc()
	id := ref.ID

	user := User{
		ID:       id,
		Username: registeringUser.Username,
		Email:    registeringUser.Email,
		Password: registeringUser.Password,
	}

	query := client.Collection(USER_COLLECTION).Where("Email", "==", registeringUser.Email)

	docs, err := query.Documents(ctx).GetAll()
	if err != nil {
		fmt.Println(err)
		return "Server Error ", UserToReturn{}, err
	}

	if len(docs) > 0 {
		return "Email already exists", UserToReturn{}, nil
	}

	_, err = ref.Set(ctx, user)
	if err != nil {
		return "Server Error", UserToReturn{}, err
	}

	token, err := GenerateToken(user.Email)
	if err != nil {
		return "Server Error", UserToReturn{}, err
	}

	refreshToken, err := GenerateRefreshToken(user.Email)
	if err != nil {
		return "Server Error", UserToReturn{}, err
	}

	return "Registration successful", UserToReturn{ID: id, Username: user.Username, Email: user.Email, TokenKey: token, RefreshTokenKey: refreshToken}, nil
}

func authenticateUser(authenticatingUser *AuthenticatingUser) (string, UserToReturn, error) {
	ctx := context.Background()
	client := config.GetFirestoreClient()

	query := client.Collection(USER_COLLECTION).Where("Email", "==", authenticatingUser.Email)

	docs, err := query.Documents(ctx).GetAll()
	if err != nil {
		fmt.Println(err)
		return "Server Error ", UserToReturn{}, err
	}

	if len(docs) == 0 {
		return "Invalid email", UserToReturn{}, nil
	}

	if docs[0].Data()["Password"].(string) != authenticatingUser.Password {
		return "Invalid password", UserToReturn{}, nil
	}

	user := UserToReturn{ID: docs[0].Data()["ID"].(string), Username: docs[0].Data()["Username"].(string), Email: docs[0].Data()["Email"].(string)}

	token, err := GenerateToken(user.Email)
    if err != nil {
        return "Server Error", UserToReturn{}, err
    }

    refreshToken, err := GenerateRefreshToken(user.Email)
    if err != nil {
        return "Server Error", UserToReturn{}, err
    }

    user.TokenKey = token
    user.RefreshTokenKey = refreshToken

	return "Authentication successful", user, nil
}

func SignUp(w http.ResponseWriter, r *http.Request) {
	var user RegisteringUser
	err := json.NewDecoder(r.Body).Decode(&user)
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte("Invalid request body"))
		return
	}

	resp, userToReturn, err := registerUser(&user)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		w.Write([]byte(err.Error()))
		return
	}

	if resp == "Email is already taken" {
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte(resp))
		return
	}

	w.WriteHeader(http.StatusCreated)
	json.NewEncoder(w).Encode(userToReturn)
}

func SignIn(w http.ResponseWriter, r *http.Request) {
	var user AuthenticatingUser
	err := json.NewDecoder(r.Body).Decode(&user)
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte("Invalid request body"))
		return
	}

	resp, userToReturn, err := authenticateUser(&user)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		w.Write([]byte(resp + err.Error()))
		return
	}

	if resp == "Invalid email" {
		w.WriteHeader(http.StatusNotFound)
		w.Write([]byte(resp))
		return
	}

	if resp == "Invalid password" {
		w.WriteHeader(http.StatusUnauthorized)
		w.Write([]byte(resp))
		return
	}

	w.WriteHeader(http.StatusFound)
	json.NewEncoder(w).Encode(userToReturn)
}

func RefreshToken(w http.ResponseWriter, r *http.Request,) {
	var requestBody map[string]string
	if err := json.NewDecoder(r.Body).Decode(&requestBody); err != nil {
		http.Error(w, "Invalid request payload", http.StatusBadRequest)
		return
	}

	refreshToken := requestBody["refreshToken"]
	claims := &Claims{}
	token, err := jwt.ParseWithClaims(refreshToken, claims, func(token *jwt.Token) (interface{}, error) {
		return JwtKey, nil
	})

	if err != nil || !token.Valid {
		http.Error(w, "Invalid refresh token", http.StatusUnauthorized)
		return
	}

	newToken, err := GenerateToken(claims.Email)
	if err != nil {
		http.Error(w, "Error generating new token", http.StatusInternalServerError)
		return
	}

	newRefreshToken, err := GenerateRefreshToken(claims.Email)
	if err != nil {
		http.Error(w, "Error generating new token", http.StatusInternalServerError)
		return
	}

	w.WriteHeader(http.StatusCreated)
	json.NewEncoder(w).Encode(map[string]string{
		"tokenKey": newToken,
		"refreshTokenKey": newRefreshToken,
	})
}
