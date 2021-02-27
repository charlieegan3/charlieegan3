#lang racket/base

(require racket/bool)
(require racket/list)

; hash-missing-keys returns a list of keys missing from a hash
(provide hash-missing-keys)
(define (hash-missing-keys required-keys hash)
  (foldr
    append
    '()
    (map
      (lambda (e) (if (not (hash-has-key? hash e)) (list e) '()))
      required-keys)))

(module+ test
  (require rackunit)
  (test-case
    "returns missing keys when not present in hash"
    (check-equal? (hash-missing-keys (list "a" "b") (hash "a" "1")) (list "b")))

  (test-case
    "returns missing keys in the same order as the request list"
    (check-equal? (hash-missing-keys (list "a" "b") (hash)) (list "a" "b")))

  (test-case
    "returns an empty list if there are no keys missing"
    (check-equal? (hash-missing-keys (list "a" "b") (hash "a" "1" "b" "2")) '())))

; hash-dig returns the value at the leaf of a nested path with a potentially
; nested hash
(provide hash-dig)
(define (hash-dig path h)
  (case (length path)
    [(1) (hash-ref h (first path) hash)]
    [else (hash-dig (rest path) (hash-ref h (first path)))]))

(module+ test
  (require rackunit)
  (test-case
    "returns a top level value"
    (check-equal? (hash-dig (list "a") (hash "a" "1")) "1"))

  (test-case
    "returns a nested value"
    (check-equal? (hash-dig (list "a" "b" "c") (hash "a" (hash "b" (hash "c" "1")))) "1"))

  (test-case
    "returns an empty hash when missing"
    (check-equal? (hash-dig (list "a" "b") (hash "a" (hash))) (hash))))
