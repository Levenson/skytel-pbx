;;;; -*- indent-tabs-mode: nil; -*-

(in-package :taskmanager)

(log:config :properties (merge-pathnames "taskmanager/log4cl.conf"
                                         (user-homedir-pathname)) :watch)

(defparameter +task-directory+ (pathname "/usr/local/www/hunchentoot/todo/"))

(defparameter *task* nil)

(defun read-file-first-line (pathname)
  (let ((stream (open pathname)))
    (unwind-protect
         (read-line stream nil nil)
      (when stream (close stream)))))

(defun rename-file-rotate (file new-name &optional (index 0))
  "Rename `file' to `new-name', and if `new-name' is allready exist,
then it moves existed file and append `index' number to its type. "
  (assert (not (null (probe-file file))) (file)
          "File ~S does not exist" file)
  (let ((new-name-path (merge-pathnames new-name file)))
    (if (probe-file new-name-path)
        (progn
          (rename-file-rotate
           new-name-path
           (make-pathname :directory (pathname-directory new-name-path)
                          :name (if (zerop index)
                                    (namestring (make-pathname :name (pathname-name new-name-path)
                                                               :type (pathname-type new-name-path)))
                                    (pathname-name new-name-path))
                          :type (princ-to-string (+ 1 index)))
           (+ 1 index))
          (rename-file file new-name-path))
        (rename-file file new-name-path))
    new-name-path))

(defun dotasks ()
  (let ((task-list (directory (merge-pathnames "*.task" +task-directory+))))
    (if (null task-list)
        (log:info "There are no any tasks!")
        (dolist (task task-list)
          (let ((*task* task))
            (let* ((method (read-from-string (read-file-first-line task)))
                   (func (symbol-function (find-symbol (string-upcase (car method))))))
              (handler-case 
                  (let ((funcall-result (apply func (rest method))))
                    (log:debug "Method ~S ~S" func funcall-result)
                    (cond
                      ((equal funcall-result :done)
                       (delete-file task))
                      ((equal funcall-result :error)
                       (rename-file-rotate task (make-pathname :name (princ-to-string task)
                                                               :type ".bug")))
                      (t (log:debug "Unknown result: ~S of method ~S"  funcall-result func))))
                (undefined-function ()
                  (warn "Function ~S not implemented." func)))))))))

(dotasks)
