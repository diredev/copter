import at.dire.copter.command.impl {
	MainCommandOptions,
	Runner,
	ReadToOperandReader,
	CommandContextImpl
}
import at.dire.copter.parse.core {
	OptionParser
}
import at.dire.copter.parse.core.annotations {
	getMappedOptionsFromAnnotations
}
import at.dire.copter.parse.core.parsers {
	ValueParserProvider
}
import at.dire.copter.read {
	gnuOptions,
	OptionReader,
	emptyOptionReader,
	OptionReaderFactory
}

import ceylon.language.meta.model {
	Class
}

"Default special options for [[*git*-style applications|MultiCommandApplication]].

 This provides implementations for both *--help* and *--version*. The difference between this and
 [[defaultSpecialOptions]] is the behavior of the *--help* command."
shared SubCommand[] defaultMultCommandSpecialOptions = ["help" -> `MultiCommandHelpCommand`, "version" -> `VersionCommand`];

"Default special options for the [[sub-commands|SubCommand]] of [[*git*-style applications|MultiCommandApplication]].
 Provides *--help* only."
shared SubCommand[] defaultMultiSubCommandSpecialOptions = ["help" -> `HelpCommand`];

"A *git*-style application.

 This executes one command given by name out of a list of [[sub-commands|MultiCommandApplication.commands]]."
shared class DefaultMultiCommandApplication<in GlobalOptions>(
	"The type of the global options, may use [[Null]] here."
	Class<GlobalOptions> globalOptionType,
	"The list of available sub-commands."
	shared actual [SubCommand+] commands,
	"Provide application information."
	ApplicationInfo() appInfoProvider,
	"List of special options to be handled. You can also annotate the [[GlobalOptions]] type (if any)."
	shared actual SubCommand[] specialOptions = defaultMultCommandSpecialOptions,
	"The default special options to apply to all sub-commands."
	SubCommand[] subCommandSpecialOptions = defaultMultiSubCommandSpecialOptions,
	"Used to format option names and creating readers."
	OptionReaderFactory optionFormatter = gnuOptions,
	"Provides [[parsers|at.dire.copter.core.parser:ValueParser]]. Default implementation searches the [[commands'|DefaultMultiCommandApplication.commands]] modules."
	ValueParserProvider valueParserProvider = ValueParserProvider(set { for (command in commands) command.item.declaration.containingModule })) extends AbstractApplication(optionFormatter) satisfies MultiCommandApplication {

	value specialOptionMap = getSpecialOptions(globalOptionType.declaration, specialOptions);
	value globalMappedOptions = getMappedOptionsFromAnnotations(`MainCommandOptions<GlobalOptions>`, valueParserProvider, specialOptionMap);
	value commandRunner = Runner(valueParserProvider);

	"Read the global options and command name."
	MainCommandOptions<GlobalOptions>|Class<Command>|ParseException readGlobalOptions(OptionReader reader) {
		value globalOptionSerializer = OptionParser<MainCommandOptions<GlobalOptions>,Class<Command>>(globalMappedOptions);

		// Parse the global options and the command name, including any global options.
		value mainOptionReader = ReadToOperandReader(reader);
		return globalOptionSerializer.parse(mainOptionReader);
	}

	shared actual Integer|ParseException runImpl(OptionReader reader) {
		value mainOptions = readGlobalOptions(reader);

		// If parsing has failed, return.
		if (is ParseException mainOptions) {
			return mainOptions;
		}

		// If we got a special option, execute it now.
		if (is Class<Command> mainOptions) {
			// Create a context without commandName for this execution.
			value context = CommandContextImpl(this, null, optionFormatter);
			context.push(globalMappedOptions);

			return commandRunner.run(mainOptions, null, emptyOptionReader, context, []);
		}

		// Read the global options and command name (and the user didn't specify a special option).
		// Get the command matching the parameter. This is case-sensitive, like git.
		value commandName = mainOptions.commandName;
		value subCommandClass = commands.find((subCommand) => subCommand.key == commandName)?.item;

		if (!exists subCommandClass) {
			return ParseException("Command \"``commandName``\" was not recognized.");
		}

		// Create a root context.
		value context = CommandContextImpl(this, mainOptions.commandName, optionFormatter);
		context.push(globalMappedOptions);

		// Read the command's command line arguments and run the command.
		return commandRunner.run(subCommandClass, mainOptions.globalOptions, reader, context, subCommandSpecialOptions);
	}

	getInfo() => appInfoProvider();
}
