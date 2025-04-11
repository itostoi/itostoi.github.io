SRC_DIR=src
BUILD_DIR=dist
MDS=$(wildcard $(SRC_DIR)/*.md)
HTMLS=$(patsubst $(SRC_DIR)%,$(BUILD_DIR)%, $(patsubst %.md,%.html, $(MDS)))
WORK_DIR=work
# STYLE= TODO: add stylesheet support

.PHONY : all

all : nav $(HTMLS)
	
nav: 
 	# Generate the nav markdown file and put it in WORK_DIR:
 	# TODO: add template support for fancier navs.
	# echo "$(HTMLS)" | sed -e "s/[^ ]* */prefix-&\n/g"
	nav_md="${WORK_DIR}/nav.md"; \
	echo "## Nav" > $$nav_md; \
	idx=1; \
 	for file in $(HTMLS); do \
		echo "$${idx}) [$$(basename $${file} .html)]($$(basename $${file}))" >> $$nav_md; \
		((idx+=1)); \
 	done; \
 	pandoc $$nav_md --from markdown --to html -o "${WORK_DIR}/nav.html"; \

$(BUILD_DIR)/%.html: $(SRC_DIR)/%.md init
	# $< is the first prereq, which is our md file.
	# $@ is the name of the target, our html file.
	echo $@; \
 	pandoc \
 		--from markdown  --to html \
 		--include-before-body "${WORK_DIR}/nav.html" \
 	 	--standalone \
 	 	-s $< -o $@; \

init:
	mkdir -p $(BUILD_DIR); \
	mkdir -p $(WORK_DIR); \
	
clean:
	rm -rf $(BUILD_DIR)/* \
	rm -rf $(WORK_DIR)/* \
