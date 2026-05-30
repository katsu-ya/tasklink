up:
	docker compose up

down:
	docker compose down

build:
	docker compose build

migrate:
	docker compose run web rails db:migrate

dbcreate:
	docker compose run web rails db:create

logs:
	docker compose logs -f web

security:
	docker compose run web bundle exec brakeman
