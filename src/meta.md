# Meta
Uses [Pandoc](https://pandoc.org/chunkedhtml-demo/8.14-raw-html.html) +
[GNU make](https://www.gnu.org/software/make/) to build markdown into a static
site. Very [Eggert](https://samueli.ucla.edu/people/paul-eggert/)!

## Notes 
More detailed notes in case I need to add features in the far future.

The templating is based on a pretty slick bit of code (metaprogramming?) by the
creator of Pandoc John MacFarlane himself! It works by creating a target html
for each markdown file in the `SRC_DIR` directory. 
These are collected in `MDS` and `HTMLS`, respectively.
`make all` can then build all of them, instead of needing a recipe to loop
over everything.
The original stackoverflow thread can be found
[here](https://stackoverflow.com/questions/11023543/recursive-directory-parsing-with-pandoc-on-mac).

Details of how the substitution works can be
found in the
[GNU make docs](https://www.gnu.org/software/make/manual/html_node/Text-Functions.html).
```sh
SRC_DIR=src
BUILD_DIR=docs
MDS=$(wildcard $(SRC_DIR)/*.md)
HTMLS=$(patsubst $(SRC_DIR)%,$(BUILD_DIR)%, $(patsubst %.md,%.html, $(MDS)))
WORK_DIR=work
STYLE=resources/style.css

.PHONY : all

all : nav $(HTMLS) resources
```

Next, `nav` collects every markdown file, and formats them into a markdown file
which is turned into an html file, and included as a header on top of each page.

Not very flexible - I should eventually implement a templating system that
doesn't just use `echo`, and figure out a common header system, either in
pandoc or otherwise.

```sh
nav: 
 	# Generate the nav markdown file and put it in WORK_DIR:
 	# TODO: add template support for fancier navs.
	# echo "$(HTMLS)" | sed -e "s/[^ ]* */prefix-&\n/g"
	nav_md="${WORK_DIR}/nav.md"; \
	echo "" > $$nav_md; \
	idx=1; \
	echo "[**itostoi.github.io**]{.navtitle}" >> $$nav_md;\
 	for file in $(HTMLS); do \
		# echo "$${idx}) [$$(basename $${file} .html)]($$(basename $${file}))" >> $$nav_md; \
		echo "[$$(basename $${file} .html)]($$(basename $${file})){.navitem}" >> $$nav_md; \
		((idx+=1)); \
 	done; \
 	pandoc $$nav_md \
 		--from markdown --to html \
 		-o "${WORK_DIR}/nav.html"; \
```

The meat and potatoes is this singular pandoc command. Using 
[automatic variables](https://www.gnu.org/software/make/manual/html_node/Automatic-Variables.html)
, it calls pandoc on `$<`, our md file, and `$@`, our target file. We're able
to "pass" this info in as the target and prereq, so it works on each member
of our `MDS` variable which was collected with `wildcard`.

Pandoc flags:

* `standalone`: includes headers and footers (default is a HTML fragment).
* `css`: adds in our css.
* `document-css`: tells Pandoc to include default css.
* `include-before-body`: inserts a file before body (nav).
* `-s`, `-o`: source, output
```sh
$(BUILD_DIR)/%.html: $(SRC_DIR)/%.md init
	# $< is the first prereq, which is our md file.
	# $@ is the name of the target, our html file.
	echo $@; \
 	pandoc \
		--css=$(STYLE) \
		-M document-css=true \
 		--from markdown  --to html \
 		--include-before-body "${WORK_DIR}/nav.html" \
 	 	--standalone \
 	 	-s $< -o $@; \
```

A few utility functions.
```
init:
	mkdir -p $(BUILD_DIR); \
	mkdir -p $(WORK_DIR); \
	
clean:
	rm -rf $(BUILD_DIR)/* \
	rm -rf $(WORK_DIR)/* \

resources:
	# Copy resources from dev to deployment
	cp -rf $(SRC_DIR)/resources $(BUILD_DIR)
```
