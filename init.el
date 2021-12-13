; Basic Settings {{{

;; importing settings from literate config {{{
(require 'ob-tangle)
; https://org-babel.readthedocs.io/en/latest/header-args/
(add-to-list 'org-babel-default-header-args
  '(:tangle . "yes"))
(org-babel-load-file (expand-file-name "config.org" user-emacs-directory))
;;}}}

;}}}
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(trailing-whitespace ((t (:foreground "#636363" :background "#373844"))))
 '(whitespace-newline ((t (:foreground "636363"))))
 '(whitespace-tab ((t (:foreground "#636363" :background nil)))))
