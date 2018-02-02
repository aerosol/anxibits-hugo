#!/usr/bin/env bash
if [ $# -eq 0 ]; then
    echo "Post pls:"
    read POST_CONTENTS
else
    POST_CONTENTS=$@
fi

D_POST=$(date +"%Y-%m-%d %H:%M:%S") # http://fuckinggodateformat.com/ what the fucking fuck
D_PERMALINK=$(date +"%s")
DIR="$(dirname "$(readlink "$0")")"
POST_FILE="$DIR/content/micro/$D_PERMALINK.md"

echo "Writing $POST_FILE"

cat > "$POST_FILE" << EOF
---
layout: "micro"
timestamp: "$D_PERMALINK"
---
$POST_CONTENTS
EOF

cd $DIR
git add $POST_FILE && git commit $POST_FILE -m "Add $POST_FILE" && ./deploy.sh
cd -
