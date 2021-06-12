;; -*- Mode: Emacs-Lisp -*-
(set-fontset-font "fontset-default"
                  ;; Supplemental Symbols and Pictographs
                  '(#x1f900 . #x1f9ff) "code2003" nil)
(server-start)
(defun switch-to-other-buffer ()
  (interactive)
  (switch-to-buffer (other-buffer (current-buffer) 1)))
(global-set-key "\C-ha" 'apropos)
(global-set-key (kbd "C-=") 'pop-to-mark-command)
(global-set-key [(meta hyper ? )] 'mark-end-of-sentence)
(global-set-key [(hyper ?a)] 'beginning-of-buffer)
(global-set-key [(hyper ?e)] 'end-of-buffer)
(set-variable 'next-error-highlight t)
(delete-selection-mode 1)
;; (electric-quote-mode)
(if (string-match "iosevka" (face-font 'default))
    (setq-default line-spacing 2))

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
 whitespace-style
 '(face
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
              (delete-char pd))))))))017


(defun right-align-= (beg end)
  (interactive "r")
  (right-align-region-str "=" beg end))

(defun right-align-> (beg end)
  (interactive "r")
  (right-align-region-str "->" beg end))

(global-set-key [C-delete] 'kill-word)
(blink-cursor-mode 0)

(global-set-key [M-backspace] 'backward-kill-word)
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
  (local-set-key [(return)] 'bookmark-bmenu-select))

(add-hook 'bookmark-bmenu-mode-hook 'my-bookmark-mode-hook)

(defun my-c-mode-hook ()
  (define-key c-mode-map [(hyper \[)] 'c-insert-curly-braces)
  (define-key c-mode-map [(hyper \])] 'c-insert-curly-braces2)
  (define-key c++-mode-map [(hyper \[)] 'c-insert-curly-braces)
  (define-key c++-mode-map [(hyper \])] 'c-insert-curly-braces2)
  (local-set-key [(return)] 'newline-and-indent)
  (c-set-style "bsd")
  (setq c-basic-offset 4)
  (c-set-offset 'statement-case-open 4)
  (c-set-offset 'case-label 0))

(defun my-sh-mode-hook ()
  (define-key sh-mode-map [(hyper \[)] 'sh-insert-curly-braces))

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
(defun match-paren (arg)
  "Go to the matching parenthesis if on parenthesis otherwise insert %."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
        ((looking-at "\\s\)")
         (forward-char 1) (backward-list 1))
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

(defun my-insert-parentheses-c ()
  (interactive)
  (let ((parens-require-spaces
         (save-excursion
           (backward-word)
           (looking-at "\\(if\\)\\|\\(for\\)\\|\\(while\\)"))))
    (princ parens-require-spaces)
    (insert-parentheses nil)))

;;======================================================================
;; redefine global and mode specific key sequences
(global-set-key [(hyper ?4)] 'match-paren)
(global-set-key [(hyper ?x) (control ?b)] 'ibuffer-lis-buffers)
(global-unset-key [(control ?x) (control ?b)]) ;; 'helm-buffers-list)
(global-unset-key [(control ?x) ?b]);; 'helm-for-files)
(global-set-key [(hyper ?b)] 'helm-for-files)
(global-set-key [(hyper ?9)] 'insert-parentheses)
(global-set-key [(hyper ?0)] 'my-insert-parentheses)
(global-set-key [(hyper ?')] 'insert-quotes)
(global-set-key [(hyper q)] 'my-kill-this-buffer-and-window)
(global-set-key [(hyper w)] 'my-delete-window)
(global-set-key [(hyper ?\[)] 'describe-function-at-point)
(global-set-key [(hyper ?\])] 'describe-variable-at-point)

(global-set-key [(hyper right)] 'bs-cycle-next)
(global-set-key [(hyper left)] 'bs-cycle-previous)

(global-set-key [(hyper ?\;)] 'caml-comment-till-end-of-line)

(defvar caml-mode-map (make-sparse-keymap))
(define-key caml-mode-map [(return)] 'newline-and-indent)
(define-key caml-mode-map [(delete)] 'delete-char)
(define-key caml-mode-map "\C-c\C-q" 'caml-indent-phrase)

;;;======================================================================
;;; Desktop + Session
;;;======================================================================
(savehist-mode)
(desktop-save-mode)
(add-to-list 'desktop-modes-not-to-save 'vc-dir-mode)
(add-to-list 'desktop-modes-not-to-save 'dired-mode)
(add-to-list 'desktop-modes-not-to-save 'Info-mode)
(add-to-list 'desktop-modes-not-to-save 'info-lookup-mode)
(add-to-list 'desktop-modes-not-to-save 'fundamental-mode)

(defun bsd-parens ()
  (interactive)
  (local-set-key [(hyper ?9)] 'my-insert-parentheses-c))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-headline-done ((t ()))) ;; (:foreground "#555753" :background "#C3C7CF"))))
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

(global-set-key "\C-x." 'helm-ag)
(global-set-key [(meta ?.)] 'helm-git-grep-at-point)
(global-set-key [(hyper ?.)] 'helm-ag-this-file)
(global-set-key [(ctrl hyper ?.)] 'helm-resume)

(fset 'yes-or-no-p 'y-or-n-p)

(global-set-key [(hyper ?l)] 'switch-to-other-buffer)

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

(defun c-insert-curly-braces2 ()
  "Insert a pair of curly braces and open-line after } in a C buffer."
  (interactive)
  (if (looking-at " ")
      (insert "{")
    (insert " {"))
  (c-indent-command)
  (c-context-line-break)
  (c-context-line-break)
  (insert "}")
  (c-indent-command)
  (open-line 1)
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
(global-set-key [(hyper ?7)] 'helm-imenu)

;; (global-set-key [(f1) (return)] 'woman)
(global-set-key [(f1) (return)] 'man)

(autoload 'gnus "gnus" "gnus" t)

(autoload 'global-whitespace-mode "whitespace" "whitespace mode" t)
(global-whitespace-mode)

(defun selector-moo ()
  (hl-line-mode 1)
  (setq cursor-type nil))
(defun selector-moo0 ()
  (hl-line-mode 1))

(dolist (mode '(c-mode caml-mode lisp-mode))
  (add-hook mode 'highlight-numbers-mode))
(add-hook 'dired-mode-hook 'selector-moo0)
(add-hook 'bs-mode-hook 'selector-moo0)
(add-hook 'package-menu-mode-hook 'selector-moo0)

(global-set-key "\C-xf" 'helm-find-files)
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)

(put 'scroll-left 'disabled nil)

(defun fromatoz ()
  (interactive)
  (require 'cl)
  (insert
   (format "%s" (loop for a from ?A to ?Z collect (format "%c\n" a)))))

;; http://orgmode.org/worg/org-tutorials/orgtutorial_dto.html
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)

(global-set-key (kbd "M-x")     'helm-M-x)
(global-set-key (kbd "C-x r b") 'helm-filtered-bookmarks)

(set-selection-coding-system 'utf-8)
(set-clipboard-coding-system 'utf-8)

(setq select-enable-clipboard nil)
(setq select-enable-primary nil)

(defun my-only-yank-x-clipboard ()
  (interactive)
  (insert (gui-get-selection 'CLIPBOARD)))

(global-set-key [(hyper ?\\)] 'my-only-yank-x-clipboard)
(global-set-key [(hyper ?/)] 'helm-occur)

(if t
    nil
  (defun my-yank-any (selt)
    ;; https://www.emacswiki.org/emacs/second-sel.el
    (let ((sel (gui-get-selection selt)))
      (funcall
       (if (fboundp 'insert-for-yank) 'insert-for-yank 'insert) sel)))

  (defun my-yank-primary () (interactive) (my-yank-any 'PRIMARY))
  (defun my-yank-clip () (interactive) (my-yank-any 'CLIPBOARD))

  (global-set-key [(hyper ?`)] 'kill-region)
  (global-set-key [(control ?`)] 'kill-region)

  (global-set-key [(control ?\\)] 'kill-ring-save)
  (global-set-key [(hyper ?\\)] 'my-yank-primary)
  (global-set-key [(hyper ?|)] 'my-yank-clip)

  (global-set-key [(hyper control ?\\)] 'clipboard-yank)

  (global-set-key [(control insert)] 'kill-ring-save) ;; fc660c
  (global-set-key [(hyper insert)] 'my-yank-primary)
  (global-set-key [(hyper shift insert)] 'my-yank-clip))

(global-set-key [(hyper ?t)] (lambda ()
                               (interactive)
                               (erc-track-switch-buffer -1)))
(global-set-key [(hyper ?n)] 'erc-track-switch-buffer)

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

(if (not (string-equal (user-login-name) "malc"))
    (global-set-key [(f10)] 'tmm-menubar)
  (load "~/.emacs.d/lacarte.elc")
  (load "~/x/rcs/git/helm-lacarte/helm-lacarte.elc")
  (require 'highlight-numbers)
  (add-hook 'prog-mode-hook 'highlight-numbers-mode)
  (set-face-foreground 'highlight-numbers-number "DodgerBlue4")
  (global-set-key [(f10)] 'helm-browse-menubar))

(defun lispy ()
  (interactive)
  (if (equal major-mode 'lisp-interaction-mode)
      (switch-to-other-buffer)
    (switch-to-buffer "*scratch*")
    (lisp-interaction-mode)))
(global-set-key [(meta hyper ?l)] 'lispy)

;; https://stackoverflow.com/questions/24904208/emacs-windows-org-mode-encoding
(modify-coding-system-alist 'file "" 'utf-8-unix)

(add-hook 'help-mode-hook 'scroll-lock-mode)
(add-hook 'gnus-article-mode-hook 'scroll-lock-mode)

(global-set-key [(hyper ?h)] (lambda () (interactive) (scroll-up 1)))
(global-set-key [(hyper ?s)] (lambda () (interactive) (scroll-down 1)))
(global-set-key [(hyper ?c)] 'my-recompile)
(global-set-key [(meta hyper ?c)] 'compile)
(defun my-date () (format-time-string "%a %d.%m.%Y"))
(defun my-date-pri () (interactive) (princ (my-date)))
(defun my-date-ins () (interactive) (insert (my-date)))

(defun my-org-date () (format-time-string "%d.%m"))
(defun my-org-time () (format-time-string "%H:%M"))

(setq erc-server "irc.libera.chat")
(setq org-todo-keywords '((sequence "TODO(t!)" "|" "DONE(d!)" "CANCELED(c@)")))
(set-scroll-bar-mode 'left)
(defadvice speed-type--setup (after activate)
  (local-set-key [(hyper escape)] 'speed-type--replay))

(setq-default scroll-bar-width 8)
(setq
 org-startup-folded t
 ;; https://stackoverflow.com/questions/12737317/collapsing-the-current-outline-in-emacs-org-mode
 org-cycle-emulate-tab 'white
 )
;;; Local Variables:
;;; End:
