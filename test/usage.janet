(use ../deps/testament)

(import ../init :as musty)

(def s
  ````
  # {{bundle-name}} API

  {{#bundle-doc}}
  {{&bundle-doc}}

  {{/bundle-doc}}
  {{#modules}}
  {{#ns}}
  ## {{ns}}

  {{/ns}}
  {{#items}}{{^first}}, {{/first}}[{{name}}](#{{in-link}}){{/items}}

  {{#doc}}
  {{&doc}}

  {{/doc}}
  {{#items}}
  ## {{name}}

  **{{kind}}** {{#private?}}| **private**{{/private?}} {{#link}}| [source][{{num}}]{{/link}}

  {{#sig}}
  ```janet
  {{&sig}}
  ```
  {{/sig}}

  {{&docstring}}

  {{#link}}
  [{{num}}]: {{link}}
  {{/link}}

  {{/items}}
  {{/modules}}
  ````)

(deftest api-document
  (def expect
    ````
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


    ````)
  (def actual (musty/render
                s
                {:bundle-name "musty"
                 :modules
                  [{:items
                    [{:name "render"
                      :first true
                      :in-link "render"
                      :kind "function"
                      :link "lib/musty.janet#L467"
                      :num "1"
                      :sig "(render template context &named dir)"
                      :docstring
                      ``
                      Renders a Mustache `template` using the provided `context` in `dir`

                      The directory `dir` is used to load partial templates. If not provided,
                      an error will be raised if a partial is encountered.
                      ``
                      }]}]}))
  (is (== expect actual)))

(run-tests!)
