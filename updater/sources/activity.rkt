#lang racket/base

(require racket/bool)
(require racket/string)
(require "../utils/hash.rkt")

; valid data example
; {
;   "activity": {
;     "average_heartrate": 145.8,
;     "url": "https://www.strava.com/activities/4844144869",
;     "distance": 4798.9,
;     "moving_time": 1370,
;     "name": "Road test for the new headlamp ",
;     "type": "Run",
;     "created_at": "2021-02-24T20:40:46Z",
;     "created_at_string": "2h ago"
;   },
; }

(provide validate-activity)
(define (validate-activity hsh)
  (let
    ([missing-keys
      (hash-missing-keys '("average_heartrate" "url" "distance" "moving_time" "name" "type" "created_at" "created_at_string") hsh)])
    (if (> (length missing-keys) 0) (format "missing keys: ~a" (string-join missing-keys ", ")) "")))

(module+ test
  (require rackunit)
  (test-case
    "validates hash as ok when valid"
    (let ([input (hash "average_heartrate" "" "url" "" "distance" "" "moving_time" "" "name" "" "type" "" "created_at" "" "created_at_string" "")])
      (check-equal? (validate-activity input) "")))

  (test-case
    "validates hash as bad when missing keys"
    (let ([input (hash "url" "" "distance" "" "moving_time" "" "name" "" "type" "" "created_at" "" "created_at_string" "")])
      (check-equal? (validate-activity input) "missing keys: average_heartrate"))))
