;;; packages.el --- mpd layer packages file for Spacemacs.
;;
;; Copyright (c) 2012-2016 Sylvain Benner & Contributors
;;
;; Author:  <dillon@dy500>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;;; Commentary:

;; See the Spacemacs documentation and FAQs for instructions on how to implement
;; a new layer:
;;
;;   SPC h SPC layers RET
;;
;;
;; Briefly, each package to be installed or configured by this layer should be
;; added to `mpd-packages'. Then, for each package PACKAGE:
;;
;; - If PACKAGE is not referenced by any other Spacemacs layer, define a
;;   function `mpd/init-PACKAGE' to load and initialize the package.

;; - Otherwise, PACKAGE is already referenced by another Spacemacs layer, so
;;   define the functions `mpd/pre-init-PACKAGE' and/or
;;   `mpd/post-init-PACKAGE' to customize the package as it is loaded.

;;; Code:

(setq mpd-packages '(
                     libmpdee
                     ))

(defun mpd/init-libmpdee()
  (use-package libmpdee
    :defer t
    :init
    (progn
      (spacemacs/declare-prefix "M" "mpd")

      )
    (spacemacs/set-leader-keys
      "Mp" 'mpd-pause
      "Mn" 'mpd-next
      "MN" 'mpd-prev
      )
    ))


;;; packages.el ends here
