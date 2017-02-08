# Infinity Engine Incredible Editor (IEIE) Core

Application is under heavy development. It is not usable yet.

## About

IEIE is a solution to create and edit files for Infinity Engine (IE).
For now there is only one reasonable application to do that: Near Infinity. 
I decided to create my own tool.

IEIE is based on gibberlings3 informations about file formats: [check it out](http://gibberlings3.net/iesdp/file_formats/index.htm), with my adjustments (some offsets/sizes just don't match expected results).

## How it works?

IEIE Core works as webserver. It communicates over API (requests are made over GET), and responds with JSON answers.

## Requirements

* Ruby, >= 2.3.0

