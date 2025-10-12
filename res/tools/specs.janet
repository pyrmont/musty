(import ../../deps/medea/lib/decode :as json)

(os/execute ["res/tools/specs.sh"])

(def s (get {:windows "\\" :mingw "\\" :cygwin "\\"} (os/which) "/"))
(def specs-dir "res/specs")

(def header
  ```
  (use ../deps/testament)
  (import ../deps/medea/lib/decode :as json)

  (import ../lib/musty)
  ```)

(def footer
  ```
  (run-tests!)
  ```)

(def deftest-template
  ```
  (deftest NAME
    (def expect
      ``
      EXPECT
      ``)
    (def template
      ``
      TEMPLATE
      ``)
    (def actual (musty/render template DATA "res/fixtures/"))
    (is (== expect actual)))
  ```)

(each entry (os/dir specs-dir)
  (def entry-name (string/slice entry 0 -6))
  (unless (or (= "LICENSE" entry) (string/has-prefix? "~" entry))
    (def output @"")
    (buffer/push output header "\n\n")
    (def contents (slurp (string specs-dir s entry)))
    (def data (json/decode contents))
    (each t (get data "tests")
      (def test-name (->> (get t "name")
                          (string/replace-all " " "-")
                          (string/replace-all "(" "_")
                          (string/replace-all ")" "_")
                          (string/ascii-lower)))
      (def data (->> (get t "data")
                     (string/format "%j")
                     (string/replace-all ":null" "nil")))
      (def expected (->> (get t "expected")
                         (string/replace-all "\n" "\n    ")))
      (def partials (get t "partials" {}))
      (eachp [p-name p-contents] partials
        (def prefix (string entry-name "_" test-name "_"))
        (def new-name (string prefix p-name))
        (def path (string "res/fixtures/" new-name ".mustache"))
        (def contents (string/replace-all "{{>" (string "{{>" prefix) p-contents))
        (spit path contents)
        (def template (->> (get t "template")
                           (string/replace-all (string ">" p-name) (string ">" new-name))
                           (string/replace-all (string "> " p-name) (string "> " new-name))))
        (put t "template" template))
      (def template (->> (get t "template")
                         (string/replace-all "\n" "\n    ")))
      (def def-str (->> deftest-template
                        (string/replace "NAME" (symbol test-name))
                        (string/replace "EXPECT" expected)
                        (string/replace "TEMPLATE" template)
                        (string/replace "DATA" data)))
      (buffer/push output def-str "\n\n"))
    (buffer/push output footer)
    (spit (string "test" s (string/replace ".json" ".janet" entry)) (string output))))

(print "Generated test files into ./test")
