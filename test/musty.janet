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


(deftest no-tags
  (is (= "This is a test." (musty/render "This is a test." {}))))


(deftest single-variable
  (is (= "This is a test template." (musty/render simple-template {:simple "test"}))))


(deftest multiple-variables
  (is (= "1 2" (musty/render "{{var1}} {{var2}}" {:var1 "1" :var2 "2"}))))


(deftest section-replacement
  (def expected
    (string "This is a\n  \n  "
            "section on the outside.\n\n  "
            "This is not matching.\n"))
  (is (= expected (musty/render complex-template {:very true}))))


(deftest nested-section-replacement
  (def expected
    (string "This is a\n      "
            "nested expression and another\n      "
            "nested expression and a\n  \n  "
            "section on the outside.\n\n"))
  (is (= expected (musty/render complex-template {:title "nested"
                                                  :very {:nested [{:expression "expression and another"}
                                                                  {:expression "expression and a"}]}
                                                  :matching true}))))


(deftest throws-error
  (is (thrown? (musty/render "This is an error, right {{" {}))))


(run-tests!)
