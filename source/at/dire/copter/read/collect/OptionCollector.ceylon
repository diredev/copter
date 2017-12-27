import at.dire.copter.read {
	OptionReader
}
import at.dire.copter.read.util {
	mapWithoutDuplicates
}

import ceylon.collection {
	HashMap,
	ArrayList,
	unlinked,
	Hashtable,
	MutableMap
}

"Collects the values read from an [[OptionReader]] into a [[Result]].

 To use this, you have to define all possible options and operands in the constructor call. This is necessary because we need to know which options
 are valid and those that accept a value. This also enables us to handle unknown or missing options/operands.

 Check the module's description for details and a usage example."
see (`interface OptionReader`, `class Result`)
shared class OptionCollector<in Key=String>(
	"The list of all possible options."
	[AvailableOption<Key>*] options,
	"The list of all possible operands."
	[AvailableOperand<Key>*] operands = []) given Key satisfies Object {

	// Create a map of the options available by name, do not allow duplicates.
	value optionsByName = mapWithoutDuplicates({ for (option in options) for (name in option.names) name->option });

	// Sanity check the operands: Only one multi-value; after multi-value only required allowed. And count number of required operands.
	variable Boolean hasMultiableOperand = false;
	variable Integer numRequired = 0;

	for (operand in operands) {
		if (operand.required) {
			numRequired++;
		} else {
			"Operand <``operand``> is optional. Must only have required operands after the one (and only) multi-value operand."
			assert (!hasMultiableOperand);
		}

		if (operand.allowMultiple) {
			"Operand <``operand``> allows multiple values. Must not have more than one operand that allows multiple values."
			assert (!hasMultiableOperand);
			hasMultiableOperand = true;
		}
	}

	function toResult(Map<Key,List<String?>> groupedValues) {
		value sequenceMap = groupedValues.mapItems((key, item) => (item.sequence()));
		return Result<Key>(sequenceMap);
	}

	"This will read the entire command line and return all read options and operands and their values or [[ParseException]] if reading
	 fails, an invalid option was read or we weren't able to assign an operand."
	shared Result<Key>|ParseException collect(OptionReader reader) {
		value groupedValues = HashMap<Key,ArrayList<String?>>(unlinked, Hashtable(options.size));
		value allOperandValues = ArrayList<String>(operands.size);

		while (!is Finished optionName = reader.read()) {
			// Reading an Operand?
			if (optionName.operand) {
				value val = reader.readValue();

				// Parsing error?
				if (is ParseException val) {
					return val;
				}

				// Only collect all operand values. Will be applied later.
				allOperandValues.add(val);
			} else {
				// Is an Option. Find a matching option in my map by name.
				value option = optionsByName.get(optionName.name);

				if (!exists option) {
					return ParseException("\"``optionName.readName``\" is not a valid option.");
				}

				// Read the value for this option.
				String?|ParseException valueRead;
				String? optionValue;

				if (option.readValue) {
					if (option.valueRequired) {
						valueRead = reader.readValue();
					} else {
						valueRead = reader.readOptionalValue() else option.defaultValue;
					}

					if (is ParseException valueRead) {
						return valueRead;
					}

					// Value or default value
					optionValue = valueRead;
				} else {
					// Not reading value; apply the default value.
					optionValue = option.defaultValue;
				}

				// Get the group for this name
				addValueForKey(groupedValues, option.key, optionValue);

				// Stop reading after this option?
				if (option.abortAfter) {
					return toResult(groupedValues);
				}
			}
		}

		// We are done reading all options and operands. Check if all required options were specified on the command line. Operands are handled below.
		for (option in options.filter(AvailableOption<Key>.required)) {
			if (!groupedValues.defines(option.key)) {
				return ParseException("Missing value for required option \"``option.names.first``\".");
			}
		}

		// Now apply the operand values and check if all required options are set.
		value operandFail = addOperandValues(groupedValues, allOperandValues);

		if (exists operandFail) {
			return operandFail;
		}

		// Return a new result object.
		return toResult(groupedValues);
	}

	"Add the given values to the mutable map. Will also apply operands in order. Returns a [[ParseException]] when that's not possible."
	ParseException? addOperandValues(MutableMap<Key,ArrayList<String?>> groupedValues, List<String> values) {
		variable value requiredSlots = numRequired;
		variable value optionalSlots = Integer.largest(values.size - numRequired, 0);
		variable value currentValueIndex = 0;

		for (operand in operands) {
			// Check if we have slots to fill in this operand.
			if (operand.required) {
				// A required operand. Fill in and reduce the number of required slots.
				requiredSlots--;

				"No more required slots left. This is not supposed to happen."
				assert (requiredSlots >= 0);
			} else if (optionalSlots > 0) {
				// An optional operand. Fill in but reduce the number of optional slots.
				optionalSlots--;
			} else {
				// Optional operand and we we have no optional slots left, abort now.
				continue;
			}

			// Provide the values for this operand.
			if (operand.allowMultiple) {
				// When we apply multiple values, we take all values beginning with the current one. Exclude any remaining required slots.
				value multiValues = values[currentValueIndex .. (values.size - requiredSlots - 1)];
				currentValueIndex += multiValues.size;

				// Add all values to this operand.
				multiValues.each((operandValue) => addValueForKey(groupedValues, operand.key, operandValue));
			} else {
				// Apply the current value index to the operand.
				value result = addValueForOperandIndex(groupedValues, operand, values, currentValueIndex++);

				if (exists result) {
					if (is ParseException result) {
						//return result;
						return ParseException("Failed to read <``operand.displayName``>: ``result.message``");
					} else {
						// Finished: Done reading all values and only optional operands left. Exit.
						return null;
					}
				}
			}
		}

		// Do we have remaining operand values?
		if (currentValueIndex < values.size) {
			log.debug(() => "Remaining operands after all operands have been applied. Currently at ``currentValueIndex``, total size is ``values.size``.");
			return ParseException("Too many operands given.");
		}

		// All done.
		return null;
	}

	"Add a value for the given operand to the map."
	ParseException|Finished? addValueForOperandIndex(MutableMap<Key,ArrayList<String?>> groupedValues, AvailableOperand<Key> operand, List<String> values, Integer index) {
		value operandValue = values[index];

		if (exists operandValue) {
			addValueForKey(groupedValues, operand.key, operandValue);
			return null;
		} else if (operand.required) {
			// No value given for this required operand.
			return ParseException("Missing value for required operand '``operand.displayName``'.");
		} else {
			// Failed to read a value for an optional value. All following values will be optional and I will never get a value, so return Finished here.
			return finished;
		}
	}

	"Add a value for the given group key to the given map."
	void addValueForKey(MutableMap<Key,ArrayList<String?>> groupedValues, Key groupKey, String? optionValue) {
		value optionValues = groupedValues[groupKey];

		if (exists optionValues) {
			optionValues.add(optionValue);
		} else {
			// Create and add a new List
			value newValueList = ArrayList<String?>(1);
			newValueList.add(optionValue);
			groupedValues[groupKey] = newValueList;
		}
	}
}
