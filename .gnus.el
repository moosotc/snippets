;; -*- Mode: Emacs-Lisp -*-
(setq
 mm-discouraged-alternatives '("text/html" "text/richtext")
 mm-automatic-display (remove "text/html" mm-automatic-display)
 mm-text-html-renderer 'links
 gnus-visible-headers (concat "^From:\\|^Subject:\\|^Summary:\\|^To:"
                              "\\|^Date:\\|^Gnus-Warning:\\|^Resent-From:")
 gnus-save-newsrc-file nil
 gnus-read-newsrc-file nil
 gnus-save-killed-list nil
 gnus-check-new-newsgroups 'ask-server
 gnus-select-method '(nntp "nntp.aioe.org" 119)
 nntp-authinfo-file "~/.config/authinfo.gpg"
 gnus-inhibit-startup-message      t    ;; no startup message
 gnus-treat-display-smileys        nil  ;; no smileys
 message-kill-buffer-on-exit       t    ;; no hanging mail buffers
 gnus-prompt-before-saving         t    ;; better than default
 gnus-large-newsgroup              1000
 bbdb-north-american-phone-numbers nil
 gnus-use-correct-string-widths nil
 gnus-secondary-select-methods
 '((nnml "" (gnus-search-engine gnus-search-notmuch ""))
   (nntp "news.gmane.io" 119)))


(add-hook
 'gnus-summary-mode-hook
 (lambda ()
   (local-set-key (kbd "<tab>") 'gnus-summary-next-unread-article)
   (local-set-key (kbd "<deletechar>") 'gnus-summary-prev-page)
   (local-set-key "u"  'gnus-summary-clear-mark-forward)
   (local-set-key "r"  'gnus-summary-followup-with-original)
   (local-set-key "x"  'gnus-summary-delete-article)
   (local-set-key "?"  'gnus-info-find-node)
   (local-set-key "$f" 'gnus-summary-sort-by-author)
   (local-set-key "$a" 'gnus-summary-sort-by-original)
   (local-set-key "$d" 'gnus-summary-sort-by-date)
   (local-set-key "$s" 'gnus-summary-sort-by-subject)
   (local-set-key "$z" 'gnus-summary-sort-by-chars)
   (local-set-key "$e" 'gnus-summary-sort-by-score)
   (if (gnus-news-group-p gnus-newsgroup-name)
       (local-set-key "f"  'gnus-summary-followup)
     (local-set-key "f" 'gnus-summary-mail-forward))))

(require 'bbdb)
(bbdb-initialize)
(add-hook 'gnus-startup-hook 'bbdb-insinuate-gnus)
(add-hook 'gnus-startup-hook 'bbdb-insinuate-message)

(add-hook 'gnus-summary-mode-hook 'selector-moo)
(add-hook 'gnus-group-mode-hook 'selector-moo)
(add-hook
 'gnus-group-mode-hook
 (lambda ()
   (gnus-topic-mode)
   ;;  https://github.com/schnecki/dot-emacs.d/blob/master/gnus.el
   (define-key gnus-topic-mode-map [tab] 'gnus-group-next-unread-group)))

(defun my-gnus-article-mode-hook ()
  (fset 'gnus-article-next-page 'gnus-article-next-page-1))
(add-hook 'gnus-article-mode-hook 'my-gnus-article-mode-hook)

(defun kill-mailcd ()
  (call-process-shell-command "cm" nil t))
(add-hook 'gnus-exit-gnus-hook 'kill-mailcd)
