(custom-set-variables
 '(erc-keyword-highlight-type 'all)
 '(erc-keywords '("moolc" "malc" "clam" "moosotc" "llpp"))
 '(erc-kill-buffer-on-part t)
 '(erc-kill-queries-on-quit t)
 '(erc-kill-server-buffer-on-quit t)
 '(erc-log-file-coding-system 'utf-8)
 '(erc-modules
   '(autojoin button completion fill
     irccontrols list log match menu
     move-to-prompt netsplit networks replace
     noncommands readonly ring stamp spelling track))
 '(erc-notice-highlight-type 'all)
 '(erc-track-position-in-mode-line t)
 '(erc-save-buffer-on-part t)
 '(erc-auto-query 'bury)                ;; thanks to fledermaus#erc
)

(defun remove-boring-erc-buffers (l)
  (cl-remove-if-not
   (lambda (e)
     (let ((name (buffer-name (car e))))
       (or ;; anything on #malc
        (string-equal "#malc" name)
        ;; ... non channel bufufers
        (not (string-prefix-p "#" name))
        ;; any buffer where current nick or any keyword was seen
        (member (cddr e) '(erc-keyword-face erc-current-nick-face)))))
   l))

(defun list-changed-hook ()
  (let ((filtered-list
         (remove-boring-erc-buffers erc-modified-channels-alist)))
    (if filtered-list
        (let ((heads (mapcar 'car filtered-list)))
          (notify-moo (format "%s" heads)))
      (notify-moo (string #x1)))))
(add-hook 'erc-track-list-changed-hook 'list-changed-hook)

(require 'erc-replace)
(setq erc-replace-alist '(("<artifexirc-bot> " . "@")))
