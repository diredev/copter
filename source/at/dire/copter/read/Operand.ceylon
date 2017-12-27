"Implementation of [[OptionOrOperand]] to represent operands."
see(`class Option`)
shared class Operand(String operandValue) satisfies OptionOrOperand {
	name => "";
	readValue(Iterator<String> moreArguments) => operandValue;
	readOptionalValue(Iterator<String> moreArguments) => operandValue;
	string => operandValue;
	readName => operandValue;
	operand => true;
}
