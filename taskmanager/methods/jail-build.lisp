;;;; -*- indent-tabs-mode: nil; -*-

(in-package :taskmanager)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Main Method

(defun jail-build (jail-name jail-ip-address &optional &key (test t))
  (log:debug "ARGS: ~S ~S" jail-name jail-ip-address)
  :done)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun strcat (&rest strings)
  (apply #'concatenate (push 'string strings)))

(defun write-jail-arguments (jail-name &optional (stream *standard-output*) &rest args)
  "Write jail arguments valid for rc.conf file"
  (assert (evenp (length args)) (args)
          "Invalid number of arguments: ~S" args )
  (format stream "~&jail_list=${jail_list}~C ~a~C~%" #\" jail-name #\" )
  (dolist (pair (nreverse (pairlis (remove-if-not #'keywordp args)
                                   (remove-if #'keywordp args))))
    (format stream "~&jail_~a_~a=~C~a~C~%" jail-name (string-downcase (car pair)) #\" (cdr pair) #\"))
  (format stream "~&#~%")
  (values))

(defun build-zfs-filesystem (zfs-name &optional &key (test t))
  (sb-ext:run-program "zfs"
                      (list "create" "-o" "quota=10G" (strcat "Zjails/" zfs-name))
                      :search t
                      :output *standard-output*))

(defun build-hostname (ip-address fqdn &optional &key (test t) (stream *standard-output*))
  "Write hostname to the root and jail systems."
  (format stream "~&~a~C~C~a ~a~%" ip-address #\Tab #\Tab fqdn (subseq fqdn 0 (position #\. fqdn))))

(defun cpdup (from to &optional (test t) &rest args) 
  (log:debug "cpdup ~S ~S" from to)
  (when (not test)
    (sb-ext:run-program "cpdup"
                        (list from to)
                        :search t
                        :output *standard-output*)))

(defun build-sip-conf (filepath)
  (check-type filepath pathname)
  (rename-file filepath (make-pathname :directory (pathname-directory filepath)
                                       :name (pathname-name filepath)
                                       :type (strcat (pathname-type filepath)".template")))
  (with-open-file (rc-conf pathname)
    (labels ((read-one-line () (read-line rc-conf nil nil)))
      (do ((line (read-one-line)
                 (read-one-line)))
          ((null line))
        (print line)))))

(defun build-rc-conf (jail-name jail-ip-address)
  (with-open-file (rc-conf (make-pathname :directory "etc" :name "rc" :type "conf")
                           :direction :output
                           :if-exists :append)
    (write-jail-arguments (strcat jail-name "_pbx")
                          rc-conf
                          :rootdir (strcat "/Zjails/" jail-name)
                          :hostname (strcat jail-name "_pbx.skytel.spb.ru")
                          :ip jail-ip-address)))


