;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-
(setq user-full-name "Denis Abrosimov"
      user-mail-address "denis.abrosimov@gmail.com")


;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
(setq doom-font (font-spec :family "Input" :size 20)
      doom-variable-pitch-font (font-spec :family "Cantarell" :size 20))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:

(setq doom-theme 'doom-acario-light)
(load-theme 'ef-elea-light :no-confirm)

(defun load-doom-theme (frame)
  (select-frame frame)
  (load-theme doom-theme t))

(if (daemonp)
    (add-hook 'after-make-frame-functions #'load-doom-theme)
  (load-theme doom-theme t))

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; normal size on start
(setq initial-frame-alist '((top . 1) (left . 1) (width . 143) (height . 55)))
(add-hook 'window-setup-hook 'toggle-frame-maximized t)

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
;; (electric-pair-mode 1)
;;
;; Use ESC as universal get me out of here command
(define-key key-translation-map (kbd "ESC") (kbd "C-g"))

;; Smoother and nicer scrolling
(setq scroll-margin 10
      scroll-step 1
      next-line-add-newlines nil
      scroll-conservatively 10000
      scroll-preserve-screen-position 1)

(setq mouse-wheel-follow-mouse 't)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1)))

(setq default-input-method "russian-computer")
(use-package reverse-im
  :ensure t
  :custom
  (reverse-im-input-methods '("russian-computer"))
  :config
  (reverse-im-mode t))
;; blink cursor on scroll (beacon package)
(beacon-mode 1)

;; projectile
;; set project root
(after! projectile
  (setq projectile-project-root-files-bottom-up '("package.json" ".projectile" "deno.json" "deno.jsonc" ".project" ".git"))
  ;; set ignore files and folders
  (setq projectile-ignored-projects '("~/.emacs.d/"))
  (setq projectile-globally-ignored-files
        '("TAGS"
          ".DS_Store"
          "yarn.lock"
          "package-lock.json"))
  (setq projectile-globally-ignored-file-suffixes
        '("gz" "zip" "tar" "elc"))
  (setq projectile-globally-ignored-directories
        '(".git"
          ".log"
          ".cache"
          "dist"
          "build"
          "target"
          "vendor"
          "node_modules"))

  (projectile-register-project-type 'yarn '("package.json" "yarn.lock")
                                    :project-file "package.json"
                                    :compile "yarn && yarn build"
                                    :test "yarn test"
                                    :run "yarn dev"
                                    :test-suffix ".spec")
  (projectile-register-project-type 'deno '("deno.json")
                                    :project-file "deno.json"
                                    :compile "deno compile"
                                    :test "deno test"
                                    :run "deno run --allow-all"
                                    :test-suffix ".test")
  )



;; treemacs
(map! :leader :desc "Open treemacs" "e" #'+treemacs/toggle)
(setq treemacs-file-event-delay 1000)
(treemacs-project-follow-mode t)
(treemacs-follow-mode t)
(setq treemacs-is-never-other-window t)
(setq treemacs-silent-refresh    t)
;; avy
(map! :leader :desc "Go to char" "j" #'avy-goto-char)
(map! :desc "Comment/ uncomment line" :nv "g /" #'comment-line)
(map! :leader :desc "Go to test" "p z" #'projectile-toggle-between-implementation-and-test)

(defun project-file-name (filepath)
  (s-replace "/home/denis/projects/" "" filepath))

;; window title
(setq frame-title-format
      '(""
        (:eval
         (let (
               (file-name (or (project-file-name buffer-file-name) "Emacs"))
               (prj-name (or (projectile-project-name) workspace-name))
               )
           (format (if (buffer-modified-p)  " ◉ %s %s" "  ● %s  %s") prj-name file-name)))))