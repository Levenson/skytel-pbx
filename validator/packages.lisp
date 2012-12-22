;; -*- mode: lisp; indent-tabs-mode:: nil; -*-

(in-package :cl-user)

(defpackage :validator
  (:use :cl)
  (:export #:check-string-valid-character
           #:check-mount-point
           #:check-ip-address))
