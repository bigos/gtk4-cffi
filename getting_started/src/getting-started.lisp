(declaim (optimize (speed 0) (safety 3) (debug 3)))

(in-package #:common-lisp)

(defpackage #:getting-started
  (:use #:cl :cffi)
  ;; (:import-from :serapeum
  ;;  :~> :@)
  ;; (:import-from :defclass-std
  ;;  :defclass/std)
  (:export #:main))

(in-package #:getting-started) ;; ==============================================

(define-foreign-library libgtk    (:unix (:or "libgtk-4.so"
                                              "libgtk-4.so.1")))
(define-foreign-library libgdk     (:unix (:or "libgdk-3.so")))
(define-foreign-library libgio     (:unix (:or "libgio-2.0.so"
                                               "libgio-2.0.so.0")))
(define-foreign-library libgobject (:unix (:or "libgobject-2.0.so")))
(define-foreign-library libglib    (:unix (:or "libglib-2.0.so")))
(define-foreign-library libcairo   (:unix (:or "libcairo.so.2")))

(use-foreign-library libgtk)
(use-foreign-library libgio)
(use-foreign-library libgobject)

(cffi:defcfun "gtk_application_new"
    :pointer
  (application_id :string)
  (flags :int))

(defcfun "g_application_run"
    :int
  (application :pointer)
  (argc :int)
  (argv :string))

(defcfun "g_object_unref"
    :void
  (object :pointer))

(defcfun "g_signal_connect_data"
    :void
  (instance :pointer)
  (detailed_signal :string)
  (c_handler :pointer)
  (data :pointer)
  (destroy_data :pointer)
  (connect_flags :pointer))

(defcfun "gtk_application_window_new"
    :pointer)

(defcfun "gtk_window_present"
    :void
  (window :pointer))

(defcallback activate :void ((app :pointer) (user_data :pointer))
  (let ((win (foreign-funcall "gtk_application_window_new" :pointer app :pointer)))
    ;;
    (foreign-funcall "gtk_window_present" :pointer win :void)))

(defun main ()
  (let ((app (foreign-funcall "gtk_application_new" :string "org.gtk.example" :int 0 :pointer))
        (status 0))
    (foreign-funcall "g_signal_connect_data"
                     :pointer app :string "activate" :pointer (cffi:callback activate)  :pointer (cffi:null-pointer) :void)
    (setf status (foreign-funcall "g_application_run"
                                  :pointer app :int 0 :string (null-pointer) :int))
    (foreign-funcall "g_object_unref"  :pointer app :void)

    status))
