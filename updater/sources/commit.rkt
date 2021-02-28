#lang racket/base

(require "../utils/hash.rkt")

; valid data example
; {
;   "commit": {
;     "message": "Merge pull request #218 from jetstack/local-server-comment",
;     "url": "https://github.com/jetstack/preflight/commit/7f4cb90dc5112d7c5e8357682da7866af3eee7c9",
;     "repo": {
;       "name": "jetstack/preflight",
;       "url": "https://api.github.com/repos/jetstack/preflight"
;     },
;     "created_at": "2021-02-19T11:45:13Z",
;     "created_at_string": "5d ago"
;   },
; }

(provide validate-commit)
(define (validate-commit hsh)
  (let
    ([schema-message
      (hash-schema hsh '("message" "url" ("repo" "name" "url") "created_at" "created_at_string"))])
    (if (equal? schema-message "") "" (format "schema validation failed: ~a" schema-message))))

(module+ test
  (require rackunit)
  (test-case
    "validates hash as ok when valid"
    (let ([input (hash "message" "" "url" "" "repo" (hash "name" "" "url" "") "created_at" "" "created_at_string" "")])
      (check-equal? (validate-commit input) "")))

  (test-case
    "validates hash as bad when missing repo keys"
    (let ([input (hash "url" "" "repo" (hash "name" "") "created_at" "" "created_at_string" "")])
      (check-equal? (validate-commit input) "schema validation failed: missing: message, repo.url"))))
