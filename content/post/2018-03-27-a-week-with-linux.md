---
layout: "post"
title: "Linux is in the house"
date: "2018-03-27"
---

> This is a continuation of my introductory vent.
> I briefly spoke about the motivations behind
> [switching from Mac OS to Linux full time](/anxibits/post/2018-03-04-the-year-of-linux-desktop-part-1/).
> Today, I'll try to describe all the gotchas and the surprises that really caught me off guard.

## The Hardware

The idea to get a PC was born once a friend showed me the iMac Pro press
release. That was the main trigger.
I really wanted all that machine had to offer, but I could not justify the price
and the quirks I knew were included.

I am a professional software developer. I'm not a rockstar by any means, yet,
I'm pretty sure top notch hardware/tools is something I just need to have in
order to get my job well done, just like everyone else investing dedication and care
in their craft.

The older I get, the more **freedom-factor matters to me**, too.
There is some truth to the meme, that with Apple, you don't own anything,
you just lease a computer and the OS.

"We all" laughed at Richard Stallman at some point. It turns out,
people need a [news story](https://duckduckgo.com/?q=facebook%20cambridge%20analytica) to validate their beliefs and wake the fuck up. 
And it turns out RMS was [mostly right](https://www.reddit.com/r/StallmanWasRight/).

I don't have any social media accounts anymore (ya, rly). I use isolated gmail
occasionally for work (with [Firefox containers](https://medium.com/firefox-test-pilot/firefox-containers-are-go-ed2e3533b6e3)) and every day I'm getting closer to
**The Glorious Internet Slow Food Nirvana**. I really appreciate the room for focus
and creativity it brings to the table.

I used to work on Macs for the past decade or so. I fell in love with Tiger
at first - it had just the _right_ defaults. It was downhill from there though.

**The time has come. I figured I want Linux at home. On a PC.**

I travel every quarter and that's the only time I really need a laptop, so
whatever mobile hardware I'll have, as long as I can `ssh dadcave`, I'm good.

After a few weeks of research, I finally got a pretty solid idea of what I wanted to go with.
A simplified decision map is as follows:

  - Threadripper processor

    - Not Intel. No known flaws ([that recent shit storm reads like stock-maniuplating attempt](https://www.theinquirer.net/inquirer/news/3028437/amd-ryzen-epyc-cpus-critical-flaws-linus-torvalds-fake)),
      no Spectre/Meltdown AFAIK, no random crashes. Not bad [reviews](https://duckduckgo.com/?q=threadripper+linux+review&t=ffab&ia=web) and [sexy benchmarks](https://www.phoronix.com/scan.php?page=article&item=ryzen-linux-10way&num=1) at Phoronix.

    - I considered Ryzen series first, but the faulty batch with parallel
      compilation segfaults made me anxious enough to pass on it. [People
      reported problems with Ryzen and Erlang](http://erlang.org/pipermail/erlang-questions/2018-January/094578.html)
      -- that was obviously a deal breaker for me.

    - For a few weeks I've been browsing reddit looking for [Threadripper and Linux](https://www.reddit.com/search?q=threadripper+linux&sort=new)
      hints and war stories. Found [amazing subreddits BTW](https://www.reddit.com/r/battlestations).

    - I did _want_ **many cores** to abuse the hell out of the Erlang VM SMP.
      Also to annoy friends with casual `htop` screenshots online, obviously.

        ![](images/dialyzer.png)

  - I did not care about the GPU. I'm not here to mine brocoins. Games?
    Bloodborne on PS4 is the game I'm going to play for the next year or two. I don't
    need to play games on my computer. I want to learn &amp; experiment on it.

    - Whatever is able to display 4k at 60Hz is great.
      I hope HiDPI on Linux works. I read [it's not that
      great](https://www.reddit.com/search?q=hidpi+linux&restrict_sr=&sort=new&t=all)

      - Your mileage may vary. But people mainly use laptops, aren't they?
        They also want to run everything under the sun, don't they?

      - I'm willing to take the risk.
        The real reason I stuck to Macs for so long, was the Retina re(s/v)olution.
        Crystal clear things I look at, at least 8h/day. Yeah. Need that.

    - I read online that AMD/Asus chips are usually a safe bet with Linux. Same goes for
      GPUs.

HiDPI was the biggest gamble for me. Luckily, all I need is a terminal and
some webapps I don't really get the right to choose (resource hungry
electron shit). I mainly play around with software, listen to music,
communicate with people I work with. That's it. I'm familiar with Linux,
I can surely imagine the pain I'm getting myself into. E.g. I don't expect drag
& drop to uniformly work everywhere and I realize that consistent keyboard
shortcuts across the whole system may be a pipe dream. I'll do my best to mitigate those issues.

I want to play it safe. I still keep my Macbook around, just in case.
It's dying, after 3 years of heavy usage. Let's have a minute of silence...
nope, can't have it, the fans are too loud.

I'll try to keep it alive until I'm fully transitioned to freedom.

I watched plenty of videos of people having fun [assembling their PCs](https://www.youtube.com/results?search_query=threadripper+build)
and [running Linux on Threadripper](https://www.youtube.com/results?search_query=threadripper+linux). 

That was pure unix porn. Yet, I don't think I trust myself enough to fiddle with $1k processor
and all its mechanical quirks (especially cooling - the last time I dug in
a PC was 15 or 20 years ago; pretty sure I'd underestimate the challenge
nowadays).

At this point, I was good to go. I did not care much about the case, the power
supply ("can I have a good one please?") etc. [PCPartPicker was insanely helpful
with their reviews and ratings](https://pcpartpicker.com/). You should check it out
if you're planning to build/get a PC. There's also [buildapc subreddit](https://www.reddit.com/r/buildapc/) too,
with tons of excellent data points.

## The Verdict

I went to a PC shop. They were insanely helpful with recommending me peripherals 
I had no true interest in (case, cooling etc.).  I told the consultant I'm not really into flashy LED
stuff, but I don't mind either. What I really need is to make sure everything fits
together, just works(TM) and **gives me plenty of space for future upgrades**.

To give you the idea - the assembly service was 80 PLN
which is a roughly an equivalent of 20 EUR. Yup, I'm down.

Now, the consultancy (aka "PC Genius" service) - I spent over two hours placing the final order,
discussing various aspects of the setup with a super friendly assistant.

The setup I eventually got is as follows:

  - **Display**: LG 27UD69P-4k - [search](https://duckduckgo.com/?q=+LG+27UD69P-4k&t=hh&ia=web)
  - **Processor**: Ryzen Threadripper 1920X - [search](https://duckduckgo.com/?q=Threadripper+1920X&t=hh&ia=web)
  - **Mobo**: X399 Aorus Gaming 7 - [search](https://duckduckgo.com/?q=aorus+gaming+7+x399&t=hh&ia=web)
  - **Case**: Corsair Crystal Series 570X RGB - [search](https://duckduckgo.com/?q=corsair+crystal+series+570x+rgb&t=hh&ia=web)
  - **Cooling**: Be Quiet! Silent Loop 360 water cooler - [search](https://duckduckgo.com/?q=silent+loop+360+&t=hh&ia=web)
  - **PSU**: Be Quiet! 750W Straight Power 11 - [search](https://duckduckgo.com/?q=750w+straight+power+11&t=hh&ia=web)
  - **RAM**: 16GB 3000MHz XPG Dazzle CL16 - [search](https://duckduckgo.com/?q=dazzle+xpg+cl16+16&t=hh&ia=web)
  - **GPU**: Radeon RX 560 EVO - [search](https://duckduckgo.com/?q=radeon+rx+560+evo&t=hh&ia=web)
  - **Disk**: Samsung SSD 250 960 EVO M.2 - [search](https://duckduckgo.com/?q=samsung+ssd+960+evo+m.2&t=hh&ia=web)

## The Gotchas

  - I had to wait over 30 days for the box to arrive for pick-up, assembled.

  - This thing is **large and heavy**. You better empty your trunk if you decide to follow my footsteps. Or
    get a home delivery service (I don't trust them much, so there's the empty
    trunk).

  - The PC was running almost flawlessly (`dmesg` was indicating some mysterious PCI BUS failures however).
    **Three days in, it shut down. Forever.** I naively suspected PSU failure, but
    was too scared to check on my own. Returned the god damned thing.

  - It took a warranty replacement (faulty GigaByte motherboard - `dmesg` did
    not lie to me) + reassembly. The box came back in after **extra 14 days**.

  - Summary: **I had to wait roughly 2 months** to get it up and running, stable.
    Incredibly frustrating, but I knew my only real alternative was to lease from
    the Apple store again -- a big "nope".

    ![](images/llama_nope.gif)

## The surprises

  - The setup **cost was comparable to a macbook pro**. And **~4x less than the iMac Pro**,
    easy. Hi 24 cores.

  - I was happily editing my `i3` config when the box shut down, out of the blue. It was late
    at night -- 1 or 2 am. I've sent an e-mail of disappointment to the consultant
    who recommended me the setup. That person replied 15 minutes later, assuring me about the
    replacement ETA. I really don't think people should be working stupid
    hours, but I have to say -- I very much appreciate the effort and responsiveness. Shout out to [x-kom](https://www.x-kom.pl/).

  - HiDPI was not a problem. I have a **retina linux**, hands down. Java apps
    probably won't scale and will look tiny or worse. I don't care at this point.

  - [Solus Budgie](https://solus-project.com/) -- my distro of choice -- worked out of the box.

    - In the meantime, I figured I don't really want a mac clone and
      [i3](https://i3wm.org/docs/userguide.html) is the right WM for me. I had to tweak
      a few things [here and there](https://git.mtod.org/hq1/dotfiles), but hey, after all - I had time (over 45 days)
      to read about the quirks online.

    - I've also spent many evenings, running
      Solus on a macbook, mainly due to boredom and
      frustration. **Having a "fake it till you break it" playground environment helped _a lot_**.
      Here I am editing this post, while downloading my Android photos via `rsync` over WiFi:



        ![](images/editing_linux_post.png)

  - I was ready for a _year_ of tweaking. Today I feel like I have a life time of tweaking ahead.
    I got a reasonable work flow setup (including
    all the must-haves such as Team Viewer, Slack, [hand-made Fastmail electron app](https://github.com/aerosol/fastmail-appimage) etc.)
    in a week or two. If there's any advice I can give, it's **you should really put your dotfiles on VCS** and make sure you can switch between platforms
    with little to no effort. What I do is:

      - work on a platform specific branch
      - use a `Makefile` that is a thin wrapper around [GNU Stow](https://www.gnu.org/software/stow/); that allows
        me to quickly deploy and retract configs without causing any damage

  - The only truly annoying Linux bug in Solus (or, more likely -- systemd) is, it won't start pulseaudio if I login too fast.
    I have to wait like 3 seconds before I type my password in and I'm good to go.
    **This is really the most annoying bug from all the bugs I've encountered thus far. I _really_ can live with that.**

  - I work remotely. **Sound quality is essential for calls**. We often spend 4-5 hours on a call when pair programming.
    [Apogee Mic 96k](http://www.apogeedigital.com/products/mic), that is, supposedly, a dedicated
    mac microphone, worked out of the box. So has the Steelseries mouse. I'm in awe.

    ![](images/dmesg_usb.png)

  - It looks awesome and makes my dad cave complete.

    ![](images/alien_krul.jpg)

    ![](images/krul.jpg)

## Summary

**Getting a good PC was not easy, but yet, the best decision ever.** My macbook feels like a fisher price toy now.
I'm having the time of my life working and learning at the same time.

Sure, things aren't as polished UX-wise as one would expect from a premium vendor.
But the thing is, you're really in control this time. 

And **open source enthusiasts are doing great job. Send them a love letter** or a tweet of appreciation if you're
into social media. I'll just keep looking forward to the new kernel/OS releases :-).

### To be continued

I have plenty of stuff queued up, that's potentially interesting:

  - making [HHKB](http://www.pfu.fujitsu.com/hhkeyboard/) work "as expected" on Linux, coming from a Mac Keyboard Layout; shortcuts like
    CMD+C/CMD+V mostly work system-wide when properly hacked. That's a good news, isn't it? But wait, there's more!
  - hacking Xorg/X11 - surprisingly there's not much to do in 2018 with distros like Solus, but (...)
  - [`tmux`](https://github.com/tmux/tmux/wiki) vs tiling window manager, and whether it
    does make sense to use both (yup!)
  - Linux and Multimedia, e.g. how to make screencasts, record songs, manage large photo libraries and all that complex stuff. I have to make
    sure I have a good understanding of pulseaudio vs ALSA first :-)
  - `systemd`. People hate it. Also, some don't. Let's find out!
  - Is Elxir compiler CPU-bound? Will it scale with Threadripper's SMP?
    ![](images/elixir.png)
  - The BIOS (UEFI). It's Sci-Fi these days, supports mouse, over
    the USB upgrades, mounting network disks and real-time charts. WTF happened to computers while I was gone?

  If you feel curious about any of the above, send me an e-mail. It's in the
  footer! `ps -out`.

