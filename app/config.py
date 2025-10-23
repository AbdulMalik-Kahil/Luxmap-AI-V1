"""
Configuration for ADK Agent Engine Deployment

Handles all environment loading and Vertex AI initialization for your agent.
"""

import os
from dataclasses import dataclass
from pathlib import Path
import google.auth
import vertexai
from dotenv import load_dotenv


# =============================================================================
# STEP 1: Load Environment Variables
# =============================================================================

def load_environment_variables() -> None:
    """Load environment variables from .env file if present."""
    env_file = Path(__file__).parent / ".env"
    if env_file.exists():
        load_dotenv(env_file)


# =============================================================================
# STEP 2: Agent Configuration (for deployment)
# =============================================================================

@dataclass
class AgentConfiguration:
    """Core configuration for your AI agent deployment."""

    model: str = os.environ.get("MODEL", "gemini-2.5-flash")
    deployment_name: str = os.environ.get("AGENT_NAME", "luxmap")
    project_id: str | None = None
    location: str = os.environ.get("GOOGLE_CLOUD_LOCATION", "us-central1")
    staging_bucket: str | None = None

    def __post_init__(self) -> None:
        """Load required settings and initialize defaults."""
        load_environment_variables()

        # Google Cloud project
        self.project_id = os.environ.get("GOOGLE_CLOUD_PROJECT")
        if not self.project_id:
            _, self.project_id = google.auth.default()

        # Vertex AI bucket
        self.staging_bucket = os.environ.get("GOOGLE_CLOUD_STAGING_BUCKET")

    @property
    def internal_agent_name(self) -> str:
        """Convert deployment name to a valid identifier."""
        name = self.deployment_name.replace("-", "_")
        if not name[0].isalpha() and name[0] != "_":
            name = f"agent_{name}"
        return name


# =============================================================================
# STEP 3: Research Configuration (for agent logic)
# =============================================================================

@dataclass
class ResearchConfiguration:
    """Configuration for research-related models and parameters."""

    critic_model: str = "gemini-2.5-pro"
    worker_model: str = "gemini-2.5-flash"
    max_search_iterations: int = 5


# =============================================================================
# STEP 4: Initialize Vertex AI
# =============================================================================

def initialize_vertex_ai(config: AgentConfiguration) -> None:
    """Initialize Vertex AI using provided configuration."""
    vertexai.init(
        project=config.project_id,
        location=config.location,
        staging_bucket=config.staging_bucket,
    )


# =============================================================================
# STEP 5: Create and Initialize Configurations
# =============================================================================

# Create agent config for deployment
agent_config = AgentConfiguration()

# Create research config for agent logic
config = ResearchConfiguration()  # <-- هذا هو المتغير الذي يستخدمه agent.py

# Initialize Vertex AI
initialize_vertex_ai(agent_config)