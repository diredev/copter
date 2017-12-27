"The default implementation of [[TargetBuilderFactory]]. Will create and return instances of [[DefaultBuilder]]."
shared object defaultBuilderFactory satisfies TargetBuilderFactory {
	shared actual DefaultBuilder<Result> create<Result>(MappedOptions<Result, Anything> mappedOptions) => DefaultBuilder<Result>(mappedOptions.forClass);
}