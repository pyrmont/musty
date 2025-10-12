(use ../deps/testament)
(import ../deps/medea/lib/decode :as json)

(import ../lib/musty)

(deftest truthy
  (def expect
    ``
    "This should be rendered."
    ``)
  (def template
    ``
    "{{#boolean}}This should be rendered.{{/boolean}}"
    ``)
  (def actual (musty/render template @{"boolean" true} "res/fixtures/"))
  (is (== expect actual)))

(deftest falsey
  (def expect
    ``
    ""
    ``)
  (def template
    ``
    "{{#boolean}}This should not be rendered.{{/boolean}}"
    ``)
  (def actual (musty/render template @{"boolean" false} "res/fixtures/"))
  (is (== expect actual)))

(deftest null-is-falsey
  (def expect
    ``
    ""
    ``)
  (def template
    ``
    "{{#null}}This should not be rendered.{{/null}}"
    ``)
  (def actual (musty/render template @{"null" nil} "res/fixtures/"))
  (is (== expect actual)))

(deftest context
  (def expect
    ``
    "Hi Joe."
    ``)
  (def template
    ``
    "{{#context}}Hi {{name}}.{{/context}}"
    ``)
  (def actual (musty/render template @{"context" @{"name" "Joe"}} "res/fixtures/"))
  (is (== expect actual)))

(deftest parent-contexts
  (def expect
    ``
    "foo, bar, baz"
    ``)
  (def template
    ``
    "{{#sec}}{{a}}, {{b}}, {{c.d}}{{/sec}}"
    ``)
  (def actual (musty/render template @{"b" "wrong" "a" "foo" "sec" @{"b" "bar"} "c" @{"d" "baz"}} "res/fixtures/"))
  (is (== expect actual)))

(deftest variable-test
  (def expect
    ``
    "bar is bar"
    ``)
  (def template
    ``
    "{{#foo}}{{.}} is {{foo}}{{/foo}}"
    ``)
  (def actual (musty/render template @{"foo" "bar"} "res/fixtures/"))
  (is (== expect actual)))

(deftest list-contexts
  (def expect
    ``
    a1.A1x.A1y.
    ``)
  (def template
    ``
    {{#tops}}{{#middles}}{{tname.lower}}{{mname}}.{{#bottoms}}{{tname.upper}}{{mname}}{{bname}}.{{/bottoms}}{{/middles}}{{/tops}}
    ``)
  (def actual (musty/render template @{"tops" @[@{"tname" @{"upper" "A" "lower" "a"} "middles" @[@{"mname" "1" "bottoms" @[@{"bname" "x"} @{"bname" "y"}]}]}]} "res/fixtures/"))
  (is (== expect actual)))

(deftest deeply-nested-contexts
  (def expect
    ``
    1
    121
    12321
    1234321
    123454321
    12345654321
    123454321
    1234321
    12321
    121
    1
    
    ``)
  (def template
    ``
    {{#a}}
    {{one}}
    {{#b}}
    {{one}}{{two}}{{one}}
    {{#c}}
    {{one}}{{two}}{{three}}{{two}}{{one}}
    {{#d}}
    {{one}}{{two}}{{three}}{{four}}{{three}}{{two}}{{one}}
    {{#five}}
    {{one}}{{two}}{{three}}{{four}}{{five}}{{four}}{{three}}{{two}}{{one}}
    {{one}}{{two}}{{three}}{{four}}{{.}}6{{.}}{{four}}{{three}}{{two}}{{one}}
    {{one}}{{two}}{{three}}{{four}}{{five}}{{four}}{{three}}{{two}}{{one}}
    {{/five}}
    {{one}}{{two}}{{three}}{{four}}{{three}}{{two}}{{one}}
    {{/d}}
    {{one}}{{two}}{{three}}{{two}}{{one}}
    {{/c}}
    {{one}}{{two}}{{one}}
    {{/b}}
    {{one}}
    {{/a}}
    
    ``)
  (def actual (musty/render template @{"b" @{"two" 2} "a" @{"one" 1} "c" @{"d" @{"five" 5 "four" 4} "three" 3}} "res/fixtures/"))
  (is (== expect actual)))

(deftest list
  (def expect
    ``
    "123"
    ``)
  (def template
    ``
    "{{#list}}{{item}}{{/list}}"
    ``)
  (def actual (musty/render template @{"list" @[@{"item" 1} @{"item" 2} @{"item" 3}]} "res/fixtures/"))
  (is (== expect actual)))

(deftest empty-list
  (def expect
    ``
    ""
    ``)
  (def template
    ``
    "{{#list}}Yay lists!{{/list}}"
    ``)
  (def actual (musty/render template @{"list" @[]} "res/fixtures/"))
  (is (== expect actual)))

(deftest doubled
  (def expect
    ``
    * first
    * second
    * third
    
    ``)
  (def template
    ``
    {{#bool}}
    * first
    {{/bool}}
    * {{two}}
    {{#bool}}
    * third
    {{/bool}}
    
    ``)
  (def actual (musty/render template @{"bool" true "two" "second"} "res/fixtures/"))
  (is (== expect actual)))

(deftest nested-_truthy_
  (def expect
    ``
    | A B C D E |
    ``)
  (def template
    ``
    | A {{#bool}}B {{#bool}}C{{/bool}} D{{/bool}} E |
    ``)
  (def actual (musty/render template @{"bool" true} "res/fixtures/"))
  (is (== expect actual)))

(deftest nested-_falsey_
  (def expect
    ``
    | A  E |
    ``)
  (def template
    ``
    | A {{#bool}}B {{#bool}}C{{/bool}} D{{/bool}} E |
    ``)
  (def actual (musty/render template @{"bool" false} "res/fixtures/"))
  (is (== expect actual)))

(deftest context-misses
  (def expect
    ``
    []
    ``)
  (def template
    ``
    [{{#missing}}Found key 'missing'!{{/missing}}]
    ``)
  (def actual (musty/render template @{} "res/fixtures/"))
  (is (== expect actual)))

(deftest implicit-iterator---string
  (def expect
    ``
    "(a)(b)(c)(d)(e)"
    ``)
  (def template
    ``
    "{{#list}}({{.}}){{/list}}"
    ``)
  (def actual (musty/render template @{"list" @["a" "b" "c" "d" "e"]} "res/fixtures/"))
  (is (== expect actual)))

(deftest implicit-iterator---integer
  (def expect
    ``
    "(1)(2)(3)(4)(5)"
    ``)
  (def template
    ``
    "{{#list}}({{.}}){{/list}}"
    ``)
  (def actual (musty/render template @{"list" @[1 2 3 4 5]} "res/fixtures/"))
  (is (== expect actual)))

(deftest implicit-iterator---decimal
  (def expect
    ``
    "(1.1)(2.2)(3.3)(4.4)(5.5)"
    ``)
  (def template
    ``
    "{{#list}}({{.}}){{/list}}"
    ``)
  (def actual (musty/render template @{"list" @[1.1000000000000001 2.2000000000000002 3.2999999999999998 4.4000000000000004 5.5]} "res/fixtures/"))
  (is (== expect actual)))

(deftest implicit-iterator---array
  (def expect
    ``
    "(123)(abc)"
    ``)
  (def template
    ``
    "{{#list}}({{#.}}{{.}}{{/.}}){{/list}}"
    ``)
  (def actual (musty/render template @{"list" @[@[1 2 3] @["a" "b" "c"]]} "res/fixtures/"))
  (is (== expect actual)))

(deftest implicit-iterator---html-escaping
  (def expect
    ``
    "(&amp;)(&quot;)(&lt;)(&gt;)"
    ``)
  (def template
    ``
    "{{#list}}({{.}}){{/list}}"
    ``)
  (def actual (musty/render template @{"list" @["&" "\"" "<" ">"]} "res/fixtures/"))
  (is (== expect actual)))

(deftest implicit-iterator---triple-mustache
  (def expect
    ``
    "(&)(")(<)(>)"
    ``)
  (def template
    ``
    "{{#list}}({{{.}}}){{/list}}"
    ``)
  (def actual (musty/render template @{"list" @["&" "\"" "<" ">"]} "res/fixtures/"))
  (is (== expect actual)))

(deftest implicit-iterator---ampersand
  (def expect
    ``
    "(&)(")(<)(>)"
    ``)
  (def template
    ``
    "{{#list}}({{&.}}){{/list}}"
    ``)
  (def actual (musty/render template @{"list" @["&" "\"" "<" ">"]} "res/fixtures/"))
  (is (== expect actual)))

(deftest implicit-iterator---root-level
  (def expect
    ``
    "(a)(b)"
    ``)
  (def template
    ``
    "{{#.}}({{value}}){{/.}}"
    ``)
  (def actual (musty/render template @[@{"value" "a"} @{"value" "b"}] "res/fixtures/"))
  (is (== expect actual)))

(deftest dotted-names---truthy
  (def expect
    ``
    "Here" == "Here"
    ``)
  (def template
    ``
    "{{#a.b.c}}Here{{/a.b.c}}" == "Here"
    ``)
  (def actual (musty/render template @{"a" @{"b" @{"c" true}}} "res/fixtures/"))
  (is (== expect actual)))

(deftest dotted-names---falsey
  (def expect
    ``
    "" == ""
    ``)
  (def template
    ``
    "{{#a.b.c}}Here{{/a.b.c}}" == ""
    ``)
  (def actual (musty/render template @{"a" @{"b" @{"c" false}}} "res/fixtures/"))
  (is (== expect actual)))

(deftest dotted-names---broken-chains
  (def expect
    ``
    "" == ""
    ``)
  (def template
    ``
    "{{#a.b.c}}Here{{/a.b.c}}" == ""
    ``)
  (def actual (musty/render template @{"a" @{}} "res/fixtures/"))
  (is (== expect actual)))

(deftest surrounding-whitespace
  (def expect
    ``
     | 	|	 | 
    
    ``)
  (def template
    ``
     | {{#boolean}}	|	{{/boolean}} | 
    
    ``)
  (def actual (musty/render template @{"boolean" true} "res/fixtures/"))
  (is (== expect actual)))

(deftest internal-whitespace
  (def expect
    ``
     |  
      | 
    
    ``)
  (def template
    ``
     | {{#boolean}} {{! Important Whitespace }}
     {{/boolean}} | 
    
    ``)
  (def actual (musty/render template @{"boolean" true} "res/fixtures/"))
  (is (== expect actual)))

(deftest indented-inline-sections
  (def expect
    ``
     YES
     GOOD
    
    ``)
  (def template
    ``
     {{#boolean}}YES{{/boolean}}
     {{#boolean}}GOOD{{/boolean}}
    
    ``)
  (def actual (musty/render template @{"boolean" true} "res/fixtures/"))
  (is (== expect actual)))

(deftest standalone-lines
  (def expect
    ``
    | This Is
    |
    | A Line
    
    ``)
  (def template
    ``
    | This Is
    {{#boolean}}
    |
    {{/boolean}}
    | A Line
    
    ``)
  (def actual (musty/render template @{"boolean" true} "res/fixtures/"))
  (is (== expect actual)))

(deftest indented-standalone-lines
  (def expect
    ``
    | This Is
    |
    | A Line
    
    ``)
  (def template
    ``
    | This Is
      {{#boolean}}
    |
      {{/boolean}}
    | A Line
    
    ``)
  (def actual (musty/render template @{"boolean" true} "res/fixtures/"))
  (is (== expect actual)))

(deftest standalone-line-endings
  (def expect
    ``
    |
    |
    ``)
  (def template
    ``
    |
    {{#boolean}}
    {{/boolean}}
    |
    ``)
  (def actual (musty/render template @{"boolean" true} "res/fixtures/"))
  (is (== expect actual)))

(deftest standalone-without-previous-line
  (def expect
    ``
    #
    /
    ``)
  (def template
    ``
      {{#boolean}}
    #{{/boolean}}
    /
    ``)
  (def actual (musty/render template @{"boolean" true} "res/fixtures/"))
  (is (== expect actual)))

(deftest standalone-without-newline
  (def expect
    ``
    #
    /
    
    ``)
  (def template
    ``
    #{{#boolean}}
    /
      {{/boolean}}
    ``)
  (def actual (musty/render template @{"boolean" true} "res/fixtures/"))
  (is (== expect actual)))

(deftest padding
  (def expect
    ``
    |=|
    ``)
  (def template
    ``
    |{{# boolean }}={{/ boolean }}|
    ``)
  (def actual (musty/render template @{"boolean" true} "res/fixtures/"))
  (is (== expect actual)))

(run-tests!)