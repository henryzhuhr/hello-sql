package main

import (
	"crypto/rand"
	"flag"
	"fmt"
	"log"

	"github.com/google/uuid"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

type User struct {
	gorm.Model
	Username string    `gorm:"column:username;unique;size:64"`
	Email    string    `gorm:"size:64"`
	Uuid     uuid.UUID `gorm:"type:uuid;default:gen_random_uuid();unique"`
	Password string    `gorm:"column:password;size:64"`
}

// 指定 User 对应的数据表名称
func (User) TableName() string {
	return "users"
}

var postgres_connect_url string

func main() {
	// 解析命令行参数
	flag.StringVar(&postgres_connect_url, "postgres_connect_url", "", "Postgres connection URL")
	flag.Parse()

	if postgres_connect_url == "" {
		log.Fatal("Please provide the Postgres connection URL using -postgres_connect_url flag.")
	}

	// 连接数据库
	var db *gorm.DB
	db, err := gorm.Open(postgres.Open(postgres_connect_url), &gorm.Config{})
	if err != nil {
		log.Fatalf("Failed to connect to database: %v", err)
	}
	log.Println("Connecting to Postgres at", postgres_connect_url)

	// 迁移 schema
	err = db.AutoMigrate(&User{})
	if err != nil {
		log.Fatalf("Failed to migrate schema: %v", err)
	}

	// 启用日志模式，打印 SQL 语句
	db = db.Debug()

	// 获取数据表中的全部数据
	getAllUser := func(db *gorm.DB) {
		var users []User
		err := db.Find(&users).Error
		if err != nil {
			log.Fatalf("Failed to fetch users: %v", err)
		}
		log.Println("All users:")
		for _, user := range users {
			log.Println("  ", user.ID, user.Username, user.Email)
		}
	}
	getAllUser(db)

	// 插入数据
	username := randomString(8)
	email := fmt.Sprintf("%s@gmail.com", username)
	err = db.Create(&User{Username: username, Email: email, Password: "123456"}).Error
	if err != nil {
		log.Fatalf("Failed to insert: %v", err)
	}

	getAllUser(db)

	err = db.Delete(&User{}, "username=?", username).Error
	if err != nil {
		log.Fatalf("Failed to delete: %v", err)
	}

	getAllUser(db)
}

func randomString(length int) string {
	const (
		lowercase = "abcdefghijklmnopqrstuvwxyz"
		uppercase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
		digits    = "0123456789"
	)
	const charset = lowercase + uppercase + digits
	b := make([]byte, length)
	_, err := rand.Read(b)
	if err != nil {
		log.Fatalf("Failed to generate random string: %v", err)
	}
	for i := range b {
		b[i] = charset[int(b[i])%len(charset)]
	}
	return string(b)
}
