all: install

install:

	cp ./bin/cwput.bash /usr/bin
	cp ./etc/cwput.conf /etc/init
	mkdir /etc/cwput
	cp -r ./etc/checks /etc/cwput
	start cwput

uninstall:

	stop cwput
	rm -r /etc/cwput
	rm /etc/init/cwput.conf

.PHONY: install uninstall
