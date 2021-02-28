#lang racket/base

(require "../utils/hash.rkt")

; valid data example
; {
;   "tweet": {
;     "text": "Thanks! In writing the tweet we realised how much we had to talk about �",
;     "link": "https://twitter.com/charlieegan3/status/1352962162042540032",
;     "location": "",
;     "created_at": "2021-01-23T12:51:30Z",
;     "created_at_string": "1mth ago"
;   },
; }

(provide validate-tweet)
(define (validate-tweet hsh)
  (let
    ([schema-message
      (hash-schema hsh '("text" "link" "location" "created_at" "created_at_string"))])
    (if (equal? schema-message "") "" (format "schema validation failed: ~a" schema-message))))

(module+ test
  (require rackunit)
  (test-case
    "validates hash as ok when valid"
    (let ([input (hash "text" "" "link" "" "location" "" "created_at" "" "created_at_string" "")])
      (check-equal? (validate-tweet input) "")))

  (test-case
    "validates hash as bad when missing keys"
    (let ([input (hash "link" "" "location" "" "created_at" "" "created_at_string" "")])
      (check-equal? (validate-tweet input) "schema validation failed: missing: text"))))
