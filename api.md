# Musty API

[musty/render](#mustyrender)


## musty/render

**function**  | [source][1]

```janet
(render template replacements)
```

Render the Mustache `template` using a dictionary `replacements`

Musty will translate the Mustache template into a series of Janet expressions
and then evaluate those expressions. The translation is accomplished by way of
a parser expression grammar that matches particular tags and then causes the
tag and its enclosed value to be replaced with the relevant Janet expression.

Musty is a partial implementation of the Mustache specification. It supports
variable tags, section tags, inverted section tags and comment tags.

[1]: src/musty.janet#L119


