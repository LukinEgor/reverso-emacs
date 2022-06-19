(provide 'reverso)

(defun reverso-search-command (text source target)
  (async-shell-command
   (format "reverso search --text=%S --source %s --target %s --format json"
           text
           source
           target)))

(defun reverso-search (start end)
  (interactive "r")
  (reverso-search-command (buffer-substring-no-properties start end) "english" "russian"))
