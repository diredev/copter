"Operand used by an [[OptionCollector]] matching zero or more operand values.

 Note that this class uses a [[AvailableOperand.key]] to identify the option applied. Check [[OptionCollector]] for an explanation."
see (`class AvailableOption`, `class OptionCollector`)
shared class AvailableOperand<out Key=String>(
	"Used as a key that groups together multiple operands."
	shared actual Key key,
	"True if we require at least (or exactly) one occurence of this operand."
	shared actual Boolean required = true,
	"True if this operand can be specified multiple times."
	shared Boolean allowMultiple = false,
	"A name for this operand used for display purposes."
	shared actual String displayName = key.string) satisfies AvailableOptionOrOperand<Key> given Key satisfies Object {

	string => displayName;
	hash => key.hash;
}
