# Copter
A fully-featured command-line argument parser for Ceylon.

## Features
Copter consists of a number of modules that allow for different use cases. Check each module's documentation for details and code examples.

### Reading Command Line Arguments
The classes in the module `at.dire.copter.read` provide simple means to read command line arguments while hiding the rules required by the reader implementation. 

The default reader implementation allows reading options as they would be provided to Gnu getopt (short and long options, groups of options, values with or without `=`, the `--` operator, etc.). There is also a simpler implementation matching the argument code of Java or some Windows commands.

You can then use the classes of the package `at.dire.copter.read.collect` to read all options into a map-like structure. This will also limit the user to entering
predefined options only.

### Parsing Objects
The module `at.dire.copter.parse.core` takes the arguments provided on the command line and turns them into objects. The options available and other
necessary information (if required, default values, etc.) are inferred from the Ceylon metamodel and/or through the use of annotations. Objects are created
using constructor calls, making option classes look and behave like proper Ceylon types.

Parsers are provided for most of the basic Ceylon types, including sequences, union types and case values (aka enums). You can easily add your own parser through the service API. You may also want to add the modules `at.dire.copter.parse.io` and `at.dire.copter.parse.file` to the classpath to add support for the Ceylon IO and File modules. This makes working with files easier and allows parsing the special option `-` (standard input).

### Command Framework
The module `at.dire.copter.command` uses the other modules to implement a simple Command Framework built around command line arguments. You can create
an application by implementing a single command/option class and adding just a few lines of startup code to your module. 

This also provides error handling, help output and documentation for your application, including the common options `--help` and `--version`. All of this is
generated from metadata and annotations, no code required.

### Git-style Applications
`at.dire.copter.command` can also collect multiple commands into a Git-style application (i.e. the command`s name as first argument).
This too comes with it's own error handling and help-output.

## Building
All modules are simple CAR modules, no additional tools required. There are also no external dependencies aside from Ceylon itself.

Note that, with the exception of the Java-specific IO and File modules, it should be possible to compile Copter to be run on JavaScript. This was
not tested however.

## Comparable Libraries
#### Native Ceylon
  Ceylon provides command-line arguments through `process.arguments`, `process.namedArgumentPresent()` and `process.namedArgumentValue()`. It uses a mixed
  approach 

#### [Snopts](https://github.com/lucaswerkmeister/snopts)
  Reading of command-line arguments ala Gnu getopt. This is similar to what `at.dire.copter.read.collect` does.
  
#### Java
  There is an enormous amount of argument parsers in the Java world you could probably use in Ceylon. Those that do value parsing (like Copter does)
   will likely have trouble with native Ceylon types though.

## How to contribute
Please feel free to report issues and suggest or share improvement. Criticism is also welcome.
