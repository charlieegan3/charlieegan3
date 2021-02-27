#lang racket/base

(require racket/bool)
(require racket/string)
(require "../utils/hash.rkt")

; valid data example
; {
;   "film": {
;     "title": "Lance",
;     "link": "https://letterboxd.com/charlieegan3/film/lance/",
;     "rating": "★★★★",
;     "year": "2020",
;     "created_at": "2021-02-11T21:21:54+13:00",
;     "created_at_string": "1w ago"
;   },
; }

(provide validate-film)
(define (validate-film hsh)
  (let
    ([missing-keys
      (hash-missing-keys '("title" "link" "rating" "year" "created_at" "created_at_string") hsh)])
    (if (> (length missing-keys) 0) (format "missing keys: ~a" (string-join missing-keys ", ")) "")))

(module+ test
  (require rackunit)
  (test-case
    "validates hash as ok when valid"
    (let ([input (hash "title" "" "link" "" "rating" "" "year" "" "created_at" "" "created_at_string" "")])
      (check-equal? (validate-film input) "")))

  (test-case
    "validates hash as bad when missing keys"
    (let ([input (hash "link" "" "rating" "" "year" "" "created_at" "" "created_at_string" "")])
      (check-equal? (validate-film input) "missing keys: title"))))