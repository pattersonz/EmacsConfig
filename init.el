(defconst user-init-dir
  (cond ((boundp 'user-emacs-directory)
         user-emacs-directory)
        ((boundp 'user-init-directory)
         user-init-directory)
        (t "~/.config/emacs")))


(defun load-user-file (file)
  (interactive "f")
  "Load a file in current user's configuration directory"
  (load-file (expand-file-name file user-init-dir)))

;;Elpaca

(load-user-file "elpaca.el")

;;packages
(use-package nerd-icons :ensure :demand t)
(use-package autothemer :ensure :demand t
  :config (load-theme 'automata t))
(use-package beacon :ensure
  :config (beacon-mode))
(use-package treemacs :ensure :demand t)
(use-package undo-tree :ensure :demand t
  :config
  (global-undo-tree-mode))
(use-package evil
  :ensure
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-vsplit-right t)
  (setq evil-split-window-below t)
  (setq evil-want-minibuffer nil)
  :config
  (evil-mode)
  (evil-set-initial-state 'dired-mode 'emacs))
(use-package evil-collection :after evil :ensure
  :config
  (setq evil-collection-mode-list '(dashboard buffer)))
(use-package ivy
  :ensure
  :custom
  (setq ivy-use-virtual-buffers t)
  (setq ivy-count-format "(%d/%d) ")
  (setq enable-recursive-minibuffers t)
  :config
  (ivy-mode))
(use-package nerd-icons-ivy-rich :ensure t
  :init (nerd-icons-ivy-rich-mode 1))
(use-package ivy-rich :ensure
  :after ivy
  :init (ivy-rich-mode 1)
  :custom
  (ivy-virtual-abbreviate 'full
			  ivy-rich-switch-buffer-align-virtual-buffer t
			  ivy-rich-path-style 'abbrev)
  :config
  (ivy-set-display-transformer 'ivy-switch-buffer
			       'ivy-rich-switch-buffer-transformer))
(use-package counsel
  :ensure t
  :after ivy
  :diminish
  :config (counsel-mode))

(use-package vertico :ensure
  :config (vertico-mode))
(use-package dirvish
  :ensure t
  :init
  (dirvish-override-dired-mode)
  :config
  ;; (dirvish-peek-mode)             ; Preview files in minibuffer
  ;; (dirvish-side-follow-mode)      ; similar to `treemacs-follow-mode'
  (setq dirvish-mode-line-format
        '(:left (sort symlink) :right (omit yank index)))
  (setq dirvish-attributes           ; The order *MATTERS* for some attributes
        '(vc-state subtree-state nerd-icons collapse git-msg file-time file-size)
        dirvish-side-attributes
        '(vc-state nerd-icons collapse file-size))
  :bind ; Bind `dirvish-fd|dirvish-side|dirvish-dwim' as you see fit
  (("C-c f" . dirvish)
   :map dirvish-mode-map          ; Dirvish inherits `dired-mode-map'
   ;; (";" . dired-up-directory)  ; So you can adjust dired bindings here
   ("?"   . dirvish-dispatch)     ; contains most of sub-menus in dirvish extensions
   ("f"   . dirvish-history-go-forward)
   ("b"   . dirvish-history-go-backward)
   ("y"   . dirvish-yank-menu)
   ("N"   . dirvish-narrow)
   ("^"   . dirvish-history-last)
   ("s"   . dirvish-setup-menu)   ; `sf' toggles fullframe, `st' toggles mtime, etc.
   ("h"   . dirvish-history-jump) ; remapped `describe-mode'
   ("r"   . dirvish-quicksort)    ; remapped `dired-sort-toggle-or-edit'
   ("v"   . dirvish-vc-menu)      ; remapped `dired-view-file'
   ("TAB" . dirvish-subtree-toggle)
   ("M-a" . dirvish-quick-access)
   ("M-f" . dirvish-file-info-menu)
   ("M-l" . dirvish-ls-switches-menu)
   ("M-m" . dirvish-mark-menu)
   ("M-t" . dirvish-layout-toggle)
   ("M-e" . dirvish-emerge-menu)
   ("M-j" . dirvish-fd-jump)))
 
(use-package dashboard
  :ensure t 
  :init
  (setq initial-buffer-choice 'dashboard-open)
  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-file-icons t)
  (setq dashboard-banner-logo-title "Emacs Is More Than A Text Editor!")
  ;;(setq dashboard-startup-banner 'logo) ;; use standard emacs logo as banner
  (setq dashboard-center-content nil) ;; set to 't' for centered content
  (setq dashboard-items '((recents . 5)
                          (agenda . 5 )
                          (bookmarks . 3)
                          (projects . 3)
                          (registers . 3)))
  :custom 
  (dashboard-modify-heading-icons '((recents . "file-text")
				    (bookmarks . "book")))
  :config
  (dashboard-setup-startup-hook))

(use-package projectile
  :ensure t
  :config
  (projectile-mode 1))

 
;;Extra Settings
(setq make-backup-files nil)
(global-display-line-numbers-mode 1)
(global-visual-line-mode t)
     
;; elisp and languages
(load-user-file "langs.el")

;; Bindings
(use-package general :ensure
     :config
     (general-evil-setup)
     (general-create-definer dt/leader-keys
			     :states '(normal insert visual emacs)
			     :keymaps 'override
			     :prefix "SPC"
			     :global-prefix "M-SPC")
     (dt/leader-keys
      "b"  '(:ignore t :wk "buffer")
      "bb" '(switch-to-buffer :wk "Switch buffer")
      "bk" '(kill-this-buffer :wk "Kill this buffer")
      "bn" '(next-buffer :wk "Next buffer")
      "bp" '(previos-buffer :wk "Previous buffer")
      "br" '(revert-buffer :wk "Reload buffer"))
)

(global-set-key (kbd "S-C-<up>") 'shrink-window-horizontally)
(global-set-key (kbd "S-C-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "S-C-<up>") 'enlarge-window)
(global-set-key (kbd "S-C-<down>") 'shrink-window)
(global-set-key (kbd "C-c l") 'windmove-right)
(global-set-key (kbd "C-c h") 'windmove-left)
(global-set-key (kbd "C-c k") 'windmove-up)
(global-set-key (kbd "C-c j") 'windmove-down)
(global-set-key (kbd "C-x h") 'previous-buffer)
(global-set-key (kbd "C-x l") 'next-buffer)

;; Theme
(add-to-list 'custom-theme-load-path "~/.config/emacs/themes")

(add-to-list 'default-frame-alist '(alpha-background . 90))





;; auto gen
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(dirvish-attributes
   '(vc-state subtree-state file-time file-size nerd-icons collapse
	      git-msg))
 '(evil-mode t)
 '(evil-split-window-below t)
 '(evil-want-keybinding nil)
 '(global-tree-sitter-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t nil)))
 '(button ((t (:foreground "darkorange4"))))
 '(custom-face-tag ((t (:inherit custom-variable-tag :foreground "darkslategray"))))
 '(custom-group-tag ((t (:inherit variable-pitch :foreground "darkolivegreen" :weight bold :height 1.2))))
 '(custom-state ((t (:foreground "chartreuse4"))))
 '(custom-variable-obsolete ((t (:foreground "saddlebrown"))))
 '(custom-variable-tag ((t (:foreground "saddlebrown" :weight bold))))
 '(dired-ignored ((t (:foreground "indianred"))))
 '(dirvish-file-time ((t (:foreground "darkolivegreen4"))))
 '(fill-column-indicator ((t (:stipple nil :foreground "black" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal))))
 '(link ((t (:foreground "darkslateblue" :underline t))))
 '(lsp-rust-analyzer-async-modifier-face ((t (:foreground "indianred"))))
 '(lsp-rust-analyzer-mutable-modifier-face ((t (:underline "seagreen"))))
 '(rust-ampersand-face ((t (:inherit default :foreground "darkolivegreen"))))
 '(shadow ((t (:foreground "lightslategray"))))
 '(warning ((t (:foreground "maroon" :weight extra-bold)))))
