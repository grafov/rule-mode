;;; drupal-mode.el --- support of rule-based comments for program code

;; Copyright © 2012 Alexander I.Grafov

;; Author: Alexander I.Grafov <axel@drupal.ru>
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

;;; Code:

(require 'font-lock)

(defconst rule-mode-version "0.2")

(defvar rule-mode-alist (list) "Global list of RULES buffers")

(defgroup rule-mode nil
	"Rule-based comments mode."
	:group 'programming)

;;;###autoload
(define-derived-mode rule-mode text-mode "RULES" ; RULE#5
  (make-local-variable 'font-lock-defaults)
 	(setq font-lock-defaults
				'((("RULE#[0-9]+\\(->\\)RULE#[0-9]+" 1 font-lock-keyword-face) ; RULE#2
					 ("\\(-\\|<-\\)RULE#[0-9]+" . font-lock-doc-face) ; RULE#1 RULE#3
					 ("RULE#[0-9]+" . font-lock-keyword-face)))) ; RULE#0					 
	(run-mode-hooks 'rule-mode-hook))

(add-hook 'rule-mode-hook	(lambda () (add-to-list 'rule-mode-alist (file-truename (buffer-file-name (current-buffer)) . (current-buffer)))))

(autoload 'rule-mode "rule-mode" "Major mode for rule-based comments." t)
(add-to-list 'auto-mode-alist '("^RULES|RULES.txt$" . rule-mode)) ; RULE#4

;;;###autoload
(define-minor-mode rule-minor-mode ; RULE#6
	"Toggle minor rule-mode."
	:init-value nil
	:lighter " RULES"
	:group   'rule-mode
	:require 'rule-mode)


(provide 'rule-mode)

;;; rule-mode.el ends here