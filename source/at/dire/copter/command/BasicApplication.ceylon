import at.dire.copter.command.impl {
	Runner,
	CommandContextImpl
}
import at.dire.copter.parse.core.parsers {
	ValueParserProvider
}
import at.dire.copter.read {
	gnuOptions,
	OptionReader,
	OptionReaderFactory
}

import ceylon.language.meta.model {
	Class
}

"Default special options for most [[applications|BasicApplication]].

 Provides common implementations for `--help` and `--version`."
shared SubCommand[] defaultSpecialOptions = ["help" -> `HelpCommand`, "version" -> `VersionCommand`];

"Application that executes one specific [[Command]]."
shared class BasicApplication(
	"Class of command being executed."
	Class<Command> commandType,
	"Special options provided by the application."
	shared actual SubCommand[] specialOptions = defaultSpecialOptions,
	"Method providing application description. Default will use the [[command's|BasicApplication.commandType]] module to create a description."
	ApplicationInfo() appInfoProvider = (() => createAppInfoFromModule(commandType.declaration.containingModule)),
	"Used to format and read the command line."
	OptionReaderFactory optionFormatter = gnuOptions,
	"Used to provide value parsers."
	ValueParserProvider valueParserProvider = ValueParserProvider([commandType.declaration.containingModule])) extends AbstractApplication(optionFormatter) {

	"This is used to execute the actual application."
	value runner = Runner(valueParserProvider);

	runImpl(OptionReader reader) => runner.run(commandType, null, reader, CommandContextImpl(this, null, optionFormatter), specialOptions);
	getInfo() => appInfoProvider();
}
