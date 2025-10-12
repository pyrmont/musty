(use ../deps/testament)
(import ../deps/medea/lib/decode :as json)

(import ../lib/musty)

(deftest basic-behavior
  (def expect
    ``
    "from partial"
    ``)
  (def template
    ``
    "{{>partials_basic-behavior_text}}"
    ``)
  (def actual (musty/render template @{} "res/fixtures/"))
  (is (== expect actual)))

(deftest failed-lookup
  (def expect
    ``
    ""
    ``)
  (def template
    ``
    "{{>text}}"
    ``)
  (def actual (musty/render template @{} "res/fixtures/"))
  (is (== expect actual)))

(deftest context
  (def expect
    ``
    "*content*"
    ``)
  (def template
    ``
    "{{>partials_context_partial}}"
    ``)
  (def actual (musty/render template @{"text" "content"} "res/fixtures/"))
  (is (== expect actual)))

(deftest recursion
  (def expect
    ``
    X<Y<>>
    ``)
  (def template
    ``
    {{>partials_recursion_node}}
    ``)
  (def actual (musty/render template @{"content" "X" "nodes" @[@{"content" "Y" "nodes" @[]}]} "res/fixtures/"))
  (is (== expect actual)))

(deftest nested
  (def expect
    ``
    *hello world!*
    ``)
  (def template
    ``
    {{>partials_nested_outer}}
    ``)
  (def actual (musty/render template @{"b" "world" "a" "hello"} "res/fixtures/"))
  (is (== expect actual)))

(deftest surrounding-whitespace
  (def expect
    ``
    | 	|	 |
    ``)
  (def template
    ``
    | {{>partials_surrounding-whitespace_partial}} |
    ``)
  (def actual (musty/render template @{} "res/fixtures/"))
  (is (== expect actual)))

(deftest inline-indentation
  (def expect
    ``
      |  >
    >
    
    ``)
  (def template
    ``
      {{data}}  {{> partials_inline-indentation_partial}}
    
    ``)
  (def actual (musty/render template @{"data" "|"} "res/fixtures/"))
  (is (== expect actual)))

(deftest standalone-line-endings
  (def expect
    ``
    |
    >|
    ``)
  (def template
    ``
    |
    {{>partials_standalone-line-endings_partial}}
    |
    ``)
  (def actual (musty/render template @{} "res/fixtures/"))
  (is (== expect actual)))

(deftest standalone-without-previous-line
  (def expect
    ``
      >
      >>
    ``)
  (def template
    ``
      {{>partials_standalone-without-previous-line_partial}}
    >
    ``)
  (def actual (musty/render template @{} "res/fixtures/"))
  (is (== expect actual)))

(deftest standalone-without-newline
  (def expect
    ``
    >
      >
      >
    ``)
  (def template
    ``
    >
      {{>partials_standalone-without-newline_partial}}
    ``)
  (def actual (musty/render template @{} "res/fixtures/"))
  (is (== expect actual)))

(deftest standalone-indentation
  (def expect
    ``
    \
     |
     <
    ->
     |
    /
    
    ``)
  (def template
    ``
    \
     {{>partials_standalone-indentation_partial}}
    /
    
    ``)
  (def actual (musty/render template @{"content" "<\n->"} "res/fixtures/"))
  (is (== expect actual)))

(deftest padding-whitespace
  (def expect
    ``
    |[]|
    ``)
  (def template
    ``
    |{{> partials_padding-whitespace_partial }}|
    ``)
  (def actual (musty/render template @{"boolean" true} "res/fixtures/"))
  (is (== expect actual)))

(run-tests!)