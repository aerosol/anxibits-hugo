---
layout: "post"
title: "Kobo/Wallabag - A Self-Hosted Read Later Service"
date: "2018-04-23"
---

## Swindle

It's been almost a year since I've chosen [Kobo Aura ONE](https://us.kobobooks.com/products/kobo-aura-one)
for my ancient Kindle replacement.

I think it's cute that people refer to it as Swindle.

To quickly list all the pros:

  - It's reasonably priced in comparison to Kindle Oasis

  - It has a large screen capable of displaying technical books (code snippets
    mainly) in a way that doesn't make me want to hurt myself

  - There's this sweet orange backlight that really does make a difference
    for bedtime reading

  - As it turns out - it's hackable!

  - Bonus: it's waterproof. Yeah, couldn't care less.

  - Bonus: it's not Amazon! I'm OK with that.

## But wat is Read Later

I don't really have the mental capacity to read books on a regular basis these days.
One day, when the kids become self-hosted themselves I hope to revisit that part of my existence.

What I am capable of reading though, are the articles I keep stumbling upon on the web,
whether it's casual mobile browsing or links people share on Signal (obviously
not WhatsApp!). A `2..25` minutes read, on average, before I pass out.

This is where Kobo comes in. It has truly excellent Pocket integration out of the box
(so does Firefox). **But** that may be somewhat controversial:

  - Pocket is baked into Firefox (you can disable it in
`about:config` by setting `extensions.pocket.enabled;false`)

  - It does show ads

  - It's not open-source

How about "we can do better"?

## The Service

[Wallabag](https://wallabag.org/) is a glorious PHP joint written with the following motto in mind:

> Save and classify articles. Read them later. Freely

It provides a well crafted API, [a hosted version if you wish](https://www.wallabag.it/en), does seem to care about your
privacy and has mobile clients ready to use.

It looks decent too:

![](images/bag-preview.png)

The [Android version](https://play.google.com/store/apps/details?id=fr.gaulupeau.apps.InThePoche) worked without any drama:


![](images/bag-preview-android.png)

And then, there's
[`wallabako`](https://gitlab.com/anarcat/wallabako) ([mirror here](https://git.mtod.org/hq1/wallabako-mirror))
that exploits the fact that [Kobo firmware lets you install arbitrary Linux programs
by uploading a `KoboRoot.tgz` archive directly via USB](https://wiki.mobileread.com/wiki/Kobo_Touch_Hacking).

The trick is, you upload that snowflake file, it gets extracted on device restart,
the services get up (hopefully) and the original file gets deleted.

I'm not sure yet how to debug/develop those yet, but I'm hoping to explore
that aspect as I go.

## Integrate!

Here are the steps I took to get it running, end to end:

  - Get a VPS. 1GB RAM, 1 CPU DigitalOcean plan works for me ($5/mo). You're free to pick your poison.
    I'm running it on the server that just sent you the page you're currently
    reading.

  - Install Docker and `docker-compose` unless you feel like spending a whole
    day, messing around with PHP modules configuration. [Alternative
    installation methods are properly documented](https://doc.wallabag.org/).

  - Get a LetsEncrypt certificate for the (sub)domain of choice.

Run the following `docker-compose.yml` with `docker-compose up`:

<figure>
  <figcaption>File: docker-compose.yml</figcaption>
  <pre>
version: '3'
services:
  wallabag:
    image: wallabag/wallabag
    restart: always
    environment:
      - SYMFONY__ENV__DOMAIN_NAME=https://{bag.example.com}
    ports:
      - "8881:80"
    volumes:
      - /opt/wallabag/images:/var/www/wallabag/web/assets/images
      - /opt/wallabag/data:/var/www/wallabag/data
  </pre>
</figure>

This means we'll be running a container, built on top of `wallabag/wallabag`
dockerhub entry, forwarding all the local TCP traffic on port 8881 to the container's
80. We do want to the restart the service, whenever it goes down, and mount the
volumes, so we get some data persistence across restarts.

Keep in mind to replace `{bag.example.com}` with your own domain,
leaving out the curly braces on replace, so e.g. `{bar.example.com}` becomes
`bag.yourdomain.org`.

Next, configure your nginx enabled site with the following:

<figure>
  <figcaption>File: /etc/nginx/sites-available/bar.example.com.conf</figcaption>
  <pre>
server {
  listen 80;
  server_name {bag.example.com};
  return 301 https://$host$request_uri;
}

server {
  listen 443;
  server_name {bag.example.com};

  ssl on;
  ssl_certificate /etc/letsencrypt/live/{bag.example.com}/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/{bag.example.com}/privkey.pem;

  location / {
    proxy_pass http://localhost:8881;
    proxy_set_header X-Forwarded-Host $server_name;
    proxy_set_header X-Forwarded-Proto https;
    proxy_set_header X-Forwarded-For $remote_addr;
  }

  root /var/www/html;

  location ~ /.well-known {
      allow all;
  }
}
</pre>
</figure>

That config will be polite enough to redirect all your plain HTTP requests to
the SSL-driven instance.

![](https://media.giphy.com/media/l0HTYUmU67pLWv1a8/giphy.gif)

The `well-known` and `root` directives are useful for verifying _you_ own the SSL
certificate.

If all goes well, you should end up having a service preview running against sqlite.
Which should be fine if you're a lone wolf user, like me.

Verify your installation by visiting `https://{bag.example.com}`, using
`wallabag` as your initial credentials, for both user name and password.

Configure further at will.

You're now free to install it as a systemd service; it seems that the
most recent versions of `docker-compose` let you do that with `docker-compose up --no-start`,
but who knows really. If it does respond via HTTP(S), we're good for now.

### Time to patch the Kobo!

[anarcat](https://gitlab.com/anarcat) did an excellent job documenting the
usage. To quote the [README](https://git.mtod.org/hq1/wallabako-mirror#download-and-install),
all you need to do is:

  > - connect your reader to your computer with a USB cable

  > - download the latest KoboRoot.tgz

  > - save the file in the .kobo directory of your e-reader

  > - create the configuration file as explained in the configuration section

  > - disconnect the reader

#### Time to complain!

It really works. I mean it. I used
[Wallabagger](https://addons.mozilla.org/en-US/firefox/addon/wallabagger/) to
bookmark a *random* :triumph: article from the site you're looking at:

![](images/bag-preview-kobo.png)

But...

### Ah Yes, The Gotchas

  - the service itself is really slow. Perhaps I got used to some ridiculous
    standards recently, but yeah... it takes a good 10-20 seconds for the clients to
    catch up properly.

  - The Wallabag Articles are not "Articles" as Kobo sees it. They're books.
    This is fine. Kind of. Unless you got really comfortable with the Pocket
    integration. I wonder, if one could change that by making Kobo see wallabag
    entries through a Pocket API impostor?

  - The new firmware patch doesn't _always_ properly catch up. Or it's just slow.
    I need to debug that and get a meaningful report.
