;;;; -*- mode: lisp; indent-tabs-mode: nil; -*-
;;;;
;;;; Provide mechanisms for argument validation.

(in-package :validator)

(defparameter +char-bag+ '(#\Tab #\Space #\-))

;;; Utilities

(defun char-position (character sequence)
  (position character sequence :test #'char=))

(defun string-split (char-delimiter sequence)
  (unless (null sequence)
    (let ((delimiter-position (char-position char-delimiter sequence)))
      (cons (subseq sequence 0 delimiter-position)
            (string-trim +char-bag+ (subseq sequence (1+ delimiter-position)))))))

(defun directory-p (directory)
  "Returns true if `directory' is a directory."
  (and (null (pathname-name directory))
       (null (pathname-type directory))))

(defun directory-ls (pathname &optional &key (recursively nil))
  (loop :for element :in (directory (format nil "~a/*.*" pathname))
     :if (directory-p element) :append
     (if recursively
         (cons element (directory-ls element))
         (list  element))))

;;; Check-functions.
;;; 
;;; All `check-'functions have to return `valid' or `invalid'

(defun check-ip-address (ip-address)
  "Return :free if there is no any jails with `ip-address' ip"
  (let ((result :valid))
    (with-open-file (rc-conf "/etc/rc.conf")
      (do ((line (read-line rc-conf nil nil)
                 (read-line rc-conf nil nil)))
          ((null line))
        (when (search ip-address line :test #'char=)
          (setf result :invalid))))
    result))

(defun check-mount-point (zfs-name)
  (if (null (member (concatenate 'string "/Zjails/" zfs-name "/")
                    (directory-ls "/Zjails/")
                    :test #'string= :key #'namestring))
      :valid :invalid))

(defun check-string-valid-character (string)
  (if (null (intersection +char-bag+ (coerce string 'list)))
      :valid :invalid))
