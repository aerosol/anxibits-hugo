#!/usr/bin/env bash
if [ $# -eq 0 ]; then
    echo "No microblog contents provided"
    exit 1
fi

D_POST=$(date +"%Y-%m-%d %H:%M:%S") # http://fuckinggodateformat.com/ what the fucking fuck
D_PERMALINK=$(date +"%s")
DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"
POST_FILE="$DIR/content/micro/$D_PERMALINK.md"

echo "Writing $POST_FILE"

cat > "$POST_FILE" << EOF
---
layout: "micro"
title: "$@"
---
EOF

git add $POST_FILE
git commit $POST_FILE -m "Add $D_POST"
./deploy.sh
