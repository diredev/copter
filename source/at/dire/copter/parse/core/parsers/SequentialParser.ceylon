import at.dire.copter.parse.core {
	ValueParser
}

import ceylon.collection {
	ArrayList
}

"A parser able to parse a list of values into a sequence.

 Use this to satisfy [[Sequence]], [[Iterable]] and [[List]]."
see(`class SequenceParser`, `class SequenceParserFactory`)
class SequentialParser<out Element = Anything>(ValueParser<Element> itemParser) satisfies ValueParser<Element[]> {
	shared default actual Element[]|ParseException parse(String?[] values) {
		value parsedValueList = ArrayList<Element>(values.size);

		for(stringValue in values) {
			value parsed = itemParser.parseSingle(stringValue);

			if(is ParseException parsed) {
				return parsed;
			}

			parsedValueList.add(parsed);
		}

		return parsedValueList.sequence();
	}

	shared actual [Element+]|ParseException parseSingle(String? stringValue) {
		value result = itemParser.parseSingle(stringValue);

		if(is ParseException result) {
			return result;
		}

		return [result];
	}
}