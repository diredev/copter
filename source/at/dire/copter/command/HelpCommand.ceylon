import at.dire.copter.command.annotations {
	commandDoc
}
import at.dire.copter.command.impl {
	printOptionsAndGroups,
	extractDescription,
	printUsage
}
import at.dire.copter.parse.core.inject {
	optionInject
}

"Print usage information for the current command or special-option to the console.

 This is commonly used as the special-option *--help*, but may also be used as a sub-command, or both.

 The format used here is derived from the [Gnu Coding Standards](https://www.gnu.org/prep/standards/standards.html#g_t_002d_002dhelp).

 Use this for single commands and applications. Use [[MultiCommandHelpCommand]] for *git*-style applications instead."
commandDoc("Print usage information and exit.")
shared class HelpCommand(optionInject CommandContext context) satisfies Command {
	shared actual Integer run() {
		"No parent context. You cannot use HelpCommand this way."
		assert(exists parentMappedOptions = context.parentMappedOptions);

		value formatter = context.optionFormatter;

		// Print command usage.
		printUsage(context.application.getInfo(), context.subCommand, parentMappedOptions, formatter);

		// Print description.
		print(extractDescription(parentMappedOptions.forClass.declaration));
		process.writeLine();

		// Print all options and option groups.
		printOptionsAndGroups(parentMappedOptions, formatter);

		return 0;
	}
}