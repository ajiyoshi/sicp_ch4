
all: test

test:
	gosh -I . t/test_*.scm
	gosh -I . t/test_order.scm
