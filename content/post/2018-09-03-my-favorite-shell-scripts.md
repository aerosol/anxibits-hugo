---
layout: "post"
title: "My favorite shell scripts (part 1)"
date: "2018-09-03"
---

This is yet another "Linux Desktop is fun" post. 
Without further ado, let's cut to the chase. 

This will hopefully turn into a series of short
shell scripts I find somewhat amusing in my everyday computer life.

You can look them up [here](https://git.mtod.org/hq1/dotfiles/src/develop/silos/scripts/bin).

## Part 1: Activate single terminal instance, with single tmux session

This is the behaviour I wanted to emulate in [KDE Plasma](https://www.kde.org/plasma-desktop) after [leaving](http://localhost:1313/anxibits/post/2018-03-04-the-year-of-linux-desktop-part-1) the [iterm2](https://iterm2.com/) world.
My muscle memory likes <key>Meta + Esc</key> to bring up the Terminal. It's just
very effortless having your left thumb on the <key>CMD</key> (also known as <key>Meta</key>) with left pinky
reaching for <key>ESC</key>.

The combination should launch either a new instance or the already active one. 

Perhaps some Linux terminals/desktop
environments already implement that feature. I use [alacritty](https://github.com/jwilm/alacritty) on [Plasma](https://www.kde.org/plasma-desktop), because it
feels like the most responsive one (without scientific benchmarks, I admit). 

The default key shortcuts set up allowed me to spawn a new program instance every time the
keystroke was made.

Anyway, here we go:

<figure>
  <figcaption>File: actterm.sh</figcaption>
  <pre>
#!/usr/bin/env bash
TERMINAL=alacritty
WID=$(xdotool search $TERMINAL 2>/dev/null | sort | head -1)
if [ -z "$WID" ]
then 
    $TERMINAL -e tmux -u
else 
    xdotool windowactivate --sync $WID;
fi
</pre>
</figure>

### Dependencies

  - [`xdotool`](https://www.archlinux.org/packages/community/x86_64/xdotool/)
  - [`alacritty-git`](https://aur.archlinux.org/packages/alacritty-git/) (optional)
  - [`tmux`](https://www.archlinux.org/packages/community/x86_64/tmux/) (optional)

### Breakdown

`TERMINAL` is defined upfront. As far as the Desktop Environment is concerned,
it doesn't matter. We obtain X11 Window ID by using `xdotool` searching for the
particular `$TERMINAL` instance, sorting the results, so we can get somewhat
predictable ordering (a weak assumption that we'll always hit the oldest
instance). `head -n1` just takes the first one.

> **Trivia!** `xdotool` is capable of much more, make sure to check [`man xdotool`](https://www.semicomplete.com/projects/xdotool/) too!.

Having the non-existing Window ID, we just launch `$TERMINAL` making it execute `tmux -u` on
startup. The `-u` flag is helpful for enforcing unicode support within the
`tmux` session:

```
 -u   When starting, tmux looks for the LC_ALL, LC_CTYPE and LANG environment variables:
      if the first found contains ‘UTF-8’, then the terminal is assumed to support UTF-8.
      This is not always correct: the -u flag explicitly informs tmux that UTF-8 is sup‐
      ported.
```

Otherwise, we have an _existing_ Window ID. We use that to activate an existing
X11 window, bringing up an already opened Terminal, hoping for the `tmux`
session to be there. Worst case, we just launch `tmux` manually and pick a
session we wanted to get back to.

### DE Integration

That should be straight-forward to integrate with
Plasma Settings at this point, just don't forget 
to make the `actterm` script executable first.

![](images/terminal_shortcut_1.png)
![](images/terminal_shortcut_2.png)
