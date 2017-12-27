import at.dire.copter.parse.core.parsers {
	ValueParserProvider
}
import at.dire.copter.read {
	gnuOptions,
	OptionReaderFactory
}

import ceylon.language.meta.model {
	Class
}

"Convenience method for executing a single [[Command]].

 Parses the command line and executes the command or any of the given special options. Will also handle
 invalid arguments and exceptions by returning a proper exit code."
see(`class BasicApplication`)
shared Integer runCommand(
	"The type of the command to execute."
	Class<Command> commandType,
	"List of additional special options to handle. The default includes *--help* and *--version*."
	SubCommand[] specialOptions = defaultSpecialOptions,
	"The command-line arguments to read."
	{String*} arguments = process.arguments,
	"Provide information on your application. The default will read the annotations on the module."
	ApplicationInfo() appInfoProvider = (() => createAppInfoFromModule(commandType.declaration.containingModule)),
	"Used to format command line options and create readers."
	OptionReaderFactory optionFormatter = gnuOptions) {

	value valueParserProvider = ValueParserProvider({ commandType.declaration.containingModule });
	value application = BasicApplication(commandType, specialOptions, appInfoProvider, optionFormatter, valueParserProvider);
	return application.run(arguments);
}
