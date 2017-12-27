import at.dire.copter.parse.core {
	ValueParserFactory,
	ValueParser
}

import ceylon.language.meta.model {
	Type,
	Interface
}

"Factory that creates parsers for [[Sequence]] and [[Sequential]]."
service(`interface ValueParserFactory`)
shared class SequenceParserFactory() satisfies ValueParserFactory {
	shared actual ValueParser<>? getInstance(ValueParserProvider allParsers, Type<Anything> forType) {
		// Only for sequences and List interface
		//TODO: This will match EVERYTHING that is iterable...
		//TODO: Change this to match exact only?
		if(!is Interface<Sequential<>|List<>|Iterable<>> forType) {
			return null;
		}

		value itemType = forType.typeArgumentList.first;

		"Failed to determine item type of sequence type ``forType``."
		assert(exists itemType);

		// Get a parser for my item.
		value itemParser = allParsers.getParserUnsafe(itemType);

		"Failed to create a parser for item type ``itemType`` of the sequence type ``forType``."
		assert(exists itemParser);

		// Create an parser to handle sequential (possibly empty)
		value sequentialParser = `class SequentialParser`.instantiate([itemType], itemParser);
		assert(is SequentialParser<> sequentialParser);

		// If we are dealing with Sequence instead of Sequential (non-empty), create a wrapper.
		if(is Interface<Iterable<Anything,Nothing>> forType) {
			value sequenceParser = `class SequenceParser`.instantiate([itemType], sequentialParser);
			assert(is SequenceParser<> sequenceParser);
			return sequenceParser;
		} else {
			return sequentialParser;
		}
	}

	priority = -210;
}