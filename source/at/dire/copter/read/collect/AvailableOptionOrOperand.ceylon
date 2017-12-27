"Either an [[AvailableOption]] or [[AvailableOperand]]."
shared interface AvailableOptionOrOperand<out Key> of AvailableOption<Key> | AvailableOperand<Key> given Key satisfies Object {
	"Used as a key that groups together multiple operands."
	shared formal Key key;

	"True if we require at least (or exactly) one occurence of this option or operand."
	shared formal Boolean required;

	"Name to display when we refer to this option or operand."
	shared formal String displayName;
}
