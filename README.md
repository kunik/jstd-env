Jstd-env is a helper script that should help writing and running tests as much quickly and easy as possible.
It creates .jstd dir with jsTestDriver, it's config and other cool stuff inside your working copy and
allows you to run tests with single `run` command.

Usage
=====
    jstd help            prints the current message

    jstd create          creates .jstd dir with virtual environment for you and enters it
    jstd enter           enters current virtual environment

    jstd start [<port>]  starts jsTestDriver server on specified port. If port is not specified it tryes to get
                       it from config or uses default one (Uses 9878 in current env)
    jstd stop            stops running jsTestDriver server
    jstd restart         restarts running jsTestDriver server
    jstd status          returns information if jsTestDriver server is running


Quick start
===========

1.  Install jstd-env
2.  Goto your project folder and run

        jstd start

    By default it will start on port 9878 but you can specify any port you want.
3.  Run the tests

        run

Creating the env
================
What means 'create the env'?
For creating environment for you jstd-env will create a folder .jstd in your project folder.
It will create symbolic link to the system wide JsTestDriver.jar and create local configuration files.

Configuration
=============
In your .jstd folder there are three config files:

*  config.yaml contains configuration for JsTestDriver. For more information on it visit [JsTestDriver page](http://code.google.com/p/js-test-driver/wiki/ConfigurationFile "ConfigurationFile - js-test-driver")
*  local_config.sh this file contains options for runner. By default it has global option values set and commented out
*  port.sh this file is re-generated after each server start and it contains port that was used last time

Installation
============
The shortest way is

    sudo curl https://github.com/kunik/jstd-env/raw/master/install.sh | sh

But the **recommended** way is to install script under your home directory:

    export _SBIN_DIR="$HOME/sbin"
    export _BIN_DIR="$HOME/bin"
    curl https://github.com/kunik/jstd-env/raw/master/install.sh | sh

By running first two commands you sets global variables `_SBIN_DIR` and `_BIN_DIR` in your environment. If they are set before
running the installation script it will try to install needed files to directories they represent.

Of course both of directories should exist and be writable. Also, `_BIN_DIR` should be in your `PATH` variable.

FAQ
===

Why the `_BIN_DIR` should be in `PATH` variable?

> PATH variable is a bit magic: it consists of a series of colon-separated absolute paths that are stored in plain text
> files. Whenever a user types in a command at the command line that is not built into the shell or that does not include
> its absolute path and then presses the Enter key, the shell searches through those directories, which constitute
> the user's search path, until it finds an executable file with that name.

How to add directory to my `PATH`?

> In your home directory there should be file with name .profile. This file is executed by your shell every time you log in.
> You need to add something like this in the end of this file:
>
>     # set PATH so it includes user's private bin if it exists
>     if [ -d "$HOME/bin" ] ; then
>         PATH="$HOME/bin:$PATH"
>     fi

What if .profile does not exist in my home?

> If it does not exist in your home directory, you can create it. Yor command interpreter will find it next time you log in.

How to enter my home directory?

>     cd ~

