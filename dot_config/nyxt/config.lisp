;; No tracking
(define-configuration (web-buffer)
  ((default-modes
    (pushnew 'nyxt/mode/reduce-tracking:reduce-tracking-mode %slot-value%))))

;; Disable 3rd party cookies
(defmethod customize-instance ((browser browser) &key)
    (setf (slot-value browser 'default-cookie-policy) :no-third-party))

;; Vim keys
(define-configuration buffer
  ((default-modes
   (pushnew 'nyxt/mode/vi:vi-normal-mode %slot-value%))))
(define-configuration (prompt-buffer)
  ((default-modes (pushnew 'nyxt/mode/vi:vi-insert-mode %slot-value%))))

;; Ad Blocker
(define-configuration (web-buffer)
  ((default-modes (pushnew 'nyxt/mode/blocker:blocker-mode %slot-value%))))

;; No JS
;; (define-configuration (web-buffer)
;;   ((default-modes (pushnew 'nyxt/mode/no-script:no-script-mode %slot-value%))))
