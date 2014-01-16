all: install

install:

	mkdir -p /etc/cwput/checks
	cp ./bin/cwput.bash /usr/bin
	cp ./etc/cwput.conf /etc/init
	start cwput

.PHONY: install
