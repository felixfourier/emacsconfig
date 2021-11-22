(require 'package)
(require 'warnings)

(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'warning-suppress-types '(yasnippet backquote-change))

; (package-initialize)
; (package-refresh-contents)
; (package-install 'use-package)

;; Load & Install packages
(use-package yasnippet :ensure t)
(use-package helm :ensure t)
(use-package projectile :ensure t)
(use-package counsel :ensure t)
(use-package flycheck :ensure t)
(use-package helm-projectile :ensure t)
(use-package xclip :ensure t)
(use-package rainbow-delimiters :ensure t)
(use-package swiper-helm :ensure t)
(use-package multiple-cursors :ensure t)
(use-package helm-tramp :ensure t)
(use-package magit :ensure t)
(use-package jedi :ensure t)
(use-package exec-path-from-shell :ensure t)
(use-package ace-window :ensure t)
(use-package babel :ensure t)
;; (use-package sqlformat :ensure t)

;; Hooks
(when (memq window-system '(mac ns)) (exec-path-from-shell-initialize))

;; (setq sqlformat-command 'sqlfluff)

(add-hook 'prog-mode-hook 'linum-mode)
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)
(add-hook 'prog-mode-hook 'flycheck-mode)
(add-hook 'org-mode-hook 'flyspell-mode)
;; (add-hook 'sql-mode-hook 'sqlformat-on-save-mode)

;; (add-hook 'python-mode-hook 'jedi:ac-setup)
;; (add-hook 'python-mode-hook 'jedi:setup)


;; Variable Definitions
(setq yas-snippet-dirs '("~/.emacs.d/snippets"))
(setq backup-directory-alist '(("." . "~/.emacs-saves")))
(setq org-src-tab-acts-natively t)

(setq-default inhibit-startup-screen t)
(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)
(setq initial-scratch-message "")
(setq shell-command-switch "-c")
(setq search-default-mode #'char-fold-to-regexp)
(setq dired-dwim-target t)
(setq flycheck-check-syntax-automatically '(mode-enabled save))
(setq jedi:complete-on-dot t)

(setq indent-line-function 'tab-to-tab-stop) ;; SQL-Mode 4 space tab

(put 'upcase-region 'disabled nil)
(put 'dired-find-alternate-file 'disabled nil)
(put 'downcase-region 'disabled nil)

;; Key Bindings
;; (global-set-key (kbd "M-x") '(helm-M-x))
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "C-x d") 'counsel-dired-jump)
(global-set-key (kbd "C-x b") 'helm-buffers-list)
(global-set-key (kbd "M-y") 'helm-show-kill-ring)
(global-set-key "\C-s" 'swiper-helm)
(global-set-key (kbd "C-x o") 'ace-window)
(global-set-key (kbd "C-=") 'er/expand-region)

(global-set-key [(control f3)] 'highlight-symbol)
(global-set-key [f3] 'highlight-symbol-next)
(global-set-key [(shift f3)] 'highlight-symbol-prev)
(global-set-key [(meta f3)] 'highlight-symbol-query-replace)

(global-set-key (kbd "C-<f2>") 'jedi:show-doc)
(global-set-key (kbd "<f2>") 'jedi:goto-definition)
(global-set-key (kbd "<f1>") 'jedi:goto-definition-pop-marker)
(global-set-key (kbd "M-c") 'org-table-export)

(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-.") 'mc/skip-to-next-like-this)
(global-set-key (kbd "C-,") 'mc/unmark-next-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)
(global-set-key (kbd "<f12>") 'flyspell-auto-correct-previous-word)

(global-set-key (kbd "<f8>") 'org-tree-slide-mode)
(global-set-key (kbd "S-<f8>") 'org-tree-slide-skip-done-toggle)

(define-key global-map [(insertchar)] nil)
(define-key global-map [(insert)] nil)
(define-key global-map [(control insert)] 'overwrite-mode)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)

(global-set-key [C-backspace] '(lambda () (interactive) (kill-line 0)) ) ;M-k kills to the left

(with-eval-after-load "org-tree-slide"
  (define-key org-tree-slide-mode-map (kbd "<f9>") 'org-tree-slide-move-previous-tree)
  (define-key org-tree-slide-mode-map (kbd "<f10>") 'org-tree-slide-move-next-tree))

;; Custom Functions
(defun insert-current-date ()
  (interactive)
  (insert (shell-command-to-string "echo -n $(date +%b-%d-%4Y)")))

(defadvice org-mode-flyspell-verify (after org-mode-flyspell-verify-hack activate)
  (let* ((rlt ad-return-value)
         (begin-regexp "^[ \t]*#\\+begin_\\(src\\|html\\|latex\\|example\\|quote\\)")
         (end-regexp "^[ \t]*#\\+end_\\(src\\|html\\|latex\\|example\\|quote\\)")
         (case-fold-search t)
         b e)
    (when ad-return-value
      (save-excursion
        (setq b (re-search-backward begin-regexp nil t))
        (if b (setq e (re-search-forward end-regexp nil t))))
      (if (and b e (< (point) e)) (setq rlt nil)))
    (setq ad-return-value rlt)))

;; SQL use 1 tab

(add-hook 'sql-mode-hook
      (lambda ()
        (setq indent-tabs-mode t)
        (setq tab-width 4)
        (setq sql-indent-offset 4)))


(xclip-mode 1) ;; https://stackoverflow.com/questions/5288213/how-can-i-paste-the-selected-region-outside-of-emacs/14659015#14659015
(pending-delete-mode t)
(yas-global-mode 1)
(yas-reload-all)
(projectile-mode +1)
(helm-projectile-on)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#242424" "#e5786d" "#95e454" "#cae682" "#8ac6f2" "#333366" "#ccaa8f" "#f6f3e8"])
 '(custom-enabled-themes '(manoj-dark))
 '(custom-safe-themes
   '("2dff5f0b44a9e6c8644b2159414af72261e38686072e063aa66ee98a2faecf0e" default))
 '(ivy-mode t)
 '(menu-bar-mode nil)
 '(org-babel-load-languages '((emacs-lisp . t) (R . t)))
 '(org-confirm-babel-evaluate nil)
 '(package-selected-packages
   '(sqlformat ace-flyspell ace-flypsell sql-indent exec-path-from-shell popwin julia-repl rainbow-delimiters use-package general swiper-helm counsel ivy vterm-toggle vterm haskell-mode expand-region xclip json-reformat org-babel-eval-in-repl flycheck jedi org-tree-slide flyspell-correct multiple-cursors julia-mode auctex org-projectile-helm helm-c-yasnippet yasnippet magit helm-projectile projectile helm htmlize highlight-symbol))
 '(projectile-mode t nil (projectile))
 '(scroll-bar-mode nil)
 '(tool-bar-mode nil)
 '(tooltip-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Hack" :foundry "SRC" :slant normal :weight normal :height 128 :width normal)))))

(set-face-attribute 'default nil :height 180)


