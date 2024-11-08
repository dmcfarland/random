make setup:
	curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh
	brew bundle install

run-mongo:
	dotenvx run -- cargo run --bin query-mongo

run-simple-api:
	dotenvx run -- cargo run --bin simple-api

docker-run:
	@trap 'docker rm -f simple-api  2>/dev/null' EXIT SIGTERM SIGINT; \
	gum spin --spinner dot --show-error --title "Building..." -- docker buildx build -q -t simple-api:latest .; \
	docker run -t -p 3300:3000 --env-file .env --name simple-api --rm simple-api:latest

run-k6-requests:
	k6 run --vus 70 --duration 30s k6-simple-request.js
