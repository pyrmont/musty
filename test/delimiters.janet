(use ../deps/testament)
(import ../deps/medea/lib/decode :as json)

(import ../lib/musty)

(deftest pair-behavior
  (def expect
    ``
    (Hey!)
    ``)
  (def template
    ``
    {{=<% %>=}}(<%text%>)
    ``)
  (def actual (musty/render template @{"text" "Hey!"} :dir "res/fixtures/"))
  (is (== expect actual)))

(deftest special-characters
  (def expect
    ``
    (It worked!)
    ``)
  (def template
    ``
    ({{=[ ]=}}[text])
    ``)
  (def actual (musty/render template @{"text" "It worked!"} :dir "res/fixtures/"))
  (is (== expect actual)))

(deftest sections
  (def expect
    ``
    [
      I got interpolated.
      |data|
    
      {{data}}
      I got interpolated.
    ]
    
    ``)
  (def template
    ``
    [
    {{#section}}
      {{data}}
      |data|
    {{/section}}
    
    {{= | | =}}
    |#section|
      {{data}}
      |data|
    |/section|
    ]
    
    ``)
  (def actual (musty/render template @{"section" true "data" "I got interpolated."} :dir "res/fixtures/"))
  (is (== expect actual)))

(deftest inverted-sections
  (def expect
    ``
    [
      I got interpolated.
      |data|
    
      {{data}}
      I got interpolated.
    ]
    
    ``)
  (def template
    ``
    [
    {{^section}}
      {{data}}
      |data|
    {{/section}}
    
    {{= | | =}}
    |^section|
      {{data}}
      |data|
    |/section|
    ]
    
    ``)
  (def actual (musty/render template @{"section" false "data" "I got interpolated."} :dir "res/fixtures/"))
  (is (== expect actual)))

(deftest partial-inheritence
  (def expect
    ``
    [ .yes. ]
    [ .yes. ]
    
    ``)
  (def template
    ``
    [ {{>delimiters_partial-inheritence_include}} ]
    {{= | | =}}
    [ |>delimiters_partial-inheritence_include| ]
    
    ``)
  (def actual (musty/render template @{"value" "yes"} :dir "res/fixtures/"))
  (is (== expect actual)))

(deftest post-partial-behavior
  (def expect
    ``
    [ .yes.  .yes. ]
    [ .yes.  .|value|. ]
    
    ``)
  (def template
    ``
    [ {{>delimiters_post-partial-behavior_include}} ]
    [ .{{value}}.  .|value|. ]
    
    ``)
  (def actual (musty/render template @{"value" "yes"} :dir "res/fixtures/"))
  (is (== expect actual)))

(deftest surrounding-whitespace
  (def expect
    ``
    |  |
    ``)
  (def template
    ``
    | {{=@ @=}} |
    ``)
  (def actual (musty/render template @{} :dir "res/fixtures/"))
  (is (== expect actual)))

(deftest outlying-whitespace-_inline_
  (def expect
    ``
     | 
    
    ``)
  (def template
    ``
     | {{=@ @=}}
    
    ``)
  (def actual (musty/render template @{} :dir "res/fixtures/"))
  (is (== expect actual)))

(deftest standalone-tag
  (def expect
    ``
    Begin.
    End.
    
    ``)
  (def template
    ``
    Begin.
    {{=@ @=}}
    End.
    
    ``)
  (def actual (musty/render template @{} :dir "res/fixtures/"))
  (is (== expect actual)))

(deftest indented-standalone-tag
  (def expect
    ``
    Begin.
    End.
    
    ``)
  (def template
    ``
    Begin.
      {{=@ @=}}
    End.
    
    ``)
  (def actual (musty/render template @{} :dir "res/fixtures/"))
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
    {{= @ @ =}}
    |
    ``)
  (def actual (musty/render template @{} :dir "res/fixtures/"))
  (is (== expect actual)))

(deftest standalone-without-previous-line
  (def expect
    ``
    =
    ``)
  (def template
    ``
      {{=@ @=}}
    =
    ``)
  (def actual (musty/render template @{} :dir "res/fixtures/"))
  (is (== expect actual)))

(deftest standalone-without-newline
  (def expect
    ``
    =
    
    ``)
  (def template
    ``
    =
      {{=@ @=}}
    ``)
  (def actual (musty/render template @{} :dir "res/fixtures/"))
  (is (== expect actual)))

(deftest pair-with-padding
  (def expect
    ``
    ||
    ``)
  (def template
    ``
    |{{= @   @ =}}|
    ``)
  (def actual (musty/render template @{} :dir "res/fixtures/"))
  (is (== expect actual)))

(run-tests!)