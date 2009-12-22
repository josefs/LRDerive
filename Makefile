Notes.pdf: Notes.tex
	pdflatex Notes.tex

Notes.tex: Notes.md header
	pandoc -s Notes.md -o Notes.tex -C header
