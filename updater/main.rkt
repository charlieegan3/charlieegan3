#lang racket/base

(require racket/cmdline)
(require racket/file)
(require racket/port)
(require racket/list)
(require racket/string)
(require racket/date)

(require json)
(require gregor)

(require "./render.rkt")

(define input-file
  (command-line
    #:args (filename)
    filename))

(define loaded-data
  (with-input-from-string
    (file->string input-file)
    (lambda () (read-json))))

(define sorted-items
  (sort
    (hash-map loaded-data (lambda (k v) (list k v)))
    (lambda (ls1 ls2)
      (datetime>?
        (iso8601->datetime (hash-ref (list-ref ls1 1) 'created_at))
        (iso8601->datetime (hash-ref (list-ref ls2 1) 'created_at))))))

(define md-list
  (string-join
    (map
      (lambda (ls)
        (let ([type (first ls)] [input (list-ref ls 1)])
          (case type
            [(activity) (render-activity input)]
            [(commit) (render-commit input)]
            [(film) (render-film input)]
            [(play) (render-play input)]
            [(post) (render-post input)]
            [(tweet) (render-tweet input)]
            [else input])))
      sorted-items)
    "\n"))

(display md-list)
