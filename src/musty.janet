(def- messages
  {:section-tag-mismatch
   "Syntax error: The opening and closing section tags do not match"

   :syntax-error
   "Syntax error at index %d: %q"})


(defn- syntax-error
  [col fragment]
  (error (string/format (messages :syntax-error) col fragment)))


(defn- inverted
  [open-id data close-id]
  (unless (= open-id close-id) (error (messages :section-tag-mismatch)))
  ~(let [val (lookup ,(keyword open-id))]
     (if (nil? val)
       ,data
       "")))


(defn- section
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
  [x]
  ~(or (lookup ,(keyword x)) ""))


(defn- text
  [x]
  x)


(defn- data
  [& xs]
  ~(string ,;xs))


(def- mustache
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


(defn render
  [template replacements]
  (def output
    (eval
     ~(fn [ctx]
        (let [lookup (fn [x]
                       (var result nil)
                       (loop [i :down-to [(- (length ctx) 1) 0]]
                         (when-let [val (get-in ctx [i x])]
                           (set result val)
                           (break)))
                       result)]
          ,;(peg/match mustache template)))))
  (output @[replacements]))
