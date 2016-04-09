;;; helm-notmuch.el --- Search emails with Notmuch and Helm  -*- lexical-binding: t; -*-

;; Copyright (C) 2016  Chunyang Xu

;; Author: Chunyang Xu <xuchunyang.me@gmail.com>
;; Keywords: mail
;; Version: 0.01
;; Package-Requires: ((helm "1.9.3") (notmuch "0.21"))

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;;

;;; Code:

(require 'helm)
(require 'notmuch)

(defun helm-notmuch-init ()
  (let ((proc (start-process "helm-notmuch" helm-buffer "notmuch" "search" helm-pattern)))
    (prog1 proc
      (set-process-sentinel proc #'ignore))))

(defun helm-notmuch-show-email (candidate)
  (let ((thread-id
         (progn (string-match "^\\(thread:[0-9]+\\) " candidate)
                (match-string 1 candidate))))
    (notmuch-show thread-id)))

(defvar helm-source-notmuch
  (helm-build-async-source "Search email with notmuch"
    :candidates-process #'helm-notmuch-init
    :requires-pattern 2
    :nohighlight t
    :action '(("Show message in notmuch" . helm-notmuch-show-email))))

;;;###autoload
(defun helm-notmuch ()
  (interactive)
  (helm :sources helm-source-notmuch
        :buffer "*helm notmuch*"))

(provide 'helm-notmuch)
;;; helm-notmuch.el ends here
