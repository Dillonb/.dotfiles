(tool-bar-mode -1) ; Hide toolbar
(menu-bar-mode -1) ; Hide menubar
(scroll-bar-mode -1) ; Hide scrollbar
(global-linum-mode t) ; Line numbers

(setq exec-path (append exec-path '("/usr/local/bin")))

; Add repos
(require 'package)
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))

; Set up package management
(setq package-enable-at-startup nil)
(package-initialize)

; Install use-package if it doesn't exist
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)

(use-package helm
  :ensure t
  :bind (("M-x" . helm-M-x)))

(use-package helm-ls-git
  :ensure t)

(use-package evil-leader
  :ensure t
  :init
  (global-evil-leader-mode)
  (evil-leader/set-leader "<SPC>"))

(evil-leader/set-key
  "b n" 'evil-next-buffer
  "b b" 'helm-mini
  "b N" 'evil-buffer-new
  "o"   'helm-browse-project)

(evil-ex-define-cmd "q" 'kill-this-buffer)
(evil-ex-define-cmd "quit" 'evil-quit)

(use-package terraform-mode
  :ensure t)

(use-package markdown-mode
  :ensure t
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . gfm-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

(use-package evil
  :ensure t
  :init (evil-mode t))

(use-package base16-theme
  :ensure t
  :init (load-theme 'base16-nord t))

(set-face-attribute 'default nil :height 140)

(use-package magit
  :ensure t)

(use-package git-gutter+
  :ensure t
  :init (global-git-gutter+-mode))


(use-package evil-magit
  :ensure t)

(use-package company
  :ensure t
  :init
  (add-hook 'after-init-hook 'global-company-mode)
  (setq company-dabbrev-downcase 0)
  (setq company-idle-delay 0.5)
  (setq company-minimum-prefix-length 1))

(use-package lsp-mode
  :ensure t
  :commands lsp)

(use-package lsp-ui
  :commands lsp-ui-mode)

(use-package company-lsp
  :commands company-lsp)

(use-package lsp-java
  :ensure t
  :init
  (add-hook 'java-mode-hook #'lsp))


(server-start)

(setq-default c-default-style "k&r")
(setq-default c-basic-offset 4)
(c-set-offset 'case-label '+)
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq-default indent-line-function 'insert-tab)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (lsp-java git-gutter+ markdown-mode git-gutter base16-theme terraform-mode evil-magit magit evil-leader use-package monokai-theme helm evil))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
