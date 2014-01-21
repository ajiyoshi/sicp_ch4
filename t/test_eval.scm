(use gauche.test)

(load "eval")

(let ((section "self-evaluating?"))
  (test-section section)

  (test* "number is self eval" #t (self-evaluating? 1))
  (test* "string is self eval" #t (self-evaluating? "string"))

  (test* "number is self eval (read-from-string)" #t (self-evaluating? (read-from-string "1")))
  (test* "string is self eval (read-from-string)" #t (self-evaluating? (read-from-string "\"string\"")))

  (test* "'symbol is self eval" #f (self-evaluating? 'symbol))
  (test* "'symbol is self eval (read-from-string)" #f (self-evaluating? (read-from-string "symb")))

  'done)

(let ((section "tagged-list?"))
  (test-section section)

  (test* "(hoge) is tagged hoge" #t (tagged-list? '(hoge) 'hoge))
  (test* "(hoge) is not tagged fuga" #f (tagged-list? '(hoge) 'fuga))
  (test* "(hoge) is tagged hoge (read-from-string)" #t (tagged-list? (read-from-string "(hoge)") 'hoge))

  (test* "'(hoge) is tagged hoge" #f (tagged-list? (read-from-string "'(hoge)") 'hoge))
  (test* "'(hoge) is tagged quoted" #t (tagged-list? (read-from-string "'(hoge)") 'quote))

  'done)

(let ((section "frame")
      (f (make-frame '(a) '(1))))
  (test-section section)

  (test* "vars"
         '(a)
         (frame-variables f))

  (test* "vals"
         '(1)
         (frame-values f))

  (add-binding-to-frame! 'b 2 f)

  (test* "add-binding-to-frame! (vars)"
         '(b a)
         (frame-variables f))

  (test* "add-binding-to-frame! (vals)"
         '(2 1)
         (frame-values f))
  'done)


(let ((section "env")
      (e1 (extend-envrironment '(a b) '(1 2) the-empty-environment)))
  (test-section section)

  (test* "first-frame (vars)"
         '(a b)
         (frame-variables (first-frame e1)))

  (test* "first-frame (vals)"
         '(1 2)
         (frame-values (first-frame e1)))

  (test* "lookup a" 1 (lookup-variable-value 'a e1))
  (test* "lookup b" 2 (lookup-variable-value 'b e1))

  'done)

(let ((section "env(add-binding-to-frame!)")
      (e1 (extend-envrironment '(a b) '(1 2) the-empty-environment)))
  (test-section section)

  (test* "lookup b" 2 (lookup-variable-value 'b e1))

  (add-binding-to-frame! 'b 3 (first-frame e1))

  (test* "lookup a" 1 (lookup-variable-value 'a e1))
  (test* "lookup b" 3 (lookup-variable-value 'b e1))

  'done)

(let ((section "env(set-variable-value!)")
      (e1 (extend-envrironment '(a b) '(1 2) the-empty-environment)))
  (test-section section)

  (set-variable-value! 'b 4 e1)

  (test* "set-variable-value! b <- 4"
         '(a b)
         (frame-variables (first-frame e1)))
  (test* "set-variable-value! b <- 4"
         '(1 4)
         (frame-values (first-frame e1)))

  (test* "lookup b" 4 (lookup-variable-value 'b e1))

  'done)

(let ((section "env(define)")
      (e1 (extend-envrironment '(a b) '(1 2) the-empty-environment)))
  (test-section section)

  (test* "unbound"
         (test-error)
         (lookup-variable-value 'c e1))

  (define-variable! 'c 10 e1)

  (test* "c was defined"
         '(c a b)
         (frame-variables (first-frame e1)))
  (test* "c was defined"
         '(10 1 2)
         (frame-values (first-frame e1)))
  (test* "c was defined as 10"
         10
         (lookup-variable-value 'c e1))

  (define-variable! 'c 11 e1)

  (test* "c was redefined"
         '(c a b)
         (frame-variables (first-frame e1)))
  (test* "c was redefined"
         '(11 1 2)
         (frame-values (first-frame e1)))
  (test* "c was defined as 11"
         11
         (lookup-variable-value 'c e1))

  'done)

(test-end)
