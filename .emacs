;; -*- Mode: Emacs-Lisp -*-
(setq initial-scratch-message "")
(setq use-dialog-box nil)

(set-fontset-font "fontset-default"
                  ;; Supplemental Symbols and Pictographs
                  '(#x1f900 . #x1f9ff) "code2003" nil)
(eval '(setq inhibit-startup-echo-area-message "malc"))
(setq compile-command "make")
(server-start)
(setq chess-images-default-size 80)
(defun switch-to-other-buffer ()
  (interactive)
  (switch-to-buffer (other-buffer (current-buffer) 1)))
(global-set-key "\C-ha" 'apropos)
(global-set-key (kbd "C-'") 'pop-to-mark-command)
(global-set-key [(meta alt ? )] 'mark-end-of-sentence)
(set-variable 'next-error-highlight t)
(delete-selection-mode 1)
(setq x-super-keysym 'meta)
(setq x-alt-keysym 'alt)
(setq x-meta-keysym 'alt)
(if (string-match "iosevka" (face-font 'default))
    (setq-default line-spacing 2))

(setq auto-save-directory (expand-file-name "~/.emacs.d/autosave")
      auto-save-directory-fallback auto-save-directory
      auto-save-hash-p nil
      efs-auto-save t
      efs-auto-save-remotely nil
      )

(setq pending-delete-modeline-string "")
(setq filladapt-mode-line-string "")

(setq-default filladapt-mode t)
(when (fboundp 'turn-off-filladapt-mode)
  (add-hook 'c-mode-hook 'turn-off-filladapt-mode)
  (add-hook 'outline-mode-hook 'turn-off-filladapt-mode))

(setq completion-auto-help t   ;; I want as much help as I can get
      completion-auto-exit nil ;; Don't want to always hit return

      ;; Tell cc-mode not to check for old-style (K&R) function declarations.
      ;; This speeds up indenting a lot.
      c-recognize-knr-p nil

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
              (delete-backward-char pd))))))))

(defun right-align-= (beg end)
  (interactive "r")
  (right-align-region-str "=" beg end))

(defun right-align-> (beg end)
  (interactive "r")
  (right-align-region-str "->" beg end))

(setq save-abbrevs 'silently)
(setq-default font-lock-maximum-decoration
              '((c-mode . 2) (t . t)))
(setq compilation-scroll-output t)
(global-set-key [C-delete] 'kill-word)
(blink-cursor-mode 0)

(global-set-key [M-backspace] 'backward-kill-word)
(defun describe-function-at-point ()
  (interactive)
  (describe-function (function-called-at-point)))

(defun describe-variable-at-point ()
  (interactive)
  (describe-variable (variable-at-point)))

(setq delete-key-deletes-forward t
      mouse-yank-at-point t
      ;; modify frame title to show what exactly we are editing
      frame-title-format '("emacs: " (buffer-file-name "%f" "%b")))

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
    (recompile)))

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
  (define-key c-mode-map [(alt \[)] 'c-insert-curly-braces)
  (define-key c-mode-map [(alt \])] 'c-insert-curly-braces2)
  (define-key c++-mode-map [(alt \[)] 'c-insert-curly-braces)
  (define-key c++-mode-map [(alt \])] 'c-insert-curly-braces2)
  (local-set-key [(return)] 'newline-and-indent)
  (c-set-style "bsd")
  (setq c-basic-offset 4)
  (c-set-offset 'statement-case-open 4)
  (c-set-offset 'case-label 0))

(defun my-shell-mode-hook ()
  (define-key shell-script-mode-map [(alt \[)] 'c-insert-curly-braces)
  (define-key shell-script-mode-map [(alt \])] 'c-insert-curly-braces2))

(add-hook 'c-mode-hook 'my-c-mode-hook)
(add-hook 'c++-mode-hook 'my-c-mode-hook)
(add-hook 'shell-script-mode-hook 'my-shell-mode-hook)

(setq backup-directory-alist `(("." . "~/.emacs.d/backups")))
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
(setq ad-redefinition-action 'accept)

(defadvice describe-key (after dcxba activate)
  (switch-to-buffer-other-window "*Help*"))

(defadvice describe-mode (after dmxba activate)
  (switch-to-buffer-other-window "*Help*"))

(defadvice describe-function (after dfxba activate)
  (switch-to-buffer-other-window "*Help*"))

(defadvice describe-variable (after dvxba activate)
  (switch-to-buffer-other-window "*Help*"))

(defadvice describe-bindings (after dbxba activate)
  (switch-to-buffer-other-window "*Help*"))

(defadvice apropos-command (after acba activate)
  (switch-to-buffer "*Apropos*")
  (delete-other-windows))

(defadvice ibuffer-list-buffers (after acba activate)
  (switch-to-buffer-other-window "*Ibuffer*")
  (hl-line-mode 1)
  (setq cursor-type nil))

(defadvice apropos (after aba activate)
  (switch-to-buffer "*Apropos*")
  (delete-other-windows))

(defadvice man (after aba activate)
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
(global-set-key [?%] 'match-paren)
(global-set-key [(control ?x) (control ?b)] 'ibuffer-list-buffers)
(global-set-key [(control ?x) (?b)] 'helm-for-files)
(global-set-key [(f5)] 'compile)
(global-set-key [(f6)] 'my-recompile)
(global-set-key [(alt ?9)] 'insert-parentheses)
(global-set-key [(alt ?0)] 'my-insert-parentheses)
(global-set-key [(alt ?')] 'insert-quotes)
(global-set-key [(alt q)] 'my-kill-this-buffer-and-window)
(global-set-key [(alt w)] 'my-delete-window)
(global-set-key [(f11)] 'describe-function-at-point)
(global-set-key [(f12)] 'describe-variable-at-point)

(global-set-key [(alt right)] 'bs-cycle-next)
(global-set-key [(alt left)] 'bs-cycle-previous)

(global-set-key [(alt ?\;)] 'caml-comment-till-end-of-line)
(global-set-key [(control ?x) (control ?`)] 'previous-error)

(defvar caml-mode-map (make-sparse-keymap))
(define-key caml-mode-map [(return)] 'newline-and-indent)
(define-key caml-mode-map [(delete)] 'delete-char)
(define-key caml-mode-map "\C-c\C-q" 'caml-indent-phrase)

;;;======================================================================
;;; Desktop + Session
;;;======================================================================
(setq desktop-path '("~/.emacs.d"))
(setq desktop-restore-frames nil)
(savehist-mode)
(desktop-save-mode)

(setq desktop-buffers-not-to-save
      (concat "\\("
              "^nn\\.a[0-9]+\\|\\.log\\|(ftp)\\|^tags\\|^TAGS"
              "\\|\\.emacs.*\\|\\.diary\\|\\.newsrc-dribble\\|\\.bbdb"
              "\\)$"))
(add-to-list 'desktop-modes-not-to-save 'vc-dir-mode)
(add-to-list 'desktop-modes-not-to-save 'dired-mode)
(add-to-list 'desktop-modes-not-to-save 'Info-mode)
(add-to-list 'desktop-modes-not-to-save 'info-lookup-mode)
(add-to-list 'desktop-modes-not-to-save 'fundamental-mode)

(defun bsd-parens ()
  (interactive)
  (local-set-key [(alt ?9)] 'my-insert-parentheses-c))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(Info-quoted ((t nil)))
 '(button ((t (:inherit (link)))))
 '(cursor ((t (:background "orchid"))))
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
 '(erc-keyword-highlight-type 'all)
 '(erc-keywords '("moolc" "malc" "clam" "moosotc" "llpp"))
 '(erc-kill-buffer-on-part t)
 '(erc-kill-queries-on-quit t)
 '(erc-kill-server-buffer-on-quit t)
 '(erc-log-file-coding-system 'utf-8)
 '(erc-modules
   '(autojoin button completion fill irccontrols list log match menu move-to-prompt netsplit networks noncommands readonly ring stamp spelling track))
 '(erc-nick "malc_")
 '(erc-notice-highlight-type 'all)
 '(erc-track-position-in-mode-line t)
 '(ibuffer-default-sorting-mode 'mode-name)
 '(load-home-init-file t t)
 '(org-agenda-files '("~/x/org/agenda"))
 '(org-support-shift-select t)
 '(package-selected-packages
   '(pinentry highlight-numbers lacarte xkcd tuareg helm-ls-git helm-git-grep helm-bbdb helm-ag))
 '(safe-local-variable-values
   '((eval overwrite-mode t)
     (eval progn
           (c-set-offset 'innamespace '0)
           (c-set-offset 'inline-open '0)))))

(setq message-send-mail-function 'smtpmail-send-it
      smtpmail-starttls-credentials '(("smtp.gmail.com" 587 nil nil))
      smtpmail-auth-credentials '(("smtp.gmail.com" 587
                                   "moosotc@gmail.com" nil))
      smtpmail-default-smtp-server "smtp.gmail.com"
      smtpmail-smtp-server "smtp.gmail.com"
      smtpmail-smtp-service 587)

(setq mail-user-agent 'gnus-user-agent)
(setq user-mail-address "moosotc@gmail.com")

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

(setq-default indent-tabs-mode nil)

(global-set-key "\C-x." 'helm-ag)
(global-set-key [(meta ?.)] 'helm-git-grep-at-point)
(global-set-key [(alt ?.)] 'helm-ag-this-file)
(global-set-key [(ctrl alt ?.)] 'helm-resume)

(fset 'yes-or-no-p 'y-or-n-p)

(global-set-key [(alt ?l)] 'switch-to-other-buffer)

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
  (previous-line 1)
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
  (previous-line 1)
  (c-indent-command))

(add-hook 'Info-mode-hook             ; After Info-mode has started
          (lambda ()
            (setq Info-additional-directory-list
                  '("/home/malc/x/rcs/git/emacs/info" "/net/share/info"))
            ;; Info-default-directory-list)
            ))
(autoload 'helm-imenu "helm-imenu")
(global-set-key [(f7)] 'helm-imenu)
(setq package-archives
      '(
        ("gnu" . "http://elpa.gnu.org/packages/")
        ;; ("sunr" ."http://joseito.republika.pl/sunrise-commander/")
        ;; ("marmalade" . "http://marmalade-repo.org/packages/")
        ("melpa" . "http://melpa.org/packages/")
        )
      )

;; (global-set-key [(f1) (return)] 'woman)
(global-set-key [(f1) (return)] 'man)

(autoload 'gnus "gnus" "gnus" t)
(setq undo-limit 120000)

(autoload 'global-whitespace-mode "whitespace" "whitespace mode" t)
(setq whitespace-global-modes '(not erc-mode))
(global-whitespace-mode)
(setq whitespace-style
      '(face
        trailing
        indentation::tabs
        lines-tail
        empty
        tabs
        tab-mark))

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
(setq org-log-done t)

(global-set-key (kbd "M-x")     'helm-M-x)
(global-set-key (kbd "C-x r b") 'helm-filtered-bookmarks)

(set-selection-coding-system 'utf-8)
(set-clipboard-coding-system 'utf-8)

(defun my-insert-primary-selection ()
  (interactive)
  (insert (gui-get-selection 'PRIMARY 'UTF8_STRING)))

(defun my-track-switch-buffer ()
  (interactive)
  (erc-track-switch-buffer -1))

(global-set-key [(meta insert)] 'my-insert-primary-selection)
(global-set-key [(alt insert)] 'x-clipboard-yank)
;;(global-set-key [(alt up)] 'erc-track-switch-buffer)
(global-set-key [(alt down)] 'my-track-switch-buffer)
;;(global-set-key [(alt ?h)] 'erc-track-switch-buffer)
(global-set-key [(alt ?h)] 'erc-track-switch-buffer)

(setq erc-log-channels-directory "~/x/log/erc")
(setq erc-save-buffer-on-part t)
(setq erc-auto-query 'bury) ;; thanks to fledermaus#erc

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

;; Takk till Stig Erik Sandø
(defun remove-boring-erc-buffers (l)
  (cl-remove-if
   (lambda (e)
     (and (string-prefix-p "#" (buffer-name (car e)))
          (not (member (cddr e) '(erc-keyword-face erc-current-nick-face)))))
   l))

(defun list-changed-hook ()
  (let ((filtered-list
         (remove-boring-erc-buffers erc-modified-channels-alist)))
    (if filtered-list
        (let ((heads (mapcar 'car filtered-list)))
          (notify-moo (format "%s" heads)))
      (notify-moo (string #x1)))))
(add-hook 'erc-track-list-changed-hook 'list-changed-hook)

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
  ;; https://github.com/Fanael/highlight-numbers
  (load "~/.emacs.d/highlight-numbers.elc")
  (add-hook 'prog-mode-hook 'highlight-numbers-mode)
  (set-face-foreground 'highlight-numbers-number "DodgerBlue4")
  (global-set-key [(f10)] 'helm-browse-menubar))

(defun lispy ()
  (interactive)
  (if (equal major-mode 'lisp-interaction-mode)
      (switch-to-other-buffer)
    (switch-to-buffer "*scratch*")
    (lisp-interaction-mode)))
(global-set-key [(meta alt ?l)] 'lispy)

;; https://stackoverflow.com/questions/24904208/emacs-windows-org-mode-encoding
(modify-coding-system-alist 'file "" 'utf-8-unix)

;;; local Variables:
;;; End:
