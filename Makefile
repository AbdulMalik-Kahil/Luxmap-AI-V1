# ==============================================================================
# Installation & Setup
# ==============================================================================

# Install dependencies using uv package manager
install:
	@command -v uv >/dev/null 2>&1 || { echo "uv is not installed. Installing uv..."; curl -LsSf https://astral.sh/uv/0.8.13/install.sh | sh; source $HOME/.local/bin/env; }
	uv sync --dev

# ==============================================================================
# Playground Targets
# ==============================================================================

# Launch local dev playground
playground:
	@echo "==============================================================================="
	@echo "| 🚀 Starting your agent playground...                                        |"
	@echo "|                                                                             |"
	@echo "| 💡 Try asking: What's the weather in San Francisco?                         |"
	@echo "|                                                                             |"
	@echo "| 🔍 IMPORTANT: Select the 'app' folder to interact with your agent.          |"
	@echo "==============================================================================="
	uv run adk web . --port 8501 --reload_agents

# ==============================================================================
# Backend Deployment Targets
# ==============================================================================

# Deploy the agent remotely
backend:
	# Export dependencies to requirements file using uv export.
	uv export --no-hashes --no-header --no-dev --no-emit-project --no-annotate > .requirements.txt 2>/dev/null || \
	uv export --no-hashes --no-header --no-dev --no-emit-project > .requirements.txt && uv run app/agent_engine_app.py


# ==============================================================================
# Infrastructure Setup
# ==============================================================================

# Set up development environment resources using Terraform
setup-dev-env:
	PROJECT_ID=$$(gcloud config get-value project) && \
	(cd deployment/terraform/dev && terraform init && terraform apply --var-file vars/env.tfvars --var dev_project_id=$$PROJECT_ID --auto-approve)

# ==============================================================================
# Testing & Code Quality
# ==============================================================================

# Run unit and integration tests
test:
	uv run pytest tests/unit && uv run pytest tests/integration

# Run code quality checks (codespell, ruff, mypy)
lint:
	uv sync --dev --extra lint
	uv run codespell
	uv run ruff check . --diff
	uv run ruff format . --check --diff
	uv run mypy .


#   أولاً اقتل العمليات القديمة ثم نفذ امر التشغيل(dev امر تشغيل)
# pkill -f uvicorn
# pkill -f adk
# sleep 2
dev:
	make dev-backend & make dev-frontend

dev-backend:
	uv run adk api_server app --allow_origins="*"

dev-frontend:
	npm --prefix frontend run dev


# dev:
# 	make dev-backend & make dev-frontend


# dev-backend:
# 	uv run adk api_server app --allow_origins="*"

# dev-frontend:
# 	npm --prefix nextjs run dev

# cd "/Users/abdulmalikkahil/Me/luxmap-ai/nextjs" اولا ندخل لهنا

#A npm install :ثانيا نثبت الحزم
# او Or
#B npm install --legacy-peer-deps

# npm run dev ثم نضغط  على الامر


