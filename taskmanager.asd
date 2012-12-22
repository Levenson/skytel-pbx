;;;; -*- indent-tabs-mode: nil; -*-

(defpackage :taskmanager-asd
  (:use :cl :asdf))

(in-package :taskmanager-asd)

(defsystem  :taskmanager
  :description "Taskmaster of methods received from XML-RPC front-end"
  :serial t
  :version "0.1"
  :depends-on (:log4cl :split-sequence :iolib)
  :pathname "taskmanager/"
  :components ((:file "packages")
               (:module methods
                        :components ((:file "jail-build")))))

