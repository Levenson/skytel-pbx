;; -*- indent-tabs-mode: nil; -*-

(defpackage :validator-asd
  (:use :cl :asdf))

(in-package :validator-asd)

(defsystem  :validator
  :description "TASK arguments checker. All requests throught the
`xml-rpc' front end and `taskmaster' back end, have to check their
arguments through the argument `validator'."
  :serial t
  :version "0.1"
  :pathname "validator/"
  :components ((:file "packages")
               (:file "validator")))

