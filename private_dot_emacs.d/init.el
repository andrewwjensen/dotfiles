(require 'package)
(add-to-list 'package-archives
         '("melpa" . "http://melpa.org/packages/") t)

(package-initialize)

(when (not package-archive-contents)
    (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(use-package undo-tree)
(global-undo-tree-mode)

(add-to-list 'load-path "~/.emacs.d/custom")

;; (use-package desktop+)
;; (use-package session)

;; (menu-bar-mode -1)
;; (tool-bar-mode -1)

;; (setq gc-cons-threshold 100000000)
;; (setq inhibit-startup-message t)

(defalias 'yes-or-no-p 'y-or-n-p)

(use-package company
  :init
  (global-company-mode 1)
  (delete 'company-semantic company-backends))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Vertico
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; 1. Enable Vertico vertical completion UI
(use-package vertico
  :ensure t
  :init
  (vertico-mode)
  :custom
  (vertico-cycle t) ;; Cycle back to the top when reaching the bottom
)

;; 2. Add rich annotations to the completion buffer
(use-package marginalia
  :ensure t
  :bind (:map minibuffer-local-map
         ("M-A" . marginalia-cycle)) ; Toggle detailed/slim view
  :init
  (marginalia-mode))

;; 3. Enable flexible, out-of-order completion filtering
(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))

;; 4. Persist minibuffer history over Emacs restarts
(use-package savehist
  :init
  (savehist-mode))

;; 5. Search and Navigation Enhancements (Consult)
(use-package consult
  :ensure t
  :bind (;; Drop-in replacements for standard commands
         ("C-x b" . consult-buffer)     ; Enhanced buffer switcher
         ("C-x C-b" . consult-buffer)
         ("M-y" . consult-yank-pop)     ; Visual kill-ring history
         ("M-s g" . consult-ripgrep)  ; 'g' for grep/ripgrep
         ;; Drop-in replacements for Helm-swoop / Helm-imenu
         ("M-s l" . consult-line)       ; Search lines in current buffer
         ("M-s i" . consult-imenu)))    ; Navigate code structures/headings

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Customize variables
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package emacs
  :custom
  ;; Support opening minibuffer inside minibuffer
  (enable-recursive-minibuffers t)
  ;; Hide commands that do not apply to the current mode
  (read-extended-command-predicate #'command-completion-default-include-p)
  ;; Do not show completions automatically in a separate buffer
  (completion-show-help nil)
  )

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(backup-directory-alist '(("." . "~/.emacs.d/backups")))
 '(blink-cursor-mode nil)
 '(c-default-style
   '((c-mode . "dss")
     (c++-mode . "dss")
     (java-mode . "java")
     (awk-mode . "awk")
     (other . "gnu")))
 '(column-number-mode t)
 '(desktop-load-locked-desktop t)
 '(display-time-day-and-date t)
 '(fill-column 90)
 '(find-file-visit-truename t)
 '(indent-tabs-mode nil)
 '(kill-whole-line t)
 '(line-number-display-limit-width 20000)
 '(mouse-yank-at-point t)
 '(ns-command-modifier 'meta)
 '(package-selected-packages
   '(company consult graphviz-dot-mode lua-mode marginalia orderless undo-tree vertico))
 '(printer-name "Brother_MFC_L8850CDW")
 '(projectile-enable-caching nil)
 '(safe-local-variable-values
   '((c-file-style . andy)
     (checkdoc-minor-mode . t)
     (require-final-newline . t)
     (mangle-whitespace . t)
     (py-indent-offset . 4)))
 '(save-interprogram-paste-before-kill t)
 '(sentence-end-double-space nil)
 '(session-use-package t)
 '(show-paren-mode t nil (paren))
 '(sort-fold-case t t)
 '(tab-width 4)
 '(tool-bar-mode nil)
 '(transient-mark-mode nil)
 '(undo-limit 2000000)
 '(undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo")))
 '(vc-diff-switches '("-btw"))
 '(vc-follow-symlinks t)
 '(vc-hg-diff-switches '("-bw"))
 '(visible-bell t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "black" :foreground "wheat" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 192 :width normal :foundry "unknown" :family "DejaVu Sans Mono"))))
 '(border ((t (:background "black"))))
 '(cursor ((t (:background "orchid")))))

(require 'setup-personal)
