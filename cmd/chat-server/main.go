package main

import (
	"context"
	"fmt"
	"github.com/brianvoe/gofakeit"
	"github.com/saitdarom/go-chat-test/config"
	desc "github.com/saitdarom/go-chat-test/pkg/chat-server/chat_v1"
	"google.golang.org/grpc"
	"google.golang.org/grpc/reflection"
	"log"
	"net"
)

//var configPath string

// func init() {
// 	flag.StringVar(&configPath, "path", "config/.env", "path to env")
// }

type server struct {
	desc.UnimplementedChatV1Server
}

func (s *server) Create(ctx context.Context, req *desc.CreateRequest) (*desc.CreateResponse, error) {

	return &desc.CreateResponse{
		Id: gofakeit.UUID(),
	}, nil
}

func main() {
	// flag.Parse()
	config.SetConfig()
	lis, err := net.Listen("tcp", fmt.Sprintf(":%s", config.Cfg.AuthPort))
	if err != nil {
		log.Fatalf("failed to listen: %v", err)
	}

	s := grpc.NewServer()
	//пробрасываен информацию об апи наружу
	reflection.Register(s)
	desc.RegisterChatV1Server(s, &server{})

	log.Printf("server listening at %v", lis.Addr())

	if err = s.Serve(lis); err != nil {
		log.Fatalf("failed to serve: %v", err)
	}
}
