get-deps:
	docker compose run --rm auth sh -c "go get -u google.golang.org/protobuf/cmd/protoc-gen-go \
										&& go get -u google.golang.org/grpc/cmd/protoc-gen-go-grpc \
										&& go get -u github.com/brianvoe/gofakeit"
	make move-vendor

logs:
	docker compose logs -f
up:
	docker compose up -d --build
down:
	docker compose down

migrate-up:
	docker compose exec auth sh -c  "migrate -path /app/migrations -database 'postgres://postgres:5432/app_db?sslmode=disable&user=app_user&password=password' up"
# make migrate-create create_table_users	
migrate-create:
	@docker compose exec auth sh -c  "migrate create -ext sql -dir migrations $(filter-out $@,$(MAKECMDGOALS))"
migrate-down:
	docker compose exec auth sh -c  "migrate -path /app/migrations -database \"postgres://postgres:5432/app_db?sslmode=disable&user=app_user&password=password\" down"

build:
	docker compose run --rm auth sh -c "go build -o ./bin/auth ./cmd/auth/main.go"
	# docker compose run --rm chat-server -c "go build -o ./bin/chat-server ./cmd/chat-server/"
	# docker compose run --rm chat-client sh -c "go build -o ./bin/chat-client ./cmd/chat-client/"
run:
	docker compose run --rm auth sh -c "go run ./cmd/auth/main.go"
	#docker compose run --rm auth sh -c "go run ./cmd/chat-server/main.go"
	#docker compose run --rm auth sh -c "go run ./cmd/chat-clien/main.go"

generate:
	make generate-api-user-v1
	make generate-api-chat-v1
generate-api-user-v1:
	mkdir -p pkg/auth/user_v1
	docker compose run --rm auth sh -c "protoc --proto_path=api/auth/user_v1 \
	--go_out=pkg/auth/user_v1 --go_opt=paths=source_relative \
	--go-grpc_out=pkg/auth/user_v1 --go-grpc_opt=paths=source_relative \
	api/auth/user_v1/user.proto"
generate-api-chat-v1:
	mkdir -p pkg/chat-server/chat_v1
	docker compose run --rm auth sh -c "protoc --proto_path=api/chat-server/chat_v1 \
	--go_out=pkg/chat-server/chat_v1 --go_opt=paths=source_relative \
	--go-grpc_out=pkg/chat-server/chat_v1 --go-grpc_opt=paths=source_relative \
	api/chat-server/chat_v1/chat.proto"

# make install github.com/sirupsen/logrus	
install:
	docker compose run --rm auth sh -c "go get -u $(filter-out $@,$(MAKECMDGOALS))"

move-vendor:
	docker compose run --rm auth sh -c "go mod vendor"

drop-all-container:
	docker network prune
	docker rm -f $$(docker ps -qa)

# to pass args to commands
%:
    @:  