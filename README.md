# Musty

Musty is an incomplete Mustache implementation in Janet.

Mustache templates are strings with special values that are expanded when
rendered. Musty handles the rendering in a straightforward way. Give it your
template and a dictionary object and you get back to the expanded string. Too
easy.

Musty passes Mustache's [specs][] for **variables**, **sections**,
**inverted sections** and **comments**. It does not implement **partials**,
**lambdas** or custom **delimiters**.

[specs]: https://github.com/mustache/spec

## Usage

Add Musty to the dependencies in your `project.janet` file:

```janet

  :dependencies ["https://github.com/pyrmont/musty"]
```

And then in your Janet code, import the module and call the render method:

```janet
(import musty)

(musty/render "Hello {{world}}!" {:world "everybody"})
```

Checkout [the API](api.md) for more information.

## Bugs

Found a bug? I'd love to know about it. The best way is to report your bug in
the [Issues][] section on GitHub.

[Issues]: https://github.com/pyrmont/musty/issues

## Licence

Musty is licensed under the MIT Licence. See [LICENSE][] for more
details.

[LICENSE]: https://github.com/pyrmont/musty/blob/master/LICENSE
