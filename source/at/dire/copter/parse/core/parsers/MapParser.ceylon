import at.dire.copter.parse.core {
	ValueParser
}

import ceylon.collection {
	HashMap,
	unlinked,
	Hashtable
}

"This parser can be used to interpret command line options given in the format \"key=value\".
 If no value is given, the value will be set to the sane default of the item type (possibly null)."
class MapParser<out Key = Object, out Item = Anything>(ValueParser<Key> keyParser, ValueParser<Item> itemParser)
		satisfies ValueParser<Map<Key,Item>> given Key satisfies Object {

	"Parse a single entry from the given option value."
	Entry<Key,Item>|ParseException parseEntry(String stringValue) {
		// Split by '='
		value entry = stringValue.split{ splitting = '='.equals; limit = 2; }.sequence();

		// Parse key value
		value key = keyParser.parseSingle(entry[0]);

		if(is ParseException key) {
			return key;
		}

		// Parse item value, may be null!
		value item = itemParser.parseSingle(entry[1]);

		if(is ParseException item) {
			return item;
		}

		return key->item;
	}

	shared actual Map<Key,Item>|ParseException parse(String?[] values) {
		// Use stringSequenceParser to get Strings without null. May return ParseException.
		value stringValues = stringSequenceParser.parse(values);

		if (is ParseException stringValues) {
			return stringValues;
		}

		// Build a map by parsing all values.
		value result = HashMap<Key,Item>(unlinked, Hashtable(stringValues.size));

		for(value stringValue in stringValues) {
			// Add entry
			value keyItem = parseEntry(stringValue);

			if(is ParseException keyItem) {
				return keyItem;
			}

			result.put(keyItem.key, keyItem.item);
		}

		return result;
	}

	shared actual Map<Key,Item>|ParseException parseSingle(String? stringValue) {
		if (!exists stringValue) {
			return ParseException("Map parser does not support null values.");
		}

		value entry = parseEntry(stringValue);

		if(is ParseException entry) {
			return entry;
		}

		return map({entry});
	}

	priority = -200;
}
