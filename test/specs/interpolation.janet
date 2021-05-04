(import testament :prefix "" :exit 1)
(import ../../src/musty :as musty)


(deftest no-interpolation
  (def data
    {})
  (def template
    "Hello from {Mustache}!")
  (def expect
    "Hello from {Mustache}!")
  (is (= expect (musty/render template data))))


(deftest basic-interpolation
  (def data
    {:subject "world"})
  (def template
    "Hello, {{subject}}!")
  (def expect
    "Hello, world!")
  (is (= expect (musty/render template data))))


(deftest html-escaping
  (def data
    {:forbidden `& " < >`})
  (def template
    "These characters should be HTML escaped: {{forbidden}}")
  (def expect
    "These characters should be HTML escaped: &amp; &quot; &lt; &gt;")
  (is (= expect (musty/render template data))))


(deftest triple-mustache
  (def data
    {:forbidden `& " < >`})
  (def template
    "These characters should not be HTML escaped: {{{forbidden}}}")
  (def expect
    "These characters should not be HTML escaped: & \" < >")
  (is (= expect (musty/render template data))))


(deftest ampersand
  (def data
    {:forbidden `& " < >`})
  (def template
    "These characters should not be HTML escaped: {{&forbidden}}")
  (def expect
    "These characters should not be HTML escaped: & \" < >")
  (is (= expect (musty/render template data))))


(deftest basic-integer-interpolation
  (def data
    {:mph 88})
  (def template
    `"{{mph}} miles an hour!"`)
  (def expect
    `"88 miles an hour!"`)
  (is (= expect (musty/render template data))))


(deftest triple-mustache-integer-interpolation
  (def data
    {:mph 88})
  (def template
    `"{{{mph}}} miles an hour!"`)
  (def expect
    `"88 miles an hour!"`)
  (is (= expect (musty/render template data))))


(deftest ampersand-integer-interpolation
  (def data
    {:mph 88})
  (def template
    `"{{&mph}} miles an hour!"`)
  (def expect
    `"88 miles an hour!"`)
  (is (= expect (musty/render template data))))


(deftest basic-decimal-interpolation
  (def data
    {:power 1.210})
  (def template
    `"{{power}} jiggawatts!"`)
  (def expect
    `"1.21 jiggawatts!"`)
  (is (= expect (musty/render template data))))


(deftest triple-mustache-decimal-interpolation
  (def data
    {:power 1.210})
  (def template
    `"{{{power}}} jiggawatts!"`)
  (def expect
    `"1.21 jiggawatts!"`)
  (is (= expect (musty/render template data))))


(deftest ampersande-decimal-interpolation
  (def data
    {:power 1.210})
  (def template
    `"{{&power}} jiggawatts!"`)
  (def expect
    `"1.21 jiggawatts!"`)
  (is (= expect (musty/render template data))))


(deftest basic-context-miss-interpolation
  (def data
    {})
  (def template
    "I ({{cannot}}) be seen!")
  (def expect
    "I () be seen!")
  (is (= expect (musty/render template data))))


(deftest triple-mustache-context-miss-interpolation
  (def data
    {})
  (def template
    "I ({{{cannot}}}) be seen!")
  (def expect
    "I () be seen!")
  (is (= expect (musty/render template data))))


(deftest ampersand-context-miss-interpolation
  (def data
    {})
  (def template
    "I ({{&cannot}}) be seen!")
  (def expect
    "I () be seen!")
  (is (= expect (musty/render template data))))


(deftest dotted-names-basic-interpolation
  (def data
    {:person {:name "Joe"}})
  (def template
    `"{{person.name}}" == "{{#person}}{{name}}{{/person}}"`)
  (def expect
    `"Joe" == "Joe"`)
  (is (= expect (musty/render template data))))


(deftest dotted-names-triple-mustache-interpolation
  (def data
    {:person {:name "Joe"}})
  (def template
    `"{{{person.name}}}" == "{{#person}}{{{name}}}{{/person}}"`)
  (def expect
    `"Joe" == "Joe"`)
  (is (= expect (musty/render template data))))


(deftest dotted-names-triple-ampersand-interpolation
  (def data
    {:person {:name "Joe"}})
  (def template
    `"{{&person.name}}" == "{{#person}}{{&name}}{{/person}}"`)
  (def expect
    `"Joe" == "Joe"`)
  (is (= expect (musty/render template data))))


(deftest dotted-names-arbitrary-depth
  (def data
    {:a {:b {:c {:d {:e {:name "Phil"}}}}}})
  (def template
    `"{{a.b.c.d.e.name}}" == "Phil"`)
  (def expect
    `"Phil" == "Phil"`)
  (is (= expect (musty/render template data))))


(deftest dotted-names-broken-chains
  (def data
    {:a {}})
  (def template
    `"{{a.b.c}}" == ""`)
  (def expect
    `"" == ""`)
  (is (= expect (musty/render template data))))


(deftest dotted-names-broken-chain-resolution
  (def data
    {:a {:b {}}
     :c {:name "Jim"}})
  (def template
    `"{{a.b.c.name}}" == ""`)
  (def expect
    `"" == ""`)
  (is (= expect (musty/render template data))))


(deftest dotted-names-initial-resolution
  (def data
    {:a {:b {:c {:d {:e {:name "Phil"}}}}}
     :b {:c {:d {:e {:name "Wrong"}}}}})
  (def template
    `"{{#a}}{{b.c.d.e.name}}{{/a}}" == "Phil"`)
  (def expect
    `"Phil" == "Phil"`)
  (is (= expect (musty/render template data))))


(deftest dotted-names-context-precedence
  (def data
    {:a {:b {}}
     :b {:c "ERROR"}})
  (def template
    "{{#a}}{{b.c}}{{/a}}")
  (def expect
    "")
  (is (= expect (musty/render template data))))


(deftest interpolation-surrounding-whitespace
  (def data
    {:string "---"})
  (def template
    "| {{string}} |")
  (def expect
    "| --- |")
  (is (= expect (musty/render template data))))


(deftest triple-mustache-surrounding-whitespace
  (def data
    {:string "---"})
  (def template
    "| {{{string}}} |")
  (def expect
    "| --- |")
  (is (= expect (musty/render template data))))


(deftest ampersand-surrounding-whitespace
  (def data
    {:string "---"})
  (def template
    "| {{&string}} |")
  (def expect
    "| --- |")
  (is (= expect (musty/render template data))))


(deftest interpolation-standalone
  (def data
    {:string "---"})
  (def template
    "  {{string}}\n")
  (def expect
    "  ---\n")
  (is (= expect (musty/render template data))))


(deftest triple-mustache-standalone
  (def data
    {:string "---"})
  (def template
    "  {{{string}}}\n")
  (def expect
    "  ---\n")
  (is (= expect (musty/render template data))))


(deftest ampersand-standalone
  (def data
    {:string "---"})
  (def template
    "  {{&string}}\n")
  (def expect
    "  ---\n")
  (is (= expect (musty/render template data))))


(deftest interpolation-with-padding
  (def data
    {:string "---"})
  (def template
    "|{{ string }}|")
  (def expect
    "|---|")
  (is (= expect (musty/render template data))))


(deftest triple-mustache-with-padding
  (def data
    {:string "---"})
  (def template
    "|{{{ string }}}|")
  (def expect
    "|---|")
  (is (= expect (musty/render template data))))


(deftest ampersand-with-padding
  (def data
    {:string "---"})
  (def template
    "|{{& string }}|")
  (def expect
    "|---|")
  (is (= expect (musty/render template data))))


(run-tests!)
