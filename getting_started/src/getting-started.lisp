(declaim (optimize (speed 0) (safety 3) (debug 3)))

(in-package #:common-lisp)

(defpackage #:getting-started
  (:use #:cl)
  ;; (:import-from :serapeum
  ;;  :~> :@)
  ;; (:import-from :defclass-std
  ;;  :defclass/std)
  (:export #:main))

(in-package #:getting-started) ;; ==============================================

(cffi:define-foreign-library libgtk     (:unix "libgtk-4.so"))
(cffi:define-foreign-library libgdk     (:unix "libgdk-3.so"))
(cffi:define-foreign-library libgio     (:unix "libgio-2.0.so"))
(cffi:define-foreign-library libgobject (:unix "libgobject-2.0.so"))
(cffi:define-foreign-library libglib    (:unix "libglib-2.0.so"))
(cffi:define-foreign-library libcairo   (:unix "libcairo.so.2"))

(cffi:use-foreign-library libgtk)
(cffi:use-foreign-library libgio)
(cffi:use-foreign-library libgobject)

(cffi:defcfun ("gtk_application_new" :libgtk)
  :pointer
  "new app"
  (application_id :string)
  (flags :int))

(cffi:defcfun ("g_application_run" :library :libgio)
  :int
  ""
  (application :pointer)
  (argc :int)
  (argv :string))

(cffi:defcfun ("g_object_unref" :library :libgobject)
  :void
  ""
  (object :pointer))

(cffi:defcfun ("g_signal_connect_data" :library :libgobject)
    :void
  "connect signal"
  (instance :pointer)
  (detailed_signal :string)
  (c_handler :pointer)
  (data :pointer)
  (destroy_data :pointer)
  (connect_flags :pointer))

(cffi:defcfun ("gtk_application_window_new" :library :libgtk)
    :pointer)

(cffi:defcfun ("gtk_window_present" :library :libgtk)
  :void
  (window :pointer))

;; (define-alien-callable activate void ((app (* t)) (u (* t)))
;;   (with-alien ((win (* t)))
;;     (setf win (gtk_application_window_new app))
;;     (gtk_window_set_title win "That")
;;     (gtk_window_set_default_size win 400 300)
;;     (gtk_widget_show_all win)))

(cffi:defcallback activate :void ((app :pointer) (user_data :pointer))
  (let ((win (cffi:foreign-funcall "gtk_application_window_new" :pointer app :pointer)))
    ;;
    (cffi:foreign-funcall "gtk_window_present" :pointer win :void)))

(defun main ()
  (let ((app (cffi:foreign-funcall "gtk_application_new" :string "org.gtk.example" :int 0 :pointer))
        (status 0))
    (cffi:foreign-funcall "g_signal_connect_data"
                          :pointer app :string "activate" :pointer (cffi:callback activate)  :pointer (cffi:null-pointer) :void)
    (setf status (cffi:foreign-funcall "g_application_run"
                                       :pointer app :int 0 :string (cffi:null-pointer) :int))
    (cffi:foreign-funcall "g_object_unref" :pointer app :void)

    status))
