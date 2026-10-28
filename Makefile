.PHONY: all min init package setup repo

all: init package setup repo
min: init setup

init:
	@./setup.sh init

package:
	@./setup.sh packages

setup:
	@./setup.sh tools

repo:
	@./setup.sh repo
