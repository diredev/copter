import at.dire.copter.read.collect {
	AvailableOperand
}

"Extension for [[at.dire.copter.read.collect::AvailableOperand]] with an additional [[OrderedOperand.order]].

 This is used to allow [[option groups|at.dire.copter.core.parse.annotations] to provide
 absolute ordering of operands accress all groups."
shared class OrderedOperand(
	"The field to be mapped."
	MappedAttribute field,
	"Absolute order of this operand."
	shared Integer order,
	"Is this operand required (i.e. has to be specified at least once)."
	Boolean required = true,
	"Can we specify multiple values for thi operand?"
	Boolean allowMultiple = false)
		extends AvailableOperand<MappedAttribute>(field, required, allowMultiple, field.displayName) satisfies Comparable<OrderedOperand> {

	compare(OrderedOperand other) => this.order.compare(other.order);
}
