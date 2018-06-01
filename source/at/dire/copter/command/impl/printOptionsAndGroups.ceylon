import at.dire.copter.command {
	Command
}
import at.dire.copter.parse.core {
	MappedOptions,
	MappedAttribute,
	MappedGroup
}
import at.dire.copter.read {
	OptionFormatter
}

import ceylon.collection {
	ArrayList
}
import ceylon.language.meta.model {
	Class
}

"Print available options and operands."
shared void printOptionsAndGroups(MappedOptions<Anything, Class<Command>> mappedOptions, OptionFormatter formatter) {

	//TODO: Consider always grouping and adding "root"-group?
	value allRows = ArrayList<String->MappedAttribute|Class<Command>>(mappedOptions.options.size + mappedOptions.operands.size + mappedOptions.groups.size * 5);

	value allOptionsAndOperands = getDisplayOptionsAndOperands(mappedOptions);

	for(option in allOptionsAndOperands[0]) {
		value valueLabel = getValueLabel(option);
		allRows.add(formatter.formatOptionNames(option, valueLabel)->option.key);
	}

	//TODO: How and where to format operand values??
	for(operand in allOptionsAndOperands[1]) {
		//print("  ``formatter.formatOperand(operand.displayName)``\t``extractDescriptionFrom(operand.key)``");
		allRows.add(formatter.formatOperand(operand.displayName)->operand.key);
	}

	// Get the max length of items to print afterwards.
	value maxDescLength = max(allRows.map((name->option)=>name.size).follow(14));

	for(descHeader->descItem in allRows) {
		// Split lines here to support indented doc output
		value descriptionRows = extractDescriptionFrom(descItem).split { splitting='\n'.equals; groupSeparators = false; };
		print("  ``descHeader.padTrailing(maxDescLength)``  ``descriptionRows.first``");

		for(descriptionRow in descriptionRows.rest) {
			process.write(" ".repeat(maxDescLength+4));
			process.writeLine(descriptionRow);
		}
	}

	//TODO: What about these groups?
	// Skip absorbed groups. Those have been handled before.
	for(group in mappedOptions.groups.filter(not(MappedGroup.absorbed))) {
		process.writeLine();

		//TODO: Label?
		print(group.targetValue.name);

		if(exists groupMapper = group.innerMapper) {
			printOptionsAndGroups(groupMapper, formatter);
		}
	}
}

