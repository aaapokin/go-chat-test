package config

import (
	"os"
	"strconv"

	"github.com/joho/godotenv"
)

var Cfg *Config

type Config struct {
	AuthPort       string
	LoggerLevel    string
	DatabaseURL    string
	JwtKey         []byte
	JwtTimeSeconds int
}

func SetConfig() *Config {
	if Cfg != nil {
		return Cfg
	}
	godotenv.Load(".env")
	jwtKey := getEnv("jwt_key", "Gf5R6GFuyFG79^TYFGF&6r&6fUYf&6r&(6rF)")
	jwtTimeSecondsStr := getEnv("jwt_time_seconds", "30")
	jwtTimeSeconds, _ := strconv.Atoi(jwtTimeSecondsStr)
	Cfg = &Config{
		AuthPort:       getEnv("auth_port", "50051"),
		LoggerLevel:    getEnv("logger_level", "debug"),
		JwtKey:         []byte(jwtKey),
		JwtTimeSeconds: jwtTimeSeconds,
		DatabaseURL:    getEnv("database_url", "host=postgres dbname=app_db port=5432 user=app_user password=password sslmode=disable"),
	}
	return Cfg
}

func getEnv(key string, defaultVal string) string {
	if value, exists := os.LookupEnv(key); exists {
		return value
	}

	return defaultVal
}
