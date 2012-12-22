;;;; -*- mode: lisp; indent-tabs-mode: nil; -*-
;;;; builder system

(defpackage :xmlrpc-handlers-asd
  (:use :cl :asdf))

(in-package :xmlrpc-handlers-asd)

(defsystem  :xmlrpc-handlers
  :description "Front end part for receiving commands and provide
  `TASKS' to the backe end taskmaster."
  :serial t
  :version "0.1"
  :depends-on (:log4cl :split-sequence :iolib :hunchentoot :cxml-rpc)
  :pathname "xmlrpc-handlers/"
  :components ((:file "skt-noname")))

