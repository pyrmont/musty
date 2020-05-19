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
  ~(let [val (lookup ,open-id)]
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
  Return the HTML-escaped computed value `x`
  ```
  [x &keys {:escape? escape?}]
  (default escape? true)
  ~(let [val (-> ,x lookup (or "") string)]
     (if ,escape? (escape val) val)))


(defn- variable-unescaped
  ```
  Return the unescaped computer value `x`
  ```
  [x]
  (variable x :escape? false))


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

      :identifier (* :s* :w (any (if-not (set "{}") :S)) :s*)

      :partial (* "{{> " :identifier "}}")

      :comments (* "{{!" (any (if-not "}}" 1)) "}}")

      :isec-close (* "{{/" ':identifier "}}")
      :isec-open (* "{{^" ':identifier "}}" :newline)
      :inverted (/ (* :isec-open :data :isec-close) ,inverted)

      :sec-close (* "{{/" ':identifier "}}")
      :sec-open (* "{{#" ':identifier "}}" :newline)
      :section (/ (* :sec-open :data :sec-close) ,section)

      :unescape-variable-ampersand (* "{{&" (/ ':identifier ,variable-unescaped) "}}")
      :unescape-variable-triple (* "{{{" (/ ':identifier ,variable-unescaped) "}}}")
      :variable (* "{{" (/ ':identifier ,variable) "}}")

      :tag (+ :variable :unescape-variable-triple :unescape-variable-ampersand
              :section :inverted
              :comments :partial)

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


(defn- lookup-fn
  ```
  Return a lookup function for a context `ctx`
  ```
  [ctx]
  (fn lookup [x]
    (def ks (->> x string/trim (string/split ".") (map keyword)))
    (var result nil)
    (loop [i :down-to [(- (length ctx) 1) 0]]
      (when-let [val (get-in ctx [i ;ks])]
        (set result val)
        (break))
      (if (and (> (length ks) 1) (get-in ctx [i ;(slice ks 0 -2)]))
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
        (let [lookup (,lookup-fn ctx)
              escape ,escape]
          ,;(peg/match mustache template)))))
  (output @[replacements]))
