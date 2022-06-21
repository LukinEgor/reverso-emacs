(provide 'reverso)

(defcustom reverso-default-source-lang
  "english"
  "Language for direct search"
  :group 'reverso
  :type 'string)

(defcustom reverso-default-target-lang
  "russian"
  "Language for reverse search"
  :group 'reverso
  :type 'string)

(defcustom reverso-binaries-folder "~/.reverso"
  "Path to reverso binaries folder."
  :group 'reverso
  :type 'string)

;; TODO download latest binary file
(defun reverso-install-binary ()
  (message "Downloading...")
  (make-directory reverso-binaries-folder t)
  (shell-command
   (format "curl -o %s/reverso -OL https://github.com/LukinEgor/reverso/releases/download/0.0.1/reverso-0.0.1" reverso-binaries-folder))
  (shell-command
   (format "chmod +x %s/reverso" reverso-binaries-folder))
  (message "Done."))

(defun reverso--search-command (text source target)
  (async-shell-command
   (format "%s/reverso search --text=%S --source %s --target %s --format emacs"
           reverso-binaries-folder
           text
           source
           target)))

(defun reverso-direct-search (start end)
  (interactive "r")
  (let ((buffer (buffer-substring-no-properties start end)))
    (if (string-blank-p buffer)
        (message "The blank buffer.")
        (reverso--search-command buffer reverso-default-source-lang reverso-default-target-lang))))

(defun reverso-reverse-search (start end)
  (interactive "r")
  (let ((buffer (buffer-substring-no-properties start end)))
    (if (string-blank-p buffer)
        (message "The blank buffer.")
        (reverso--search-command buffer reverso-default-target-lang reverso-default-source-lang))))
