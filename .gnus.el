;; -*- Mode: Emacs-Lisp -*-

(setq mm-discouraged-alternatives
      '("text/html" "text/richtext")
      mm-automatic-display
      (remove "text/html" mm-automatic-display))

(require 'nnir)
(setq gnus-visible-headers
      (concat "^From:\\|^Subject:\\|^Summary:\\|^To:"
              "\\|^Date:\\|^Gnus-Warning:\\|^Resent-From:"))

(setq gnus-save-newsrc-file nil
      gnus-read-newsrc-file nil
      gnus-save-killed-list nil
      gnus-check-new-newsgroups 'ask-server)

(setq gnus-select-method '(nntp "nntp.aioe.org" 119))

(setq nnmail-split-methods
      '(("gerrit" "X-Gerrit-MessageType.*")
        ("mail.malc" "To:.*av1474@comtv.ru.*")
        ("mail.moo" "To:.*moosotc@gmail.com.*")
        ("list.\\1" "From:.* \\(.*\\)-list@majordomo.com")
        ("list.\\1" "List-Id:.* <\\(.*\\)>")
        ("list.lkml.kernel" "X-Mailing-List:.*linux-kernel@vger\\.kernel\\.org")
        ("list.linux-arm-kernel"
         "Cc:.*linux-arm-kernel@lists\\.infradead\\.org")
        ("mail.other" "")))

(if nil
    (setq message-send-mail-function 'smtpmail-send-it
          smtpmail-starttls-credentials '(("smtp.gmail.com" 587 nil nil))
          smtpmail-auth-credentials '(("smtp.gmail.com" 587
                                       "moosotc@gmail.com" nil))
          smtpmail-default-smtp-server "smtp.gmail.com"
          smtpmail-smtp-server "smtp.gmail.com"
          smtpmail-smtp-service 587)
  )

(setq gnus-ignored-newsgroups "^to\\.\\|^[0-9. ]+\\( \\|$\\)\\|^[\"]\"[#'()]")


(setq user-mail-address "moosotc@gmail.com"
      nntp-authinfo-file "~/.authinfo.gpg")

(require 'bbdb)
(bbdb-initialize)
(add-hook 'gnus-startup-hook 'bbdb-insinuate-gnus)
(add-hook 'gnus-startup-hook 'bbdb-insinuate-message)
;; (add-hook 'message-setup-hook 'bbdb-define-all-aliases)
(setq bbdb-north-american-phone-numbers nil)

;; ━
(setq gnus-summary-line-format "%U%R%z%B%(%[%4L: %-23,23f%]%) %s\n"
      gnus-sum-thread-tree-false-root ""
      gnus-sum-thread-tree-indent " "
      gnus-sum-thread-tree-leaf-with-other "├─⇨ "
      gnus-sum-thread-tree-root ""
      gnus-sum-thread-tree-single-leaf "└─━ "
      gnus-sum-thread-tree-vertical "│ ")

(defun gnus--simplify-summary-line-mode ()
  (when (string-match "lists\..*\.bugzilla" gnus-newsgroup-name)
    (setf gnus-summary-line-format "%U%R%z%B%s\n")))

(setq gnus-secondary-select-methods
      (list
       '(nnml "")
       '(nntp "news.gmane.org" 119)
       )
      )

;; http://www.emacswiki.org/emacs/GnusAndPine
;; (setq gnus-visual nil)
(add-hook 'gnus-summary-mode-hook 'selector-moo)
(add-hook 'gnus-group-mode-hook 'selector-moo)

(defun kill-mailcd ()
  (call-process-shell-command "cm" nil t))

(add-hook 'gnus-exit-gnus-hook 'kill-mailcd)

(add-hook
 'gnus-summary-mode-hook
 (lambda ()
   (local-set-key (kbd "<tab>") 'gnus-summary-next-unread-article)
   (local-set-key "="  'toggle-article-window)
   ;; (local-set-key "n"  'gnus-summary-next-article)
   (local-set-key "m"  'self-insert-and-exit)
   (local-set-key "p"  'gnus-summary-prev-article)
   (local-set-key "!"  'gnus-summary-put-mark-as-ticked-next)
   (local-set-key "d"  'gnus-summary-put-mark-as-expirable-next)
   (local-set-key "u"  'gnus-summary-clear-mark-forward)
   (local-set-key "r"  'gnus-summary-followup-with-original)
   (local-set-key "x"  'gnus-summary-delete-article)
   ;; (local-set-key "g"  'gnus-summary-goto-group)
   (local-set-key "?"  'gnus-info-find-node)
   ;; (local-set-key "l"  'gnus-summary-exit)
   ;; (local-set-key "s"  'gnus-summary-save-and-expire)
   (local-set-key "v"  'gnus-article-view-part)
   ;; (local-set-key "c"  'gnus-summary-mail-other-window)
   (local-set-key "$f" 'gnus-summary-sort-by-author)
   (local-set-key "$a" 'gnus-summary-sort-by-original)
   (local-set-key "$d" 'gnus-summary-sort-by-date)
   ;; (local-set-key "$t" 'gnus-summary-toggle-threads)
   (local-set-key "$s" 'gnus-summary-sort-by-subject)
   (local-set-key "$z" 'gnus-summary-sort-by-chars)
   (local-set-key "$e" 'gnus-summary-sort-by-score)
   (if (gnus-news-group-p gnus-newsgroup-name)
       (local-set-key "f"  'gnus-summary-followup)
     (local-set-key "f" 'gnus-summary-mail-forward))))

(setq gnus-inhibit-startup-message      t    ;; no startup message
      gnus-treat-display-smileys        nil  ;; no smileys
      ;; gnus-treat-strip-cr               t    ;; no carriage returns
      message-kill-buffer-on-exit       t    ;; no hanging mail buffers
      gnus-prompt-before-saving         t    ;; better than default
      ;; message-send-mail-partially-limit nil  ;; size of sent messages
      gnus-large-newsgroup              1000)

(defun my-gnus-article-mode-hook ()
  (fset 'gnus-article-next-page 'gnus-article-next-page-1))
(add-hook 'gnus-article-mode-hook 'my-gnus-article-mode-hook)
(setq gnus-use-correct-string-widths nil)

(add-hook
 'gnus-group-mode-hook
 (lambda ()
   (gnus-topic-mode)
   ;;  https://github.com/schnecki/dot-emacs.d/blob/master/gnus.el
   (define-key gnus-topic-mode-map [tab] 'gnus-group-next-unread-group)))
