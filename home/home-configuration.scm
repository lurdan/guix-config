;; This "home-environment" file can be passed to 'guix home reconfigure'
;; to reproduce the content of your profile.  This is "symbolic": it only
;; specifies package names.  To reproduce the exact same profile, you also
;; need to capture the channels being used, as returned by "guix describe".
;; See the "Replicating Guix" section in the manual.

(use-modules (gnu home)
             (gnu home services)
             (gnu home services shepherd)
             (gnu home services guix)
             (gnu packages)
             (gnu packages base) ;; glibc locales
             (gnu packages emacs)
             (gnu packages syncthing)
             (gnu services)
             (gnu services shepherd)
             (guix channels)
             (guix gexp)
             (gnu home services shells))

(define glibc-locales-ja
  (make-glibc-utf8-locales glibc
    #:locales (list "ja_JP")
    #:name "glibc-locales-ja"))

(define my--syncthing-service
  (shepherd-service
   (provision '(syncthing))
   (documentation "Run and control syncthing")
   (start #~(make-forkexec-constructor
             (list #$(file-append syncthing "/bin/syncthing")
                   "-no-browser")))
   (stop #~(make-kill-destructor))))


(home-environment
  ;; Below is the list of packages that will show up in your
  ;; Home profile, under ~/.guix-home/profile.
  (packages (append
              (specifications->packages (list "git" "htop" "byobu" "tmux" "nss-certs" "alacritty" "rsync" "ripgrep" "w3m"
                                              "gcc-toolchain" "make"
                                              "iperf" "fio"
                                              "syncthing" 
                                              "dbus"
                                              "font-hackgen-nerd" "font-nasu" "font-google-noto-serif-cjk" "font-google-noto-sans-cjk" "font-awesome" "font-google-noto-emoji"
                                              "emacs-next" "emacs-guix" "sqlite" "emacs-vterm" "mu" "isync" "pinentry-tty" "pinentry-emacs" "graphviz"
                                              "hyprland" "xdg-desktop-portal-hyprland" "waybar-experimental" "rofi-wayland" "mako" "wl-clipboard" "swayidle" "vlc"))
              (list glibc-locales-ja)
              ))
  ;; Below is the list of Home services.  To search for available
  ;; services, run 'guix home search KEYWORD' in a terminal.
  (services
   (list (service home-bash-service-type
                  (home-bash-configuration
                   (environment-variables '(("GUIX_LOCPATH" . "$HOME/.guix-home/profile/lib/locale")
                                            ("SSL_CERT_DIR" . "$HOME/.guix-home/profile/etc/ssl/certs")
                                            ;;("VISUAL" . "emacsclient")
                                            ;;("EDITOR" . "emacsclient")
                                            ))
                   ;;(aliases '(("ls" . "ls --color=auto")
                   ;;           ("grep" . "grep --color=auto")))
                   (bashrc (list (local-file
                                  "/home/kura/repos/guix-config/home/.bashrc"
                                  "bashrc")))
                   ;;(bash-logout (list (local-file
                   ;;                    "/home/kura/repos/guix-config/home/.bash_logout"
                   ;;                    "bash_logout")))
                   ))
         (simple-service 'env-vars
                home-environment-variables-service-type
                `(("QT_QPA_PLATFORM" . "wayland")
                  ("XDG_SESSION_TYPE" . "wayland")
                  ;;("GDK_BACKEND" . "wayland")
                  ("MOZ_ENABLE_WAYLAND" . "1")
                  ("GTK_IM_MODULE" . "fcitx")
                  ("QT_IM_MODULE" . "fcitx")
                  ("SDL_IM_MODULE" . "fcitx")
                  ("XMODIFIERS" . "@im=fcitx")
                  )) 
         (simple-service 'my--services
                home-shepherd-service-type
                (list my--syncthing-service))
         ;;(simple-service 'dotfiles-symlink-service
         ;;       home-files-service-type
         ;;           `((".config/emacs" ,(local-file "/home/kura/.autosync/.emacs.d" "emacs-d" #:recursive? #t))))
         (simple-service 'variant-packages-service
                home-channels-service-type
                (list
                 (channel
                  (name 'nonguix)
                  (url "https://gitlab.com/nonguix/nonguix")
                  (introduction
                   (make-channel-introduction
                   "897c1a470da759236cc11798f4e0a5f7d4d59fbc"
                   (openpgp-fingerprint
                   "2A39 3FFF 68F4 EF7A 3D29  12AF 6F51 20A0 22FB B2D5"))))
                 (channel
                  (name 'rosenthal)
                  (url "https://codeberg.org/hako/rosenthal.git")
                  (branch "trunk")
                  (introduction
                   (make-channel-introduction
                   "7677db76330121a901604dfbad19077893865f35"
                   (openpgp-fingerprint
                   "13E7 6CD6 E649 C28C 3385  4DF5 5E5A A665 6149 17F7"))))
                 (channel
                  (name 'local-channel)
                  (url "file:///home/kura/repos/guix-packages"))
                 ))
          )))

