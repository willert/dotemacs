(require 'package)
(setq package-archives
      '(("gnu" . "http://elpa.gnu.org/packages/")
        ("nongnu" . "https://elpa.nongnu.org/nongnu/")
        ("melpa-stable" . "http://stable.melpa.org/packages/")
                                        ;("melpa" . "http://melpa.org/packages/")
        )
      )

(setq package-install-upgrade-built-in t)

(package-initialize)
