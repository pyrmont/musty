(declare-project
  :name "Musty"
  :description "An implementation of the mustache template library"
  :author "Michael Camilleri"
  :license "MIT"
  :url "https://github.com/pyrmont/musty"
  :repo "git+https://github.com/pyrmont/musty"
  :dev-dependencies ["https://github.com/pyrmont/testament"])

(declare-source
  :source ["src/musty.janet"])

(task "dev-deps" []
  (if-let [deps ((dyn :project) :dev-dependencies)]
    (each dep deps
      (bundle-install dep))
    (do
      (print "no dependencies found")
      (flush))))
