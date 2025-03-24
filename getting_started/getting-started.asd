(asdf/defsystem:defsystem "getting-started"
  :description "GTK experiment with CFFI"
  :serial t
  :depends-on ("cffi")
  :pathname "src/"
  :components ((:file "getting-started")))
