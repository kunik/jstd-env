Jstd-env is a helper script that should help writing and running tests as much quickly and easy as possible.
It creates .jstd dir with jsTestDriver, it's config and other cool stuff inside your working copy and
allows you to run tests with single "run" command.

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

Not ready yet :)
