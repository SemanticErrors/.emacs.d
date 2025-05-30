;; -*- lexical-binding: t; -*-

;; Automatically install packages
(setq use-package-always-ensure t
      use-package-enable-imenu-support t)

;; Packages Repos
(setq package-archives
      '(("melpa"  . "https://melpa.org/packages/")
        ("org"    . "https://orgmode.org/elpa/")
        ("elpa"   . "https://elpa.gnu.org/packages/")
        ("nongnu" . "https://elpa.nongnu.org/nongnu/")))

;; Native compilation
(setq comp-deferred-compilation t
      package-native-compile t
      native-comp-async-report-warnings-errors 'silent)

;; Some pre-init performance tweaks
(setq gc-cons-threshold (* 256 1024 1024)
      read-process-output-max (* 4 1024 1024)
      process-adaptive-read-buffering nil
      jit-lock-defer-time 0.05
      inhibit-startup-screen t
      initial-scratch-message nil)

;; VIM EVIL MODE
(use-package evil
  :init
  (evil-mode)
  :config
  (evil-set-initial-state 'eat-mode 'insert)) ;; Set initial state in eat terminal to insert mode

;; Core Emacs settings
(use-package emacs
  :init
  (global-display-line-numbers-mode t)             ;; Enable line numbers
  (global-display-fill-column-indicator-mode t)    ;; Enable vertical line
  (load-theme 'modus-vivendi)                      ;; protesilaos's modus vivendi theme

  :custom
  (menu-bar-mode nil)                              ;; Disable menu bar
  (tooltip-mode nil)                               ;; Disable tooltips
  (tool-bar-mode nil)                              ;; Disable tool bar
  (scroll-bar-mode nil)                            ;; Disable scroll bar
  (tab-width 4)                                    ;; 4 spaces for tabs
  (indent-tabs-mode nil)                           ;; Spaces instead of tabs
  (make-backup-files nil)                          ;; F* backup~ files
  (create-lockfiles nil)                           ;; F* #lockfile 
  (auto-save-default nil)                          ;; Disable auto-save
  (display-line-numbers-type 'relative)            ;; enable relative line numbers
  (display-fill-column-indicator-column 80))       ;; Vertical line at 80 column

;; Tree-Sitter Configurations
(setq treesit-language-source-alist
   '((c     "https://github.com/tree-sitter/tree-sitter-c")
     (cpp   "https://github.com/tree-sitter/tree-sitter-cpp")
     (java  "https://github.com/tree-sitter/tree-sitter-java")
     (python "https://github.com/tree-sitter/tree-sitter-python")
     (bash "https://github.com/tree-sitter/tree-sitter-bash")
     (html "https://github.com/tree-sitter/tree-sitter-html")
     (css "https://github.com/tree-sitter/tree-sitter-css")
     (javascript "https://github.com/tree-sitter/tree-sitter-javascript" "master" "src")))

(dolist (lang (mapcar #'car treesit-language-source-alist))
  (unless (treesit-language-available-p lang)
    (treesit-install-language-grammar lang)))

(use-package treesit
  :ensure nil
  :custom
  (major-mode-remap-alist
   '((c-mode             . c-ts-mode)
     (c++-mode           . c++-ts-mode)
     (java-mode          . java-ts-mode)
     (python-mode        . python-ts-mode)
     (bash-mode          . bash-ts-mode)
     (html-mode          . html-ts-mode)
     (css-mode           . css-ts-mode)
     (js-mode            . js-ts-mode)))
  ;; Fixing Indentations
  (c-ts-mode-indent-offset 4)
  (python-indent-guess-indent-offset nil))

;; GCMH Optimizations
(use-package gcmh
  :hook (after-init . gcmh-mode)
  :diminish
  :custom
  (gcmh-high-cons-threshold (* 256 1024 1024))
  (gcmh-idle-delay 20)
  (gcmh-verbose nil))

;; Startup Time Reporting
(defun my/emacs-startup-report ()
  "Report startup time and garbage collections."
  (message "Emacs loaded in %s with %d garbage collections."
           (format "%.2f seconds"
                   (float-time
                    (time-subtract after-init-time before-init-time)))
           gcs-done))

(add-hook 'emacs-startup-hook #'my/emacs-startup-report)
