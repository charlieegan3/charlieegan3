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

(define files
  (command-line
    #:args (status-json readme)
    (list status-json readme)))

(define loaded-data
  (with-input-from-string
    (file->string (first files))
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

(define tod-icon
  (case (->hours (current-time))
    [(range 0 8 1) "🌌"]
    [(range 9 12 1) "🌄"]
    [(range 13 17 1) "🌤️"]
    [(range 18 21 1) "🌆"]
    [(range 21 23 1) "🌃"]))

(define template #<<MD
Welcome to my GitHub profile! ~a

My main home is [charlieegan3.com](https://charlieegan3.com) but here's my latest news:

~a

MD
)

(define out (open-output-file (list-ref files 1) #:exists 'replace))
(display (format template tod-icon md-list) out)
(close-output-port out)
