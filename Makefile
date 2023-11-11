all: init package setup repo
min: init setup

init:
	@./shell/init.sh

package:
	@./shell/packages.sh

setup:
	@./shell/setup.sh

repo:
	@./shell/repo.sh
