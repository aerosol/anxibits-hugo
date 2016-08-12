---
layout: "post"
title: "Uncommon Things for Common Tests"
date: "2015-01-26"
---

As far as the Erlang testing goes, here are some snippets I've
collected over the years with the great help of my teammates (shout out to the
Regulators crew!).

## First things first

At least if you're using `rebar` everyone is so keen about, you can put your
helper libs in the CT test directory. I usually make one called `test_helpers` and
alias it with `?th` macro.

## Run a single Common Test case via `Makefile`

It greatly improves your workflow, especially if the whole local build takes up
to 30 minutes. Here's a `make` target ready to use:

```make
ct-single:
	@mkdir -p ct_log
	@if [ -z "$(suite)" ] || [ -z "$(case)" ]; then \
		echo "Provide args. e.g. suite=moo case=boo"; exit 1; \
		else true; fi
	@ct_run -noshell -pa deps/*/ebin -pa apps/*/ebin -include apps/*/include \
		-include deps/*/include -sname test -logdir ct_log -ct_hooks cth_surefire \
		-sasl sasl_error_logger false \
		-dir $(dir $(shell find . -name $(suite)_SUITE.erl)) -suite $(suite)_SUITE -case $(case)
```

Of course this won't work if you're using CT groups. That can be tweaked with the `-group`
switch.

## Common fixtures directory

The CT-enforced convention is to have one data directory per suite.  We were fed up with that;
reusing fixtures is usually the bread and butter of medium/large systems.

```erlang
set_fixt_dir(Test, Config) ->
    case code:which(Test) of
        Filename when is_list(Filename) ->
            CommonDir = filename:dirname(Filename) ++ "/fixtures/",
            [{common_data_dir, CommonDir}|Config]
    end.

load_fixt(Config, Filename) ->
    F = filename:join(?config(common_data_dir, Config), Filename),
    {ok, Fixture} = file:read_file(F),
    Fixture.
```

So the way you call it in your suites is:

```erlang
init_per_suite(Config) ->
    % fiddling with application:env and all the mocking tyranny...
    Config2 = ?th:set_fixt_dir(?MODULE, Config),
    Config2.
```

whereas:

```erlang
t_do_what_i_tell_you(Config) ->
    BinData = ?th:load_fixt(Config, "data.raw"),
    % ...

```

## Exporting all the tests

Have you noticed the `t_NAME` convention for a test case I used in the previous
paragraph? This comes in handy when you choose not to use groups.

```erlang
all_tests(Module) ->
    lists:filtermap(
      fun({F, _}) ->
              Name = atom_to_list(F),
              case Name of
                  [$t,$_|_] -> {true, F};
                  _ -> false
              end
      end, Module:module_info(exports)).
```

And then, in CT `all/0` callback:

```erlang
all() ->
    ?th:all_tests(?MODULE).
```

This way you don't need to needlessly repeat yourself in `all/0` and
`-export/0`. Just export the tests you wish to run, and the compiler will warn
you about the unexported ones.

## Debug calls

Let's assume, for the purpose of the following example, that your system
has become too hard to reason about, especially when it comes to testing async routines.
First of all, `dbg` works here too.

```erlang
start_debug_modules(Mods) when is_list(Mods) ->
    dbg:start(),
    dbg:tracer(),
    lists:foreach(fun(M) -> dbg:tp(M, '_', '_', []) end, Mods),
    dbg:p(all, c).

stop_debug_modules() ->
    dbg:stop_clear().
```

That's all you need in your helpers library. Call that on setup/teardown with
the modules of interest/hate as an input to get things moving.

## Sleep is the cousin of death

When testing e2e async routines, people often use `timer:sleep/1` and similar
to "wait for an output". This is wrong due to the fact that any kind of `sleep`
is non deterministic. In other words it will behave incalculably on different
test environments - example: the Bongo DB on your ssd omgmacbook is way faster
than the one on the CI box. If you really need to wait for an output,
please *keep trying to wait* instead. Consider the following functions in your
helpers module:

```erlang
keep_trying(Match, F, Sleep, Tries) ->
    try
        case F() of
            Match      -> ok;
            Unexpected -> throw({unexpected, Unexpected})
        end
    catch
        _:_=E ->
            timer:sleep(Sleep),
            case Tries-1 of
                0 -> error(E);
                N -> keep_trying(Match, F, Sleep, N)
            end
    end.

keep_trying_receive(Match, Sleep, Tries) ->
    keep_trying(Match, fun() -> receive Msg -> Msg
                                after Sleep -> error
                                end
                       end,
                0, Tries).
```

## Comparing JSON dudes

Dure to different circumstance I have never tried maps.  We often need to put some JSON 
somewhere and check if the output matches a JSON elsewhere. We have written a function
that tries to deeply compare two lists of tuples at least as far as `jsx`
is concerned.

```erlang
assert_deep_love(Expected, Got) ->
    compare(lists:sort(Expected), lists:sort(Got)).

compare(X, X) ->
    true;
compare([], []) ->
    true;
compare(Obj1, []) ->
    {false, {obj1, Obj1}};
compare([], Obj2) ->
    {false, {obj2, Obj2}};
compare([{K, V}|Obj1], [{K, V}|Obj2]) ->
    compare(Obj1, Obj2);
compare([{K, V1}|Obj1] , [{K, V2}|Obj2]) ->
    case compare_values(V1, V2) of
        true ->
            compare(Obj1, Obj2);
        {false, E} ->
            {false, {key, K, E}}
    end;
compare([V1|L1], [V2|L2]) ->
    case compare_values(V1, V2) of
        true ->
            compare(L1, L2);
        {false, E} ->
            {false, {list, E}}
    end.

compare_values([{_,_}|_] = Obj1, [{_,_}|_] = Obj2) ->
    assert_deep_love(Obj1, Obj2);
compare_values(L1, L2)
  when is_list(L1) and is_list(L2) ->
    assert_deep_love(L1, L2);
compare_values(V1, V2) ->
    {false, { {expected, V1}, {got, V2} }}.
```

Put that in your helpers module and benefit from it.

## That's all folks

Ping me if you need me!
