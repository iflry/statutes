# Variables
PANDOC = pandoc
PDF_ENGINE = xelatex
FONT_SIZE = 11pt
HEADER = config/header.tex
LINK_FILTER = config/custom-links.lua

# Source and output files
BUILD_FOLDER = build

# Formal documents (numbered sections, TOC, line numbering)
FORMAL_DOCS = statutes statuts rules-of-procedure internal-regulations manifesto code-of-conduct

# Default target
all: $(foreach doc,$(FORMAL_DOCS),$(BUILD_FOLDER)/$(doc).pdf)

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

# Clean target
clean:
	rm -rf $(BUILD_FOLDER)

# Phony targets
.PHONY: all clean
