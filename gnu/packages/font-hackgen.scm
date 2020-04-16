(define-module (gnu packages font-hackgen)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix build-system font)
  #:use-module (gnu packages fontutils))

(define-public font-hackgen
  (package
    (name "font-hackgen")
    (version "1.4.1")
    (home-page "https://github.com/yuru7/HackGen")
    (source (origin
              (method url-fetch)
              (uri (string-append
                    "https://github.com/yuru7/HackGen/releases/download/v"
                    version
                    "/HackGen_v"
                    version
                    ".zip"))
              (sha256
               (base32
                "15p9jyjz88sn9l3hkangz6mfqr2wr0fpazi79mg1xzrmy0jhy69z"))))
    (build-system font-build-system)
    (synopsis "Hackgen Japanese TrueType font")
    (description "")
    (license license:silofl1.1)))
