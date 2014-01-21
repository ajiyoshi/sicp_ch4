
all: test

test:
	gosh -I . t/test_*.scm
