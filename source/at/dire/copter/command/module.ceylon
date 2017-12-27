"Implement executable commands with command line options.

 Using this module you can create executable commands in a fast and simple way while also handling parsing errors, help output, etc. You
 can also combine multiple command to create Git-style command-line applications.

 # Creating Commands
 Every application contains one or more [[commands|Command]]. We can easily add command line option and operands by using the annotation found in
 `at.dire.copter.parse.core`. These control how to call the application and which options and operands are required. Check that module's documentation
 for details.

 Here's a very basic example command:
 ~~~
 \"Command documentation.\"
 class TestCommand(
 	\"Target directory.\"
 	option(\"t\", \"target-directory\")
 	shared Path targetDir,
 	\"List of files to process.\"
 	operand(0)
 	shared [String+] files,
 	\"Verbose output.\"
 	flag(\"v\", \"verbose\")
 	shared Boolean verbose = false
 ) satisfies Command {
 	shared actual Integer run() {
 		// Do something with your arguments here.

 		// Return an exit code of your choosing. Typcially 0 if successful.
 		return 0;
 	}
 }
 ~~~

 This will result in a command with the options `-t` (or `--target-directory`) and `-v` (or `--verbose`) as well as a list of files to process (operands). The target-directory and at
 least one file have to be specified.

 ## Special Options
 You may also want to add options to your application that aren't directly related to your command itself but perform
 related functionality (e.g. `--help` but also Git's `--html-path`, etc.).

 You can do this by creating another [[Command]] and then adding an [[specialOption|at.dire.copter.command.annotations::specialOption]] annotation to your command class:
 ~~~
 \"Command documentation.\"
 specialOption(\"special\", \`class SpecialOptionCommand\`)
 class TestCommand(
 ...
 ~~~

 This results in the `SpecialOptionCommand` being [[run|Command.run]] when `--special` is provided on the command line. Note that
 you do not need to implement or add `--help` and `--version` yourself, we'll get to those eventually.

 # Applications
 ## Basic Applications
 Use this approach to invoke a command (and special options, if any). You can use [[runCommand]] to make this very easy:

 ~~~
 shared void run() {
    value result = runCommand(\`TestCommand\`);
    process.exit(result);
 }
 ~~~

 This will interpret the command line and run your command. We then exit the application with the given exit code. This will also execute a special option if needed.
 Note that both `--help` and `--version` are added by default.

 The application will return exit code 1 when encountering an exception and 2 if the command line arguments couldn't be parsed.

 ## Multi-Command Applications
 You build Git-style applications by definining multiple commands, each annotated with [[command|at.dire.copter.command.annotations::command]] and the name we call this command by:
 ~~~
 \"Command documentation.\"
 command(\"test\")
 class TestCommand(
 ...
 ~~~

 You can then use [[runCommands]], which will lookup all annotated commands and have the user select any one of them:
 ~~~
 shared void run() {
    value result = runCommands(\`module\`);
    process.exit(result);
 }
 ~~~

 Note that you'll also get matching `--help` and `--version` implementations by default.

 ### Global Options
 In addition to options per command and special-options, you can also add global options to your application that are available to
 all commands. You can combine commands with and without global options, but you must only use one single global option type.

 To use this approach, we first have to create a global option class. You can use the same annotations used
 for commands here:
 ~~~
 specialOption(\"special\", \`class SpecialOptionCommand\`)
 class GlobalOptions(
 	flag(\"v\", \"verbose\")
 	shared Boolean verbose = false
 ) {}
 ~~~

 Next we create a command with the options as argument, annotated with [[globalOptions|at.dire.copter.command.annotations::globalOptions]]:
 ~~~
 \"Command documentation.\"
 class TestCommand2(
 	\"Global options.\"
 	globalOptions
 	GlobalOptions globalOptions,
 	\"Verbose output.\"
 	option(\"n\", \"name\")
 	String name
 ) satisfies Command {
 	shared actual Integer run() {
 		// Do something with your arguments here.
 		print(globalOptions.verbose);

 		// Return an exit code of your choosing. Typcially 0 if successful.
 		return 0;
 	}
 }
 ~~~

 You can then run your application using [[runCommandsWithGlobalOptions]].

 # Customizing Documentation
 The documentation code uses the [[doc]] annotations on various elements to create the
 documentation. You can apply a [[commandDoc|at.dire.copter.command.annotations::commandDoc]]
 instead to use another (shorter) documentation.

 You can also annotate your module with annotations that influence help:
 * [[label|at.dire.copter.command.annotations::label]] ... to use another title for your application.
 * [[copyright|at.dire.copter.command.annotations::copyright]] ... to add copyright information.
 * [[license|license]] ... to add licensing information.
 * [[parentModule|at.dire.copter.command.annotations::parentModule]] ... to make this a sub-module of a larger application.

 ## Executable Name
 The help output also includes the application's executable name. This defaults to the module's
 name or [[label|at.dire.copter.command.annotations::label]].

 You can customize the executable name by providing the `copter.application.executable` property to the virtual machine
 (i.e. `-Dcopter.application.executable=mycom` for Java)."
module at.dire.copter.command "1.0.0" {
	shared import at.dire.copter.parse.core "1.0.0";
	import ceylon.logging "1.3.3";
	import ceylon.collection "1.3.3";
}
