#lang racket/base

(require racket/bool)
(require racket/list)
(require racket/string)

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

; hash-schema ensures that a hash has the required schema, recursively
(provide hash-schema)
(define (hash-schema hsh schema [prefix ""])
  (let
    ([missing-keys (foldr
                     append
                     '()
                     (map
                       (lambda (e)
                         (if (list? e)
                           (hash-schema (hash-dig (list (first e)) hsh) (rest e) (format "~a" (first e)))
                           (if (hash-has-key? hsh e) '() (list e))))
                       schema))])
    (if (equal? prefix "")
      (if (> (length missing-keys) 0)
         (format "missing: ~a" (string-join missing-keys ", "))
         "")
      (if (> (length missing-keys) 0)
         (map (lambda (e) (format "~a.~a" prefix e)) missing-keys)
         '()))
))

(module+ test
  (require rackunit)
  (test-case
    "validates a simple hash"
    (check-equal? (hash-schema (hash "a" "1" "b" "2") '("a" "b")) ""))
  (test-case
    "validates a simple hash with missing key"
    (check-equal? (hash-schema (hash "a" "1" "b" "2") '("a" "b" "c")) "missing: c"))
  (test-case
    "validates a nested hash"
    (check-equal? (hash-schema (hash "a" (hash "b" "1")) (list (list "a" "b"))) ""))
  (test-case
    "validates a nested hash with missing key"
    (check-equal? (hash-schema (hash "a" (hash "b" "1")) (list (list "a" "b" "c"))) "missing: a.c"))
  (test-case
    "validates a nested hash with many missing keys"
    (check-equal? (hash-schema (hash "a" (hash "b" "1")) (list (list "a" "b" "c") "d")) "missing: a.c, d")))
