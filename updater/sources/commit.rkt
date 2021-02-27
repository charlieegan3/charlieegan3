#lang racket/base

(require racket/bool)
(require racket/string)
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
    ([missing-keys
      (hash-missing-keys '("message" "url" "repo" "created_at" "created_at_string") hsh)]
     [missing-repo-keys
      (hash-missing-keys '("name" "url") (hash-dig '("repo") hsh))])
    (string-join
      (append
        (if (> (length missing-keys) 0) (list (format "missing keys: ~a" (string-join missing-keys ", "))) '())
        (if (> (length missing-repo-keys) 0) (list (format "missing keys from repo: ~a" (string-join missing-repo-keys ", "))) '()))
      "; ")))

(module+ test
  (require rackunit)
  (test-case
    "validates hash as ok when valid"
    (let ([input (hash "message" "" "url" "" "repo" (hash "name" "" "url" "") "created_at" "" "created_at_string" "")])
      (check-equal? (validate-commit input) "")))

  (test-case
    "validates hash as bad when missing repo keys"
    (let ([input (hash "url" "" "repo" (hash "name" "") "created_at" "" "created_at_string" "")])
      (check-equal? (validate-commit input) "missing keys: message; missing keys from repo: url"))))
