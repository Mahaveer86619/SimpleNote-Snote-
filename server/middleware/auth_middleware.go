package middleware

import (
    "context"
    "net/http"
    "strings"
    "github.com/dgrijalva/jwt-go"
    "github.com/Mahaveer86619/SimpleNote-Snote-/features/auth"
)

type contextKey string

const userContextKey = contextKey("user")

func AuthMiddleware(next http.Handler) http.Handler {
    return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
        authHeader := r.Header.Get("Authorization")
        if authHeader == "" {
            http.Error(w, "Authorization header is required", http.StatusUnauthorized)
            return
        }

        tokenString := strings.TrimPrefix(authHeader, "Bearer ")
        claims := &auth.Claims{}
        token, err := jwt.ParseWithClaims(tokenString, claims, func(token *jwt.Token) (interface{}, error) {
            return auth.JwtKey, nil
        })

        if err != nil || !token.Valid {
            http.Error(w, "Invalid token", http.StatusUnauthorized)
            return
        }

        ctx := context.WithValue(r.Context(), userContextKey, claims.Email)
        next.ServeHTTP(w, r.WithContext(ctx))
    })
}

func UserFromContext(ctx context.Context) (string, bool) {
    email, ok := ctx.Value(userContextKey).(string)
    return email, ok
}
