#!/bin/bash
source utils/colors.sh

clear
color_echo "$BOLD$BLUE" "=== Habilidades e Tecnologias ==="
echo
color_echo "$CYAN" "Docker"
cat ascii/docker.txt
echo

color_echo "$CYAN" "Oracle - PL/SQL"
cat ascii/oracle.txt
echo

color_echo "$CYAN" "Linux"
cat ascii/linux.txt
echo

color_echo "$CYAN" "PHP"
cat ascii/php.txt
echo

color_echo "$CYAN" "AWS"
cat ascii/aws.txt
echo

color_echo "$CYAN" "Ansible"
cat ascii/ansible.txt
echo