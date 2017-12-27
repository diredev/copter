import ceylon.language.meta.declaration {
	ValueDeclaration
}

"Marks an Attribute as an Operand."
see (`function option`, `function flag`, `function valueLabel`)
shared annotation OperandAnnotation operand(
	"Defines the order of operands if multiple operands are given."
	Integer order) => OperandAnnotation(order);

"Annotation class for [[operand]]."
shared final annotation class OperandAnnotation(
	"Order of this operand relative to other operands."
	shared Integer order) satisfies OptionalAnnotation<OperandAnnotation,ValueDeclaration> {}
