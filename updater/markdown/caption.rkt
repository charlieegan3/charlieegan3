#lang racket/base

(provide md-caption)

(define (md-caption text)
  (format "<sub><sup>~a</sub></sup>" text))

(module+ test
  (require rackunit)
  (test-case
    "generates a caption of the input string"
    (let ([input "cap"])
    (check-equal? (md-caption input) "<sub><sup>cap</sub></sup>"))))
