#!/usr/bin/env bash
if [ $# -eq 0 ]; then
    echo "No microblog contents provided"
    exit 1
fi

d_post=$(date +"%Y-%m-%d %H:%M:%S") # http://fuckinggodateformat.com/ what the fucking fuck
d_permalink=$(date +"%s")
cwd="$( cd "$( dirname "$0" )" && pwd )"

echo $d_post
echo $d_permalink
echo $cwd

cat > "$cwd/content/micro/${d_permalink}.md" << EOF
---
layout: "micro"
title: "$@"
date: "$d_post"
---
