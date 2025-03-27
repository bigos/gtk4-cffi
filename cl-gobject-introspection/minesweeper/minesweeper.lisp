(declaim (optimize (speed 0) (safety 3) (debug 2)))

(in-package :cl-user)

(defpackage #:minesweeper
  (:use #:cl)
  (:import-from :serapeum
   :~> :@)
  (:import-from :defclass-std
   :defclass/std)
  (:export #:main))

(in-package :minesweeper)

(defvar *gio* (gir:ffi "Gio"))
(defvar *gtk* (gir:ffi "Gtk" "4.0"))

(defun activate (app)
  (let ((window (gir:invoke (*gtk* "ApplicationWindow" 'new) app))
        (button (gir:invoke (*gtk* "Button" 'new-with-label) "Click me")))
    (setf (gir:property button 'margin-top) 40
          (gir:property button 'margin-bottom) 40
          (gir:property button 'margin-start) 20
          (gir:property button 'margin-end) 20)
    (gir:connect button :clicked
                 (lambda (button)
                   (setf (gir:property button 'label) "Hello, world!")))
    (gir:invoke (window 'set-child) button)
    (gir:invoke (window 'show))))

(defun main ()
  (let ((app (gir:invoke (*gtk* "Application" 'new)
                         "com.example.helloworld"
                         (gir:nget *gio* "ApplicationFlags" :default-flags))))
    (gir:connect app :activate #'activate)

    (sb-int:with-float-traps-masked (:divide-by-zero)
      (gir:invoke (app 'run) nil))))
