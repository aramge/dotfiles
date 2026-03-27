;;; Axel's emacs configuration (Bootstrap XDG Version)

(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file t)

(setq inhibit-startup-message t)
(when (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(when (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

(setq native-comp-async-report-warnings-errors 'silent)
(column-number-mode 1)
(setq word-wrap t)
(global-visual-line-mode 1)

;;;(global-auto-revertmode t)
;;;(setq global-auto-revert-non-file-buffers t)

(defun my-copy-to-clipboard (text)
  (let ((process-connection-type nil))
    (cond
     ;; macOS
     ((executable-find "pbcopy")
      (let ((proc (start-process "pbcopy" nil "pbcopy")))
        (process-send-string proc text)
        (process-send-eof proc)))
     ;; NixOS / Linux (setzt xclip voraus)
     ((executable-find "xclip")
      (let ((proc (start-process "xclip" nil "xclip" "-selection" "clipboard" "-i")))
        (process-send-string proc text)
        (process-send-eof proc))))))

(setq interprogram-cut-function 'my-copy-to-clipboard)

(defun my-paste-from-clipboard ()
  (cond
   ((executable-find "pbpaste")
    (shell-command-to-string "pbpaste"))
   ((executable-find "xclip")
    (shell-command-to-string "xclip -o -selection clipboard"))))

(setq interprogram-paste-function 'my-paste-from-clipboard)

(setq ispell-program-name "hunspell")
(setq ispell-dictionary "de_DE")

(let ((backup-dir (expand-file-name "backup-files" user-emacs-directory)))
  (unless (file-exists-p backup-dir)
    (make-directory backup-dir t))
  (setq backup-directory-alist `(("." . ,backup-dir)))
  (setq auto-save-file-name-transforms `((".*" ,(concat backup-dir "/") t))))

(setq backup-by-copying t)
(setq delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)

(setq dired-kill-when-opening-new-dired-buffer t)
(setq dired-dwim-target t)
(with-eval-after-load 'dired
  (defvar dired-external-extensions
    '("pdf"
      ;; LibreOffice / Microsoft Office
      "doc" "docx" "xls" "xlsm" "xlsx" "odt" "ods" "csv"
      ;; Bilder
      "jpg" "jpeg" "png" "gif" "svg" "webp"
      ;; Audio / Video
      "mp3" "mp4" "mkv" "avi")
    "Liste der Dateiendungen, die an das Betriebssystem übergeben werden.")

  (defun dired-ret-external-or-emacs ()
    "Öffnet definierte Dateien über xdg-open/open, den Rest in Emacs."
    (interactive)
    (let* ((file (dired-get-file-for-visit))
           (ext (file-name-extension file)))
      ;; file-regular-p entspricht exakt 'find -type f'
      (if (and ext (file-regular-p file) (member (downcase ext) dired-external-extensions))
          (let ((cmd (if (eq system-type 'darwin) "open" "xdg-open")))
            (call-process cmd nil 0 nil file))
        (dired-find-file))))

  (define-key dired-mode-map (kbd "RET") #'dired-ret-external-or-emacs))

;; --- Paket-Management & Bootstrapping ---
(require 'package)
(setq package-archives
      '(("GNU ELPA"     . "https://elpa.gnu.org/packages/")
        ("MELPA Stable" . "https://stable.melpa.org/packages/")
        ("MELPA"        . "https://melpa.org/packages/")))

(package-initialize)

;; Falls keine Paketlisten da sind (frisches System), lade sie jetzt
(unless package-archive-contents
  (package-refresh-contents))

;; Stelle sicher, dass use-package installiert ist
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
;; Pareto-Tipp: Erspare dir das ":ensure t" bei jedem Paket
(setq use-package-always-ensure t)

(server-start)

;; --- Pakete ---
(use-package which-key
  :ensure t
  :config
  (which-key-mode))

(use-package clipetty)
(use-package smartparens
  :hook (prog-mode . smartparens-mode)
  :config (require 'smartparens-config))

(use-package magit
  :bind ("C-x g" . magit-status))

(use-package sudo-edit)
(use-package vertico :init (vertico-mode))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion)))))

(use-package marginalia :init (marginalia-mode))

(use-package consult
  :bind (("C-s" . consult-line)
         ("C-x b" . consult-buffer)))

(use-package embark
  :bind (("C-." . embark-act)
         ("C-;" . embark-dwim)))

(use-package embark-consult
  :after (embark consult))

(use-package corfu
  :custom (corfu-auto t)
  :init (global-corfu-mode))

(use-package denote
  :bind (("C-c n n" . denote)
         ("C-c n i" . denote-link))
  :config (setq denote-directory "~/sync/gh/notes"))

(use-package org
  :ensure nil
  :bind (("C-c a" . org-agenda)
         ("C-c c" . org-capture))
  :config
  (setq org-directory "~/sync/gh/notes")
  (setq org-agenda-files '("~/sync/gh/todo/todo.org"))
  (setq org-log-done 'time))

;;;(use-package org-modern
;;;  :hook (org-mode . org-modern-mode))

(setq org-default-priority ?C)
(setq org-agenda-custom-commands
      '(("e" "Eisenhower Matrix"
         ((tags-todo "+PRIORITY=\"A\"+TODO=\"NEXT\""
                     ((org-agenda-overriding-header "Quadrant A: Dringend & Wichtig (NEXT)")))
          (tags-todo "+PRIORITY=\"B\"+TODO=\"TODO\""
                     ((org-agenda-overriding-header "Quadrant B: Wichtig & Geplant (TODO + SCHEDULED)")))
          (tags-todo "+PRIORITY=\"C\"+TODO=\"TODO\""
                     ((org-agenda-overriding-header "Quadrant C: Dringend & Unwichtig (TODO ohne Prio oder [#C])")))
          (todo "SOMEDAY"
                ((org-agenda-overriding-header "Quadrant D: Weder noch (SOMEDAY)")))))))
;(setq org-agenda-hide-tags-regexp ".*") ; Versteckt alle Tags in der Agenda-Ansicht
(setq org-agenda-prefix-format
      '((agenda . " %i %-12:c%?-12t% s")
        (todo   . " ") ; Entfernt das "todo:" Präfix für mehr Platz
        (tags   . " ")
        (search . " ")))

(use-package eglot
  :ensure nil
  :config (setq eglot-autoshutdown t))

(use-package nix-mode
  :mode "\\.nix\\'")

(use-package yaml-mode
  :ensure t
  :mode ("\\.yml\\'" "\\.yaml\\'"))

(defun date ()
  (interactive)
  (insert (format-time-string "%Y-%m-%d")))

(let ((local-file (expand-file-name "local.el" user-emacs-directory)))
  (when (file-exists-p local-file)
    (load local-file)))
