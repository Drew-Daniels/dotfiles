;; "No Script mode - Disables JS on every buffer"
;; (define-configuration web-buffer
;;                         ((default-modes
;;                                (pushnew 'nyxt/mode/no-script:no-script-mode %slot-value%))))
;; VI-NORMAL-MODE
(define-configuration buffer
                        ((default-modes
                               (pushnew 'nyxt/mode/vi:vi-normal-mode %slot-value%))))
