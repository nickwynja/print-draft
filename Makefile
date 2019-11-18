install:
	mkdir -p ~/.pandoc/templates
	ln -fs $(shell pwd)/template-draft.tex ~/.pandoc/templates
	ln -fs $(shell pwd)/pd /usr/local/bin/pd

uninstall:
	rm -f ~/.pandoc/templates/template-draft.tex
	rm -f /usr/local/bin/pd
