# musty API


[render](#render)

## render

**function**  | [source][1]

```janet
(render template context &named dir)
```

Renders a Mustache `template` using the provided `context` in `dir`

The directory `dir` is used to load partial templates. If not provided,
an error will be raised if a partial is encountered.

[1]: lib/musty.janet#L467

