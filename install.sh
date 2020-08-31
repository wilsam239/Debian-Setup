#!/bin/bash

sudo apt update
sudo apt upgrade

# -- Languages -- #

# Java
sudo apt install openjdk-8-jdk
# Python3
sudo apt install python3.8
sudo apt install python3-pip
# C... etc
sudo apt install build-essential

# Node
sudo apt install nodejs
sudo apt install npm 

# Curl
sudo apt install curl

# Git
sudo apt-get install git


# Snap
sudo apt install snapd

# Apps from snap
sudo snap install discord
sudo snap install firefox
sudo snap install sublime-text --classic
# Visual Studio Code
sudo snap install code --classic