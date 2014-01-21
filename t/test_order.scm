(use gauche.test)

(load "eval")

(let ((section "eval-order"))

  (define expr "
    (begin 
      (define n 3)
      (define (square!)
        (set! n (* n n))
        n)
      (define (double!)
        (set! n (+ n n))
        n)
      (define (add a b)
        (+ a b))
      (add (square!) (double!)))
  ")

  (test-section section)

  (test* "left to right"
         42
         (my-eval (read-from-string expr) the-global-environment))

  'done)

