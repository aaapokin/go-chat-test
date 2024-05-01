package main

import (
	"context"
	"fmt"
	"github.com/brianvoe/gofakeit"
	"github.com/saitdarom/go-chat-test/config"
	desc "github.com/saitdarom/go-chat-test/pkg/auth/user_v1"
	"google.golang.org/grpc"
	"google.golang.org/grpc/reflection"
	"google.golang.org/protobuf/types/known/timestamppb"
	"log"
	"net"
)

//var configPath string

// func init() {
// 	flag.StringVar(&configPath, "path", "config/.env", "path to env")
// }

type server struct {
	desc.UnimplementedUserV1Server
}

func (s *server) Get(ctx context.Context, req *desc.GetRequest) (*desc.GetResponse, error) {
	log.Printf("Note id: %d", req.GetId())

	return &desc.GetResponse{
		Note: &desc.User{
			Id: req.GetId(),
			Info: &desc.UserInfo{
				Name:     gofakeit.BeerName(),
				Email:    gofakeit.Email(),
				Password: "pass",
				Role:     desc.Role_ADMIN,
			},
			CreatedAt: timestamppb.New(gofakeit.Date()),
			UpdatedAt: timestamppb.New(gofakeit.Date()),
		},
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
	desc.RegisterUserV1Server(s, &server{})

	log.Printf("server listening at %v", lis.Addr())

	if err = s.Serve(lis); err != nil {
		log.Fatalf("failed to serve: %v", err)
	}
}
