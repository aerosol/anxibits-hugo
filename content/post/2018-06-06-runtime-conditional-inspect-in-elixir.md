---
layout: "post"
title: "Runtime conditional inspect in Elixir"
date: "2018-06-05"
---

> Took me a good hour to discover that
> if I change (meta) date of this post to
> 2018-06-06 (which it is right now, at least in this part of the globe),
> hugo won't render the post, at all. Hi UTC, it's 00:55 CET.


## Use Case

A large struct. Possibly [Ecto](https://github.com/elixir-ecto/ecto) schema.

<figure>
  <figcaption>File: big_data_user.ex</figcaption>
  <pre>
defmodule BigDataUser do
  defstruct name: nil,
            association: :many_of_them,
            description: "Many associations"
end
  </pre>
</figure>

### Problem

You're annoyed by the amount of `%BigDataUser{}`'s associations.
Most of that data is unnecessary noise when debugging within the REPL.

Sometimes you're only interested in a shortened version when inspecting the
output. 

Piping via [`Map`](https://hexdocs.pm/elixir/Map.html)
functions obviously works, but quickly becomes a bit repetitive.

For the sake of inner peace, you're only interested in `%BigDataUser`'s `name`
during that REPL session, unless sometimes `description` as well.

### Solution

We'll exploit the fact that `iex` session,
just like [the erlang shell, is a process](https://ferd.ca/repl-a-bit-more-and-less-than-that.html).

We'll also take advantage of the
[process dictionary](https://ferd.ca/on-the-use-of-the-process-dictionary-in-erlang.html)
 lookup in [`Inspect`](https://hexdocs.pm/elixir/Inspect.html) protocol implementation, to
exploit some of the Elixir goodness.


<figure>
  <figcaption>File: big_data_user.ex</figcaption>
  <pre>
defmodule BigDataUser do
  defstruct name: nil, association: :many_of_them, description: "Many associations"

  def inspect_reset, do: Process.delete(:inspect_variant)

  def inspect_session(level) when level in [:short, :minimal] do
    Process.put(:inspect_variant, level)
  end

  defimpl Inspect do
    def inspect(u, opts) do
      case Process.get(:inspect_variant) do
        nil -> Inspect.Any.inspect(u, opts) # default fallback
        :short -> "#User<#{u.name}> (#{u.description})"
        :minimal -> "#User<#{u.name}>"
      end
    end
  end
end
  </pre>
</figure>

### Proof of Concept

Live `iex -S mix`:

```
Erlang/OTP 20 [erts-9.3.1] [source] [64-bit] [smp:24:24] [ds:24:24:10] [async-threads:10] [hipe] [kernel-poll:false]
Interactive Elixir (1.6.5) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> user = %BigDataUser{name: "Joe"}
%BigDataUser{
  association: :many_of_them,
  description: "Many associations",
  name: "Joe"
}
iex(2)> list_of_users = [user, user, user, user]
[
  %BigDataUser{
    association: :many_of_them,
    description: "Many associations",
    name: "Joe"
  },
  %BigDataUser{
    association: :many_of_them,
    description: "Many associations",
    name: "Joe"
  },
  %BigDataUser{
    association: :many_of_them,
    description: "Many associations",
    name: "Joe"
  },
  %BigDataUser{
    association: :many_of_them,
    description: "Many associations",
    name: "Joe"
  }
]
iex(3)> BigDataUser.inspect_session(:short)
nil
iex(4)> list_of_users
[#User<Joe> (Many associations), #User<Joe> (Many associations),
 #User<Joe> (Many associations), #User<Joe> (Many associations)]
iex(5)> BigDataUser.inspect_session(:minimal)
:short
iex(6)> list_of_users
[#User<Joe>, #User<Joe>, #User<Joe>, #User<Joe>]
iex(7)> BigDataUser.inspect_reset()
```

### Fistbumps

Thanks [Wojtek Mach](http://wojtekmach.pl/) for helping me come up with this.
