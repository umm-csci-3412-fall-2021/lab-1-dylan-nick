#!/bin/bash


for file in var/log/*
do
	awk 'match($0, /(.*Failed password for ([a-zA-Z]+ )+([0-9]+\.)+[0-9]+)/, groups) {print groups[1]}' $file
done
