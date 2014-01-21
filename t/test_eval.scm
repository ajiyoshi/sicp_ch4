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

(test-section "assignment")

(test-end)
