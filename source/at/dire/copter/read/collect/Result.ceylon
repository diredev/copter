"Result of parsing all command line options and operands.

 This class uses predefined [[keys|Key]] to identify items. Check [[OptionCollector]] for an explanation on this."
see (`class OptionCollector`)
shared class Result<in Key=String>(
	"A map containing all keys and their values."
	Map<Key,String?[]> valueGroups) given Key satisfies Object {

	"Returns true if the Option or Operand was specified on the command line. This method ignores the existance and number of values."
	shared Boolean isPresent(Key key) => valueGroups.defines(key);

	"Return the value for the given Option or Operand. When the option has multiple values, the last value is returned.
	 This will return null if the option is not present or no value was given for an option (optional value)."
	shared String? getValue(Key key) => getValues(key).last;

	"Returns all the values for the given option, which may include Null if optional values are given. This will return an
	 empty list if the option is not present or no values were given."
	shared String?[] getValues(Key key) => valueGroups[key] else [];

	string => valueGroups.string;
}
