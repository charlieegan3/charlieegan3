#lang racket/base

(require "../utils/hash.rkt")

; valid data example
; {
;   "play": {
;     "album": "Conditions",
;     "artist": "The Temper Trap",
;     "artwork": "https://i.scdn.co/image/ab67616d0000b273cb3d624d713c325479dfd208",
;     "track": "Sweet Disposition",
;     "created_at": "2021-02-24T21:44:54Z",
;     "created_at_string": "1h ago"
;   }
; }

(provide validate-play)
(define (validate-play hsh)
  (let
    ([schema-message
      (hash-schema hsh '("album" "artist" "artwork" "track" "created_at" "created_at_string"))])
    (if (equal? schema-message "") "" (format "schema validation failed: ~a" schema-message))))

(module+ test
  (require rackunit)
  (test-case
    "validates hash as ok when valid"
    (let ([input (hash "album" "" "artist" "" "artwork" "" "track" "" "created_at" "" "created_at_string" "")])
    (check-equal? (validate-play input) "")))

  (test-case
    "validates hash as bad when missing keys"
    (let ([input (hash "artist" "" "artwork" "" "track" "" "created_at" "" "created_at_string" "")])
    (check-equal? (validate-play input) "schema validation failed: missing: album"))))
