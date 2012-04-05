;; Support of rule-based programming
;; GPL v3

(require 'font-lock)

(defconst rule-mode-version "0.1")

(define-derived-mode rule-mode text-mode "RULES"
  (make-local-variable 'font-lock-defaults)
	(setq font-lock-defaults 
				'(( ("-RULE#[0-9]+" . font-lock-doc-face)
						("RULE#[0-9]+" . font-lock-keyword-face)
						("^-*-.+-*-$" . font-lock-comment-face) )))
	(run-mode-hooks 'rule-mode-hook))

(provide 'rule-mode)