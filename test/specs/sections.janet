(import testament :prefix "" :exit 1)
(import src/musty :as musty)


(deftest truthy
  (def data
    {:boolean true})
  (def template
    `"{{#boolean}}This should be rendered.{{/boolean}}"`)
  (def expect
    `"This should be rendered."`)
  (is (= expect (musty/render template data))))


(deftest falsey
  (def data
    {:boolean false})
  (def template
    `"{{#boolean}}This should not be rendered.{{/boolean}}"`)
  (def expect
    `""`)
  (is (= expect (musty/render template data))))


(deftest context
  (def data
    {:context {:name "Joe"}})
  (def template
    `"{{#context}}Hi {{name}}.{{/context}}"`)
  (def expect
    `"Hi Joe."`)
  (is (= expect (musty/render template data))))


(deftest deeply-nested-contexts
  (def data
    {:a {:one 1}
     :b {:two 2}
     :c {:three 3}
     :d {:four 4}
     :e {:five 5}})
  (def template
    "{{#a}}\n{{one}}\n{{#b}}\n{{one}}{{two}}{{one}}\n{{#c}}\n{{one}}{{two}}{{three}}{{two}}{{one}}\n{{#d}}\n{{one}}{{two}}{{three}}{{four}}{{three}}{{two}}{{one}}\n{{#e}}\n{{one}}{{two}}{{three}}{{four}}{{five}}{{four}}{{three}}{{two}}{{one}}\n{{/e}}\n{{one}}{{two}}{{three}}{{four}}{{three}}{{two}}{{one}}\n{{/d}}\n{{one}}{{two}}{{three}}{{two}}{{one}}{{/c}}\n{{one}}{{two}}{{one}}\n{{/b}}\n{{one}}\n{{/a}}\n")
  (def expect
    "1\n121\n12321\n1234321\n123454321\n1234321\n12321\n121\n1\n")
  (is (= expect (musty/render template data))))


(deftest list
  (def data
    {:list [ {:item 1} {:item 2} {:item 3}]})
  (def template
    `"{{#list}}{{item}}{{/list}}"`)
  (def expect
    `"123"`)
  (is (= expect (musty/render template data))))


(deftest empty-list
  (def data
    {:list []})
  (def template
    `"{{#list}}Yay lists!{{/list}}"`)
  (def expect
    `""`)
  (is (= expect (musty/render template data))))


(deftest doubled
  (def data
    {:bool true :two "second"})
  (def template
    "{{#bool}}\n* first\n{{/bool}}\n* {{two}}\n{{#bool}}\n* third\n{{/bool}}")
  (def expect
    "* first\n* second\n* third\n")
  (is (= expect (musty/render template data))))


(deftest nested-truthy
  (def data
    {:bool true})
  (def template
    "| A {{#bool}}B {{#bool}}C{{/bool}} D{{/bool}} E |")
  (def expect
    "| A B C D E |")
  (is (= expect (musty/render template data))))


(deftest nested-falsey
  (def data
    {:bool false})
  (def template
    "| A {{#bool}}B {{#bool}}C{{/bool}} D{{/bool}} E |")
  (def expect
    "| A  E |")
  (is (= expect (musty/render template data))))


(deftest context-misses
  (def data
    {})
  (def template
    "[{{#missing}}Cannot find key 'missing'!{{/missing}}]")
  (def expect
    "[]")
  (is (= expect (musty/render template data))))


(deftest implicit-iterator-string
  (def data
    {:list ["a" "b" "c" "d" "e"]})
  (def template
    `"{{#list}}({{.}}){{/list}}"`)
  (def expect
    `"(a)(b)(c)(d)(e)"`)
  (is (= expect (musty/render template data))))


(deftest implicit-iterator-integer
  (def data
    {:list [1 2 3 4 5]})
  (def template
    `"{{#list}}({{.}}){{/list}}"`)
  (def expect
    `"(1)(2)(3)(4)(5)"`)
  (is (= expect (musty/render template data))))


(deftest implicit-iterator-decimal
  (def data
    {:list [1.10 2.20 3.30 4.40 5.50]})
  (def template
    `"{{#list}}({{.}}){{/list}}"`)
  (def expect
    `"(1.1)(2.2)(3.3)(4.4)(5.5)"`)
  (is (= expect (musty/render template data))))


(deftest implicit-iterator-array
  (def data
    {:list [[1 2 3] ["a" "b" "c"]]})
  (def template
    `"{{#list}}({{#.}}{{.}}{{/.}}){{/list}}"`)
  (def expect
    `"(123)(abc)"`)
  (is (= expect (musty/render template data))))


(deftest dotted-names-truthy
  (def data
    {:a {:b {:c true}}})
  (def template
    `"{{#a.b.c}}Here{{/a.b.c}}" == "Here"`)
  (def expect
    `"Here" == "Here"`)
  (is (= expect (musty/render template data))))


(deftest dotted-names-falsey
  (def data
    {:a {:b {:c false}}})
  (def template
    `"{{#a.b.c}}Here{{/a.b.c}}" == ""`)
  (def expect
    `"" == ""`)
  (is (= expect (musty/render template data))))


(deftest dotted-names-broken-chains
  (def data
    {:a {}})
  (def template
    `"{{#a.b.c}}Here{{/a.b.c}}" == ""`)
  (def expect
    `"" == ""`)
  (is (= expect (musty/render template data))))


(deftest surrounding-whitespace
  (def data
    {:boolean true})
  (def template
    " | {{#boolean}}\t|\t{{/boolean}} | \n")
  (def expect
    " | \t|\t | \n")
  (is (= expect (musty/render template data))))


(deftest internal-whitespace
  (def data
    {:boolean true})
  (def template
    " | {{#boolean}} {{! Important Whitespace }}\n {{/boolean}} | \n")
  (def expect
    " |  \n  | \n")
  (is (= expect (musty/render template data))))


(deftest indented-inline-sections
  (def data
    {:boolean true})
  (def template
    " {{#boolean}}YES{{/boolean}}\n {{#boolean}}GOOD{{/boolean}}\n")
  (def expect
    " YES\n GOOD\n")
  (is (= expect (musty/render template data))))


(deftest standalone-lines
  (def data
    {:boolean true})
  (def template
    "| This Is\n{{#boolean}}\n|\n{{/boolean}}\n| A Line\n")
  (def expect
    "| This Is\n|\n| A Line\n")
  (is (= expect (musty/render template data))))


(deftest standalone-indented-lines
  (def data
    {:boolean true})
  (def template
    "| This Is\n  {{#boolean}}\n|\n  {{/boolean}}\n| A Line\n")
  (def expect
    "| This Is\n|\n| A Line\n")
  (is (= expect (musty/render template data))))


(deftest standalone-line-endings
  (def data
    {:boolean true})
  (def template
    "|\r\n{{#boolean}}\r\n{{/boolean}}\r\n|")
  (def expect
    "|\r\n|")
  (is (= expect (musty/render template data))))


(deftest standalone-without-previous-line
  (def data
    {:boolean true})
  (def template
    "  {{#boolean}}\n^{{/boolean}}\n/")
  (def expect
    "^\n/")
  (is (= expect (musty/render template data))))


(deftest standalone-without-newline
  (def data
    {:boolean true})
  (def template
    "^{{#boolean}}\n/\n  {{/boolean}}")
  (def expect
    "^\n/\n")
  (is (= expect (musty/render template data))))


(deftest padding
  (def data
    {:boolean true})
  (def template
    "|{{# boolean }}={{/ boolean }}|")
  (def expect
    "|=|")
  (is (= expect (musty/render template data))))


(run-tests!)
