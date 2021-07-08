(setq
 mm-discouraged-alternatives '("text/html" "text/richtext")
 mm-automatic-display (remove "text/html" mm-automatic-display)
 mm-text-html-renderer nil
 gnus-visible-headers "^From:\\|^Subject:\\|^To:\\|^Date:"
 gnus-save-newsrc-file nil
 gnus-read-newsrc-file nil
 gnus-save-killed-list nil
 gnus-check-new-newsgroups nil
 gnus-select-method '(nntp "nntp.aioe.org" 119)
 gnus-inhibit-startup-message t ;; no startup message
 gnus-treat-display-smileys nil ;; no smileys
 message-kill-buffer-on-exit t  ;; no hanging mail buffers
 gnus-prompt-before-saving t    ;; better than default
 gnus-large-newsgroup 20
 bbdb-north-american-phone-numbers nil
 gnus-use-correct-string-widths nil
 mail-sources nil)

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

(add-hook 'gnus-article-mode-hook
          (lambda ()
            (fset 'gnus-article-next-page 'gnus-article-next-page-1)))
