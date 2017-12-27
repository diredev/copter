"Option used by an [[OptionCollector]].

 This could represent both short as well as a long option for *Gnu*-style options.
 Note that this class uses a [[AvailableOption.key]] to identify the option applied. Check [[OptionCollector]] for an explanation."
see (`class AvailableOperand`, `class OptionCollector`)
shared class AvailableOption<out Key=String>(
	"Used as a key that groups together multiple options."
	shared actual Key key,
	"The names of this option. Use a single letter for short-options."
	shared [String+] names,
	"True if this option has to be given on the command line."
	shared actual Boolean required = false,
	"True if we'll need to read a value for this option"
	shared Boolean readValue = false,
	"True if the value read is required. Only relevant if [[AvailableOption.readValue]] is true as well."
	shared Boolean valueRequired = true,
	"The default value for this option. Applied if no value is [[read|AvailableOption.readValue]] or the (optional) value is absent."
	shared String? defaultValue = null,
	"True if the parsing should be aborted after reading this option. Intended for special options only."
	shared Boolean abortAfter = false) satisfies AvailableOptionOrOperand<Key> given Key satisfies Object {

	string => names.first;
	hash => key.hash;
	displayName => names.first;
}
