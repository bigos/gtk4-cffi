(asdf/defsystem:defsystem "hello-world"
  :depends-on ("cl-gobject-introspection")
  :components ((:file "hello-world")))

;; (push #p"~/Programming/Lisp/gtk4-cffi/cl-gobject-introspection/hello-world/" asdf:*central-registry*)
;; (ql:quickload 'hello-world)
;; (main)
