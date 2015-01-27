;; -*- mode: emacs-lisp -*-
;; This file is loaded by Spacemacs at startup.
;; It must be stored in your home directory.

;; Configuration Layers
;; --------------------

(setq-default
 ;; List of additional paths where to look for configuration layers.
 ;; Paths must have a trailing slash (ie. `~/.mycontribs/')
 dotspacemacs-configuration-layer-path '()
 ;; List of configuration layers to load.
 dotspacemacs-configuration-layers '(themes-megapack)
 ;; A list of packages and/or extensions that will not be install and loaded.
 dotspacemacs-excluded-packages '()
)

;; Settings
;; --------

(setq-default
 ;; Default theme applied at startup
 dotspacemacs-default-theme 'solarized-dark
 ;; The leader key
 dotspacemacs-leader-key "SPC"
 ;; Guide-key delay in seconds. The Guide-key is the popup buffer listing
 ;; the commands bound to the current keystrokes.
 dotspacemacs-guide-key-delay 0.4
 ;; If non nil the frame is maximized when Emacs starts up (Emacs 24.4+ only)
 dotspacemacs-fullscreen-at-startup nil
 ;; If non nil smooth scrolling (native-scrolling) is enabled. Smooth scrolling
 ;; overrides the default behavior of Emacs which recenters the point when
 ;; it reaches the top or bottom of the screen
 dotspacemacs-smooth-scrolling t
 ;; If non nil pressing 'jk' in insert state, ido or helm will activate the
 ;; evil leader.
 dotspacemacs-feature-toggle-leader-on-jk nil
 ;; The default package repository used if no explicit repository has been
 ;; specified with an installed package.
 ;; Not used for now.
 dotspacemacs-default-package-repository nil
)

;; Initialization Hooks
;; --------------------

(defun dotspacemacs/init ()
  "User initialization for Spacemacs. This function is called at the very
 startup."

  ;; Load packages
  (spacemacs/load-or-install-package 'rvm)
  (spacemacs/load-or-install-package 'rspec-mode)
  (spacemacs/load-or-install-package 'escreen)
  (spacemacs/load-or-install-package 'emamux)
  (spacemacs/load-or-install-package 'rubocop)
  (spacemacs/load-or-install-package 'enh-ruby-mode)
  (spacemacs/load-or-install-package 'winner)
  (spacemacs/load-or-install-package 'cider)
  (spacemacs/load-or-install-package 'clojure-mode)
  (spacemacs/load-or-install-package 'paredit)
  (spacemacs/load-or-install-package 'omnisharp)

  (spacemacs/load-or-install-package 'company)
  (spacemacs/load-or-install-package 'rainbow-mode)
  (spacemacs/load-or-install-package 'yaml-mode))

(defun dotspacemacs/do-tmux (cmd name)
  (shell-command (concat "osascript ~/Library/Scripts/SwitchToITerm.applescript; tmux new-window -n " name " \"" cmd "; read \"")))

(defun dotspacemacs/run-all-specs ()
  "Runs 'parallel_rspec spec' in a new tmux window..."
  (interactive)
  (dotspacemacs/do-tmux "cd ~/jobber/Jobber; source ~/.zshrc; SIMPLECOV=1 parallel_rspec spec" "all-specs"))

(defun dotspacemacs/rake-vcr-clear ()
  "Runs zeus rake vcr clear..."
  (interactive)
  (compile (concat "cd ~/jobber/Jobber/"
                   " && "
                   "zeus rake vcr:clear")))

(defun dotspacemacs/rails-production-console ()
  (interactive)
  (dotspacemacs/do-tmux "cd ~/jobber/Jobber; heroku run console --app jobber-production"
                      "prod-console"))

(defun dotspacemacs/rails-local-console ()
  (interactive)
  (dotspacemacs/do-tmux "cd ~/jobber/Jobber; source ~/.zshrc; zeus c"
                      "console"))

(defun dotspacemacs/github-open-pull-request ()
  (interactive)
  (let* ((branch (magit-get-current-branch))
         (url (format "https://github.com/GetJobber/Jobber/compare/%s?expand=1"
                      branch)))
    (browse-url url)))

(defun dotspacemacs/config-clojure ()
  (add-hook 'cider-mode-hook 'cider-turn-on-eldoc-mode)
  (add-hook 'cider-repl-mode-hook 'company-mode)
  (add-hook 'cider-mode-hook 'company-mode)
  (add-hook 'cider-mode-hook 'paredit-mode)

  (evil-leader/set-key "cji" 'cider-jack-in)
  (evil-leader/set-key "sp" 'paredit-splice-sexp)
  )

(defadvice rspec-compile (around rspec-compile-around)
  "Use BASH shell for running specs because ZSH causes issues.."
  (let ((shell-file-name "/bin/bash"))
    ad-do-it))

(defun dotspacemacs/config ()
  "This is were you can ultimately override default Spacemacs configuration.
This function is called at the very end of Spacemacs initialization."

  (add-hook 'before-save-hook 'whitespace-cleanup)

  (dotspacemacs/config-clojure)

  (evil-leader/set-key "bb" 'helm-buffers-list)
  (evil-leader/set-key "fr" 'helm-recentf)
  (evil-leader/set-key "gd" 'vc-diff)
  (evil-leader/set-key "gpr" 'dotspacemacs/github-open-pull-request)

  (evil-leader/set-key "sv" 'rspec-verify)
  (evil-leader/set-key "tsa" 'dotspacemacs/run-all-specs)
  (evil-leader/set-key "jcp" 'dotspacemacs/rails-production-console)
  (evil-leader/set-key "jcl" 'dotspacemacs/rails-local-console)

  (evil-leader/set-key "rvc" 'dotspacemacs/rake-vcr-clear)

  (when (string-equal system-type "darwin")
    (set-face-attribute 'default nil :font "Menlo-11")
    (set-frame-font "Menlo-11" nil t))

  (when (string-equal system-type "gnu/linux")
    (set-face-attribute 'default nil :font "Deja Vu Sans Mono-9")
    (set-frame-font "Deja Vu Sans Mono-9" nil t))

  (evil-leader/set-key "esk" 'escreen-kill-screen)
  (evil-leader/set-key "esc" 'escreen-create-screen)
  (evil-leader/set-key "esn" 'escreen-goto-next-screen)
  (evil-leader/set-key "esp" 'escreen-goto-prev-screen)

  (global-set-key (kbd "M-w") 'escreen-kill-screen)
  (global-set-key (kbd "M-t") 'escreen-create-screen)
  (global-set-key (kbd "M-{") 'escreen-goto-prev-screen)
  (global-set-key (kbd "M-}") 'escreen-goto-next-screen)

  (escreen-create-screen)

  (winner-mode 1)
  (global-set-key (kbd "C--") 'winner-undo)
  (global-set-key (kbd "C-=") 'winner-redo)

  (ad-activate 'rspec-compile)

  (sp-use-paredit-bindings)

  (eval-after-load 'company
    '(add-to-list 'company-backends 'company-omnisharp))

  (add-hook 'csharp-mode-hook 'company-mode)
  (add-hook 'csharp-mode-hook 'omnisharp-mode)

  (defadvice auto-complete-mode (around disable-auto-complete-for-csharp)
    (unless (eq major-mode 'csharp-mode) ad-do-it))

  (ad-activate 'auto-complete-mode)


  (load-theme 'zenburn)
  (load-theme 'base16-chalk)

  (custom-theme-set-faces
   'base16-chalk
   '(highlight ((t (:background "black"))))
   '(cursor ((t (:background "gray")))))

)

;; Custom variables
;; ----------------

;; Do not write anything in this section. This is where Emacs will
;; auto-generate custom variable definitions.


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ac-ispell-requires 4)
 '(ahs-case-fold-search nil)
 '(ahs-default-range (quote ahs-range-whole-buffer))
 '(ahs-idle-interval 0.25)
 '(ahs-idle-timer 0 t)
 '(ahs-inhibit-face-list nil)
 '(company-idle-delay 0)
 '(company-minimum-prefix-length 2)
 '(css-indent-offset 2)
 '(custom-safe-themes (quote ("9dae95cdbed1505d45322ef8b5aa90ccb6cb59e0ff26fef0b8f411dfc416c552" "c0dd5017b9f1928f1f337110c2da10a20f76da0a5b14bb1fec0f243c4eb224d4" "9bac44c2b4dfbb723906b8c491ec06801feb57aa60448d047dbfdbd1a8650897" default)))
 '(flycheck-checkers (quote (ledger ada-gnat asciidoc c/c++-clang c/c++-gcc c/c++-cppcheck cfengine chef-foodcritic coffee coffee-coffeelint coq css-csslint d-dmd elixir emacs-lisp emacs-lisp-checkdoc erlang eruby-erubis fortran-gfortran go-gofmt go-golint go-vet go-build go-test go-errcheck haml handlebars haskell-ghc haskell-hlint html-tidy javascript-jshint javascript-eslint javascript-gjslint json-jsonlint less lua make perl perl-perlcritic php php-phpmd php-phpcs puppet-parser puppet-lint python-flake8 python-pylint racket rpm-rpmlint rst rst-sphinx ruby-rubocop rust sass scala scala-scalastyle scss sh-bash sh-posix-dash sh-posix-bash sh-zsh sh-shellcheck slim tex-chktex tex-lacheck texinfo verilog-verilator xml-xmlstarlet xml-xmllint yaml-jsyaml yaml-ruby)))
 '(global-evil-surround-mode nil)
 '(js-indent-level 2)
 '(magit-use-overlays nil)
 '(omnisharp-company-template-use-yasnippet nil)
 '(ring-bell-function (quote ignore) t)
 '(rspec-use-rake-when-possible nil)
 '(rspec-use-rvm t)
 '(rspec-use-zeus-when-possible t)
 '(scss-compile-at-save nil)
 '(split-height-threshold 100)
 '(web-mode-code-indent-offset 2)
 '(web-mode-enable-auto-opening nil)
 '(web-mode-markup-indent-offset 2))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(highlight ((t nil))))
