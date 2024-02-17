;;; package --- Summary
;;; Commentary:
;;; Code:

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(modus-vivendi))
 '(package-selected-packages
   '(evil-commentary flycheck company which-key lsp-ui lsp-mode go-mode yaml-mode evil)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Iosevka Nerd Font" :foundry "UKWN" :slant normal :weight regular :height 143 :width normal)))))

(set-default 'truncate-lines t)

;; https://ianyepan.github.io/posts/setting-up-use-package/
;; https://emacs-lsp.github.io/lsp-mode/page/installation/

(require 'package)
(add-to-list 'package-archives '("gnu"   . "https://elpa.gnu.org/packages/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-and-compile
  (setq use-package-always-ensure t
        use-package-expand-minimally t))
(require 'use-package)

(use-package magit)

(use-package yaml-mode
  :mode ("\\.yml\\'" . yaml-mode))

(use-package go-mode
  :mode ("\\.go\\'" . go-mode))

(use-package which-key
  :init
  (setq which-key-idle-delay 0.3)
  :config
  (which-key-mode))

;; https://old.reddit.com/r/emacs/comments/726p7i/evil_mode_and_use_package/dnh3338/
;; https://stackoverflow.com/a/18851955
(use-package evil
  :init
  (setq evil-want-C-u-scroll t)
  :config
  (evil-mode 1)
  (evil-set-undo-system 'undo-redo))

(use-package evil-commentary
  :config
  (evil-commentary-mode))

;; https://github.com/jwiegley/use-package-examples?tab=readme-ov-file#company
(use-package company
  :config
  (global-company-mode))

(use-package flycheck
  :config
  (add-hook 'after-init-hook #'global-flycheck-mode))

(use-package lsp-mode
  :init
  (setq lsp-keymap-prefix "C-c l")
  :hook (
	 (go-mode . lsp))
  :commands lsp)

(use-package lsp-ui :commands lsp-ui-mode)

(provide '.emacs)
;;; .emacs ends here
