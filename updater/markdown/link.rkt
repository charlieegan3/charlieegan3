#lang racket/base

(provide md-link)

(define (md-link text url)
  (validate text url)
  (format "[~a](~a)" text url))

(define (validate text url)
  (let ([errors (string-append (validate-text-safe text) (validate-url-has-protocol url))])
    (if (not (equal? errors ""))
      (error errors) (list))))

(define (validate-text-safe text)
  (if (regexp-match? #rx"\\[|\\]" text)
    (format "text '~a' contains [ or ]" text) ""))

(define (validate-url-has-protocol url)
  (if (not (regexp-match? #px"^\\w+://" url))
    (format "expected input '~a' to have protocol" url) ""))

(module+ test
  (require rackunit)
  (test-case
    "generates a link given text and url"
    (let ([text "text"] [url "https://example.com"])
    (check-equal? (md-link text url) "[text](https://example.com)")))

  (test-case
    "rejects urls without protocol"
    (let ([text "text"] [url "example.com"])
    (check-exn #rx"^expected input 'example.com' to have protocol$" (lambda () (md-link text url)))))

  (test-case
    "rejects text containing [ or ]"
    (let ([text "te[xt"] [url "https://example.com"])
    (check-exn #rx"^text 'te\\[xt' contains \\[ or \\]$" (lambda () (md-link text url))))))
