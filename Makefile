.PHONY: install build test run clean deploy monitor

# Variables
NODE_ENV ?= development
DOCKER_IMAGE = zilla-dam:latest
DOCKER_COMPOSE = docker-compose

# Installation
install:
	npm install
	pip3 install -r requirements.txt

install-dev: install
	npm install --save-dev

# Building
build:
	npm run build

build-docker:
	$(DOCKER_COMPOSE) build

# Testing
test:
	npm test
	python3 -m pytest tests/

test-coverage:
	npm run test:coverage
	python3 -m pytest --cov=core tests/

# Running
run:
	node main.js

run-dev:
	npm run dev

run-docker:
	$(DOCKER_COMPOSE) up -d

run-docker-dev:
	$(DOCKER_COMPOSE) -f docker-compose.dev.yml up -d

# Database
db-migrate:
	node database/migrate.js

db-seed:
	node database/seed.js

db-reset: db-clean db-migrate db-seed

db-clean:
	rm -f data/zilla.db

# Monitoring
monitor:
	$(DOCKER_COMPOSE) up -d monitoring
	open http://localhost:9090

logs:
	$(DOCKER_COMPOSE) logs -f zilla-dam

# Deployment
deploy: test build-docker
	$(DOCKER_COMPOSE) up -d --force-recreate

deploy-prod:
	$(DOCKER_COMPOSE) -f docker-compose.prod.yml up -d --force-recreate

# Cleanup
clean:
	rm -rf node_modules
	rm -rf __pycache__
	rm -rf *.log
	$(DOCKER_COMPOSE) down -v

clean-all: clean
	docker system prune -f

# Security
security-scan:
	npm audit
	bandit -r core/ml/
	safety check

# Performance
profile:
	node --prof main.js
	node --prof-process isolate-*.log > profile.txt

profile-memory:
	node --inspect --trace-gc main.js

benchmark:
	npm run benchmark

# Backup
backup:
	tar -czf backup-$(shell date +%Y%m%d).tar.gz data/ logs/ config/

# Help
help:
	@echo "Available targets:"
	@echo "  install      - Install dependencies"
	@echo "  build        - Build the application"
	@echo "  test         - Run tests"
	@echo "  run          - Run application"
	@echo "  deploy       - Deploy with Docker"
	@echo "  monitor      - Start monitoring"
	@echo "  clean        - Clean up"
	@echo "  security-scan - Security audit"
	@echo "  profile      - Performance profiling"
