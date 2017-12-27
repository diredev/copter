import at.dire.copter.command {
	Application,
	CommandContext,
	CommandOptions
}
import at.dire.copter.read {
	OptionFormatter
}

"Implementation of [[at.dire.copter.command::CommandContext]].

 Make sure to call [[CommandContextImpl.push]] at least once to make this usable."
shared class CommandContextImpl(
	shared actual Application application,
	shared actual String? subCommand,
	shared actual OptionFormatter optionFormatter) satisfies CommandContext {

	"Current options."
	variable CommandOptions? currentMappedOptions = null;

	"The previous options."
	variable CommandOptions? varParentMappedOptions = null;

	"Activates the given options and pushes the current options to the previous position."
	shared void push(CommandOptions newOptions) {
		varParentMappedOptions = currentMappedOptions;
		currentMappedOptions = newOptions;
	}

	shared actual CommandOptions mappedOptions {
		assert (exists mappedOptions = currentMappedOptions);
		return mappedOptions;
	}

	parentMappedOptions => varParentMappedOptions;
}
