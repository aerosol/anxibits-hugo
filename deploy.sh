#!/usr/bin/env bash
hugo && rsync -avz -e ssh ./public/ anxibits:/home/www/html/anxibits
