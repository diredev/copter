import at.dire.copter.read {
	OptionReader,
	OptionReaderFactory
}

"Abstract base for [[applications|Application]].

 This implementation handles [[parsing|parseFailureExitStatus]] and [[execution|exceptionExitStatus]] errors via logging and will return a matching exit code."
shared abstract class AbstractApplication("Formatter for help output." shared OptionReaderFactory optionFormatter) satisfies Application {
	"The default exit status to use when an exception is encountered during execution."
	shared default Integer exceptionExitStatus => 1;

	"The default exit status used when parsing the command line has failed."
	shared default Integer parseFailureExitStatus => 2;

	shared actual Integer run({String*} arguments) {
		try {
			value result = runImpl(optionFormatter.createReader(arguments));

			if (is ParseException result) {
				print(result.message);

				// If there is a help command, print an additional info here.
				if(this.specialOptions.any((subCommand) => subCommand.key == "help")) {
					//TODO: For Multi-Command application, we should print `use "executableName command --help"` instead...
					print("Use \"``this.getInfo().executableName`` ``optionFormatter.formatOption("help", false)``\" to get further information.");
				}

				return parseFailureExitStatus;
			}

			return result;
		} catch (Exception e) {
			process.writeErrorLine(e.message);
			log.error("Unhandled exception during command execution.", e);
			return exceptionExitStatus;
		}
	}

	"Implement the logic behind your command here. Return either an Exit Status or a [[ParseException]].

	 Return [[ParseException]] to handle invalid command line arguments. This will result in [[AbstractApplication.parseFailureExitStatus]] being returned."
	shared formal Integer|ParseException runImpl(OptionReader reader);
}
