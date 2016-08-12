---
layout: "post"
title: "A little known fact about Erlang's sys.config"
date: "2014-12-12"
---

If you ever wondered how to deploy Erlang releases with ability to override
their configuration per node/region/whatever, enjoy this little gem hidden in
[config](http://www.erlang.org/doc/man/config.html) documentation:

> When traversing the contents of sys.config and a filename is encountered, its
> contents are read and merged with the result so far.

Let's make a quick example of how it works.

Assume our release kernel is equipped with the following config file:

<figure>
  <figcaption>File: releases/1/sys.config</figcaption>

<pre>
[{kernel, [
           {inet_dist_listen_min, 10000},
           {inet_dist_listen_max, 10015},
           {database_for_example_purposes, "db://0.0.0.0:8080"}
          ]}].
</pre>

</figure>

And assume `database_for_example_purposes` is something that's specific to
the deployment target, while we can afford the luxury of provisioning the
environments with, let's say `/etc/region.config`. Of course that key 
doesn't belong to the `kernel` application and it's only here for
`example_purposes`.

<figure>
  <figcaption>File: /etc/region.config</figcaption>

<pre>
[{kernel, [
           {database_for_example_purposes, "db://prod-host-omg:8081"}
          ]}].
</pre>
</figure>

All we need to do is to do is to include `/etc/region.config` by putting a
string at the end of our release config file, so The Mustache of Release
Configuration will pick it up.

<figure>
  <figcaption>File: releases/1/sys.config</figcaption>

<pre>
[{kernel, [
           {inet_dist_listen_min, 10000},
           {inet_dist_listen_max, 10015},
           {database_for_example_purposes, "db://0.0.0.0:8080"},
          ]},
    "/etc/region.config"].
</pre>

</figure>

Let's check out if it works:

```
$ erl -config releases/1/sys
Erlang R16B02 (erts-5.10.3) [source] [64-bit] [smp:8:8] [async-threads:10]
[kernel-poll:false]

Eshell V5.10.3  (abort with ^G)
1> application:get_all_env(kernel)
[{database_for_example_purposes,"db://prod-host-omg:8081"},
 {inet_dist_listen_min,10000},
 {inet_dist_listen_max,10015},
 {included_applications,[]},
 {error_logger,tty}]
```

Et voilà.
