import ceylon.language.meta.model {
	Type
}

"Provides properties to be injected during the parsing process."
see(`class InjectingBuilder`)
shared interface PropertySource {
	"Return the value of the property matching the given property name and result class.

	 If no name is given, return the first property value matching the expected type. If neither of
	 these two approaches works, return null instead."
	shared formal Result? getProperty<out Result = Anything>(String? name, Type<Result> ofType);
}
