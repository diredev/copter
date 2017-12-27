import at.dire.copter.parse.core {
	TargetBuilderFactory,
	defaultBuilderFactory,
	MappedOptions
}

"Factory for [[InjectingBuilder]].

 Implemented as a decorator around another [[at.dire.copter.parse:TargetBuilderFactory]].
 Note that the [[PropertySource]] will be shared by all created instances."
shared class InjectingBuilderFactory(PropertySource properties, TargetBuilderFactory inner = defaultBuilderFactory) satisfies TargetBuilderFactory {
	shared actual InjectingBuilder<Result> create<Result>(MappedOptions<Result, Anything> mappedOptions) => InjectingBuilder(mappedOptions.forClass, inner.create(mappedOptions), properties);
}