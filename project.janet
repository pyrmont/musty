(declare-project
  :name "Musty"
  :description "An implementation of the mustache template library"
  :author "Michael Camilleri"
  :license "MIT"
  :url "https://github.com/pyrmont/musty"
  :repo "git+https://github.com/pyrmont/musty"
  :dependencies ["https://github.com/janet-lang/spork"
                 "https://github.com/pyrmont/testament"])

(declare-source
  :source @["src/musty.janet"])
