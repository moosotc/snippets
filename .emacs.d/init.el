;; -*- Mode: Emacs-Lisp -*-
(set-fontset-font "fontset-default"
                  ;; Supplemental Symbols and Pictographs
                  '(#x1f900 . #x1f9ff) "code2003" nil)
(server-start)
(defun switch-to-other-buffer ()
  (interactive)
  (switch-to-buffer (other-buffer (current-buffer) 1)))

(set-variable 'next-error-highlight t)
(delete-selection-mode 1)

(setq-default
 indent-tabs-mode nil
 font-lock-maximum-decoration '((c-mode . 2) (t . t)))

(setq
 auto-save-directory (expand-file-name "~/.emacs.d/autosave")
 auto-save-directory-fallback auto-save-directory
 auto-save-hash-p nil
 inhibit-startup-echo-area-message "malc"
 compile-command ""
 chess-images-default-size 80
 backup-directory-alist `(("." . "~/.emacs.d/backups"))

 desktop-path '("~/.emacs.d")
 desktop-restore-frames nil
 desktop-buffers-not-to-save
 (concat "\\("
         "^nn\\.a[0-9]+\\|\\.log\\|(ftp)\\|^tags\\|^TAGS"
         "\\|\\.emacs.*\\|\\.diary\\|\\.newsrc-dribble\\|\\.bbdb"
         "\\)$")
 mail-user-agent 'gnus-user-agent
 user-mail-address "clamky@hotmail.com"
 package-archives
 '(
   ("gnu" . "http://elpa.gnu.org/packages/")
   ;; ("sunr" ."http://joseito.republika.pl/sunrise-commander/")
   ;; ("marmalade" . "http://marmalade-repo.org/packages/")
   ("melpa" . "http://melpa.org/packages/")
   )

 undo-limit 120000
 whitespace-global-modes '(not erc-mode)
 whitespace-style '(face
                    trailing
                    indentation::tabs
                    lines-tail
                    empty
                    tabs
                    tab-mark)

 org-log-done t

 ad-redefinition-action 'accept

 browse-url-mosaic-program ""
 initial-scratch-message ""
 use-dialog-box nil
 calendar-week-start-day 1

 delete-key-deletes-forward t
 save-abbrevs 'silently
 compilation-scroll-output t
 mouse-yank-at-point t
 frame-title-format '("emacs: " (buffer-file-name "%f" "%b"))

 efs-auto-save t
 efs-auto-save-remotely nil

 completion-auto-help t   ;; I want as much help as I can get
 completion-auto-exit nil ;; Don't want to always hit return

 ;; Tell cc-mode not to check for old-style (K&R) function declarations.
 ;; This speeds up indenting a lot.
 c-recognize-knr-p nil

 x-super-keysym 'meta
 x-alt-keysym 'meta
 x-meta-keysym 'hyper

 pending-delete-modeline-string "-+"

 track-eol nil
 print-escape-newlines t
 inhibit-startup-message t
 default-major-mode 'text-mode
 garbage-collection-messages nil

 ;; show position
 line-number-mode t
 column-number-mode t

 next-line-add-newlines nil
 require-final-newline t
 signal-error-on-buffer-boundary nil

 ;; autosave

 ;; now that we have auto-save-timeout, let's crank this up
 ;; for better interactive response.
 auto-save-interval 0
 auto-save-timeout 0

 ;; little compilation window
 compilation-window-height 15

 ;; remove anoying bell
 bell-volume 0

 ;; said to improve remote speed
 interprogram-cut-function nil
 interprogram-paste-function nil

 ;; dont use w3
 browse-url-browser-function 'browse-url-generic
 browse-url-generic-program "runffox"
 )

;; Misc
(defun re-kill-buffers (re)
  (interactive "sRegexp: \n")
  (dolist (b (mapcan (lambda (e)
                       (if (string-match re (buffer-name e))
                           (list e) ()))
                     (buffer-list)))
    (kill-buffer b)))

(defun right-align-region-str (what beg end)
  (interactive "sWhat to look for: \nr")
  (let ((ps '())
        (max-point -1)
        (slen (string-width what))
        (bpat (concat "[^ ] *" what)))
    (save-excursion
      (goto-char beg)

      (while (and (< (point) end)
                  (re-search-forward what end t))
        (let ((bol (point-at-bol))
              (pm (1- (point))))
          (re-search-backward bpat bol t)
          (forward-char)
          (let ((pw (point)))
            (setq ps (cons (cons pm pw) ps))
            (setq max-point (max (- pw bol) max-point))))
        (forward-line 1))

      (if (= max-point -1)
          (message "%s not found in region" what)
        (dolist (pp ps)
          (let* ((pm (car pp))
                 (pw (cdr pp))
                 (xx (goto-char pw))
                 (pd (+ (- pw pm) (- max-point (- pw (point-at-bol))) slen)))
            (goto-char pw)
            (if (> pd 0)
                (insert-char 32 pd)
              (delete-char pd))))))))

(defun right-align-= (beg end)
  (interactive "r")
  (right-align-region-str "=" beg end))

(defun right-align-> (beg end)
  (interactive "r")
  (right-align-region-str "->" beg end))

(blink-cursor-mode 0)
(defun describe-function-at-point ()
  (interactive)
  (describe-function (function-called-at-point)))

(defun describe-variable-at-point ()
  (interactive)
  (describe-variable (variable-at-point)))

(defun my-delete-window ()
  (interactive)
  (if (> (count-windows) 1) (delete-window)))

(defun good-buffer-p (&optional buffer)
  (let ((buffer-name (buffer-name buffer)))
    (or (member buffer-name '("*scratch*" "*cvs*"))
        (not (string-match "^ ?\\*.*\\*$" buffer-name)))))

(defun my-kill-this-buffer-and-window ()
  (interactive)
  (kill-this-buffer)
  (if (= (count-windows) 2) (delete-window))
  (or (good-buffer-p)
      (switch-to-buffer
       (or (cl-find-if 'good-buffer-p (buffer-list)) "*scratch*"))))

(defun my-kill-this-buffer-and-window ()
  (interactive)
  (let ((buffer (current-buffer)))
    (unless (= (count-windows) 1)
      (other-window 1)
      (delete-other-windows))
    (kill-buffer buffer)))

(defun my-recompile ()
  (interactive)
  (let ((compilation-ask-about-save nil))
    (if (fboundp 'recompile)
        (recompile)
      (message "compile first"))))

;; **********************************************************************
;; hooks
;; **********************************************************************
(defun my-lisp-mode-hook ()
  (put 'with-slots 'lisp-indent-function 2)
  (put 'with-open-file 'lisp-indent-function 'defun)
  (put 'with-open-stream 'lisp-indent-function 'defun))

(add-hook 'lisp-mode-hook 'my-lisp-mode-hook)
(add-hook 'emacs-lisp-mode-hook 'my-lisp-mode-hook)

(defun my-bookmark-mode-hook ()
  (local-set-key (kbd "<return>") 'bookmark-bmenu-select))

(add-hook 'bookmark-bmenu-mode-hook 'my-bookmark-mode-hook)

(defun my-c-mode-hook ()
  (define-key c-mode-map (kbd "H-[") 'c-insert-curly-braces)
  (local-set-key (kbd "<return>") 'newline-and-indent)
  (c-set-style "bsd")
  (setq c-basic-offset 4)
  (c-set-offset 'statement-case-open 4)
  (c-set-offset 'case-label 0))

(defun my-sh-mode-hook ()
  (define-key sh-mode-map (kbd "H-[") 'sh-insert-curly-braces))

(add-hook 'c-mode-hook 'my-c-mode-hook)
(add-hook 'c++-mode-hook 'my-c-mode-hook)
(add-hook 'sh-mode-hook 'my-sh-mode-hook)

;;; **********************************************************************
;;; OCaml
;;; **********************************************************************
(setq completion-ignored-extensions (append
                                     '(".cmo" ".cmx" ".cma" ".cmxa" ".cmi")
                                     completion-ignored-extensions))

(defun caml-comment-till-end-of-line (&optional arg)
  (interactive "P")
  (save-excursion
    (if (looking-at search-whitespace-regexp)
        (re-search-forward search-whitespace-regexp))
    (comment-region (point) (progn (end-of-line) (point)) arg)))

;; ----------------------------------------------------------------------
(defun my-match-paren (arg)
  "Go to the matching parenthesis if on parenthesis otherwise insert %."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
        ((looking-at "\\s\)") (forward-char 1) (backward-list 1))
        (t (self-insert-command (or arg 1)))))

;;; ********
;;; Few advices for FSF to behave more like Lucid
(defadvice describe-key (after activate)
  (switch-to-buffer-other-window "*Help*"))

(defadvice describe-mode (after activate)
  (switch-to-buffer-other-window "*Help*"))

(defadvice describe-function (after activate)
  (switch-to-buffer-other-window "*Help*"))

(defadvice describe-variable (after activate)
  (switch-to-buffer-other-window "*Help*"))

(defadvice describe-bindings (after activate)
  (switch-to-buffer-other-window "*Help*"))

(defadvice apropos-command (after activate)
  (switch-to-buffer "*Apropos*")
  (delete-other-windows))

(defadvice ibuffer-list-buffers (after activate)
  (switch-to-buffer-other-window "*Ibuffer*")
  (hl-line-mode 1)
  (setq cursor-type nil))

(defadvice apropos (after activate)
  (switch-to-buffer "*Apropos*")
  (delete-other-windows))

(defadvice man (after activate)
  (delete-window))

(defun insert-quotes ()
  (interactive)
  (insert "\"\"")
  (goto-char (- (point) 1)))

(defun my-insert-parentheses (beg end)
  (interactive "*r")
  (save-excursion
    (goto-char beg)
    (forward-sexp)
    (backward-sexp)
    (insert "(")
    (goto-char end)
    (backward-sexp)
    (forward-sexp)
    (insert ")")))

(defun my-insert-parentheses-no-space ()
  (interactive)
  (let ((parens-require-spaces
         (save-excursion
           (backward-word)
           (looking-at "\\(if\\)\\|\\(for\\)\\|\\(while\\)"))))
    (insert-parentheses nil)))

(defvar caml-mode-map (make-sparse-keymap))
(define-key caml-mode-map (kbd "<return>") 'newline-and-indent)
(define-key caml-mode-map (kbd "<delete>") 'delete-char)
(define-key caml-mode-map (kbd "C-c C-q") 'caml-indent-phrase)

;;;======================================================================
;;; Desktop + Session
;;;======================================================================
(savehist-mode)
(desktop-save-mode)
(setq desktop-modes-not-to-save
      (append desktop-modes-not-to-save
              '(vc-dir-mode dired-mode Info-mode
                            info-lookup-mode fundamental-mode)))

(defun bsd-parens ()
  (interactive)
  (local-set-key (kbd "H-9") 'my-insert-parentheses-no-space))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(helm-bookmark-info ((t (:foreground "tomato3" :weight bold))))
 '(org-headline-done ((t ())))
 '(helm-M-x-key ((t (:foreground "blue1"))))
 '(helm-locate-finish ((t (:foreground "black"))))
 '(Info-quoted ((t nil)))
 '(button ((t (:inherit (link)))))
 '(cursor ((t (:background "tomato4"))))
 '(speed-type-correct ((t (:foreground "darkgreen"))))
 '(erc-current-nick-face ((t (:foreground "green4" :weight bold))))
 '(erc-keyword-face ((t (:foreground "blue1" :weight bold))))
 '(erc-timestamp-face ((t (:foreground "dark green" :weight bold))))
 '(escape-glyph ((t (:foreground "#0076c1"))))
 '(fixed-pitch ((t (:inherit (default)))))
 '(font-lock-builtin-face ((t (:weight bold))))
 '(font-lock-comment-delimiter-face ((default (:inherit (font-lock-string-face)))))
 '(font-lock-comment-face ((t (:foreground "#204A87"))))
 '(font-lock-doc-face ((t (:foreground "#527c00"))))
 '(font-lock-function-name-face ((t (:weight bold :foreground "#00578E"))))
 '(font-lock-keyword-face ((t (:foreground "#A52A2A"))))
 '(font-lock-negation-char-face ((t (:foreground "#204A87"))))
 '(font-lock-preprocessor-face ((t (:foreground "#c80084"))))
 '(font-lock-regexp-grouping-backslash ((t (:foreground "#555753"))))
 '(font-lock-regexp-grouping-construct ((t (:foreground "#888a85"))))
 '(font-lock-string-face ((t (:foreground "#0076c1"))))
 '(font-lock-type-face ((t (:foreground "#004d41"))))
 '(font-lock-variable-name-face ((t (:weight bold :foreground "#0076c1"))))
 '(font-lock-warning-face ((t (:weight bold :foreground "#CC0000"))))
 '(fringe ((t (:background "#DBDBDB"))))
 '(gnus-cite-5 ((t (:foreground "maroon"))))
 '(header-line ((t (:foreground "#555753" :background "#C3C7CF"))))
 '(highlight ((t (:foreground "#2E3436" :background "#FEFFBF"))))
 '(hl-line ((t (:background "black" :foreground "white"))))
 '(isearch ((t (:foreground "#FFFFFF" :background "#204A87"))))
 '(isearch-fail ((t (:foreground "#FFFFFF" :background "#CC0000"))))
 '(lazy-highlight ((t (:foreground "#555753" :background "#FEFFBF"))))
 '(link ((t (:underline (:color foreground-color :style line) :foreground "#0066CC"))))
 '(link-visited ((t (:underline (:color foreground-color :style line) :foreground "#c80084"))))
 '(match ((t (:foreground "#FFFFFF" :background "#00578E"))))
 '(minibuffer-prompt ((t (:weight bold :foreground "#0066CC"))))
 '(mode-line ((t (:height 0.9 :box (:line-width 1 :color nil :style nil)))))
 '(mode-line-buffer-id ((t (:height 0.9 :foreground "#2E3436"))))
 '(mode-line-emphasis ((t (:weight bold))))
 '(mode-line-highlight ((t (:height 0.9 :foreground "#2E3436" :background "#FEFFBF"))))
 '(next-error ((t (:inherit (region)))))
 '(query-replace ((t (:inherit (isearch)))))
 '(region ((t (:background "#FEFFBF"))))
 '(secondary-selection ((t (:background "#EDD400"))))
 '(sh-heredoc ((t (:foreground "dim gray"))))
 '(shadow ((t (:foreground "#555753"))))
 '(c-electric-flag nil)
 '(variable-pitch ((t (:inherit (default))))))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(canlock-password "320a46eeec84e8e4e041534d821600d69eb36d15")
 '(dired-listing-switches "-aBhl --dired --group-directories-first --sort=extension")
 '(erc-log-channels-directory "~/x/log/erc")
 '(erc-nick "malc")
 '(ibuffer-default-sorting-mode 'mode-name)
 '(load-home-init-file t t)
 '(org-agenda-files '("~/x/org/agenda"))
 '(org-support-shift-select t)
 '(package-selected-packages
   '(monkeytype speed-type typing typit ag pinentry highlight-numbers lacarte xkcd tuareg helm-ls-git helm-git-grep helm-bbdb helm-ag)))

;; Takk till Stig Erik Sandø
(setq message-send-mail-function 'smtpmail-send-it
      smtpmail-starttls-credentials '(("smtplive.com" 587 nil nil))
      smtpmail-default-smtp-server "smtp.live.com"
      smtpmail-smtp-server "smtp.live.com"
      smtpmail-smtp-service 587)

(defun transpose-assignment ()
  (interactive)
  (replace-regexp
   "\\(\\W+\\)\\(.*\\) = \\(.*\\);"
   "\\1\\3 = \\2;"))

(defun transpose-arrow ()
  (interactive)
  (replace-regexp
   "\\(\\W+\\)\\(.*\\) -> \\(.*\\)"
   "\\1\\3 -> \\2"))

(fset 'yes-or-no-p 'y-or-n-p)

(defun c-insert-curly-braces ()
  "Insert a pair of curly braces in a C buffer."
  (interactive)
  (if (looking-at " ")
      (insert "{")
    (insert " {"))
  (c-indent-command)
  (c-context-line-break)
  (c-context-line-break)
  (insert "}")
  (c-indent-command)
  (forward-line -1)
  (c-indent-command))

(defun sh-insert-curly-braces ()
  "Insert a pair of curly braces in a Shell Script buffer."
  (interactive)
  (if (looking-at " ")
      (insert "{")
    (insert " {"))
  (indent-for-tab-command)
  (newline)
  (newline)
  (insert "}")
  (indent-for-tab-command)
  (forward-line -1)
  (indent-for-tab-command))

(add-hook 'Info-mode-hook             ; After Info-mode has started
          (lambda ()
            (setq Info-additional-directory-list
                  '("/usr/share/info"
                    "/home/malc/x/rcs/git/emacs/info"
                    "/net/share/info"))
            ;; Info-default-directory-list)
            ))

(autoload 'helm-imenu "helm-imenu")
(autoload 'gnus "gnus" "gnus" t)
(autoload 'global-whitespace-mode "whitespace" "whitespace mode" t)
(global-whitespace-mode)

(defun selector-moo ()
  (hl-line-mode 1)
  (setq cursor-type nil))

(defun selector-moo0 ()
  (hl-line-mode 1))

(add-hook 'dired-mode-hook 'selector-moo0)
(add-hook 'bs-mode-hook 'selector-moo0)
(add-hook 'package-menu-mode-hook 'selector-moo0)

(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)

(put 'scroll-left 'disabled nil)

(defun fromatoz ()
  (interactive)
  (require 'cl)
  (insert
   (format "%s" (loop for a from ?A to ?Z collect (format "%c\n" a)))))

(set-selection-coding-system 'utf-8)
(set-clipboard-coding-system 'utf-8)

(setq select-enable-clipboard nil)
(setq select-enable-primary nil)

(defun my-only-yank-x-clipboard ()
  (interactive)
  (insert (gui-get-selection 'CLIPBOARD)))

(put 'dired-find-alternate-file 'disabled nil)

(defun notify-moo (s)
  (with-temp-buffer
    (if (string-equal s (string #x1))
        (insert s)
      (insert "☎  " s))
    (when (file-writable-p "/tmp/i3.fifo")
      (write-region (point-min)
                    (point-max)
                    "/tmp/i3.fifo"))))

(add-hook 'tuareg-mode-hook
          (function
           (lambda ()
             (load "caml")
             (setq imenu-create-index-function 'caml-create-index-function)

             ;; Merci - Christophe Troestler, Stefan Monnier
             ;; https://github.com/ocaml/tuareg/issues/105
             (advice-add 'tuareg-smie-rules :before-until
                         (lambda (kind token)
                           (and (eq kind :before)
                                (equal token "|-or")
                                (smie-rule-parent-p "|")
                                (smie-rule-parent)))))))

(load "~/.emacs.d/lacarte.elc")
(load "~/x/rcs/git/helm-lacarte/helm-lacarte.elc")
(require 'highlight-numbers)
(add-hook 'prog-mode-hook 'highlight-numbers-mode)
(set-face-foreground 'highlight-numbers-number "DodgerBlue4")

(defun lispy ()
  (interactive)
  (if (equal major-mode 'lisp-interaction-mode)
      (switch-to-other-buffer)
    (switch-to-buffer "*scratch*")
    (lisp-interaction-mode)))

(defun orgy ()
  (interactive)
  (insert "#+TODO: TODO(t) | DONE(t)")
  (org-mode))

;; https://stackoverflow.com/questions/24904208/emacs-windows-org-mode-encoding
(modify-coding-system-alist 'file "" 'utf-8-unix)

(add-hook 'help-mode-hook 'scroll-lock-mode)
(add-hook 'gnus-article-mode-hook 'scroll-lock-mode)

(defun my-date () (format-time-string "%a %d.%m.%Y"))
(defun my-date-ins () (interactive) (insert (my-date)))

(defun my-time () (format-time-string "%H:%M"))
(defun my-time-ins () (interactive) (insert (my-time)))

(defun my-org-date () (format-time-string "%d.%m"))
(defun my-org-time () (format-time-string "%H:%M"))

(setq erc-server "irc.libera.chat")
(setq org-todo-keywords '((sequence "TODO(t!)" "|" "DONE(d!)" "CANCELED(c@)")))
(set-scroll-bar-mode 'left)
(defadvice speed-type--setup (after activate)
  (local-set-key (kbd "H-<escape>") 'speed-type--replay))

(setq-default scroll-bar-width 8)
(setq org-startup-folded t)

(defun my-close-org-element ()
  (interactive)
  (org-up-element)
  (org-cycle))

(defun my-org-mode-hook ()
  (princ "org mode")
  (define-key org-mode-map (kbd "H-<tab>") 'my-close-org-element))

(add-hook 'org-mode-hook 'my-org-mode-hook)
(defun copy-buffer-file-name ()
  (interactive) (gui-set-selection 'CLIPBOARD (buffer-file-name)))

(defun my-erc-track-switch-buffer ()
  (interactive) (erc-track-switch-buffer -1))

(autoload 'helm-imenu "helm-imenu")

;;======================================================================
;; redefine global and mode specific key sequences
(global-set-key (kbd "H-7") 'helm-imenu)
(global-set-key (kbd "C-x f") 'helm-find-files)
;; http://orgmode.org/worg/org-tutorials/orgtutorial_dto.html
(global-set-key (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-x r b") 'helm-filtered-bookmarks)
(global-set-key (kbd "H-\\") 'my-only-yank-x-clipboard)
(global-set-key (kbd "H-t") 'my-erc-track-switch-buffer)
(global-set-key (kbd "H-d") 'erc-track-switch-buffer)
(global-set-key (kbd "M-H-l") 'lispy)
(global-set-key (kbd "M-H-L") 'orgy)
(global-set-key (kbd "H-h") (lambda () (interactive) (scroll-up 1)))
(global-set-key (kbd "H-s") (lambda () (interactive) (scroll-down 1)))
(global-set-key (kbd "H-c") 'my-recompile)
(global-set-key (kbd "M-H-c") 'compile)
(global-set-key (kbd "H-3") 'my-match-paren)
(global-set-key (kbd "H-x H-b") 'ibuffer-list-buffers)
(global-set-key (kbd "H-b") 'helm-for-files)
(global-set-key (kbd "H-9") 'insert-parentheses)
(global-set-key (kbd "H-0") 'helm-browse-menubar)
(global-set-key (kbd "H-'") 'insert-quotes)
(global-set-key (kbd "H-q") 'my-kill-this-buffer-and-window)
(global-set-key (kbd "H-;") 'caml-comment-till-end-of-line)
(global-set-key (kbd "C-=") 'pop-to-mark-command)
(global-set-key (kbd "H-a") 'beginning-of-buffer)
(global-set-key (kbd "H-e") 'end-of-buffer)
(global-set-key (kbd "M-.") 'helm-git-grep-at-point)
(global-set-key (kbd "H-.") 'helm-ag-this-file)
(global-set-key (kbd "C-H-.") 'helm-resume)
(global-set-key (kbd "H-l") 'switch-to-other-buffer)
(global-set-key (kbd "H-|") 'yank-from-kill-ring)
(global-set-key (kbd "H-1") 'other-window)

(global-set-key (kbd "C-h a") 'apropos)
(global-set-key (kbd "C-x .") 'helm-ag)

(global-unset-key (kbd "C-x C-b")) ;; 'helm-buffers-list)
(global-unset-key (kbd "C-x b"))   ;; 'helm-for-files)

(global-set-key (kbd "H-M-<right>") 'mark-end-of-sentence)
(global-set-key (kbd "H-S-<insert>") 'yank-from-kill-ring)
(global-set-key (kbd "H-<right>") 'bs-cycle-next)
(global-set-key (kbd "H-<left>") 'bs-cycle-previous)
(global-set-key (kbd "C-<delete>") 'kill-word)
(global-set-key (kbd "M-<backspace>") 'backward-kill-word)

(define-key emacs-lisp-mode-map (kbd "H-,") 'describe-variable-at-point)
(define-key emacs-lisp-mode-map (kbd "H-.") 'describe-function-at-point)

(global-set-key (kbd "H-/") 'helm-occur)

;;; Local Variables:
;;; End:
