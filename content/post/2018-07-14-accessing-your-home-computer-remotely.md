---
layout: "post"
title: "Accessing your home computer remotely (now, months with Linux)"
date: "2018-07-14"
---

## The Utopia

Remote work is all about not caring too much about your physical location. As
long as there is no background noise, you should be able to work from anywhere.

The reality of course has its ways of verifying the utopian claims, one of the
most brutal ones being a shitty internet connection in some random middle of
nowhere.

One of the most enlightening realisations I recently got was: 

> the fact that I work remotely is the only reason I need a laptop. 

Otherwise all the work is done **[at home](/anxibits/post/2018-03-27-a-week-with-linux/)**.

## Different strokes for different folks

I'm still on Linux and I'm definitely not looking back, however the initial excitement.
But, the very first desire of having everything
carefully tailored and configured by hand is gone now. I realised, i3's minimalism was not for me
(despite being truly entertaining!),
because I couldn't really get a decent workflow with it. I've switched to bleeding edge
[KDE (Plasma)](https://kde.org), since it resembles macOS in many ways,
and it has been so stable ever since, it became boring. A truly rewarding and
calm experience, despite getting tons of updates **every day**.

BTW I use [Arch](https://archlinux.org) now :joy:. [It's a well established
meme in case you did not know](https://duckduckgo.com/?q=i+use+arch+btw&t=ffab&ia=web).


## Let's define the problem

Having this big, powerful and hardened unit at home, really makes you
wonder what are the best patterns of accessing it efficiently when travelling
to _very_ random locations.

The most basic use case is: You want to be able to access your home machine no
matter the ISP changing your home router's IP address as they please.

The main quirk is: the connection may drop at any time and all your work is suddenly lost,
so some fault-tolerance steps need to be taken.

### Run your own domain and your own dynamic DNS

First, you need to build your own dynamic DNS, given, whoever
has your domain, provides you with an interface to modify the records.

#### Your own dynamic DNS

I keep my stuff on DigitalOcean and they have not failed me yet. And this is
what my Linux machine runs every **interval**:

```
#!/usr/bin/env bash
domain=$YOUR_DOMAIN
record=$RECORD_ID # get id with https://api.digitalocean.com/v2/domains/$domain/records
api_key=$DO_API_KEY
ip="$(curl -s https://mtod.org/ip)"
echo content="$(curl \
        -s \
        -k \
        -H "Authorization: Bearer $api_key" \
        -H "Content-Type: application/json" \
        -d '{"data": "'"$ip"'"}' \
-X PUT "https://api.digitalocean.com/v2/domains/$domain/records/$record")"
```

In essence, Having _some_ DNS interface, update the `A` record on regular basis.

There are several ways to make it run on Linux on a regular basis. One is a cron job. But it
seems that this is getting replaced with systemd timers. They work in similar
ways and I can't really recommend anything here - it's whatever works on your OS.

#### Your own what's my ip

The interesting bit about the snippet above is the fact of hosting "what's my IP"
service on your own, so that you don't rely on any third-party.

It turns out, that it can be done in a very slick manner using plain nginx.
I run one already to serve this site, so I don't mind an extra configuration
section. The following curl call:

```
ip="$(curl -s https://mtod.org/ip)"
```

hits my nginx at:

```
location /ip {
        add_header content-type text/plain;
        return 200 '$remote_addr\n';
}
```

That's it. [Your own, super-elegant "what's my IP" service](https://mtod.org/ip).

#### Your own router rules

OK. We have some (sub)domain that points at our home router's public IP
address, dynamically. Almost there.

The router needs a forwarding rule, so it can redirect the traffic coming at
port `XXXX` to a local subnet IP. This is pretty straight forward to achieve:

##### Set a static LAN IP for your home computer (e.g. `192.168.0.42`)

  - Consult the [glorious wiki](https://wiki.archlinux.org/index.php/Dhcpcd)
    if in doubt

  - Make sure you're not mistaking dhcp**cd** with dhcp**d**, the former is is a
    client, while the latter is a DHCP server deamon. It's mad easy to make a typo and remain confused for hours. 
    This is especially try for [configuring your network](https://wiki.archlinux.org/index.php/Network_configuration).

##### Run `sshd` service on your home computer.

   - Make sure that only public key authentication is allowed and no root login is permitted.

   - You can leave the standard port intact.

##### Set up a router rule that forwards the traffic from `XXXX` TCP port to `192.168.0.42:22`.

   - This highly depends on your router's interface, but you'll figure it out.

### Configure your local SSH client

I assume you already know how to set up a proper key-based authentication.
Now it's time for the client. OpenSSH offers a wide variety of configuration
options to make your everyday struggle a bit less of a struggle.

The end-game is to be able to type something like `ssh yharnam` to access your
machine from anywhere, no matter the internal configuration details.

To do that, make sure a similar entry lands in your `~/.ssh/config`:

```
Host yharnam
  User yourusername
  Port 66666
  HostName yharnam.example.com
  LocalForward 4000 localhost:4000 # if you'd like to develop phoenix apps remotely
  LocalForward 1313 localhost:1313 # if you'd like to write hugo blog posts remotely
  LocalForward 5432 localhost:5432 # if you'd like to access a postgres instance remotely
  # ....
```

Port forwarding over SSH is a godsend. In a nutshell: you can work on your remote dumb laptop
and access the application server at `http://localhost:4000`. Same goes for
postgres, or any TCP service socket.

For local access (laptop within the same LAN) I use a slightly different
config:

```
Host yharnam.local
  # ...
  Port 22
  HostName 192.168.0.20
  # .... 
```

### Get ready for connection breakages

Fault-tolerance bit is a tricky one.

You have to optimize for two scenarios, namely:

#### 1. The connection drops out of a sudden

This is relatively simple to address. Having the following in your shell
rc, ensures you always create or attach to a single tmux session
when using SSH (I keep that in `.zshrc`):

```
if [[ -z "$TMUX" ]] && [ "$SSH_CONNECTION" != "" ]; then
	tmux attach-session -t ssh_tmux || tmux new-session -s ssh_tmux
fi
```

#### 2. The connection lags so much, you procrastinate trying to watch stand ups on YouTube

Yeah, they never load, making the lags even worse.

That made me think of [`mosh`](https://mosh.org/). It's truly great at
making 2g/3g connection ssh experience mainly pleasant.

You need to have it installed on the server (your home machine) as well as the client
(laptop), and make sure UDP ports in range 60001-60999 are open and forwarded
at your home router. 

The installation is simple, `brew install mosh` and `pacman -Sy mosh` did the
job for me.

Unfortunately there's a caveat with `mosh`: SSH port forwarding doesn't
work. If you feel powerful enough to fix it, there's a bounty at https://github.com/mobile-shell/mosh/issues/337
