#lang racket/base

(require "./markdown/link.rkt")
(require "./markdown/caption.rkt")
(require "./markdown/blockquote.rkt")

(define icon-index
  (hash "commit" "💻"
        "post" "📸"
        "activity" "🎽"
        "play" "🎧"
        "film" "📽️"
        "tweet" "🐦"))

(define (render-commit commit)
  (format
   "* ~a ~a ~a\n  ~a"
   (hash-ref icon-index "commit")
   (md-link "Public commit" (hash-ref commit "url"))
   (md-caption (hash-ref commit "created_at_string"))
   (md-blockquote (hash-ref commit "message"))))

(define (render-tweet tweet)
  (format
   "* ~a ~a ~a\n  ~a"
   (hash-ref icon-index "tweet")
   (md-link "Tweet" (hash-ref tweet "link"))
   (md-caption (hash-ref tweet "created_at_string"))
   (md-blockquote (hash-ref tweet "text"))))

(define (render-post post)
  (format
   "* ~a ~a ~a"
   (hash-ref icon-index "post")
   (md-link (hash-ref post "location") (hash-ref post "url"))
   (md-caption (hash-ref post "created_at_string"))))

(define (render-activity activity)
  (format
   "* ~a ~a ~a"
   (hash-ref icon-index "activity")
   (md-link "Strava activity" (hash-ref activity "url"))
   (md-caption (hash-ref activity "created_at_string"))))

(define (render-film film)
  (format
   "* ~a Watched ~a ~a"
   (hash-ref icon-index "film")
   (md-link (hash-ref film "title") (hash-ref film "link"))
   (md-caption (hash-ref film "created_at_string"))))

(define (render-play play)
  (format
   "* ~a ~a ~a"
   (hash-ref icon-index "play")
   (md-link (format "_\"~a\"_ by _~a_" (hash-ref play "track") (hash-ref play "artist")) "https://music.charlieegan3.com")
   (md-caption (hash-ref play "created_at_string"))))

(module+ test
  (require rackunit)
  (define input-commit
    (hash
      "message" "Merge pull request #218 from jetstack/local-server-comment"
      "url" "https://github.com/jetstack/preflight/commit/7f4cb90dc5112d7c5e8357682da7866af3eee7c9"
      "repo"
        (hash
          "name" "jetstack/preflight"
          "url" "https://api.github.com/repos/jetstack/preflight")
      "created_at" "2021-02-19T11:45:13Z"
      "created_at_string" "5d ago"))
  (define output-commit #<<MD
* 💻 [Public commit](https://github.com/jetstack/preflight/commit/7f4cb90dc5112d7c5e8357682da7866af3eee7c9) <sub><sup>5d ago</sub></sup>
  > Merge pull request #218 from jetstack/local-server-comment
MD
)
  (test-case
    "returns expected list item for valid input"
    (check-equal? (render-commit input-commit) output-commit))

  (define input-tweet
    (hash
    "text" "Maybe use comic sans if the referrer is hacker news? Hacker news hates comic sans..."
    "link" "https://twitter.com/charlieegan3/status/1352962162042540032"
    "location" ""
    "created_at" "2021-01-23T12:51:30Z"
    "created_at_string" "1mth ago"))
  (define output-tweet #<<MD
* 🐦 [Tweet](https://twitter.com/charlieegan3/status/1352962162042540032) <sub><sup>1mth ago</sub></sup>
  > Maybe use comic sans if the referrer is hacker news? Hacker news hates comic sans...
MD
)
  (test-case
    "returns expected list item for valid input"
    (check-equal? (render-tweet input-tweet) output-tweet))

  (define input-post
    (hash
    "url" "https://instagram.com/p/CLXPx-rrl3P"
    "location" "Dartmouth Park"
    "type" "photo"
    "created_at" "2021-02-16T18:31:14Z"
    "created_at_string" "1w ago"))
  (define output-post #<<MD
* 📸 [Dartmouth Park](https://instagram.com/p/CLXPx-rrl3P) <sub><sup>1w ago</sub></sup>
MD
)
  (test-case
    "returns expected list item for valid input"
    (check-equal? (render-post input-post) output-post))

  (define input-activity
    (hash
      "average_heartrate" 145.8
      "url" "https://www.strava.com/activities/4844144869"
      "distance" 4798.9
      "moving_time" 1370
      "name" "Road test for the new headlamp "
      "type" "Run"
      "created_at" "2021-02-24T20:40:46Z"
      "created_at_string" "2h ago"))
  (define output-activity #<<MD
* 🎽 [Strava activity](https://www.strava.com/activities/4844144869) <sub><sup>2h ago</sub></sup>
MD
)
  (test-case
    "returns expected list item for valid input"
    (check-equal? (render-activity input-activity) output-activity))

  (define input-film
    (hash
      "title" "Lance"
      "link" "https://letterboxd.com/charlieegan3/film/lance/"
      "rating" "★★★★"
      "year" "2020"
      "created_at" "2021-02-11T21:21:54+13:00"
      "created_at_string" "1w ago"))
  (define output-film #<<MD
* 📽️ Watched [Lance](https://letterboxd.com/charlieegan3/film/lance/) <sub><sup>1w ago</sub></sup>
MD
)
  (test-case
    "returns expected list item for valid input"
    (check-equal? (render-film input-film) output-film))

  (define input-play
    (hash
      "album" "Conditions"
      "artist" "The Temper Trap"
      "artwork" "https://i.scdn.co/image/ab67616d0000b273cb3d624d713c325479dfd208"
      "track" "Sweet Disposition"
      "created_at" "2021-02-24T21:44:54Z"
      "created_at_string" "1h ago"))
  (define output-play #<<MD
* 🎧 [_"Sweet Disposition"_ by _The Temper Trap_](https://music.charlieegan3.com) <sub><sup>1h ago</sub></sup>
MD
)
  (test-case
    "returns expected list item for valid input"
    (check-equal? (render-play input-play) output-play)))
