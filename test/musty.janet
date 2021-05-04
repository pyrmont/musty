(import testament :prefix "" :exit 1)
(import spork/misc :as spork)
(import ../src/musty :as musty)


(def simple-template
  "This is a {{simple}} template.")


(def complex-template
  (spork/dedent
    ```
    This is a
    {{#very}}
      {{#nested}}
        {{title}} {{expression}}
      {{/nested}}
      section on the outside.
    {{/very}}
    {{^matching}}
      This is not matching.
    {{/matching}}
    ```))


(deftest no-tags
  (is (= "This is a test." (musty/render "This is a test." {}))))


(deftest single-variable
  (is (= "This is a test template." (musty/render simple-template {:simple "test"}))))


(deftest multiple-variables
  (is (= "1 2" (musty/render "{{var1}} {{var2}}" {:var1 "1" :var2 "2"}))))


(deftest section-replacement
  (def expected
    (string "This is a\n  "
            "section on the outside.\n  "
            "This is not matching.\n"))
  (is (= expected (musty/render complex-template {:very true}))))


(deftest nested-section-replacement
  (def expected
    (string "This is a\n    "
            "nested expression and another\n    "
            "nested expression and a\n  "
            "section on the outside.\n"))
  (is (= expected (musty/render complex-template {:title "nested"
                                                  :very {:nested [{:expression "expression and another"}
                                                                  {:expression "expression and a"}]}
                                                  :matching true}))))


(deftest throws-error
  (def message "Syntax error at index 24: \"{{\"")
  (is (thrown? message (musty/render "This is an error, right {{" {})))
  (def message2 "Syntax error at index 11: \"{{ error }\"")
  (is (thrown? message2 (musty/render "This is an {{ error } right" {}))))


(deftest escape-html
  (is (= "&lt;html&gt;" (musty/render "{{tag}}" {:tag "<html>"}))))


(deftest unescape-html
  (is (= "<html>" (musty/render "{{{tag}}}" {:tag "<html>"})))
  (is (= "<html>" (musty/render "{{&tag}}" {:tag "<html>"}))))


(deftest padding
  (is (= "world" (musty/render "{{ hello }}" {:hello "world"}))))


(deftest interpolation
  (is (= "1.21 jiggawatts!" (musty/render "{{power}} jiggawatts!" {:power 1.210}))))


(run-tests!)
