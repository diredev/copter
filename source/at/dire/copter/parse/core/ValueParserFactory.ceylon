import at.dire.copter.parse.core.parsers {
	ValueParserProvider
}

import ceylon.language.meta.model {
	Type
}

"These classes provide means to create [[parsers|ValueParser]] dynamically when no
 explicit parser was given for a type.

 Make your class visible as a [[service]] (as [[ValueParserFactory]]) to enable."
see (`class ValueParserProvider`)
shared interface ValueParserFactory {
	"Returns a priority for this factory. Used to order factories by relevance.

	    This is used to call factories in the correct order when creating new instances. The lower the order the earlier a factory is called.
	    You can leave this priority at the default value (0), because all default factory types have a higher priority."
	shared default Integer priority => 0;

	"Return a matching instance for the given type or null if impossible"
	shared formal ValueParser<>? getInstance(ValueParserProvider allParsers, Type<> forType);
}
