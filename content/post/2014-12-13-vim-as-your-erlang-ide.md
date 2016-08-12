---
layout: "post"
title: "Writing Erlang with vim"
date: "2014-12-13"
---

Did you know that there's a suite of vim plugins dedicated to Erlang
development making it, hands down, the best Erlang/OTP development environment?
Let me break it down for you.

> **Disclaimer** All vim plugins mentioned in this article
> come with documentation. Look it up in anything's unclear. Also feel free to
> ping me :)

## Documentation lookups

[thinca](https://github.com/thinca) who's one of my favorite plugin authors,
wrote the inconspicuous (due to the lack of `README`)
[vim-ref](https://github.com/thinca/vim-ref) plugin.

It integrates well with the excellent
[unite.vim](https://github.com/Shougo/unite.vim), my all time favorite, and
provides the user with remarkable experience of browsing docs for many open
source projects such as Clojure, Perl, PyDoc, manpages, and of course
Erlang/OTP.
Writing about unite is out of scope of this blog post, but I encourage you to
look for useful information [here](http://usevim.com/2013/06/19/unite/),
[here](http://bling.github.io/blog/2013/06/02/unite-dot-vim-the-plugin-you-didnt-know-you-need/) 
and [there](http://www.codeography.com/2013/06/17/replacing-all-the-things-with-unite-vim.html).

Here's a short demo of vim-ref for Erlang in action:

<script type="text/javascript" src="https://asciinema.org/a/14686.js"
id="asciicast-14686" async></script>

`vim-ref` is smart enough to bind my `K` (the default key for manpages lookup).
Additional settings I use:

```
let g:ref_use_vimproc = 1
let g:ref_open = 'split'
let g:ref_cache_dir = expand($TMP . '/vim_ref_cache/')
nno <leader>K :<C-u>Unite ref/erlang
            \ -vertical -default-action=split<CR>
```

## Get the errors as you save

[Csaba](https://github.com/hcs42) is my IRL friend and the main guy behind
[vim-erlang](http://vim-erlang.github.io/) project. He wrote the absolutely
amazing [vim-erlang-runtime](https://github.com/vim-erlang/vim-erlang-runtime)
and [vim-erlang-compiler](https://github.com/vim-erlang/vim-erlang-compiler)
plugins.
The former provides you with up to date, slick set of syntax highlithing rules,
while the latter delivers compilation errors (and warnings) straight to your list window.
Both plugins require zero configuration, just plug and play. Here's a sneak
peek:

<script type="text/javascript" src="https://asciinema.org/a/14687.js"
id="asciicast-14687" async></script>

## Jump between modules and symbols definitions

[vim-erlang-tags](https://github.com/vim-erlang/vim-erlang-tags) is another
must-have in our toolbelt. As you probably know, vim out of the box has
an excellent support for `ctags`. The problem with that is `ctags` doesn't care
about Erlang modules. So for instance, it can't really distinguish between
`foo:moo()` and `bar:moo()`.  

Csaba figured out a wondeful hack to overcome
this, and I took the opportunity to optimize its indexing speed (it still does take
a few seconds to generate the whole tag tree for Erlang/OTP distribution - [pull
requests are welcome!](https://github.com/vim-erlang/vim-erlang-tags/pulls)). 
Enjoy this little demo operating on R16B02 codebase:

<script type="text/javascript" src="https://asciinema.org/a/14688.js"
id="asciicast-14688" async></script>

As with the previous plugins, this one requires no extra configuration and will
work out of the box with your standard `ctags` bindings.

## tmux integration

One thing that was always making me Emacs-envy was its fine tuned integration
with all kinds of REPLs. Although, vim is way worse when it comes to
understanding LISPs (and understandning more than text in general, due to its
nature), vim users should be more than happy with using the vim-tmux combo,
that plays really well together.

[There are many vim tmux plugins](https://www.youtube.com/watch?v=2G551KpNnA0).
The one I chose after evaluating a few of them is
[tslime](https://github.com/sjl/tslime.vim) by [Steve
Losh](http://stevelosh.com/), since it requires no extra configuration and
provides a set of defaults that just work for me.

`tmux` is my daily-driver. I used to use iTerm2 but then ditched it for
standard OSX Terminal (for lolspeed) and `tmux` and I've been happy ever since,
especially with the marvelous [tmux-plugins suite](https://github.com/tmux-plugins). 

The way `tslime` works is it can send any input to a particular triple
of session/pane/window.

I use the default `C-c C-c` keybinding which works with visual selections as
well. It's emacsy - yes. I use [PFU
HHKB](http://www.pfu.fujitsu.com/hhkeyboard/) keyboard and it taught me that
Ctrl key's place is where the world thinks Caps Lock should be. Remapping your
Caps Lock to Ctrl is a game changer and I encourage you to try it. With OSX it's super easy:

![](http://i.imgur.com/MsW3Bgq.png)

Here's a quick demo of tmux/vim interaction with the Erlang shell:

<script type="text/javascript" src="https://asciinema.org/a/14690.js"
id="asciicast-14690" async></script>

## Templates / snippets

For quick snippets I decided to go with [neosnippet](https://github.com/Shougo/neosnippet.vim) 
by [The Dark Master of vim](https://github.com/Shougo) himself.

The only configuration tweaks I use are as follows:

```
let g:neosnippet#snippets_directory = expand($VIM . 'snippets')
let g:neosnippet#disable_runtime_snippets = {
            \   'erlang' : 1
            \ }
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)
```

I made a gist with [my Erlang
snippets](https://gist.github.com/aerosol/bc89457de5b873e840f3) if you're
interested. And this is how it works in practice:

<script type="text/javascript" src="https://asciinema.org/a/14693.js"
id="asciicast-14693" async></script>

## Other goodies worth mentioning

There are more helpful plugins when it comes to Erlang/OTP development. Make
sure you check out the following:

- [vim-erlang-omnicomplete](https://github.com/vim-erlang/vim-erlang-omnicomplete) is 
the Ctrl+Space of Java/.NET world visiting vim and erlang!
- [erlang-motions](https://github.com/edkolev/erlang-motions.vim) helps you
  navigate between function clauses and declarations quickly (within a single
module)

Happy hacking!

