import at.dire.copter.parse.core {
	MappedOptions
}
import at.dire.copter.read {
	OptionFormatter
}

import ceylon.language.meta.model {
	Class
}

"Keyword used to [[inject|at.dire.copter.parse.core.inject::optionInject]] the [[at.dire.copter.command::CommandContext]]."
shared String contextInjectName = "at.dire.copter.commandContext";

"An alias for a [[Command]]'s [[options|at.dire.copter.parse.core::MappedOptions]]."
shared alias CommandOptions => MappedOptions<Anything,Class<Command>>;

"A special option or sub-command. Maps a name to a [[Command]] class."
shared alias SubCommand => Entry<String,Class<Command>>;

"Context for the execution of a command or special-option."
shared interface CommandContext {
	"The application being executed."
	shared formal Application application;

	"Sub-command invoked or null."
	shared formal String? subCommand;

	"Use This formatter to print option names if needed."
	shared formal OptionFormatter optionFormatter;

	"Mapped options for the current command or special-option."
	shared formal CommandOptions mappedOptions;

	"Mapped options of the previous operation.
	 This can be used to access the global option from commands or the command from a special option."
	shared formal CommandOptions? parentMappedOptions;
}
