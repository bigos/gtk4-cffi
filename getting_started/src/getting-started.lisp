(declaim (optimize (speed 0) (safety 3) (debug 3)))

;;; an example of using Gtk4 taken from:
;;; https://docs.gtk.org/gtk4/getting_started.html

(in-package #:common-lisp)

(defpackage #:getting-started
  (:use #:cl :cffi)
  ;; (:import-from :serapeum
  ;;  :~> :@)
  ;; (:import-from :defclass-std
  ;;  :defclass/std)
  (:export #:main))

(in-package #:getting-started) ;; ==============================================

(define-foreign-library libgtk     (:unix (:or "libgtk-4.so")))
(define-foreign-library libgdk     (:unix (:or "libgdk-3.so")))
(define-foreign-library libgio     (:unix (:or "libgio-2.0.so")))
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
    :ulong
  (instance :pointer)
  (detailed_signal :string)
  (c_handler :pointer)
  (data :pointer)
  (destroy_data :pointer)
  (connect_flags :int))

(defcfun "gtk_application_window_new"
    :pointer
  (application :pointer))

(defcfun "gtk_set_title"
    :void
  (window :pointer)
  (title :string))

(defcfun "gtk_window_set_default_size"
    :void
  (window :pointer)
  (width :int)
  (height :int))

(defcfun "gtk_window_present"
    :void
  (window :pointer))

(defcallback activate :void ((app :pointer) (user_data :pointer))
  (let ((win (foreign-funcall "gtk_application_window_new" :pointer app :pointer)))
    (foreign-funcall "gtk_window_set_title" :pointer win :string "Window" :void)
    (foreign-funcall "gtk_window_set_default_size" :pointer win :int 200 :int 200 :void)
    (foreign-funcall "gtk_window_present" :pointer win :void)))

(defun main ()
  (let ((app (foreign-funcall "gtk_application_new" :string "org.gtk.example" :int 0 :pointer))
        (status 0))
    (foreign-funcall "g_signal_connect_data"
                     :pointer app
                     :string "activate"
                     :pointer (cffi:callback activate)
                     :pointer (cffi:null-pointer)
                     :pointer (cffi:null-pointer)
                     :ulong   0
                     :void)

    (sb-int:with-float-traps-masked (:divide-by-zero)
      (setf status (foreign-funcall "g_application_run"
                                    :pointer app
                                    :int 0
                                    :string (cffi:null-pointer)
                                    :int)))

    (foreign-funcall "g_object_unref"
                     :pointer app
                     :void)

    status))
