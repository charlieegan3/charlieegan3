#lang racket/base

(require racket/string)

(provide md-blockquote)

(define (md-blockquote text)
  (string-join (map (lambda (e) (format "> ~a" e)) (string-split text "\n")) "\n"))

(module+ test
  (require rackunit)
  (test-case
    "works for single lines of text"
    (let ([text "text"])
    (check-equal? (md-blockquote text) "> text")))
  (test-case
    "works for multiple lines of text"
    (let ([text "text\nmore lines"])
    (check-equal? (md-blockquote text) "> text\n> more lines"))))
