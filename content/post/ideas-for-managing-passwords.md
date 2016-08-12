+++
date = "2016-06-15T22:21:29+02:00"
title = "Ideas for password management"
layout = "post"

+++

> **Disclaimer** I am not a security expert by any means.

Remembering passwords has been always a huge pain for me and storing them
(even in an encrypted form) always felt very vulnerable. After all, getting
access to the storage could lead to a massive leak. One master password,
private key, hardware -- to me, those are all single points of failure.

Back in 2011, I came across an HN thread with the idea of generating passwords
on demand, every time you need one, based on keys you store in your own,
mental memory (or a thought process, so you associate notions instead of actually
remembering terms). One could argue that's a single point of failure too (dementia
anyone?), but in my naive sense of security, I found the idea very appealing.

The idea is simple: you use HMAC along with a "target domain" and a secret scheme
of keys stored/produced in your head. As far as I understand, the strength of HMAC lies
in the length of the secret used, so that's something to keep in mind too.
The reason I'm mentioning keys in plural is, you can diversify the way of
building your secret, so:

 - it's not really obvious what the "target domain" is (can be <code>tumblr</code> for
   your cat pics and <code>000gmail.com</code> for things you care about)
 - you can associate "target domains" with categories/schemes to quickly find
   a mental path to the key you're looking for (<code>whatever123</code> vs
   <code>i very much care about cats</code>)
 - you are free to add *anything you like* to the generated final password and
   that's yet another random and unpredictable key in the pool. It's obviously
   easier to remember a way to figure out the keys, than to remember the
   passwords you frequently use.

The next step is to build a generator that produces passwords having all
the properties that comply with the odd requirements most sites enforce.
And more, it's really up to you.

Based on the comments I found in the mentioned HN thread, I took a stab at
writing such generator. You can check out the source [here](https://github.com/aerosol/Passy/blob/master/passy.py).

For the sake of clarity, I use a slightly modified version, but mind your own business :-),
the principle stays the same.

The utility is simple -- it prompts you for the target domain and a password
(being your secret, diversified HMAC key) and writes the target password to the
standard output. 

With `p() { passy "$*" | pbcopy; }` function in your <code>.zshrc</code> you
can:

```
$  p foo.com
Password: <bar>
```

and <code>QhhRuvC@RSGZS@:dY:KX^,S,%+Kn^:X`G:rg</code> lands in your
clipboard.  Append it with <code>hurr durr</code> and you've got a pretty
strong password.

Of course this particular implementation has its flaws, for instance:

 - it leaves a trace in your shell history (unless you prepend the call with a
   space -- at least in zsh; see the shell snippet above).
 - it's not cross-platform (in this case it depends on shell/python
   runtime -- on mobile you really have to go the extra mile)
 - it's vulnerable to keyloggers
 - etc.

The pros, on the other hand:

 - it's completely custom (don't get me wrong, do not roll your own crypto)
   -- it is nearly impossible to guess what generator is in use
 - nothing is persisted

So as long as someone's not holding a gun to your head, maybe give this a shot.
