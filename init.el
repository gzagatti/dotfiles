; Basic Settings {{{

; do not follow symlinks
(setq vc-follow-symlinks nil)

;; importing settings from literate config {{{
(require 'ob-tangle)
; https://org-babel.readthedocs.io/en/latest/header-args/
(add-to-list 'org-babel-default-header-args '(:tangle . "yes"))
(org-babel-load-file (expand-file-name "emacs-config.org" user-emacs-directory))
;;}}}

;}}}
