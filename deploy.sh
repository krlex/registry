#!/bin/env bash

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
  htpasswd -Bc ./auth/htpasswd admin
}

deployment(){
  docker-compose up -d
}

nginx(){
  cp ./nginx/config.conf /etc/nginx/config.d/regestry.example.com.conf
}

docker_init
generate_key
deployment
nginx
