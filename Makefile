help:
	@echo "usage: make [command]"

download_python_environment_manager:
	@if test ! -d ".tmp/python-environment-manager-master";then \
		sudo rm -rf maintenance; \
		sudo su -m $(SUDO_USER) -c "mkdir -p .tmp"; \
		sudo su -m $(SUDO_USER) -c "cd .tmp; wget https://github.com/terminal-labs/python-environment-manager/archive/master.zip"; \
		sudo su -m $(SUDO_USER) -c "cd .tmp; unzip -qq master.zip"; \
		sudo cp .tmp/python-environment-manager-master/dpe/create.sh create.sh; \
		sudo chown $(SUDO_USER) create.sh; \
	fi

rambobox: download_python_environment_manager
	@sudo bash create.sh $(SUDO_USER)
