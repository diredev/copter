import at.dire.copter.read {
	OptionReader
}
import at.dire.copter.read.collect {
	CollectResult=Result,
	OptionCollector
}

"This class interprets all command line parameters and creates an object out of it."
shared class OptionParser<out Result, out SpecialOption=Nothing>(
	"Mapping of all attributes that will be used for serialization. Also includes all special-options."
	shared MappedOptions<Result,SpecialOption> mappedOptions,
	"A factory that returns a builder we use for constructing objects."
	TargetBuilderFactory targetBuilderFactory = defaultBuilderFactory) given Result satisfies Object given SpecialOption satisfies Object {

	// Create a collector for all options and operands, including those of option-groups and all special options.
	value optionsAndOperands = mappedOptions.getAllOptionsAndOperands();
	value collector = OptionCollector<MappedAttribute|SpecialOption>(*optionsAndOperands);

	"This reads all options and operands from the given [[reader]] and will try to create an object out of it. If that is not
	 possible, we return the reason for failure as [[ParseException]].

	 Also, if we read a special option (e.g. *--help* or *--version*), we return this object instead of creating anything."
	shared Result|SpecialOption|ParseException parse(OptionReader reader) {
		// Parse the command line.
		value result = this.collector.collect(reader);

		if (is ParseException result) {
			return result;
		}

		return parseResult(result);
	}

	"Parses the given parse result into an object."
	Result|SpecialOption|ParseException parseResult(CollectResult<MappedAttribute|SpecialOption> result) {
		value objectBuilder = targetBuilderFactory.create<Result>(mappedOptions);

		// Was any special option specified?
		for (value specialOption in mappedOptions.specialOptions) {
			if (result.isPresent(specialOption.item)) {
				// Special option specified. Abort reading.
				log.debug(() => "Have read the special option '``specialOption``'. Aborting parse operation.");
				return specialOption.item;
			}
		}

		// Parse all Option groups using their own parser.
		for (value optionGroup in mappedOptions.groups) {
			log.debug(() => "Parse and apply option group '``optionGroup``'.");

			Anything groupValue;

			// Use another serializer to read this group.
			if (exists groupMapper = optionGroup.innerMapper) {
				value groupSerializer = OptionParser(groupMapper, targetBuilderFactory);
				groupValue = groupSerializer.parseResult(result);
			} else {
				groupValue = null;
			}

			if (is ParseException groupValue) {
				return groupValue;
			}

			// Apply to my attribute.
			objectBuilder.apply(optionGroup.targetValue, groupValue);
		}

		// Apply all option and operand values
		for (mappedValue in mappedOptions.values) {
			value values = result.getValues(mappedValue);
			log.debug(() => "Got the following values for option '``mappedValue.targetValue.name``': '``values``'");

			// If the list of value is an empty sequence then the option/operand was not specified.
			Anything parsedValue;

			// If no values were given by the user and I am told to not apply an empty list in this case, then skip.
			if (values.empty && !mappedValue.applyEmpty) {
				log.debug(() => "Not applying empty value list to option ``mappedValue.targetValue.name``. Will be left at the default value or fail.");
				continue;
			}

			// Parse the value(s), possibly an empty list.
			log.debug(() => "Parsing string values '``values``' for value '``mappedValue``' using '``mappedValue.parser``'");
			parsedValue = mappedValue.parser.parse(values);

			if (is ParseException parsedValue) {
				// Failed to parse value.
				return ParseException("Invalid argument for '``mappedValue.displayName``': ``parsedValue.message``");
			}

			// Apply the value(s) to the target object.
			objectBuilder.apply(mappedValue.targetValue, parsedValue);
		}

		// Finish and return the object.
		log.debug("All options and option groups applied. Creating instance.");
		return objectBuilder.build();
	}
}