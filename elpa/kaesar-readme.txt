This package provides AES algorithm to encrypt/decrypt Emacs
string. Supported algorithm desired to get interoperability with
openssl command. You can get decrypted text by that command if
you won't forget password.

Why kaesar?
This package previously named 'cipher/aes' but ELPA cannot handle
such package name.  So, I had to change the name but `aes' package
already exists. (That is faster than this package!)  I continue to
consider the new name which contains "aes" string. There is the
ancient cipher algorithm caesar
http://en.wikipedia.org/wiki/Caesar_cipher
 K`aes'ar is change the first character of Caesar. There is no
meaning more than containing `aes' word.

How to suppress password prompt?
There is no official way to suppress that prompt. If you want to
learn more information, please read `kaesar-password' doc string.
