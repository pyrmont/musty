(import testament :prefix "" :exit 1)
(import spork/misc :as spork)
(import src/musty :as musty)


(deftest falsey
  (def data
    {:boolean false})
  (def template
    `"{{^boolean}}This should be rendered.{{/boolean}}"`)
  (def expect
    `"This should be rendered."`)
  (is (= expect (musty/render template data))))


(deftest truthy
  (def data
    {:boolean true})
  (def template
    `"{{^boolean}}This should not be rendered.{{/boolean}}"`)
  (def expect
    `""`)
  (is (= expect (musty/render template data))))


(deftest context
  (def data
    {:context {:name "Joe"}})
  (def template
    `"{{^context}}Hi {{name}}.{{/context}}"`)
  (def expect
    `""`)
  (is (= expect (musty/render template data))))


(deftest list
  (def data
    {:list [ {:n 1} {:n 2} {:n 3}]})
  (def template
    `"{{^list}}{{n}}{{/list}}"`)
  (def expect
    `""`)
  (is (= expect (musty/render template data))))


(deftest empty-list
  (def data
    {:list []})
  (def template
    `"{{^list}}Yay lists!{{/list}}"`)
  (def expect
    `"Yay lists!"`)
  (is (= expect (musty/render template data))))


(deftest doubled
  (def data
    {:bool false :two "second"})
  (def template
    "{{^bool}}\n* first\n{{/bool}}\n* {{two}}\n{{^bool}}\n* third\n{{/bool}}")
  (def expect
    "* first\n* second\n* third\n")
  (is (= expect (musty/render template data))))


(deftest nested-falsey
  (def data
    {:bool false})
  (def template
    "| A {{^bool}}B {{^bool}}C{{/bool}} D{{/bool}} E |")
  (def expect
    "| A B C D E |")
  (is (= expect (musty/render template data))))


(deftest nested-truthy
  (def data
    {:bool true})
  (def template
    "| A {{^bool}}B {{^bool}}C{{/bool}} D{{/bool}} E |")
  (def expect
    "| A  E |")
  (is (= expect (musty/render template data))))


(deftest context-misses
  (def data
    {})
  (def template
    "[{{^missing}}Cannot find key 'missing'!{{/missing}}]")
  (def expect
    "[Cannot find key 'missing'!]")
  (is (= expect (musty/render template data))))


(deftest dotted-names-truthy
  (def data
    {:a {:b {:c true}}})
  (def template
    `"{{^a.b.c}}Not Here{{/a.b.c}}" == ""`)
  (def expect
    `"" == ""`)
  (is (= expect (musty/render template data))))


(deftest dotted-names-falsey
  (def data
    {:a {:b {:c false}}})
  (def template
    `"{{^a.b.c}}Not Here{{/a.b.c}}" == "Not Here"`)
  (def expect
    `"Not Here" == "Not Here"`)
  (is (= expect (musty/render template data))))


(deftest dotted-names-broken-chains
  (def data
    {:a {}})
  (def template
    `"{{^a.b.c}}Not Here{{/a.b.c}}" == "Not Here"`)
  (def expect
    `"Not Here" == "Not Here"`)
  (is (= expect (musty/render template data))))


(deftest surrounding-whitespace
  (def data
    {:boolean false})
  (def template
    " | {{^boolean}}\t|\t{{/boolean}} | \n")
  (def expect
    " | \t|\t | \n")
  (is (= expect (musty/render template data))))


(deftest internal-whitespace
  (def data
    {:boolean false})
  (def template
    " | {{^boolean}} {{! Important Whitespace }}\n {{/boolean}} | \n")
  (def expect
    " |  \n  | \n")
  (is (= expect (musty/render template data))))


(deftest indented-inline-sections
  (def data
    {:boolean false})
  (def template
    " {{^boolean}}NO{{/boolean}}\n {{^boolean}}WAY{{/boolean}}\n")
  (def expect
    " NO\n WAY\n")
  (is (= expect (musty/render template data))))


(deftest standalone-lines
  (def data
    {:boolean false})
  (def template
    "| This Is\n{{^boolean}}\n|\n{{/boolean}}\n| A Line\n")
  (def expect
    "| This Is\n|\n| A Line\n")
  (is (= expect (musty/render template data))))


(deftest standalone-indented-lines
  (def data
    {:boolean false})
  (def template
    "| This Is\n  {{^boolean}}\n|\n  {{/boolean}}\n| A Line\n")
  (def expect
    "| This Is\n|\n| A Line\n")
  (is (= expect (musty/render template data))))


(deftest standalone-line-endings
  (def data
    {:boolean false})
  (def template
    "|\r\n{{^boolean}}\r\n{{/boolean}}\r\n|")
  (def expect
    "|\r\n|")
  (is (= expect (musty/render template data))))


(deftest standalone-without-previous-line
  (def data
    {:boolean false})
  (def template
    "  {{^boolean}}\n^{{/boolean}}\n/")
  (def expect
    "^\n/")
  (is (= expect (musty/render template data))))


(deftest standalone-without-newline
  (def data
    {:boolean false})
  (def template
    "^{{^boolean}}\n/\n  {{/boolean}}")
  (def expect
    "^\n/\n")
  (is (= expect (musty/render template data))))


(deftest padding
  (def data
    {:boolean false})
  (def template
    "|{{^ boolean }}={{/ boolean }}|")
  (def expect
    "|=|")
  (is (= expect (musty/render template data))))


(run-tests!)
