import at.dire.copter.read.collect {
	AvailableOption
}

"Used to format options and operands for display purposes."
shared interface OptionFormatter {
	"Format the given option, possibly with a hint for the option's value."
	shared formal String formatOption(
		"Name of the option, including single character options."
		String name,
		"Will we read a (possibly optional) value?"
		Boolean readValue,
		"Is the value optional?"
		Boolean valueRequired = true,
		"Label used for the value (if any)."
		String valueLabel = "VALUE");

	"Format the given option."
	see (`function formatOption`)
	shared default String formatOptionName(
		"Option to print."
		AvailableOption<Anything> option,
		"Label used for the value (if any)."
		String valueLabel = "VALUE") => formatOption(option.displayName, option.readValue, option.valueRequired, valueLabel);

	"Format all of an [[at.dire.copter.read.collect::AvailableOption]]'s name, comma separated."
	shared default String formatOptionNames(
		"Option to print."
		AvailableOption<Anything> option,
		"Label used for the value (if any)."
		String valueLabel = "VALUE") {

		value formattedNames = { for (name in option.names.exceptLast) formatOption(name, false) };
		value lastName = formatOption(option.names.last, option.readValue, option.valueRequired, valueLabel);

		return ", ".join(formattedNames.chain({lastName}));
	}

	"Format an operand."
	shared default String formatOperand(
		"Display name for this operand."
		String name,
		"Allow multiple values?"
		Boolean allowMultiple = false,
		"Is this operand required?"
		Boolean required = true) {

		String formatted;

		if (required) {
			formatted = "<``name``>";
		} else {
			formatted = "[<``name``>]";
		}

		if (allowMultiple) {
			return formatted + "...";
		} else {
			return formatted;
		}
	}
}
