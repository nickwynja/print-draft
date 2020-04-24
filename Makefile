install:
	mkdir -p ~/.config/print-draft/
	ln -fs $(shell pwd)/template-draft.tex ~/.config/print-draft/
	ln -fs $(shell pwd)/pd /usr/local/bin/pd

uninstall:
	rm -f ~/.config/print-draft/template-draft.tex
	rm -f /usr/local/bin/pd
