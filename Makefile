# Makefile for Christmas Murder Dinner 1926 Project
# For automation of common tasks

.PHONY: help ingest clean

# Default target - show available commands
help:
	@echo "🎭 Christmas Murder Dinner 1926 - Makefile Commands"
	@echo ""
	@echo "Available commands:"
	@echo "  make ingest    - Create a digest of the repository for LLMs"
	@echo "  make clean     - Remove generated digest files"
	@echo "  make help      - Show this help message"
	@echo ""
	@echo "📝 Note: 'make ingest' requires gitingest to be installed"
	@echo "   Install with: pip install gitingest"

# Generate repository digest using gitingest
ingest:
	@echo "🔍 Creating repository digest..."
	@if ! command -v gitingest &> /dev/null; then \
		echo "❌ Error: gitingest is not installed"; \
		echo "   Install with: pip install gitingest"; \
		exit 1; \
	fi
	gitingest . --output digest.txt
	@echo "✅ Digest created: digest.txt"
	@echo "📊 You can now share this file with LLMs!"

# Clean up generated files
clean:
	@echo "🧹 Cleaning up digest files..."
	@rm -f digest.txt
	@echo "✅ Clean complete!"
