(use ../deps/testament)
(import ../deps/medea/lib/decode :as json)

(import ../lib/musty)

(deftest inline
  (def expect
    ``
    1234567890
    ``)
  (def template
    ``
    12345{{! Comment Block! }}67890
    ``)
  (def actual (musty/render template @{} "res/fixtures/"))
  (is (== expect actual)))

(deftest multiline
  (def expect
    ``
    1234567890
    
    ``)
  (def template
    ``
    12345{{!
      This is a
      multi-line comment...
    }}67890
    
    ``)
  (def actual (musty/render template @{} "res/fixtures/"))
  (is (== expect actual)))

(deftest standalone
  (def expect
    ``
    Begin.
    End.
    
    ``)
  (def template
    ``
    Begin.
    {{! Comment Block! }}
    End.
    
    ``)
  (def actual (musty/render template @{} "res/fixtures/"))
  (is (== expect actual)))

(deftest indented-standalone
  (def expect
    ``
    Begin.
    End.
    
    ``)
  (def template
    ``
    Begin.
      {{! Indented Comment Block! }}
    End.
    
    ``)
  (def actual (musty/render template @{} "res/fixtures/"))
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
    {{! Standalone Comment }}
    |
    ``)
  (def actual (musty/render template @{} "res/fixtures/"))
  (is (== expect actual)))

(deftest standalone-without-previous-line
  (def expect
    ``
    !
    ``)
  (def template
    ``
      {{! I'm Still Standalone }}
    !
    ``)
  (def actual (musty/render template @{} "res/fixtures/"))
  (is (== expect actual)))

(deftest standalone-without-newline
  (def expect
    ``
    !
    
    ``)
  (def template
    ``
    !
      {{! I'm Still Standalone }}
    ``)
  (def actual (musty/render template @{} "res/fixtures/"))
  (is (== expect actual)))

(deftest multiline-standalone
  (def expect
    ``
    Begin.
    End.
    
    ``)
  (def template
    ``
    Begin.
    {{!
    Something's going on here...
    }}
    End.
    
    ``)
  (def actual (musty/render template @{} "res/fixtures/"))
  (is (== expect actual)))

(deftest indented-multiline-standalone
  (def expect
    ``
    Begin.
    End.
    
    ``)
  (def template
    ``
    Begin.
      {{!
        Something's going on here...
      }}
    End.
    
    ``)
  (def actual (musty/render template @{} "res/fixtures/"))
  (is (== expect actual)))

(deftest indented-inline
  (def expect
    ``
      12 
    
    ``)
  (def template
    ``
      12 {{! 34 }}
    
    ``)
  (def actual (musty/render template @{} "res/fixtures/"))
  (is (== expect actual)))

(deftest surrounding-whitespace
  (def expect
    ``
    12345  67890
    ``)
  (def template
    ``
    12345 {{! Comment Block! }} 67890
    ``)
  (def actual (musty/render template @{} "res/fixtures/"))
  (is (== expect actual)))

(deftest variable-name-collision
  (def expect
    ``
    comments never show: ><
    ``)
  (def template
    ``
    comments never show: >{{! comment }}<
    ``)
  (def actual (musty/render template @{"!comment" 3 "! comment " 2 "! comment" 1 "comment" 4} "res/fixtures/"))
  (is (== expect actual)))

(run-tests!)