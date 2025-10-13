# Musty

[![Test Status][icon]][status]

[icon]: https://github.com/pyrmont/musty/workflows/test/badge.svg
[status]: https://github.com/pyrmont/musty/actions?query=workflow%3Atest

Musty is an implementation of the [Mustache][] templating language in Janet.

[Mustache]: https://mustache.github.io/

## Rationale

Mustache templates are strings with special values that are expanded when
rendered. Give Musty your template string, a context dictionary and an optional
directory path for partials. You get back the expanded string. Too easy.

Musty passes Mustache's [specs][] for **variables**, **sections**, **inverted
sections**, **comments**, **partials** and **custom delimiters**. It does not
support **lambdas**, **dynamic names** or **inheritance**.

[specs]: https://github.com/mustache/spec

## Library

### Installation

Add the dependency to your `info.jdn` file:

```janet
  :dependencies ["https://github.com/pyrmont/musty"]
```

### Usage

Musty can be used like this:

```janet
(import musty)

(musty/render "Hello {{world}}!" {:world "everybody"} :dir ".")
# => "Hello everybody!"
```

Check out the [API document](api.md) for more information.

## Bugs

Found a bug? I'd love to know about it. The best way is to report your bug in
the [Issues][] section on GitHub.

[Issues]: https://github.com/pyrmont/musty/issues

## Licence

Musty is licensed under the MIT Licence. See [LICENSE][] for more
details.

[LICENSE]: https://github.com/pyrmont/musty/blob/master/LICENSE
