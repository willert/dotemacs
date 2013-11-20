;;; kaesar-autoloads.el --- automatically extracted autoloads
;;
;;; Code:


;;;### (autoloads (kaesar-change-password kaesar-decrypt kaesar-encrypt
;;;;;;  kaesar-decrypt-string kaesar-encrypt-string kaesar-decrypt-bytes
;;;;;;  kaesar-encrypt-bytes) "kaesar" "kaesar.el" (21132 48425))
;;; Generated autoloads from kaesar.el

(autoload 'kaesar-encrypt-bytes "kaesar" "\
Encrypt a UNIBYTE-STRING with ALGORITHM.
If no ALGORITHM is supplied, default value is `kaesar-algorithm'.
See `kaesar-algorithm' list of the supported ALGORITHM .

To suppress the password prompt, set password to `kaesar-password' as a vector.

\(fn UNIBYTE-STRING &optional ALGORITHM)" nil nil)

(autoload 'kaesar-decrypt-bytes "kaesar" "\
Decrypt a ENCRYPTED-STRING which was encrypted by `kaesar-encrypt-bytes'

\(fn ENCRYPTED-STRING &optional ALGORITHM)" nil nil)

(autoload 'kaesar-encrypt-string "kaesar" "\
Encrypt a well encoded STRING to encrypted string
which can be decrypted by `kaesar-decrypt-string'.

This function is a wrapper function of `kaesar-encrypt-bytes'
to encrypt string.

\(fn STRING &optional CODING-SYSTEM ALGORITHM)" nil nil)

(autoload 'kaesar-decrypt-string "kaesar" "\
Decrypt a ENCRYPTED-STRING which was encrypted by `kaesar-encrypt-string'.

This function is a wrapper function of `kaesar-decrypt-bytes'
to decrypt string

\(fn ENCRYPTED-STRING &optional CODING-SYSTEM ALGORITHM)" nil nil)

(autoload 'kaesar-encrypt "kaesar" "\
Encrypt a UNIBYTE-STRING with KEY-INPUT (Before expansion).
KEY-INPUT arg expects valid length of hex string or vector (0 - 255).
See `kaesar-algorithm' list the supported ALGORITHM .
IV-INPUT may be required if ALGORITHM need this.

This is a low level API to create the data which can be decrypted
 by other implementation.

\(fn UNIBYTE-STRING KEY-INPUT &optional IV-INPUT ALGORITHM)" nil nil)

(autoload 'kaesar-decrypt "kaesar" "\
Decrypt a ENCRYPTED-STRING which was encrypted by `kaesar-encrypt' with KEY-INPUT.
IV-INPUT may be required if ALGORITHM need this.

This is a low level API to decrypt data that was encrypted by other implementation.

\(fn ENCRYPTED-STRING KEY-INPUT &optional IV-INPUT ALGORITHM)" nil nil)

(autoload 'kaesar-change-password "kaesar" "\
Utility function to change ENCRYPTED-BYTES password to new one.
ENCRYPTED-BYTES will be cleared immediately after decryption is done.
CALLBACK is a function accept one arg which indicate decrypted bytes.
  This bytes will be cleared after creating the new encrypted bytes.

\(fn ENCRYPTED-BYTES &optional ALGORITHM CALLBACK)" nil nil)

;;;***

;;;### (autoloads nil nil ("kaesar-pkg.el") (21132 48425 250495))

;;;***

(provide 'kaesar-autoloads)
;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; kaesar-autoloads.el ends here
