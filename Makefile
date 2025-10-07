# Makefile for Christmas Murder Dinner 1926 Project
# For automation of common tasks

.PHONY: help ingest clean pdf pdf-helena pdf-all-chars check-pandoc

# Default target - show available commands
help:
	@echo "🎭 Christmas Murder Dinner 1926 - Makefile Commands"
	@echo ""
	@echo "Available commands:"
	@echo "  make ingest         - Create a digest of the repository for LLMs"
	@echo "  make pdf-helena     - Convert Helena dossier to PDF"
	@echo "  make pdf-all-chars  - Convert all character notes to PDFs"
	@echo "  make pdf            - Convert all Markdown docs to PDFs"
	@echo "  make clean          - Remove generated files (digests & PDFs)"
	@echo "  make help           - Show this help message"
	@echo ""
	@echo "📝 Requirements:"
	@echo "  - gitingest: pip install gitingest"
	@echo "  - pandoc: apt install pandoc (or brew install pandoc on macOS)"
	@echo "  - texlive-xetex: apt install texlive-xetex (for PDF generation)"

# Generate repository digest using gitingest
ingest:
	@echo "🔍 Creating repository digest..."
	@if command -v gitingest &> /dev/null; then \
		gitingest . --output digest.txt; \
	elif [ -f ~/.local/bin/gitingest ]; then \
		~/.local/bin/gitingest . --output digest.txt; \
	else \
		echo "❌ Error: gitingest is not installed"; \
		echo "   Install with: pip install gitingest"; \
		exit 1; \
	fi
	@echo "✅ Digest created: digest.txt"
	@echo "📊 You can now share this file with LLMs!"

# Check if Pandoc is installed
check-pandoc:
	@command -v pandoc > /dev/null 2>&1 || { \
		echo "❌ Error: pandoc is not installed"; \
		echo "   Install with:"; \
		echo "   - Ubuntu/Debian: sudo apt install pandoc texlive-xetex"; \
		echo "   - macOS: brew install pandoc basictex"; \
		exit 1; \
	}

# Convert Helena Complete Dossier to PDF
pdf-helena: check-pandoc
	@echo "📄 Converting Helena Complete Dossier to PDF..."
	@pandoc 04_GAME_MASTER_MATERIALS/helena_master_script/HELENA_COMPLETE_DOSSIER.md \
		-o 04_GAME_MASTER_MATERIALS/helena_master_script/HELENA_COMPLETE_DOSSIER.pdf \
		--pdf-engine=xelatex \
		-V geometry:margin=1in \
		-V fontsize=10pt \
		--toc \
		--toc-depth=2 \
		-V colorlinks=true \
		-V linkcolor=blue \
		-V urlcolor=blue \
		-V toccolor=black
	@echo "✅ PDF created: 04_GAME_MASTER_MATERIALS/helena_master_script/HELENA_COMPLETE_DOSSIER.pdf"

# Convert all character notes to PDFs
pdf-all-chars: check-pandoc
	@echo "📚 Converting all character notes to PDFs..."
	@for dir in 02_CHARACTERS/*/; do \
		if [ -f "$$dir/notes.md" ] && [ -s "$$dir/notes.md" ]; then \
			basename=$$(basename "$$dir"); \
			echo "  → Converting $$basename..."; \
			pandoc "$$dir/notes.md" \
				-o "$$dir/notes.pdf" \
				--pdf-engine=xelatex \
				-V geometry:margin=1in \
				-V fontsize=11pt \
				-V colorlinks=true; \
		fi \
	done
	@echo "✅ All character PDFs created!"

# Convert all major Markdown documents to PDFs
pdf: pdf-helena pdf-all-chars
	@echo "📖 Converting additional documents..."
	@if [ -f "00_PROJECT_DOCS/CHARACTER_ANALYSIS_COMPLETE.md" ]; then \
		pandoc 00_PROJECT_DOCS/CHARACTER_ANALYSIS_COMPLETE.md \
			-o 00_PROJECT_DOCS/CHARACTER_ANALYSIS_COMPLETE.pdf \
			--pdf-engine=xelatex \
			-V geometry:margin=1in; \
		echo "  ✅ CHARACTER_ANALYSIS_COMPLETE.pdf"; \
	fi
	@echo "🎉 All PDFs generated successfully!"

# Clean up generated files
clean:
	@echo "🧹 Cleaning up generated files..."
	@rm -f digest.txt
	@find . -name "*.pdf" -type f -not -path "*/node_modules/*" -delete
	@echo "✅ Clean complete! (removed digest.txt and all PDFs)"
