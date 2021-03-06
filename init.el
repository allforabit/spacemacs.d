;; -*- eval: (git-auto-commit-mode 1) -*-
;;; Dotspacemacs

;; -- Kevin Nolan's Spacemacs Configuration --
;; -- Contact: kevnolan@gmail.com --
;; -- MIT License --
;; -- Emacs 25.2.1 - Dev Branch - Release 0.200.9.x - pulled/pkgs updated: 8/23 --
;; -- See README for details and VERSION for updates --
;;
;; All configuration is housed in personal layers

(defvar ERIC-ONLY? nil
  "If cloning, set to nil, enable non-layer personal configuration.")


;; TODO Not sure where else to put this
(setenv "NODE_PATH"
        (concat
         "~/.config/yarn/global/node_modules/" ":"
         (getenv "NODE_PATH")))

;; Windows, set home as default find-file location
(cd "~")

(setq is-linuxp (eq system-type 'gnu/linux))
(defun os-path (x) (if is-linuxp x (expand-file-name x "c:")))

(defun dotspacemacs/init ()
  "Spacemacs core settings."
  (dotspacemacs/init/coding)
  (dotspacemacs/init/display)
  (dotspacemacs/init/evil)
  (dotspacemacs/init/keys)
  (dotspacemacs/init/layouts)
  (dotspacemacs/init/helm)
  (dotspacemacs/init/misc)
  (dotspacemacs/init/packages)
  (dotspacemacs/init/startup))

(defun dotspacemacs/layers ()
  "Spacemacs layers declarations and package configurations."
  (dotspacemacs/layers/config)
  (dotspacemacs/layers/packages))

(defun dotspacemacs/user-init ()
  "Package independent settings to run before `dotspacemacs/user-config'."
  (set-fontset-font "fontset-default" nil
                    (font-spec :size 20 :name "Symbola"))
  (when (version<= "26.0.50" emacs-version )
    (global-display-line-numbers-mode))
  (setq custom-file "~/.spacemacs.d/custom.el")
  (load custom-file))

(defun dotspacemacs/user-config ()
  "Configuration that cannot be delegated to layers."

  (dotspacemacs/user-config/toggles)
  (dotspacemacs/user-config/experiments)

  ;; Switch to org agenda view
  (org-agenda-list)
  (switch-to-buffer "*Org Agenda*")
  ;; Temporary fix
  ;; https://github.com/syl20bnr/spacemacs/issues/9549
  (require 'helm-bookmark))

;;; Spacemacs/Layers
;;;; Local

(defvar dotspacemacs/layers/local
  '(
    (macros :location local)    ; All local layers inherit these macros

    (config :location local)    ; Org, Avy, Evil, Misc... config
    (display :location local)   ; Pretty-eshell/code/outlines... pkgs
    (langs :location local)     ; Language config
    (personal :location local)  ; Personal pkgs
    )
  "Local layers housed in '~/.spacemacs.d/layers'.")

;;;; Core

(defvar dotspacemacs/layers/core
  '(better-defaults
    git
    syntax-checking
    (auto-completion :variables
                     auto-completion-return-key-behavior nil
                     auto-completion-tab-key-behavior nil
                     auto-completion-enable-snippets-in-popup t
                     ;; Possibly could set to "jk" as suggested in the docs
                     auto-completion-complete-with-key-sequence nil
                     auto-completion-private-snippets-directory "~/.spacemacs.d/snippets/")
    helm
    ;; (ivy :variables
    ;;      ivy-extra-directories nil)
    (org :variables
         org-want-todo-bindings t)
    (shell :variables
           shell-default-shell 'eshell)
    (version-control :variables
                     version-control-global-margin t
                     version-control-diff-tool 'git-gutter+)
    spell-checking
    )
  "Layers I consider core to Spacemacs")

;;;; Langs

(defvar dotspacemacs/layers/langs
  '(emacs-lisp
    html
    ;; Configured in langs layer
    javascript
    markdown
    rust
    (clojure :variables
             clojure-enable-fancify-symbols t)
    (haskell :variables
             haskell-completion-backend 'intero)
    (python :variables
            python-sort-imports-on-save t
            python-test-runner 'pytest
            :packages
            (not hy-mode)  ; I maintain `hy-mode', using local branch
            )
    pandoc
    latex
    pandoc
    vimscript)
  "Programming and markup language layers")

;;;; Extra

(defvar dotspacemacs/layers/extra
  '(gnus
    graphviz
    ranger
    (osx
     :variables
     osx-right-option-as `none)
    search-engine
    (ibuffer :variables
             ibuffer-group-buffers-by 'projects))
  "Miscellaneous layers")

;;;; Layers/config

(defun dotspacemacs/layers/config ()
  ;; Doesn't seem to be setting above
  ;; TODO figure out why this variable isn't setting
  (setq-default
   dotspacemacs-distribution 'spacemacs
   dotspacemacs-enable-lazy-installation 'unused
   dotspacemacs-ask-for-lazy-installation t
   dotspacemacs-configuration-layer-path `(,(os-path "~/.spacemacs.d/layers/"))
   dotspacemacs-configuration-layers (append dotspacemacs/layers/core
                                             dotspacemacs/layers/langs
                                             dotspacemacs/layers/extra
                                             dotspacemacs/layers/local)
   ))


;;;; Layers/packages

(defun dotspacemacs/layers/packages ()
  (setq-default
   dotspacemacs-additional-packages '(org-web-tools
                                      org-protocol-capture-html
                                      ob-browser
                                      graphql-mode
                                      doom-themes
                                      solaire-mode)
   dotspacemacs-excluded-packages '(fringe hy-mode)
   dotspacemacs-frozen-packages '()
   dotspacemacs-install-packages 'used-but-keep-unused
   ))

;;; Spacemacs/Init
;;;; Coding

(defun dotspacemacs/init/coding ()
  (setq-default
   dotspacemacs-search-tools '("ag" "rg" "pt" "ack" "grep")
   dotspacemacs-smooth-scrolling t
   dotspacemacs-folding-method 'evil
   dotspacemacs-smartparens-strict-mode nil
   dotspacemacs-smart-closing-parenthesis nil
   dotspacemacs-highlight-delimiters 'all
   dotspacemacs-line-numbers nil
   dotspacemacs-whitespace-cleanup 'trailing
   ))

;;;; Display

(defun dotspacemacs/init/display ()
  (setq-default
   dotspacemacs-themes '(doom-one doom-one-light spacemacs-dark leuven)
   dotspacemacs-default-font `("Source Code Pro"
                               :size 13
                               :powerline-scale 1.5)
   dotspacemacs-fullscreen-at-startup (if is-linuxp nil t)
   dotspacemacs-fullscreen-use-non-native nil
   dotspacemacs-maximized-at-startup nil
   dotspacemacs-active-transparency 90
   dotspacemacs-inactive-transparency 90
   dotspacemacs-mode-line-unicode-symbols t
   dotspacemacs-zone-out-when-idle nil
   dotspacemacs-frame-title-format "%I@%S"
   dotspacemacs-icon-title-format nil
   ))

;;;; Evil

(defun dotspacemacs/init/evil ()
  (setq-default
   dotspacemacs-editing-style 'vim
   dotspacemacs-colorize-cursor-according-to-state t
   dotspacemacs-remap-Y-to-y$ t
   dotspacemacs-retain-visual-state-on-shift t
   dotspacemacs-visual-line-move-text nil
   dotspacemacs-ex-substitute-global nil
   dotspacemacs-enable-paste-transient-state t
   dotspacemacs-show-transient-state-title t
   dotspacemacs-show-transient-state-color-guide t
   ))

;;;; Keys

(defun dotspacemacs/init/keys ()
  (setq-default
   dotspacemacs-leader-key "SPC"
   dotspacemacs-emacs-command-key "SPC"
   dotspacemacs-ex-command-key ":"
   dotspacemacs-emacs-leader-key "M-m"
   dotspacemacs-major-mode-leader-key ","
   dotspacemacs-major-mode-emacs-leader-key "C-M-m"
   dotspacemacs-which-key-delay 0.4
   dotspacemacs-which-key-position 'bottom
   dotspacemacs-distinguish-gui-tab nil
   ))

;;;; Layouts

(defun dotspacemacs/init/layouts ()
  (setq-default
   dotspacemacs-scratch-mode 'org-mode
   dotspacemacs-default-layout-name "Default"
   dotspacemacs-display-default-layout nil
   dotspacemacs-auto-resume-layouts nil
   dotspacemacs-auto-generate-layout-names t
   dotspacemacs-switch-to-buffer-prefers-purpose nil
   ))

;;;; Misc

(defun dotspacemacs/init/misc ()
  (setq-default
   dotspacemacs-large-file-size 1
   dotspacemacs-auto-save-file-location 'cache
   dotspacemacs-max-rollback-slots 5
   dotspacemacs-persistent-server nil))

;;;; Helm

(defun dotspacemacs/init/helm ()
  (setq-default
   dotspacemacs-helm-resize nil
   dotspacemacs-helm-no-header nil
   dotspacemacs-helm-position 'bottom
   dotspacemacs-helm-use-fuzzy 'always))

;;;; Packages

(defun dotspacemacs/init/packages ()
  (setq-default
   dotspacemacs-default-package-repository nil
   dotspacemacs-elpa-https t
   dotspacemacs-elpa-timeout 5
   dotspacemacs-check-for-update nil
   dotspacemacs-elpa-subdirectory nil
   ))

;;;; Startup

(defun dotspacemacs/init/startup ()
  (setq-default
   dotspacemacs-verbose-loading nil
   dotspacemacs-startup-banner 'official
   dotspacemacs-startup-lists '()
   dotspacemacs-startup-buffer-responsive t
   dotspacemacs-loading-progress-bar t
   ))

;;; Spacemacs/User-Config
;;;; Toggles

(defun dotspacemacs/user-config/toggles ()
  "Spacemacs toggles not intended to be put into layers."
  (spacemacs/toggle-highlight-long-lines-globally-on)
  (spacemacs/toggle-mode-line-minor-modes-off)
  (spacemacs/toggle-aggressive-indent-globally-on)
  (global-highlight-parentheses-mode 1)
  (rainbow-delimiters-mode-enable)
  (fringe-mode '(0 . 8)))

;;;; Experiments

(defun dotspacemacs/user-config/experiments ()
  (when (configuration-layer/package-usedp 'olivetti)
    (spacemacs/set-leader-keys "wo" 'olivetti))

  (when ERIC-ONLY?
    (load-file (os-path "~/dev/hy-mode/hy-mode.el"))
    (load-file (os-path "~/dev/hy-mode/spacemacs-hy.el"))
    (require 'hy-mode)
    (require 'spacemacs-hy)))
