#lang racket/base

(require racket/bool)
(require racket/string)
(require "../utils/hash.rkt")

; valid data example
; {
;   "post": {
;     "url": "https://instagram.com/p/CLXPx-rrl3P",
;     "location": "Dartmouth Park",
;     "type": "photo",
;     "created_at": "2021-02-16T18:31:14Z",
;     "created_at_string": "1w ago"
;   },
; }

(provide validate-post)
(define (validate-post hsh)
  (let
    ([missing-keys
      (hash-missing-keys '("url" "location" "type" "created_at" "created_at_string") hsh)])
    (if (> (length missing-keys) 0) (format "missing keys: ~a" (string-join missing-keys ", ")) "")))

(module+ test
  (require rackunit)
  (test-case
    "validates hash as ok when valid"
    (let ([input (hash "url" "" "location" "" "type" "" "created_at" "" "created_at_string" "")])
      (check-equal? (validate-post input) "")))

  (test-case
    "validates hash as bad when missing keys"
    (let ([input (hash "location" "" "type" "" "created_at" "" "created_at_string" "")])
      (check-equal? (validate-post input) "missing keys: url"))))
