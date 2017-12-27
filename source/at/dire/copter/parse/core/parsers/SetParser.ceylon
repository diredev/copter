import at.dire.copter.parse.core {
	ValueParser
}

import ceylon.collection {
	SingletonSet
}

"A decorator for [[SequenceParser]] that will return a [[Set]]  of values instead. The usual rules for duplicate values apply.

 Also note that any duplicate entries specified will be missing from the final
 set without a [[ParseException]] being returned!"
class SetParser<out Element = Object>(SequenceParser<Element> sequenceParser) satisfies ValueParser<Set<Element>> given Element satisfies Object {
	shared actual Set<Element>|ParseException parse(String?[] values) {
		value items = sequenceParser.parse(values);

		if(is ParseException items) {
			return items;
		}

		return set(items);
	}

	shared actual Set<Element>|ParseException parseSingle(String? stringValue) {
		value singleItem = sequenceParser.parseSingle(stringValue);

		if(is ParseException singleItem) {
			return singleItem;
		}

		return SingletonSet(singleItem[0]);
	}

	priority = -210;
}