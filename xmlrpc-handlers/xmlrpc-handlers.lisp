;;;; -*- indent-tabs-mode: nil; -*-

(in-package :cl-user)

(defpackage :xmlrpc-handlers
  (:use :cl :validator :cl-who :cxml-rpc))

(in-package :xmlrpc-handlers)

(log:config :debug :sane :daily (sb-posix:getenv "HT_LOG"))

(defparameter +task-directory+ (merge-pathnames "todo/"
                                                (user-homedir-pathname)))

;;; Handlers
(pushnew (hunchentoot:create-prefix-dispatcher "/RPC2" (cxml-rpc-method-handler 'default))
         hunchentoot:*dispatch-table*)

;; Default handler
(hunchentoot:define-easy-handler (default :uri "/") ()
  (with-html-output (*standard-output* nil :prologue t :indent t)
    (:html
     (:head (:title "Skytel Utilities"))
     (:body
      (:center (:strong (:font :color "#ff0000" "Access Forbidden.")))))))

;; XML-RPC methods
(define-xrpc-method ("jail-build" default) (jail-name jail-ip-address) (:string :string :string)
  "Build a brand new FreeBSD jail."
  (assert (vectorp (iolib.sockets::string-address-to-vector jail-ip-address))
          (jail-ip-address)
          ":NOT_ACCEPTED IP address ~S is incorrect."
          jail-ip-address)
  (let ((task-filepath (merge-pathnames (concatenate 'string  "jail-build." jail-name ".task" )
                                        +task-directory+)))
    (assert (null (probe-file task-filepath)) (task-filepath)
            ":NOT_ACCEPTED Task with name ~S allready exist." (pathname-name task-filepath))
    (assert (equal (check-string-valid-character jail-name) :valid) (jail-name)
            ":NOT_ACCEPTED Jail name ~S contains invalid character." jail-name)
    (assert (equal (check-mount-point jail-name) :valid) (jail-name)
            ":NOT_ACCEPTED Jail name ~S allready exist." jail-name)
    (assert (equal (check-mount-point jail-ip-address) :valid) (jail-name)
            ":NOT_ACCEPTED IP address ~S is in use." jail-ip-address)
    (log:debug "Build TASK_FILE ~S for ~S"
               (pathname-name task-filepath)
               (list "jail-build" jail-name jail-ip-address))
    (with-open-file (stream task-filepath :direction :output)
      (format stream "~&~S~%" (list "jail-build" jail-name jail-ip-address))))
  :ACCEPTED)
