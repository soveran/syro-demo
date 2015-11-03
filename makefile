GS=./bin/gs
DEP=./bin/dep

.PHONY: test

default: help

test:
	@$(GS) cutest -r ./test/helper.rb ./test/*.rb

server:
	@$(GS) shotgun -o 0.0.0.0

console:
	@$(GS) irb -r ./app

gems:
	@$(GS) gem list

check: .gs .env
	@$(GS) $(DEP)

install: .gs .env
	@$(GS) $(DEP) install

.gs:
	@mkdir -p .gs

.env:
	@cp env.example .env

help:
	@less ./doc/help
