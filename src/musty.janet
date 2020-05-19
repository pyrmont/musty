### Musty

## An incomplete Mustache implementation in Janet

## by Michael Camilleri
## 19 May 2020


(def- messages
  {:section-tag-mismatch
   "Syntax error: The opening and closing section tags do not match"

   :syntax-error
   "Syntax error at index %d: %q"})


(defn- syntax-error
  ```
  Raise a syntax error specifying the `col` and `fragment`
  ```
  [col fragment]
  (error (string/format (messages :syntax-error) col fragment)))


(defn- inverted
  ```
  Return the computed `data` if the tag name in `open-id` and `close-id` does
  not exist
  ```
  [open-id data close-id]
  (unless (= open-id close-id) (error (messages :section-tag-mismatch)))
  ~(let [val (lookup ,(keyword open-id))]
     (if (nil? val)
       ,data
       "")))


(defn- section
  ```
  Return the computed `data` if the tag name in `open-id` and `close-id` exists
  or is a non-empty list

  If the tag represents:

  1. a non-empty list, will concatenate the generated value;
  2. a truthy value, will return the generated value.
  ```
  [open-id data close-id]
  (unless (= open-id close-id) (error (messages :section-tag-mismatch)))
  ~(let [val (lookup ,(keyword open-id))]
     (cond
       (indexed? val)
       (string ;(seq [el :in val
                         :before (array/push ctx el)
                         :after (array/pop ctx)]
                  ,data))

       (dictionary? val)
       (defer (array/pop ctx)
         (array/push ctx val)
         ,data)

       val
       ,data

       :else
       "")))


(defn- variable
  ```
  Return the computed value `x`
  ```
  [x]
  ~(or (lookup ,(keyword x)) ""))


(defn- text
  ```
  Return the text `x`
  ```
  [x]
  x)


(defn- data
  ```
  Concatenate the values `xs`
  ```
  [& xs]
  ~(string ,;xs))


(def- mustache
  ```
  The grammar for Mustache
  ```
  (peg/compile
    ~{:end-or-error (+ -1 (cmt '(* ($) (between 1 10 1)) ,syntax-error))

      :newline (? "\n")

      :identifier (* :w (any (if-not "}}" 1)))

      :partial (* "{{> " :identifier "}}")

      :comments (* "{{!" (any (if-not "}}" 1)) "}}")

      :isec-close (* "{{/" ':identifier "}}")
      :isec-open (* "{{^" ':identifier "}}" :newline)
      :inverted (/ (* :isec-open :data :isec-close) ,inverted)

      :sec-close (* "{{/" ':identifier "}}")
      :sec-open (* "{{#" ':identifier "}}" :newline)
      :section (/ (* :sec-open :data :sec-close) ,section)

      :variable (* "{{" (/ ':identifier ,variable) "}}")

      :tag (+ :variable :section :inverted :comments :partial)

      :text (/ '(some (if-not "{{" 1)) ,text)

      :data (/ (any (+ :tag :text)) ,data)
      :main (* :data :end-or-error)}))


(defn- escape
  ```
  Escape the `str` of HTML entities
  ```
  [str]
  (def translations
    {34 "&quot;"
     38 "&amp;"
     39 "&apos;"
     60 "&lt;"
     62 "&gt;"})
  (def result @"")
  (each byte str
    (if-let [replacement (get translations byte)]
      (buffer/push-string result replacement)
      (buffer/push-byte result byte)))
  (string result))


(defn- lookup
  ```
  Return a lookup function for a context `ctx`
  ```
  [ctx]
  (fn [x]
    (var result nil)
    (loop [i :down-to [(- (length ctx) 1) 0]]
      (when-let [val (get-in ctx [i x])]
        (set result val)
        (break)))
    result))


(defn render
  ```
  Render the Mustache `template` using a dictionary `replacements`

  Musty will translate the Mustache template into a series of Janet expressions
  and then evaluate those expressions to produce a string.. The translation is
  accomplished by way of a parser expression grammar that matches particular
  tags and then causes the tag and its enclosed value to be replaced with the
  relevant Janet expression.

  Musty is a partial implementation of the Mustache specification. It supports
  variable tags, section tags, inverted section tags and comment tags.
  ```
  [template replacements]
  (def output
    (eval
     ~(fn [ctx]
        (let [lookup (,lookup ctx)
              escape ,escape]
          ,;(peg/match mustache template)))))
  (output @[replacements]))
