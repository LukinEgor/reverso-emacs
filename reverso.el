(defgroup reverso nil
  "An Emacs interface for Reverso Context."
  :group 'tools
  :prefix "reverso-"
  :link '(url-link :tag "GitHub" "https://github.com/LukinEgor/reverso-emacs"))

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

(defvar reverso--github-api-url "https://api.github.com/repos/lukinegor/reverso/releases/latest")

(defun reverso--detect-latest-binary-url ()
  (substring
   (shell-command-to-string
    (format "curl --silent %S | jq .assets[0].browser_download_url" reverso--github-api-url)) 0 -1))

;;;###autoload
(defun reverso-install-binary ()
  "Download reverso cli binary"
  (interactive)
  (let* ((latest-binary-url (reverso--detect-latest-binary-url))
        (latest-version (nth 7 (split-string latest-binary-url "/"))))
    (message
     (format "Downloading %s version..." latest-version))
    (make-directory reverso-binaries-folder t)
    (shell-command
     (format "curl -o %s/reverso -OL %s" reverso-binaries-folder latest-binary-url))
    (shell-command
     (format "chmod +x %s/reverso" reverso-binaries-folder))
    (message "Done.")))

(defun reverso--search-command (text source target)
  (async-shell-command
   (format "%s/reverso search --text=%S --source %s --target %s --format emacs"
           reverso-binaries-folder
           text
           source
           target)))

(defun reverso-search (start end source-lang target-lang)
  (let ((buffer (buffer-substring-no-properties start end)))
    (if (string-blank-p buffer)
        (message "The blank buffer.")
        (reverso--search-command buffer source-lang target-lang))))

;;;###autoload
(defun reverso-direct-search (start end)
  "Reverso search on source lang"
  (interactive "r")
  (reverso-search start end reverso-default-source-lang reverso-default-target-lang))

;;;###autoload
(defun reverso-reverse-search (start end)
  "Reverso search on target lang"
  (interactive "r")
  (reverso-search start end reverso-default-target-lang reverso-default-source-lang))

(provide 'reverso)
