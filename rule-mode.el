;;; drupal-mode.el --- support of rule-based comments for program code

;; Copyright © 2012 Alexander I.Grafov

;; Author: Alexander I.Grafov <grafov@gmail.com>
;; Version: 0.2
;; Keywords: programming
;; URL: https://github.com/siberianlaika/rule-mode

;; This file is not part of GNU Emacs.

;; This is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;;; Commentary:
;;

;; К разработке:
; хук к rule-mode: при открытии файла RULES искать буферы со включённым rule-minor-mode и проставлять для них rule-mode-buffer-with-rules если оно соответствует открытому RULES
; RULE#7 при инициализации rule-minor-mode искать подходящий RULES в rule-mode-alist и проставлять в rule-mode-buffer-with-rules
;
; команда сортировки по номерам правил в файле RULES
; команда генерации RULE#NN с подстановкой номера NN

;;; Code:

(require 'font-lock)
(require 'thingatpt)

(provide 'rule-mode)

(defconst rule-mode-version "0.4")

(defvar rule-mode-alist '() "Global list of RULES buffers")

(defgroup rule-mode nil "Rule-based comments mode."
	:group 'programming)

;;;###autoload
(define-derived-mode rule-mode text-mode "RULES" ; RULE#5
  (make-local-variable 'font-lock-defaults)
 	(setq font-lock-defaults
				'((("RULE#[0-9]+\\(->\\)RULE#[0-9]+" 1 font-lock-keyword-face) ; RULE#2
					 ("\\(-\\|<-\\)RULE#[0-9]+" . font-lock-doc-face) ; RULE#1 RULE#3
					 ("RULE#[0-9]+" . font-lock-keyword-face)))) ; RULE#0
	(run-mode-hooks 'rule-mode-hook))

(add-to-list 'auto-mode-alist '("^RULES|RULES.txt$" . rule-mode)) ; RULE#4

(defun rule-mode-buffer-directory ()
	(file-name-directory (file-truename (buffer-file-name (current-buffer)))))

(add-hook 'rule-mode-hook	(lambda () (add-to-list 'rule-mode-alist (list (rule-mode-buffer-directory) (current-buffer)))))

;;;###autoload
(define-minor-mode rule-minor-mode ; RULE#6
	"Toggle minor rule-mode."
	:init-value nil
	:lighter " RULES"
	:keymap `((,(kbd "M-RET") . rule-mode-looking-for-rule))
	:group   'rule-mode
	:require 'rule-mode
	(make-variable-buffer-local 'rule-mode-buffer-with-rules) ; RULE#7
	(setq rule-mode-buffer-with-rules (second (assoc-string (rule-mode-buffer-directory) rule-mode-alist))) ; XXX
	;(run-hooks 'rule-minor-mode)
)

(defun rule-mode-bounds-of-rule-at-point ()
	"Return the start and end points of an integer at the current point.
   The result is a paired list of character positions for an RULE regexp."
	(save-excursion
		(skip-chars-backward "RULE#0123456789")
		(if (looking-at "RULE#[0-9]+")
				(cons (point) (match-end 0))
			nil)))

(put 'rule 'bounds-of-thing-at-point 'rule-mode-bounds-of-rule-at-point)

(defun rule-mode-looking-for-rule ()
	(interactive)
	(let ((current-rule (thing-at-point 'rule)))
		(if current-rule
				(progn
					(setq current-rule (buffer-substring-no-properties (match-beginning 0) (match-end 0)))
					(switch-to-buffer rule-mode-buffer-with-rules)
					(beginning-of-buffer)
					(search-forward current-rule nil nil)
					(beginning-of-line)))))

;;; rule-mode.el ends here

