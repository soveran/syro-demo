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
project.
