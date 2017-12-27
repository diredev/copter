import at.dire.copter.parse.core.parsers {
	ValueParserProvider
}
import at.dire.copter.read {
	gnuOptions,
	OptionReaderFactory
}

import ceylon.language.meta.declaration {
	Module
}
import ceylon.language.meta.model {
	Class
}

"Convenience method for executing a *git*-style application.

 This will parse the command line, get a sub-command to execute by name and will then execute it. You can also
 provide a list of special options and any parsing error or exception is handled by returning a
 proper exit code.

 The list of available commands is created by finding [[Command]] classes annotated using [[at.dire.copter.command.annotations::command]] in the given module."
see (`function findCommands`, `class DefaultMultiCommandApplication`)
shared Integer runCommands(
	"The module to read commands from."
	Module fromModule,
	"List of additional special options to handle before the command name is parsed. The default includes *--help* and *--version*."
	SubCommand[] specialOptions = defaultMultCommandSpecialOptions,
	"List of additional special options to include per command. The default uses *--help*."
	SubCommand[] subCommandSpecialOptions = defaultMultiSubCommandSpecialOptions,
	"Reader used for command line. Default will use Gnu style to read the process arguments."
	{String*} arguments = process.arguments,
	"Provide information on your application. The default will read the annotations on the module."
	ApplicationInfo() appInfoProvider = (() => createAppInfoFromModule(fromModule)),
	"Used to format options and create readers."
	OptionReaderFactory optionFormatter = gnuOptions) => runCommandsWithGlobalOptions(fromModule, `Null`, specialOptions, subCommandSpecialOptions, arguments, appInfoProvider, optionFormatter);

"Similar to [[runCommands]] but provides global options.

 Note that the global option type for commands is only checked at runtime. Only use a single global option type for all
 commands in your module when using this method."
see (`function findCommands`, `class DefaultMultiCommandApplication`)
shared Integer runCommandsWithGlobalOptions<GlobalOptions>(
	"The module to read commands from."
	Module fromModule,
	"Type of global options to use."
	Class<GlobalOptions> globalOptionType,
	"List of additional special options to handle before the command name is parsed. The default includes *--help* and *--version*."
	SubCommand[] specialOptions = defaultMultCommandSpecialOptions,
	"List of additional special options to include per command. The default uses *--help*."
	SubCommand[] subCommandSpecialOptions = defaultMultiSubCommandSpecialOptions,
	"Reader used for command line. Default will use Gnu style to read the process arguments."
	{String*} arguments = process.arguments,
	"Provide information on your application. The default will read the annotations on the module."
	ApplicationInfo() appInfoProvider = (() => createAppInfoFromModule(fromModule)),
	"Used to format options and create readers."
	OptionReaderFactory optionFormatter = gnuOptions) {

	// Get the list of commands inside the module.
	value subCommands = findCommands(fromModule).sequence();

	"Failed to find any commands in module ``fromModule``."
	assert (nonempty subCommands);

	value valueParserProvider = ValueParserProvider([fromModule]);
	value app = DefaultMultiCommandApplication<GlobalOptions>(globalOptionType, subCommands, appInfoProvider, specialOptions, subCommandSpecialOptions, optionFormatter, valueParserProvider);
	return app.run(arguments);
}
