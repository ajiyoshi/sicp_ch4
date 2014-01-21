(use gauche.test)

(load "eval")

(test-start "eval test")

(test-section "self-evaluating?")

(test* "number is self eval" #t (self-evaluating? 1))
(test* "string is self eval" #t (self-evaluating? "string"))
(test* "number is self eval (read-from-string)" #t (self-evaluating? (read-from-string "1")))
(test* "string is self eval (read-from-string)" #t (self-evaluating? (read-from-string "\"string\"")))

(test* "'symbol is symbol" #f (self-evaluating? 'symbol))
(test* "'symbol is symbol (read-from-string)" #f (self-evaluating? (read-from-string "symb")))

(test-section "tagged-list?")

(test* "(hoge) is tagged hoge" #t (tagged-list? '(hoge) 'hoge))
(test* "(hoge) is not tagged fuga" #f (tagged-list? '(hoge) 'fuga))
(test* "(hoge) is tagged hoge (read-from-string)" #t (tagged-list? (read-from-string "(hoge)") 'hoge))

(test* "'(hoge) is tagged hoge" #f (tagged-list? (read-from-string "'(hoge)") 'hoge))
(test* "'(hoge) is tagged quoted" #t (tagged-list? (read-from-string "'(hoge)") 'quote))

(test-section "frame")

(define f (make-frame '(a) '(1)))

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

(test-section "env")

(define e1 (extend-envrironment '(a b) '(1 2) the-empty-environment))

(test* "first-frame (vars)"
       '(a b)
       (frame-variables (first-frame e1)))

(test* "first-frame (vals)"
       '(1 2)
       (frame-values (first-frame e1)))

(test* "lookup a" 1 (lookup-variable-value 'a e1))
(test* "lookup b" 2 (lookup-variable-value 'b e1))

(add-binding-to-frame! 'b 3 (first-frame e1))

(test* "add-binding-to-frame! b -> 3 (vars)"
       '(b a b)
       (frame-variables (first-frame e1)))

(test* "add-binding-to-frame! b -> 3 (vals)"
       '(3 1 2)
       (frame-values (first-frame e1)))

(test* "lookup a" 1 (lookup-variable-value 'a e1))
(test* "lookup b" 3 (lookup-variable-value 'b e1))

(test-end)
