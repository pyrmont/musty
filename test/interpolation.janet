(use ../deps/testament)
(import ../deps/medea/lib/decode :as json)

(import ../lib/musty)

(deftest no-interpolation
  (def expect
    ``
    Hello from {Mustache}!
    
    ``)
  (def template
    ``
    Hello from {Mustache}!
    
    ``)
  (def actual (musty/render template @{} :dir "res/fixtures/"))
  (is (== expect actual)))

(deftest basic-interpolation
  (def expect
    ``
    Hello, world!
    
    ``)
  (def template
    ``
    Hello, {{subject}}!
    
    ``)
  (def actual (musty/render template @{"subject" "world"} :dir "res/fixtures/"))
  (is (== expect actual)))

(deftest no-re-interpolation
  (def expect
    ``
    {{planet}}: Earth
    ``)
  (def template
    ``
    {{template}}: {{planet}}
    ``)
  (def actual (musty/render template @{"template" "{{planet}}" "planet" "Earth"} :dir "res/fixtures/"))
  (is (== expect actual)))

(deftest html-escaping
  (def expect
    ``
    These characters should be HTML escaped: &amp; &quot; &lt; &gt;
    
    ``)
  (def template
    ``
    These characters should be HTML escaped: {{forbidden}}
    
    ``)
  (def actual (musty/render template @{"forbidden" "& \" < >"} :dir "res/fixtures/"))
  (is (== expect actual)))

(deftest triple-mustache
  (def expect
    ``
    These characters should not be HTML escaped: & " < >
    
    ``)
  (def template
    ``
    These characters should not be HTML escaped: {{{forbidden}}}
    
    ``)
  (def actual (musty/render template @{"forbidden" "& \" < >"} :dir "res/fixtures/"))
  (is (== expect actual)))

(deftest ampersand
  (def expect
    ``
    These characters should not be HTML escaped: & " < >
    
    ``)
  (def template
    ``
    These characters should not be HTML escaped: {{&forbidden}}
    
    ``)
  (def actual (musty/render template @{"forbidden" "& \" < >"} :dir "res/fixtures/"))
  (is (== expect actual)))

(deftest basic-integer-interpolation
  (def expect
    ``
    "85 miles an hour!"
    ``)
  (def template
    ``
    "{{mph}} miles an hour!"
    ``)
  (def actual (musty/render template @{"mph" 85} :dir "res/fixtures/"))
  (is (== expect actual)))

(deftest triple-mustache-integer-interpolation
  (def expect
    ``
    "85 miles an hour!"
    ``)
  (def template
    ``
    "{{{mph}}} miles an hour!"
    ``)
  (def actual (musty/render template @{"mph" 85} :dir "res/fixtures/"))
  (is (== expect actual)))

(deftest ampersand-integer-interpolation
  (def expect
    ``
    "85 miles an hour!"
    ``)
  (def template
    ``
    "{{&mph}} miles an hour!"
    ``)
  (def actual (musty/render template @{"mph" 85} :dir "res/fixtures/"))
  (is (== expect actual)))

(deftest basic-decimal-interpolation
  (def expect
    ``
    "1.21 jiggawatts!"
    ``)
  (def template
    ``
    "{{power}} jiggawatts!"
    ``)
  (def actual (musty/render template @{"power" 1.21} :dir "res/fixtures/"))
  (is (== expect actual)))

(deftest triple-mustache-decimal-interpolation
  (def expect
    ``
    "1.21 jiggawatts!"
    ``)
  (def template
    ``
    "{{{power}}} jiggawatts!"
    ``)
  (def actual (musty/render template @{"power" 1.21} :dir "res/fixtures/"))
  (is (== expect actual)))

(deftest ampersand-decimal-interpolation
  (def expect
    ``
    "1.21 jiggawatts!"
    ``)
  (def template
    ``
    "{{&power}} jiggawatts!"
    ``)
  (def actual (musty/render template @{"power" 1.21} :dir "res/fixtures/"))
  (is (== expect actual)))

(deftest basic-null-interpolation
  (def expect
    ``
    I () be seen!
    ``)
  (def template
    ``
    I ({{cannot}}) be seen!
    ``)
  (def actual (musty/render template @{"cannot" nil} :dir "res/fixtures/"))
  (is (== expect actual)))

(deftest triple-mustache-null-interpolation
  (def expect
    ``
    I () be seen!
    ``)
  (def template
    ``
    I ({{{cannot}}}) be seen!
    ``)
  (def actual (musty/render template @{"cannot" nil} :dir "res/fixtures/"))
  (is (== expect actual)))

(deftest ampersand-null-interpolation
  (def expect
    ``
    I () be seen!
    ``)
  (def template
    ``
    I ({{&cannot}}) be seen!
    ``)
  (def actual (musty/render template @{"cannot" nil} :dir "res/fixtures/"))
  (is (== expect actual)))

(deftest basic-context-miss-interpolation
  (def expect
    ``
    I () be seen!
    ``)
  (def template
    ``
    I ({{cannot}}) be seen!
    ``)
  (def actual (musty/render template @{} :dir "res/fixtures/"))
  (is (== expect actual)))

(deftest triple-mustache-context-miss-interpolation
  (def expect
    ``
    I () be seen!
    ``)
  (def template
    ``
    I ({{{cannot}}}) be seen!
    ``)
  (def actual (musty/render template @{} :dir "res/fixtures/"))
  (is (== expect actual)))

(deftest ampersand-context-miss-interpolation
  (def expect
    ``
    I () be seen!
    ``)
  (def template
    ``
    I ({{&cannot}}) be seen!
    ``)
  (def actual (musty/render template @{} :dir "res/fixtures/"))
  (is (== expect actual)))

(deftest dotted-names---basic-interpolation
  (def expect
    ``
    "Joe" == "Joe"
    ``)
  (def template
    ``
    "{{person.name}}" == "{{#person}}{{name}}{{/person}}"
    ``)
  (def actual (musty/render template @{"person" @{"name" "Joe"}} :dir "res/fixtures/"))
  (is (== expect actual)))

(deftest dotted-names---triple-mustache-interpolation
  (def expect
    ``
    "Joe" == "Joe"
    ``)
  (def template
    ``
    "{{{person.name}}}" == "{{#person}}{{{name}}}{{/person}}"
    ``)
  (def actual (musty/render template @{"person" @{"name" "Joe"}} :dir "res/fixtures/"))
  (is (== expect actual)))

(deftest dotted-names---ampersand-interpolation
  (def expect
    ``
    "Joe" == "Joe"
    ``)
  (def template
    ``
    "{{&person.name}}" == "{{#person}}{{&name}}{{/person}}"
    ``)
  (def actual (musty/render template @{"person" @{"name" "Joe"}} :dir "res/fixtures/"))
  (is (== expect actual)))

(deftest dotted-names---arbitrary-depth
  (def expect
    ``
    "Phil" == "Phil"
    ``)
  (def template
    ``
    "{{a.b.c.d.e.name}}" == "Phil"
    ``)
  (def actual (musty/render template @{"a" @{"b" @{"c" @{"d" @{"e" @{"name" "Phil"}}}}}} :dir "res/fixtures/"))
  (is (== expect actual)))

(deftest dotted-names---broken-chains
  (def expect
    ``
    "" == ""
    ``)
  (def template
    ``
    "{{a.b.c}}" == ""
    ``)
  (def actual (musty/render template @{"a" @{}} :dir "res/fixtures/"))
  (is (== expect actual)))

(deftest dotted-names---broken-chain-resolution
  (def expect
    ``
    "" == ""
    ``)
  (def template
    ``
    "{{a.b.c.name}}" == ""
    ``)
  (def actual (musty/render template @{"c" @{"name" "Jim"} "a" @{"b" @{}}} :dir "res/fixtures/"))
  (is (== expect actual)))

(deftest dotted-names---initial-resolution
  (def expect
    ``
    "Phil" == "Phil"
    ``)
  (def template
    ``
    "{{#a}}{{b.c.d.e.name}}{{/a}}" == "Phil"
    ``)
  (def actual (musty/render template @{"b" @{"c" @{"d" @{"e" @{"name" "Wrong"}}}} "a" @{"b" @{"c" @{"d" @{"e" @{"name" "Phil"}}}}}} :dir "res/fixtures/"))
  (is (== expect actual)))

(deftest dotted-names---context-precedence
  (def expect
    ``
    
    ``)
  (def template
    ``
    {{#a}}{{b.c}}{{/a}}
    ``)
  (def actual (musty/render template @{"b" @{"c" "ERROR"} "a" @{"b" @{}}} :dir "res/fixtures/"))
  (is (== expect actual)))

(deftest dotted-names-are-never-single-keys
  (def expect
    ``
    
    ``)
  (def template
    ``
    {{a.b}}
    ``)
  (def actual (musty/render template @{"a.b" "c"} :dir "res/fixtures/"))
  (is (== expect actual)))

(deftest dotted-names---no-masking
  (def expect
    ``
    d
    ``)
  (def template
    ``
    {{a.b}}
    ``)
  (def actual (musty/render template @{"a" @{"b" "d"} "a.b" "c"} :dir "res/fixtures/"))
  (is (== expect actual)))

(deftest implicit-iterators---basic-interpolation
  (def expect
    ``
    Hello, world!
    
    ``)
  (def template
    ``
    Hello, {{.}}!
    
    ``)
  (def actual (musty/render template "world" :dir "res/fixtures/"))
  (is (== expect actual)))

(deftest implicit-iterators---html-escaping
  (def expect
    ``
    These characters should be HTML escaped: &amp; &quot; &lt; &gt;
    
    ``)
  (def template
    ``
    These characters should be HTML escaped: {{.}}
    
    ``)
  (def actual (musty/render template "& \" < >" :dir "res/fixtures/"))
  (is (== expect actual)))

(deftest implicit-iterators---triple-mustache
  (def expect
    ``
    These characters should not be HTML escaped: & " < >
    
    ``)
  (def template
    ``
    These characters should not be HTML escaped: {{{.}}}
    
    ``)
  (def actual (musty/render template "& \" < >" :dir "res/fixtures/"))
  (is (== expect actual)))

(deftest implicit-iterators---ampersand
  (def expect
    ``
    These characters should not be HTML escaped: & " < >
    
    ``)
  (def template
    ``
    These characters should not be HTML escaped: {{&.}}
    
    ``)
  (def actual (musty/render template "& \" < >" :dir "res/fixtures/"))
  (is (== expect actual)))

(deftest implicit-iterators---basic-integer-interpolation
  (def expect
    ``
    "85 miles an hour!"
    ``)
  (def template
    ``
    "{{.}} miles an hour!"
    ``)
  (def actual (musty/render template 85 :dir "res/fixtures/"))
  (is (== expect actual)))

(deftest interpolation---surrounding-whitespace
  (def expect
    ``
    | --- |
    ``)
  (def template
    ``
    | {{string}} |
    ``)
  (def actual (musty/render template @{"string" "---"} :dir "res/fixtures/"))
  (is (== expect actual)))

(deftest triple-mustache---surrounding-whitespace
  (def expect
    ``
    | --- |
    ``)
  (def template
    ``
    | {{{string}}} |
    ``)
  (def actual (musty/render template @{"string" "---"} :dir "res/fixtures/"))
  (is (== expect actual)))

(deftest ampersand---surrounding-whitespace
  (def expect
    ``
    | --- |
    ``)
  (def template
    ``
    | {{&string}} |
    ``)
  (def actual (musty/render template @{"string" "---"} :dir "res/fixtures/"))
  (is (== expect actual)))

(deftest interpolation---standalone
  (def expect
    ``
      ---
    
    ``)
  (def template
    ``
      {{string}}
    
    ``)
  (def actual (musty/render template @{"string" "---"} :dir "res/fixtures/"))
  (is (== expect actual)))

(deftest triple-mustache---standalone
  (def expect
    ``
      ---
    
    ``)
  (def template
    ``
      {{{string}}}
    
    ``)
  (def actual (musty/render template @{"string" "---"} :dir "res/fixtures/"))
  (is (== expect actual)))

(deftest ampersand---standalone
  (def expect
    ``
      ---
    
    ``)
  (def template
    ``
      {{&string}}
    
    ``)
  (def actual (musty/render template @{"string" "---"} :dir "res/fixtures/"))
  (is (== expect actual)))

(deftest interpolation-with-padding
  (def expect
    ``
    |---|
    ``)
  (def template
    ``
    |{{ string }}|
    ``)
  (def actual (musty/render template @{"string" "---"} :dir "res/fixtures/"))
  (is (== expect actual)))

(deftest triple-mustache-with-padding
  (def expect
    ``
    |---|
    ``)
  (def template
    ``
    |{{{ string }}}|
    ``)
  (def actual (musty/render template @{"string" "---"} :dir "res/fixtures/"))
  (is (== expect actual)))

(deftest ampersand-with-padding
  (def expect
    ``
    |---|
    ``)
  (def template
    ``
    |{{& string }}|
    ``)
  (def actual (musty/render template @{"string" "---"} :dir "res/fixtures/"))
  (is (== expect actual)))

(run-tests!)