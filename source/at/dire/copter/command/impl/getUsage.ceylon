
import at.dire.copter.command {
	Command
}
import at.dire.copter.command.util {
	split
}
import at.dire.copter.parse.core {
	MappedOptions,
	MappedAttribute,
	OrderedOperand
}
import at.dire.copter.parse.core.annotations {
	ValueLabelAnnotation,
	valueLabel
}
import at.dire.copter.read {
	OptionFormatter
}
import at.dire.copter.read.collect {
	AvailableOption
}

import ceylon.language.meta.model {
	Class
}

//TODO: Inefficient!! Will get all options for usage as well as later on...

"Returns usage information on all of the given options and operands."
String getUsage(MappedOptions<Anything, Class<Command>> mappedOptions, OptionFormatter formatter) {
	value result = StringBuilder();

	value allOptionAndOperands = getDisplayOptionsAndOperands(mappedOptions, true);
	value requiredOrOptionalOptions = split(allOptionAndOperands[0], (AvailableOption<MappedAttribute|Class<Command>> option) => option.required);

	// We first print all required options
	requiredOrOptionalOptions[0].each((option) => printUsageOption(option, formatter, result));

	// Print optional options unless there are too many.
	value optionalOptions = requiredOrOptionalOptions[1];

	if(optionalOptions.size <= 16) {
		optionalOptions.each((option) => printUsageOption(option, formatter, result));
	} else {
		// Too many options. Print a placeholder.
		result.append(" [OPTION]...");
	}

	// We then print the operands in order, no matter if optional.
	allOptionAndOperands[1].each((operand) => printUsageOperand(operand, formatter, result));

	return result.string;
}

"Print usage for operands."
void printUsageOperand(OrderedOperand operand, OptionFormatter formatter, StringBuilder result) {
	if(!operand.required) {
		result.append(" [");
	} else {
		result.append(" ");
	}

	result.append(formatter.formatOperand(operand.displayName));

	if(!operand.required) {
		result.append("]");
	}

	if(operand.allowMultiple) {
		result.append("...");
	}
}

"Print usage for options."
void printUsageOption(AvailableOption<MappedAttribute|Class<Command>> option, OptionFormatter formatter, StringBuilder result) {
	// Print optional options in "[]"
	if(!option.required) {
		result.append(" [");
	} else {
		result.append(" ");
	}

	// Print the first option name only.
	result.append(formatter.formatOptionName(option, getValueLabel(option)));

	if(!option.required) {
		result.append("]");
	}
}

"Returns the label to be used for an option's value."
see(`function valueLabel`)
String getValueLabel(AvailableOption<MappedAttribute|Class<Command>> option) {
	return (if(is MappedAttribute mappedAttribute = option.key) then mappedAttribute.targetValue.annotations<ValueLabelAnnotation>().first?.string else "VALUE") else "VALUE";
}
