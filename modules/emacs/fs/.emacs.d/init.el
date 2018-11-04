(tool-bar-mode -1) ; Hide toolbar
(menu-bar-mode -1) ; Hide menubar
(scroll-bar-mode -1) ; Hide scrollbar
(global-linum-mode t) ; Line numbers

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

(use-package evil-leader
  :ensure t
  :init
  (global-evil-leader-mode)
  (evil-leader/set-leader "<SPC>"))

(evil-leader/set-key
  "b n" 'evil-next-buffer
  "b b" 'helm-mini
  "b N" 'evil-buffer-new)

(evil-ex-define-cmd "q" 'kill-this-buffer)
(evil-ex-define-cmd "quit" 'evil-quit)


(use-package evil
  :ensure t
  :init (evil-mode t))

(use-package helm
  :ensure t
  :bind (("M-x" . helm-M-x)))

(use-package monokai-theme
  :ensure t
  :init (load-theme 'monokai t))

(use-package magit
  :ensure t)

(use-package evil-magit
  :ensure t)

(use-package company
  :ensure t
  :init (add-hook 'after-init-hook 'global-company-mode))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (evil-magit magit evil-leader use-package monokai-theme helm evil))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
