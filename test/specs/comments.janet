(import testament :prefix "" :exit 1)
(import spork/misc :as spork)
(import src/musty :as musty)


(deftest inline
  (def data
    {})
  (def template
    "12345{{! Comment Block! }}67890")
  (def expect
    "1234567890")
  (is (= expect (musty/render template data))))


(deftest multiline
  (def data
    {})
  (def template
    "12345{{!\n   This is a\n   multi-line comment}}67890")
  (def expect
    "1234567890")
  (is (= expect (musty/render template data))))


(deftest standalone
  (def data
    {})
  (def template
    "Begin.\n{{! Comment Block! }}\nEnd.")
  (def expect
    "Begin.\nEnd.")
  (is (= expect (musty/render template data))))


(deftest indented-standalone
  (def data
    {})
  (def template
    "Begin.\n  {{! Indented Comment Block! }}\nEnd.")
  (def expect
    "Begin.\nEnd.")
  (is (= expect (musty/render template data))))


(deftest standalone-line-endings
  (def data
    {})
  (def template
    "|\r\n{{! Standalone Comment }}\r\n|")
  (def expect
    "|\r\n|")
  (is (= expect (musty/render template data))))


(deftest standalone-without-previous-line
  (def data
    {})
  (def template
    "  {{! I'm Still Standalone }}\n!")
  (def expect
    "!")
  (is (= expect (musty/render template data))))


(deftest standalone-without-newline
  (def data
    {})
  (def template
    "!\n  {{! I'm Still Standalone }}")
  (def expect
    "!\n")
  (is (= expect (musty/render template data))))


(deftest multiline-standalone
  (def data
    {})
  (def template
    "Begin.\n{{!\nSomething's going on here...\n}}End.")
  (def expect
    "Begin.\nEnd.")
  (is (= expect (musty/render template data))))


(deftest indented-multiline-standalone
  (def data
    {})
  (def template
    "Begin.\n  {{!\n    Something's going on here...\n  }}\nEnd.")
  (def expect
    "Begin.\nEnd.")
  (is (= expect (musty/render template data))))


(deftest indented-inline
  (def data
    {})
  (def template
    "  12 {{! 34 }}\n")
  (def expect
    "  12 \n")
  (is (= expect (musty/render template data))))


(deftest surrounding-whitespace
  (def data
    {})
  (def template
    "12345 {{! Comment Block! }} 67890")
  (def expect
    "12345  67890")
  (is (= expect (musty/render template data))))


(run-tests!)
