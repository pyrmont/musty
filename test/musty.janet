(import testament :prefix "" :exit 1)
(import spork/misc :as spork)
(import src/musty :as musty)


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

(deftest no-replacements
  (is (= "This is a test." (musty/render "This is a test." {}))))


(deftest variable-replacement
  (is (= "This is a test template." (musty/render simple-template {:simple "test"}))))


(deftest section-replacement
  (def expect "This is a\n\n  \n  section on the outside.\n\n\n  This is not matching.\n")
  (is (= expect (musty/render complex-template {:very true}))))


(deftest nested-section-replacement
  (def expect "This is a\n\n  \n    nested expression and another\n  \n    nested expression and a\n  \n  section on the outside.\n\n")
  (is (= expect (musty/render complex-template {:title "nested"
                                                :very {:nested [{:expression "expression and another"}
                                                                {:expression "expression and a"}]}
                                                :matching true}))))


(run-tests!)
