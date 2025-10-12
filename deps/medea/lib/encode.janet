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
  (var indent 0)
  (def close-arr @"")
  (def close-obj @"")
  (def kv? @"")
  (def processing @[data])
  (while (not (empty? processing))
    (def item (array/pop processing))
    (case item
      close-arr
      (buffer/push res "]")

      close-obj
      (buffer/push res "}")

      (do
        (if first?
          (set first? false)
          (do
            (buffer/push res ",")
            (when pretty?
              (buffer/push res "\n" (string/repeat " " indent)))))
        (cond
          (= kv? item)
          (do
            (set first? true)
            (def kv (array/pop processing))
            (array/push processing (kv 1))
            (buffer/push res `"` (escape (kv 0)) `":`))

          (indexed? item)
          (do
            (set first? true)
            (array/push processing close-arr)
            (def new-length (+ (length processing) (length item)))
            (array/ensure processing new-length 1)
            (var i new-length)
            (each el item
              (put processing (-- i) el))
            (buffer/push res "[")
            (when pretty?
              (+= indent 2)
              (buffer/push "\n" (string/repeat " " indent))))

          (dictionary? item)
          (do
            (set first? true)
            (array/push processing close-obj)
            (eachp kv item
              (array/push processing kv)
              (array/push processing kv?))
            (buffer/push res "{")
            (when pretty?
              (+= indent 2)
              (buffer/push "\n" (string/repeat " " indent))))

          (= :null item)
          (buffer/push res "null")

          (and (bytes? item) (not (symbol? item)))
          (buffer/push res `"` (escape item) `"`)

          (number? item)
          (buffer/push res (describe item))

          (true? item)
          (buffer/push res "true")

          (false? item)
          (buffer/push res "false")

          (nil? item)
          (buffer/push res "null")

          (error (string "cannot encode " (type item) " '" item "' to JSON"))))))
  res)
