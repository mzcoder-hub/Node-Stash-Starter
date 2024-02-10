#!/bin/bash

# Path: command/avail-clash-of-challenge/madara-cli/command.sh

sudo apt install -y git-all

# Install Rust using rustup

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

expect "1) Proceed with installation (default)"
send -- "1\r"
expect eof

# Source .bashrc to make rustup available in the current shell session

source "$HOME/.cargo/env"

# Install the latest stable version of Docker

# Add Docker's official GPG key:
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo docker run hello-world

sudo apt update -y
sudo apt upgrade -y
sudo apt install -y build-essential

sudo apt install -y pkg-config
sudo apt install -y libssl-dev
sudo apt install -y clang
sudo apt install -y protobuf-compiler

# Clone the repository

git clone https://github.com/karnotxyz/madara-cli

cd madara-cli

# Install dependencies

cargo build --release

# Run the CLI

./target/release/madara init

echo "You can make or edit the seed and wallet in the ~/.madara/app-chains/name-yourappchain/da-config.js directory."

echo "You can use './target/release/madara run' to start the appchain."

