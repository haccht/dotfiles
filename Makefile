all: init package setup repo


init:
	@./shell/init.sh

package:
	@./shell/packages.sh

setup:
	@./shell/setup.sh

repo:
	@./shell/repo.sh
