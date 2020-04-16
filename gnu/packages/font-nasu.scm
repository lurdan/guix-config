(define-module (gnu packages font-nasu)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix build-system font)
  #:use-module (gnu packages fontutils))

(define-public font-nasu
  (package
    (name "font-nasu")
    (version "20200227")
    (home-page "http://itouhiro.hatenablog.com/entry/20140917/font")
    (source (origin
              (method url-fetch)
              (uri (string-append
                    "https://osdn.net/frs/chamber_redir.php?m=jaist&f=%2Fusers%2F25%2F25473%2FNasuFont-"
                    version
                    ".zip"))
              (file-name (string-append "NasuFont-" version ".zip"))
              (sha256
               (base32
                "0djsjym8jya9cdhrxrq6si7zq67kjir73kw42j7nxi22af4kwack"))))
    (build-system font-build-system)
    (synopsis "Nasu and NasuM Japanese TrueType fonts")
    (description "")
    (license license:asl2.0)))
