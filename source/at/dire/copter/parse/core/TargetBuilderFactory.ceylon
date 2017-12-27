"Factory for [[TargetBuilder]]. A builder is created every time a command line is interpreted by the [[OptionParser]]."
see (`value defaultBuilderFactory`)
shared interface TargetBuilderFactory {
	"Create and return a new target instance for the given type."
	shared formal TargetBuilder<Result> create<Result>(
		"Mapped options for the given type."
		MappedOptions<Result,Anything> mappedOptions);
}
