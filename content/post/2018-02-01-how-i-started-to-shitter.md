---
layout: "post"
title: "How I started to Shitter"
date: "2018-01-02"
---

I've quit Twitter a while ago. I have a blog post draft outlining the reasons,
rationale and whatnot, but let's keep that for another occasion.

Today, I thought to myself that I really enjoyed shitposting rage tweets, such as
"fsck computers, they never work". It would be nice, to be able to do that from
the command line, while _owning_ the data at the same time. I never cared for
retweets, followers and all that jazz, so it seemed obvious that what I wanted
was a self-hosted microblog.

## Requirements

- command line interface
- self-hosted
- RSS (I don't use it, but let's assume my visitors do! Stuff is meant to be 
  public after all)

### Test case

```
$ mb "fsck computers, they never work"
```


## Prototype

I already own a simple webserver, the one you're interacting with, right now.

The most basic prototype I wrote was:

```
mb() {
  echo "Posting $1"
  ssh anxibits "echo \"$1<br/></hr><br/>\" >> /home/www/html/micro/index.html"
}
```

Obviously _you_ can't just `ssh anxibits`. I can, because I have an appropriate 
section in my `~/.ssh/config`:

```
Host anxibits
  User *******
  Port *******
  HostName ********
  IdentityFile ~/.ssh/*******
```

It's pretty much what I wanted, except it would be nice for shit posts to
appear ordered by the most recent ones. 

`>>` is appending and I wanted to prepend.
It turned out unnecessarily complicated at this point. And the RSS on top of
that, oh lord.

### Requirements

- command line interface
- self-hosted
- RSS
- ordered by latest

Suddenly, I came to realize that:

> I already own a simple webserver, the one you’re interacting with, right now.

The website you're looking at, already has RSS, is static, is equipped with all
the SSL quirks, and is powered by a static weblog generator, Hugo, that happens
to be written in golang. This is fine, because it takes care of the bits I'm
not really keen to implement on my own.

What I need right now is the ability to write shitpost files, integrate them
with my Hugo site, optionally commit,
[build and publish](https://github.com/aerosol/anxibits-hugo/blob/master/deploy.sh)
them. That's it.

So I came up with this:

```
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
```

I pushed some [random
bits](https://github.com/aerosol/anxibits-hugo/compare/4c484e1c214d3ad7320351b4df05ca76e5f8f303...master),
basically a trial & error series and got it running.

To make the initial test case work, we have to create a symbolic link to the script (or define an alias):

```
 ☛  master* ~/dev/anxibits-hugo $ ln -s /Users/hq1/dev/anxibits-hugo/micropost.sh /Users/hq1/bin/mb
 ☛  master* ~/dev/anxibits-hugo $ mb "hello blog post"
Writing /Users/hq1/bin/content/micro/1517532244.md
/Users/hq1/bin/mb: line 14: /Users/hq1/bin/content/micro/1517532244.md: No such file or directory
...
```

Oops! [StackOverflow to the
rescue](https://unix.stackexchange.com/questions/17499/get-path-of-current-script-when-executed-through-a-symlink) #noshame:

```
diff --git a/micropost.sh b/micropost.sh
index 05fa0a9..fe20872 100755
--- a/micropost.sh
+++ b/micropost.sh
@@ -6,7 +6,7 @@ fi
 
 D_POST=$(date +"%Y-%m-%d %H:%M:%S") # http://fuckinggodateformat.com/ what the fucking fuck
 D_PERMALINK=$(date +"%s")
-DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"
+DIR="$(dirname "$(readlink "$0")")"
 POST_FILE="$DIR/content/micro/$D_PERMALINK.md"
 
 echo "Writing $POST_FILE"
```

And after a few retries, I became a truly independent shit poster, as seen
[here](https://mtod.org/anxibits/micro/1517532722/) and
[here](https://mtod.org/anxibits/micro/).

```
 ☛  master-* ~/dev/anxibits-hugo $ mb "hello blog post"
Writing /Users/hq1/dev/anxibits-hugo/content/micro/1517532722.md
[master 291b603] Add 2018-02-02 01:52:02
 1 file changed, 4 insertions(+)
 create mode 100644 content/micro/1517532722.md
Started building sites ...
Built site for language en:
0 draft content
0 future content
0 expired content
13 pages created
0 non-page files copied
1 paginator pages created
0 tags created
0 categories created
total in 30 ms
building file list ... done
404.html
index.html
index.xml
sitemap.xml
micro/
micro/index.html
micro/index.xml
micro/1517526924/index.html
micro/1517527077/index.html
micro/1517527581/index.html
micro/1517527909/index.html
micro/1517532554/index.html
micro/1517532695/index.html
micro/1517532722/
micro/1517532722/index.html
page/1/index.html
post/index.html
post/index.xml
post/2014-12-12-little-known-fact-about-erlang-sys-config/index.html
post/2014-12-13-vim-as-your-erlang-ide/index.html
post/2015-01-26-uncommon-things-for-common-tests/index.html
post/2016-01-30-elixir-vs-erlang/index.html
post/2018-02-01-how-i-started-to-shitter/index.html
post/ideas-for-managing-passwords/index.html

sent 4073 bytes  received 1788 bytes  2344.40 bytes/sec
total size is 4905020  speedup is 836.89
```

I should probably delete the failed attempts -- this is as easy as removing
files from the git repo and hitting `./deploy.sh` again. `#wontfix`
