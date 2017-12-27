import at.dire.copter.command {
	Command,
	SubCommand,
	getSpecialOptions,
	contextInjectName
}
import at.dire.copter.command.annotations {
	globalOptionsInjectName
}
import at.dire.copter.parse.core {
	OptionParser
}
import at.dire.copter.parse.core.annotations {
	getMappedOptionsFromAnnotations
}
import at.dire.copter.parse.core.inject {
	MapPropertySource,
	InjectingBuilderFactory
}
import at.dire.copter.parse.core.parsers {
	ValueParserProvider
}
import at.dire.copter.read {
	emptyOptionReader,
	OptionReader
}

import ceylon.language.meta.model {
	Class
}

"Used to parse and execute [[sub-commands|SubCommand]] and special-options.

 This handles sub-options of the commands as well."
shared class Runner<in GlobalOptions=Null>(ValueParserProvider valueParserProvider) {
	"Read the command line and run the given command. Return an exit code if successful."
	shared default Integer|ParseException run(
		"Command to run."
		Class<Command> commandType,
		"Global options or null."
		GlobalOptions? globalOptions,
		"To read options from."
		OptionReader reader,
		"Context for execution."
		CommandContextImpl commandContext,
		"List of special options to handle."
		SubCommand[] specialOptions) {
		value specialOptionMap = getSpecialOptions(commandType.declaration, specialOptions);
		value mappedOptions = getMappedOptionsFromAnnotations(commandType, valueParserProvider, specialOptionMap);

		// Inject the commandContext and globalOptions.
		value properties = MapPropertySource(map { contextInjectName->commandContext, globalOptionsInjectName->globalOptions });
		value serializer = OptionParser(mappedOptions, InjectingBuilderFactory(properties));

		// Update the Context for the new command.
		commandContext.push(mappedOptions);

		// Interpret the command line
		value command = serializer.parse(reader);

		// Failed to read?
		if (is ParseException command) {
			return command;
		}

		// If a Class<Command> was returned, we are dealing with a special option here.
		if (is Class<Command> command) {
			return run(command, globalOptions, emptyOptionReader, commandContext, []);
		} else {
			try {
				// Otherwise we run the command.
				return command.run();
				//return command.exitCode;
			} finally {
				// Allow commands to be Destroyable.
				if (is Destroyable destroyableCommand = command) {
					destroyableCommand.destroy(null);
				}
			}
		}
	}
}
