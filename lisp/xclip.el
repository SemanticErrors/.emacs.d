;; -*- lexical-binding: t; -*-

(defun evil-copy-to-clipboard (beg end)
  "Copy region to system clipboard using xclip."
  (interactive "r")
  (when (use-region-p)
    (call-process-region beg end "xclip" nil 0 nil "-i" "-selection" "clipboard")
    (message "Copied to clipboard")
    (evil-normal-state)))

(defun evil-cut-to-clipboard (beg end)
  "Cut region to system clipboard using xclip."
  (interactive "r")
  (when (use-region-p)
    (call-process-region beg end "xclip" nil 0 nil "-i" "-selection" "clipboard")
    (delete-region beg end)
    (message "Cut to clipboard")
    (evil-normal-state)))

(defun evil-paste-from-clipboard ()
  "Paste from system clipboard using xclip."
  (interactive)
  (let ((clipboard-text (with-temp-buffer
                          (call-process "xclip" nil t nil "-o" "-selection" "clipboard")
                          (buffer-string))))
    (insert clipboard-text)))

(defun my-save-and-copy-buffer-to-clipboard ()
  "Save current buffer (if file-associated) and copy its contents to the system clipboard via xclip."
  (interactive)
  ;; Save the buffer to disk if it’s visiting a file
  (when buffer-file-name
    (save-buffer))
  ;; Call `xclip`, sending the whole buffer (point-min to point-max) to its stdin
  (let ((exit-code 
         (call-process-region (point-min) (point-max)
                              "xclip" nil nil nil
                              "-selection" "clipboard" "-in")))
    ;; Check exit status
    (if (eq exit-code 0)
        (message "Buffer contents copied to clipboard")
      (message "Failed to copy to clipboard (xclip exited with code %s)" exit-code))))


(with-eval-after-load 'evil
  (evil-define-key '(normal visual) 'global
    (kbd "SPC y") 'evil-copy-to-clipboard
    (kbd "SPC x") 'evil-cut-to-clipboard
    (kbd "SPC p") 'evil-paste-from-clipboard
    (kbd "SPC fy") #'my-save-and-copy-buffer-to-clipboard))

(provide 'xclip)
