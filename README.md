# Infinity Engine Incredible Editor Core

Application is under heavy development. It is not usable yet. Well, **IEIE Core** *is* usable, but the whole app isn't.

In fact, what **IEIE Core** lacks for now is: more file tables, reverse conversion (in other words: saving data) of some already supported (in terms of reading) files. But it has very solid base for creating new content, so bright future here, if project won't die until then.

The core itself is in "lib" directory. The rest is API Rails server.

## About

**IEIE Core** is a solution to create and edit files for Infinity Engine (IE).
For now there is only one reasonable application to do that: Near Infinity. 
I decided to create my own tool, which - in example - is more flexible to use with other applications (see **IEIE Interface**).

**IEIE Core** is based on gibberlings3 informations about file formats: [check it out](http://gibberlings3.net/iesdp/file_formats/index.htm).

It seems, that it is faster than Near Infinity in many terms.

## How it works?

IEIE Core works as webserver. It communicates over API (requests are made over HTTP), and responds with JSON answers.

It may be used with **IEIE Interface** application, however is not limited to. The only requirement is proper API.

## Requirements

* Ruby, >= 2.3.0

