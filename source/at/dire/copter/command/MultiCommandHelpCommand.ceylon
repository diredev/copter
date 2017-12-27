import at.dire.copter.command.annotations {
	commandDoc,
	UndocumentedAnnotation
}
import at.dire.copter.command.impl {
	printUsage,
	printOptionsAndGroups,
	extractDescription
}
import at.dire.copter.parse.core.inject {
	optionInject
}

"Print help on [[at.dire.copter.command::MultiCommandApplication]] and exit.

 Will print the global options, special-options as well as all available sub-commands."
commandDoc("Print usage information and exit.")
see(`class HelpCommand`)
shared class MultiCommandHelpCommand(optionInject CommandContext context) satisfies Command {
	shared actual Integer run() {
		"Application is not a MultiCommandApplication."
		assert(is MultiCommandApplication application = context.application);

		// Print the application description.
		value appInfo = application.getInfo();
		print(appInfo.description);

		// Print global options, if any.
		if(exists mappedOptions = context.parentMappedOptions) {
			printUsage(appInfo, null, mappedOptions, context.optionFormatter, context.optionFormatter.formatOperand("command-arg", true, false));

			print("\nGlobal Options:");
			printOptionsAndGroups(mappedOptions, context.optionFormatter);
		}

		// Print available sub-commands, sorted by name but skip 'undocumented' ones.
		print("\nAvailable commands:");
		value commands = application.commands.filter((SubCommand element) => !element.item.declaration.annotated<UndocumentedAnnotation>()).sort(byIncreasing(SubCommand.key));

		// Right align the various
		value maxCommandLength = max(commands.map((element)=>element.key.size).follow(8));

		for(command in commands) {
			print("   ``command.key.padTrailing(maxCommandLength)``  " + extractDescription(command.item.declaration));
		}

		return 0;
	}
}