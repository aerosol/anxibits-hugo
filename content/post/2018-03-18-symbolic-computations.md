---
layout: "post"
title: "Symbolic Computations"
date: "2018-03-18"
---

I went with ruby because I don't know ruby. I have written ~300 LoC of ruby code
in my life. That'd have been much prettier with Elixir, but hey :sunglasses:

Here I am doubling my ruby record.

## Notes

  - It was incredibly fun, rewarding, experience to express integers and lists
    with pure functions. Using language I always deliberately stayed away from.
    Also learning how map/filter really work. It's about time, right?

  - I can't really comprehend the brilliance of building all the logic gates with a single [NAND](https://en.wikipedia.org/wiki/NAND_logic). This is awesome.

  - I need to figure out how to express boolean logic with pure lambdas.


### Code

<figure>
  <figcaption>File: lmb.rb</figcaption>

<pre>
#!/usr/bin/env ruby

empty_list = lambda { |selector| selector.(false, false, true) }
car        = lambda { |l| l.(lambda { |head, tail, e| head }) }
cdr        = lambda { |l| l.(lambda { |head, tail, e| tail }) }
zero       = empty_list

is_empty = lambda { |l| l.(lambda { |head, tail, e| e }) }

cons = lambda { |l, el| 
  lambda { |selector|
    selector.(el, l, false)
  }
}

map = lambda {
  |l, func| 
  if is_empty.(l)
    empty_list
  else
    cons.(map.(cdr.(l), func), func.(car.(l)))
  end
}

filter = lambda {
  |l, func|
  if is_empty.(l)
    empty_list
  elsif (func.(car.(l)))
    cons.(filter.(cdr.(l), func), car.(l))
  else
    filter.(cdr.(l), func)
  end
}

nand = lambda {
  |a, b|
  if a
    if b
      false
    else
      true
    end
  elsif b
    true
  else
    true
  end
}

# not
nah = lambda {
  |a| nand.(a, a)
}

# and
annnd = lambda {
  |a, b| nand.(nand.(a, b), nand.(a, b))
}

# or
orrr = lambda {
  |a, b| nand.(nand.(a, a), nand.(b, b))
}

inc = lambda { |n| cons.(n, empty_list) }
dec = lambda { |n| cdr.(n) }

is_zero     = lambda { |n| is_empty.(n) }
is_non_zero = lambda { |n| nah.(is_zero.(n)) }

add = lambda { 
  |a, b|
  if is_zero.(b)
    a
  else
    add.(inc.(a), dec.(b))
  end
}

sub = lambda {
  |a, b|
  if is_zero.(b)
    a
  else
    sub.(dec.(a), dec.(b))
  end
}

is_equal = lambda {
  |n, m|
  if annnd.(is_zero.(n), is_zero.(m))
    true
  elsif orrr.(is_zero.(n), is_zero.(m))
    false
  else
    is_equal.(dec.(n), dec.(m))
  end
}

nth = lambda {
  |l, n|
  if is_zero.(n)
    car.(l)
  else
    nth.(cdr.(l), dec.(n))
  end
}

lt = lambda {
  |a, b|
  if annnd.(is_zero.(a), is_zero.(b))
    false
  elsif is_zero.(a)
    true
  elsif is_zero.(b)
    false
  else
    lt.(dec.(a), dec.(b))
  end
}

gt = lambda { |a, b| lt.(b, a) }

rem = lambda {
  |a, b|
  if lt.(a, b)
    a
  else
    rem.(sub.(a, b), b)
  end
}

mult = lambda {
  |a, b|
  if is_zero.(b)
    zero
  else
    add.(a, mult.(a, dec.(b)))
  end
}

two   = cons.(cons.(empty_list, empty_list), empty_list)
one   = dec.(two)
three = inc.(two)
four  = inc.(three)
six   = add.(four, two)

is_odd = lambda {
  |n|
  if is_zero.(rem.(n, two))
    false
  else
    true
  end
}

is_even = lambda { |n| nah.(is_odd.(n)) }

square = lambda { |x| mult.(x, x) }

assert = lambda {
  |x|
  if x
    true
  else
    raise "Assertion error: #{x}"
  end
}

l = cons.(cons.(cons.(empty_list, three), two), one) # 1, 2, 3

first  = nth.(l, zero)
second = nth.(l, one)
third  = nth.(l, two)

assert.(is_equal.(first, one))
assert.(is_equal.(second, two))
assert.(is_equal.(third, three))

squared = map.(l, square) # 1, 4, 9

first  = nth.(squared, zero)
second = nth.(squared, one)
third  = nth.(squared, two)

assert.(is_equal.(first, one))
assert.(is_equal.(second, four))
assert.(is_equal.(third, add.(six, three)))

assert.(is_empty.(filter.(squared, is_zero)))

assert.(is_zero.(rem.(two, two)))
assert.(is_zero.(rem.(two, two)))

assert.(is_odd.(one))
assert.(is_even.(two))
assert.(is_odd.(three))
assert.(is_even.(four))

odd = filter.(squared, is_odd) # 1, 9

first  = nth.(odd, zero)
second = nth.(odd, one)

assert.(is_equal.(first, one))
assert.(is_equal.(second, add.(six, three)))

puts "passed"
</pre>
</figure>

<figure>
  <figcaption>shell</figcaption>
<pre>
~/dev/lambdas $ ruby lmb.rb
passed
</pre>

</figure>
