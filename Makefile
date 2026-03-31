# Variables
PANDOC = pandoc
PDF_ENGINE = xelatex
FONT_SIZE = 11pt
HEADER = config/header.tex
SIMPLE_HEADER = config/header-simple.tex
LINK_FILTER = config/custom-links.lua

# Source and output files
BUILD_FOLDER = build

# Formal documents (numbered sections, TOC, line numbering)
FORMAL_DOCS = statutes rules-of-procedure internal-regulations manifesto code-of-conduct

# Simple documents (no numbered sections, no TOC, no line numbering)
SIMPLE_DOCS = minutes

# Default target
all: $(foreach doc,$(FORMAL_DOCS),$(BUILD_FOLDER)/$(doc).pdf) $(foreach doc,$(SIMPLE_DOCS),$(BUILD_FOLDER)/$(doc).pdf)

# Ensure the build folder exists
$(BUILD_FOLDER):
	mkdir -p $(BUILD_FOLDER)

# Common pandoc options
PANDOC_COMMON = --pdf-engine=$(PDF_ENGINE) -V fontsize=$(FONT_SIZE) --lua-filter=$(LINK_FILTER)

# Rule for formal documents (numbered sections, TOC, line numbering)
define FORMAL_RULE
$(BUILD_FOLDER)/$(1).pdf: $(1).md $(HEADER) $(LINK_FILTER) | $(BUILD_FOLDER)
	$(PANDOC) $(1).md -o $(BUILD_FOLDER)/$(1).pdf $(PANDOC_COMMON) --number-sections -H $(HEADER)
endef

$(foreach doc,$(FORMAL_DOCS),$(eval $(call FORMAL_RULE,$(doc))))

# Rule for simple documents (no numbered sections, no TOC, no line numbering)
# Set the title from the filename (e.g. minutes -> IFLRY Minutes)
define SIMPLE_RULE
$(BUILD_FOLDER)/$(1).pdf: $(1).md $(SIMPLE_HEADER) $(LINK_FILTER) | $(BUILD_FOLDER)
	$(PANDOC) $(1).md -o $(BUILD_FOLDER)/$(1).pdf $(PANDOC_COMMON) -H $(SIMPLE_HEADER) -M title="$(2)"
endef

$(eval $(call SIMPLE_RULE,minutes,IFLRY Guide to Taking Minutes))

# Clean target
clean:
	rm -rf $(BUILD_FOLDER)

# Phony targets
.PHONY: all clean
