package auth

import (
	"os"
	"time"

	"github.com/dgrijalva/jwt-go"
	"github.com/joho/godotenv"
)

type Claims struct {
	Email string `json:"email"`
	jwt.StandardClaims
}

func init() {
	godotenv.Load(".env")
}

var JwtKey = []byte(os.Getenv("JWT_SECRET"))

func GenerateToken(email string) (string, error) {
    expirationTime := time.Now().Add(15 * time.Minute)
    claims := &Claims{
        Email: email,
        StandardClaims: jwt.StandardClaims{
            ExpiresAt: expirationTime.Unix(),
        },
    }
    token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
    return token.SignedString(JwtKey)
}

func GenerateRefreshToken(email string) (string, error) {
    expirationTime := time.Now().Add(24 * time.Hour)
    claims := &Claims{
        Email: email,
        StandardClaims: jwt.StandardClaims{
            ExpiresAt: expirationTime.Unix(),
        },
    }
    token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
    return token.SignedString(JwtKey)
}
