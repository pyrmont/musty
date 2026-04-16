(defn- escape [s]
  (def num-bytes (length s))
  (def b (buffer/new num-bytes))
  (var i 0)
  (while (< i num-bytes)
    (def c (get s i))
    (buffer/push b (cond
                     (= c 0x08)
                     "\\b"
                     (= c 0x09)
                     "\\t"
                     (= c 0x0A)
                     "\\n"
                     (= c 0x0C)
                     "\\f"
                     (= c 0x0D)
                     "\\r"
                     (= c 0x22)
                     "\\\""
                     (= c 0x5C)
                     "\\\\"
                     (< c 0x20)
                     (string/format "\\u%04x" c)
                     # 1-byte variant (0xxxxxxx)
                     (< c 0x80)
                     c
                     # 2-byte variant (110xxxxx 10xxxxxx)
                     (< 0xBF c 0xE0)
                     (string/format "\\u%04x"
                                    (bor (blshift (band c 0x1F) 6)
                                         (band (get s (++ i)) 0x3F)))
                     # 3-byte variant (1110xxxx 10xxxxxx 10xxxxxx)
                     (< c 0xF0)
                     (string/format "\\u%04x"
                                    (bor (blshift (band c 0x0F) 12)
                                         (blshift (band (get s (++ i)) 0x3F) 6)
                                         (band (get s (++ i)) 0x3F)))
                     # 4-byte variant (11110xxx 10xxxxxx 10xxxxxx 10xxxxxx)
                     (< c 0xF8)
                     (do
                       (def cp (bor (blshift (band c 0x07) 18)
                                    (blshift (band (get s (++ i)) 0x3F) 12)
                                    (blshift (band (get s (++ i)) 0x3F) 6)
                                    (band (get s (++ i)) 0x3F)))
                       (def hi (+ (brshift (- cp 0x10000) 10) 0xd800))
                       (def lo (+ (band (- cp 0x10000) 0x3ff) 0xdc00))
                       (string/format "\\u%04x\\u%04x" hi lo))
                     (error (string "invalid byte:" c))))
    (++ i))
  b)


(defn encode
  ```
  Encodes a native Janet data structure into JSON
  ```
  [data &keys {:pretty? pretty?}]
  (default pretty? false)
  (var res @"")
  (var first? true)
  (var col 0)
  (def indents @[])
  (def close-arr @"")
  (def close-obj @"")
  (def kv? @"")
  (def visiting @{})
  (def processing @[data])

  # Helper to write and track column position
  (defn write [& args]
    (each s args
      (buffer/push res s)
      (def str (string s))
      (if-let [nl-pos (string/find "\n" str)]
        # Contains newline - column is length after last newline
        (let [parts (string/split "\n" str)
              last-part (last parts)]
          (set col (length last-part)))
        # No newline - increment column
        (+= col (length str)))))

  (while (not (empty? processing))
    (def item (array/pop processing))
    (case item
      close-arr
      (do
        (def obj (array/pop processing))
        (put visiting obj nil)
        (when pretty?
          (array/pop indents))
        (write "]"))

      close-obj
      (do
        (def obj (array/pop processing))
        (put visiting obj nil)
        (when pretty?
          (array/pop indents))
        (write "}"))

      (do
        (if first?
          (set first? false)
          (do
            (write ",")
            (when pretty?
              (write "\n" (string/repeat " " (last indents))))))
        (cond
          (= kv? item)
          (do
            (set first? true)
            (def kv (array/pop processing))
            (array/push processing (kv 1))
            (write `"` (escape (kv 0)) `":`))

          (indexed? item)
          (do
            (when (get visiting item)
              (error "circular reference detected"))
            (put visiting item true)
            (set first? true)
            (array/push processing item)
            (array/push processing close-arr)
            (def new-length (+ (length processing) (length item)))
            (array/ensure processing new-length 1)
            (var i new-length)
            (each el item
              (put processing (-- i) el))
            (write "[")
            (when pretty?
              (array/push indents col)))

          (dictionary? item)
          (do
            (when (get visiting item)
              (error "circular reference detected"))
            (put visiting item true)
            (set first? true)
            (array/push processing item)
            (array/push processing close-obj)
            (eachp kv item
              (array/push processing kv)
              (array/push processing kv?))
            (write "{")
            (when pretty?
              (array/push indents col)))

          (= :null item)
          (write "null")

          (and (bytes? item) (not (symbol? item)))
          (write `"` (escape item) `"`)

          (number? item)
          (write (describe item))

          (true? item)
          (write "true")

          (false? item)
          (write "false")

          (nil? item)
          (write "null")

          (error (string "cannot encode " (type item) " '" item "' to JSON"))))))
  res)
