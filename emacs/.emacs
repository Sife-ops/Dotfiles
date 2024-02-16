(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(misterioso))
 '(package-selected-packages '(company which-key lsp-ui lsp-mode go-mode yaml-mode evil)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Iosevka Nerd Font" :foundry "UKWN" :slant normal :weight regular :height 143 :width normal)))))

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

(use-package company
  :config
  (global-company-mode))

(use-package which-key
  :config
  (which-key-mode))

;; https://old.reddit.com/r/emacs/comments/726p7i/evil_mode_and_use_package/dnh3338/
;; https://stackoverflow.com/a/18851955
(use-package evil
  :init
  (setq evil-want-C-u-scroll t)
  :config
  (evil-mode 1))

(use-package yaml-mode
  :mode ("\\.yml\\'" . yaml-mode))

(use-package go-mode
  :mode ("\\.go\\'" . go-mode))

(use-package lsp-mode
  :init
  (setq lsp-keymap-prefix "C-c l")
  :hook (
	 (go-mode . lsp))
  :commands lsp)
