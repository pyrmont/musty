(use ../deps/testament)
(import ../deps/medea/lib/decode :as json)

(import ../lib/musty)

(deftest falsey
  (def expect
    ``
    "This should be rendered."
    ``)
  (def template
    ``
    "{{^boolean}}This should be rendered.{{/boolean}}"
    ``)
  (def actual (musty/render template @{"boolean" false} :dir "res/fixtures/"))
  (is (== expect actual)))

(deftest truthy
  (def expect
    ``
    ""
    ``)
  (def template
    ``
    "{{^boolean}}This should not be rendered.{{/boolean}}"
    ``)
  (def actual (musty/render template @{"boolean" true} :dir "res/fixtures/"))
  (is (== expect actual)))

(deftest null-is-falsey
  (def expect
    ``
    "This should be rendered."
    ``)
  (def template
    ``
    "{{^null}}This should be rendered.{{/null}}"
    ``)
  (def actual (musty/render template @{"null" nil} :dir "res/fixtures/"))
  (is (== expect actual)))

(deftest context
  (def expect
    ``
    ""
    ``)
  (def template
    ``
    "{{^context}}Hi {{name}}.{{/context}}"
    ``)
  (def actual (musty/render template @{"context" @{"name" "Joe"}} :dir "res/fixtures/"))
  (is (== expect actual)))

(deftest list
  (def expect
    ``
    ""
    ``)
  (def template
    ``
    "{{^list}}{{n}}{{/list}}"
    ``)
  (def actual (musty/render template @{"list" @[@{"n" 1} @{"n" 2} @{"n" 3}]} :dir "res/fixtures/"))
  (is (== expect actual)))

(deftest empty-list
  (def expect
    ``
    "Yay lists!"
    ``)
  (def template
    ``
    "{{^list}}Yay lists!{{/list}}"
    ``)
  (def actual (musty/render template @{"list" @[]} :dir "res/fixtures/"))
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
    {{^bool}}
    * first
    {{/bool}}
    * {{two}}
    {{^bool}}
    * third
    {{/bool}}
    
    ``)
  (def actual (musty/render template @{"bool" false "two" "second"} :dir "res/fixtures/"))
  (is (== expect actual)))

(deftest nested-_falsey_
  (def expect
    ``
    | A B C D E |
    ``)
  (def template
    ``
    | A {{^bool}}B {{^bool}}C{{/bool}} D{{/bool}} E |
    ``)
  (def actual (musty/render template @{"bool" false} :dir "res/fixtures/"))
  (is (== expect actual)))

(deftest nested-_truthy_
  (def expect
    ``
    | A  E |
    ``)
  (def template
    ``
    | A {{^bool}}B {{^bool}}C{{/bool}} D{{/bool}} E |
    ``)
  (def actual (musty/render template @{"bool" true} :dir "res/fixtures/"))
  (is (== expect actual)))

(deftest context-misses
  (def expect
    ``
    [Cannot find key 'missing'!]
    ``)
  (def template
    ``
    [{{^missing}}Cannot find key 'missing'!{{/missing}}]
    ``)
  (def actual (musty/render template @{} :dir "res/fixtures/"))
  (is (== expect actual)))

(deftest dotted-names---truthy
  (def expect
    ``
    "" == ""
    ``)
  (def template
    ``
    "{{^a.b.c}}Not Here{{/a.b.c}}" == ""
    ``)
  (def actual (musty/render template @{"a" @{"b" @{"c" true}}} :dir "res/fixtures/"))
  (is (== expect actual)))

(deftest dotted-names---falsey
  (def expect
    ``
    "Not Here" == "Not Here"
    ``)
  (def template
    ``
    "{{^a.b.c}}Not Here{{/a.b.c}}" == "Not Here"
    ``)
  (def actual (musty/render template @{"a" @{"b" @{"c" false}}} :dir "res/fixtures/"))
  (is (== expect actual)))

(deftest dotted-names---broken-chains
  (def expect
    ``
    "Not Here" == "Not Here"
    ``)
  (def template
    ``
    "{{^a.b.c}}Not Here{{/a.b.c}}" == "Not Here"
    ``)
  (def actual (musty/render template @{"a" @{}} :dir "res/fixtures/"))
  (is (== expect actual)))

(deftest surrounding-whitespace
  (def expect
    ``
     | 	|	 | 
    
    ``)
  (def template
    ``
     | {{^boolean}}	|	{{/boolean}} | 
    
    ``)
  (def actual (musty/render template @{"boolean" false} :dir "res/fixtures/"))
  (is (== expect actual)))

(deftest internal-whitespace
  (def expect
    ``
     |  
      | 
    
    ``)
  (def template
    ``
     | {{^boolean}} {{! Important Whitespace }}
     {{/boolean}} | 
    
    ``)
  (def actual (musty/render template @{"boolean" false} :dir "res/fixtures/"))
  (is (== expect actual)))

(deftest indented-inline-sections
  (def expect
    ``
     NO
     WAY
    
    ``)
  (def template
    ``
     {{^boolean}}NO{{/boolean}}
     {{^boolean}}WAY{{/boolean}}
    
    ``)
  (def actual (musty/render template @{"boolean" false} :dir "res/fixtures/"))
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
    {{^boolean}}
    |
    {{/boolean}}
    | A Line
    
    ``)
  (def actual (musty/render template @{"boolean" false} :dir "res/fixtures/"))
  (is (== expect actual)))

(deftest standalone-indented-lines
  (def expect
    ``
    | This Is
    |
    | A Line
    
    ``)
  (def template
    ``
    | This Is
      {{^boolean}}
    |
      {{/boolean}}
    | A Line
    
    ``)
  (def actual (musty/render template @{"boolean" false} :dir "res/fixtures/"))
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
    {{^boolean}}
    {{/boolean}}
    |
    ``)
  (def actual (musty/render template @{"boolean" false} :dir "res/fixtures/"))
  (is (== expect actual)))

(deftest standalone-without-previous-line
  (def expect
    ``
    ^
    /
    ``)
  (def template
    ``
      {{^boolean}}
    ^{{/boolean}}
    /
    ``)
  (def actual (musty/render template @{"boolean" false} :dir "res/fixtures/"))
  (is (== expect actual)))

(deftest standalone-without-newline
  (def expect
    ``
    ^
    /
    
    ``)
  (def template
    ``
    ^{{^boolean}}
    /
      {{/boolean}}
    ``)
  (def actual (musty/render template @{"boolean" false} :dir "res/fixtures/"))
  (is (== expect actual)))

(deftest padding
  (def expect
    ``
    |=|
    ``)
  (def template
    ``
    |{{^ boolean }}={{/ boolean }}|
    ``)
  (def actual (musty/render template @{"boolean" false} :dir "res/fixtures/"))
  (is (== expect actual)))

(run-tests!)