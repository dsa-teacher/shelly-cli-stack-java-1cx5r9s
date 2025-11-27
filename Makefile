.PHONY: install-cli install-cli-remote

install-cli:
	@echo "Installing DSA CLI from remote repository..."
	@bash ./scripts/install-cli.sh

install-cli-remote: install-cli
