#lang racket/base

(require "./utils/hash.rkt")

; validate-item will return a string message if there are keys missing from the
; input data
(provide validate-item)
(define (validate-item kind hsh)
  (let
    ([schema-message (hash-schema hsh (schema-for-kind kind))])
    (if (equal? schema-message "") "" (format "schema validation failed: ~a" schema-message))))

(define (schema-for-kind kind)
  (case kind
    [("tweet")    '("text" "link" "location" "created_at" "created_at_string")]
    [("activity") '("average_heartrate" "url" "distance" "moving_time" "name" "type" "created_at" "created_at_string")]
    [("film")     '("title" "link" "rating" "year" "created_at" "created_at_string")]
    [("play")     '("album" "artist" "artwork" "track" "created_at" "created_at_string")]
    [("post")     '("url" "location" "type" "created_at" "created_at_string")]
    [("commit")   '("message" "url" ("repo" "name" "url") "created_at" "created_at_string")]
    [else '()]))

(module+ test
  (require rackunit)
  (test-case
    "validates hash as ok when valid"
    (let ([input (hash "text" "" "link" "" "location" "" "created_at" "" "created_at_string" "")])
      (check-equal? (validate-item "tweet" input) "")))

  (test-case
    "validates hash as bad when missing keys"
    (let ([input (hash "link" "" "location" "" "created_at" "" "created_at_string" "")])
      (check-equal? (validate-item "tweet" input) "schema validation failed: missing: text"))))
