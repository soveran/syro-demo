Syro Demo
=========

This is a demo application that showcases some very basic functionality
like rendering templates, sending emails, and managing user accounts.

Getting started
---------------

I recommend having this command that runs make with a custom set
of environment variables. I put it in `~/bin/mk`, and I use it
instead of running `make` directly.

```
#!/bin/sh

if [ -f .env ]; then
	env `cat .env` \
	make $*
else
	make $*
fi
```

Once you have the `mk` command, run `mk` or `mk help` to setup the
project. For your convenience, the `mk` command is installed inside
`./bin`, so you can just run `./bin/mk` and it will work.

Directory layout
----------------

```
.env      # Environment variables
.gems     # Dependencies
LICENSE   # Full text of the project's license
README.md # Information about the project
app.rb    # Top level Syro application
bin/      # Executable files
config.ru # Rack's entry point, it loads ./app.rb
decks/    # Custom decks
doc/      # Documentation
filters/  # Validation filters
lib/      # Libraries
mails/    # Templates for emails
makefile  # make server; make console; make tests
models/   # Models
public/   # Static files
routes/   # Syro apps that will be mounted
services/ # Service objects
test/     # Test files
views/    # Templates for views
```

More information
----------------

To learn more about Syro, visit the [website][syro] and check the
[tutorial][tutorial].

[syro]: http://soveran.github.io/syro/
[tutorial]: http://files.soveran.com/syro/
