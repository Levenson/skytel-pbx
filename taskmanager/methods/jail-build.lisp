;;;; -*- indent-tabs-mode: nil; -*-

(in-package :taskmanager)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Main Method

(defun jail-build (jail-name jail-ip-address &optional &key (test t))
  "Build a free jail on ZFS system of FreeBSD host system, based on
/Zjails/template. All data from template compies by cpdup utilities,
and then process rc.conf, /etc/hosts /etc/pf.conf and files of jail:
/etc/hosts /usr/local/"
  (log:debug "ARGS: ~S ~S" jail-name jail-ip-address)
  (run-program "/root/bin/build-jail" (strcat jail-name " " jail-ip-address :test nil))
  ;; (build-zfs-filesystem jail-name :test test)
  ;; (cpdup "/Zjails/template" (strcat "/Zjails/" jail-name) :test test)
  ;; (build sip-file )
  :done)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun run-program (program args &optional &key (test t))
  (log:debug "~S ~S" program args)
  (when (not test)
    (let ((proc (sb-ext:run-program program
                                    (split-sequence:split-sequence #\Space args)
                                    :search t
                                    :output :stream)))
      (with-open-stream (result (sb-ext:process-output proc))
        (labels ((read-one-line () (read-line result nil nil)))
          (do ((line (read-one-line)
                     (read-one-line)))
              ((null line))
            (log:debug "~S" line)))))))


(defun strcat (&rest strings)
  (apply #'concatenate (push 'string strings)))

;; (defun write-jail-arguments (jail-name &optional (stream *standard-output*) &rest args)
;;   "Write jail arguments valid for rc.conf file"
;;   (assert (evenp (length args)) (args)
;;           "Invalid number of arguments: ~S" args )
;;   (format stream "~&jail_list=${jail_list}~C ~a~C~%" #\" jail-name #\" )
;;   (dolist (pair (nreverse (pairlis (remove-if-not #'keywordp args)
;;                                    (remove-if #'keywordp args))))
;;     (format stream "~&jail_~a_~a=~C~a~C~%" jail-name (string-downcase (car pair)) #\" (cdr pair) #\"))
;;   (format stream "~&#~%")
;;   (values))

;; (defun build-zfs-filesystem (zfs-name &optional &key (test t))
;;   (run-program "zfs" (strcat  "create -o quota=10G " (strcat "Zjails/" zfs-name)) :test test))

;; (defun build-hostname (ip-address fqdn &optional &key (test t) (stream *standard-output*))
;;   "Write hostname to the root and jail systems."
;;   (format stream "~&~a~C~C~a ~a~%" ip-address #\Tab #\Tab fqdn (subseq fqdn 0 (position #\. fqdn))))

;; (defun cpdup (from to &optional &key (test t)) 
;;   (run-program "cpdup" (strcat from " " to) :test test))

;; (defun build-sip-conf (filepath)
;;   ;; (check-type filepath pathname)
;;   (let ((template-filepath (make-pathname :directory (pathname-directory filepath)
;;                                           :name (strcat (pathname-name filepath) "." (pathname-type filepath))
;;                                           :type "template")))
;;     (rename-file-rotate filepath template-filepath)
;;     (with-open-file (template-file template-filepath)
;;       (with-open-file (sip-file filepath :direction :output)
;;         (labels ((read-one-line () (read-line template-file nil nil)))
;;           (do ((line (read-one-line)
;;                      (read-one-line)))
;;               ((null line))
;;             (cond
;;               ((search "useragent=" line)
;;                (format sip-file "useragent=~A_PBX" *jail-name*))
;;               ((search "sdpsession=" line)
;;                (format sip-file "sdpsession=~A_PBX" *jail-name*))
;;               (t (write-line line sip-file)))))))
;;     (run-program "diff" (strcat (namestring filepath) " " (namestring template-filepath)) :test nil)))

;; (defun build-rc-conf (jail-name jail-ip-address)
;;   (with-open-file (rc-conf (make-pathname :directory "etc" :name "rc" :type "conf")
;;                            :direction :output
;;                            :if-exists :append)
;;     (write-jail-arguments (strcat jail-name "_pbx")
;;                           rc-conf
;;                           :rootdir (strcat "/Zjails/" jail-name)
;;                           :hostname (strcat jail-name "_pbx.skytel.spb.ru")
;;                           :ip jail-ip-address)))


