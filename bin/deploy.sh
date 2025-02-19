#!/bin/env bash

export BIN_DIR=`dirname $0`
export PROJECT_ENV="${BIN_DIR}/../"
if [ "$EUID" -ne 0 ]; then
    echo "This script requires sudo privileges. Please run with sudo."
    exit 1
fi

# Load variables from .env file
if [ -f .env ]; then
    export $(cat .env | xargs)
fi

docker_init(){
  # Function to check if a command is available
  command_exists() {
      command -v "$1" >/dev/null 2>&1
  }
  
  # Check if Docker is installed
  if ! command_exists docker; then
      echo "Docker is not installed. Installing Docker..."
  
      # Install Docker
      curl -fsSL https://get.docker.com -o get-docker.sh
      sudo sh get-docker.sh
      rm get-docker.sh
  
      echo "Docker installed successfully."
  else
      echo "Docker is already installed."
  fi
  
  # Check if Docker Compose is installed
  if ! command_exists docker-compose; then
      echo "Docker Compose is not installed. Installing Docker Compose..."
  
      # Install Docker Compose
      sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
      sudo chmod +x /usr/local/bin/docker-compose
  
      echo "Docker Compose installed successfully."
  else
      echo "Docker Compose is already installed."
  fi
}


generate_key(){
  # Check if htpasswd is installed
  if ! command_exists htpasswd; then
      echo "htpasswd is not installed. Installing apache2-utils..."
      sudo apt update
      sudo apt install -y apache2-utils
      echo "htpasswd installed successfully."
  else
      echo "htpasswd is already installed."
  fi

  htpasswd -Bc ./auth/htpasswd admin
}

deployment(){
  docker-compose up -d
}

docker_init
generate_key
deployment
