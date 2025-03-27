(asdf/defsystem:defsystem "minesweeper"
  :depends-on ("cl-gobject-introspection"
               "defclass-std"
               "serapeum")
  :components ((:file "minesweeper")))

;; (push #p"~/Programming/Lisp/gtk4-cffi/cl-gobject-introspection/minesweeper/" asdf:*central-registry*)
;; (ql:quickload 'minesweeper)
;; (main)
