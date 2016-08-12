---
layout: "post"
title: "Elixir vs Erlang"
date: "2016-01-30"
---

A friend of mine who is learning Elixir asked me how I would write a function
that takes a length `n` and a char `c` to build a string consisting of `n`
chars `c`.

Firing up `iex` and messing around with it brings me up to the conclusion - easy:

```elixir
Stream.repeatedly(fn -> "-" end) |> Stream.take(10) |> Enum.join("")
```

Wow, so Clojure. Nothing wrong with that, but the said friend rated it ugly.
Then I figured `String.duplicate/2` exists:

```elixir
String.duplicate("-", 10)
```

Which made me angry enough to look up `String.duplicate/2` source:

```elixir
  @spec duplicate(t, non_neg_integer) :: t
  def duplicate(subject, n) when is_integer(n) and n >= 0 do
    :binary.copy(subject, n)
  end
```

Duh. [All hail Erlang](http://erlang.org/doc/man/binary.html#copy-2).
