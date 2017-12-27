import ceylon.language.meta.declaration {
	ValueDeclaration
}

"Mark attributes to be injected with values during the parsing process.

 This way, you can fill attributes that aren't marked as [[at.dire.copter.parse.core.annotations::option]] or
 [[at.dire.copter.parse.core.annotations::operand]]."
see(`class InjectingBuilder`, `interface PropertySource`)
shared annotation OptionInjectAnnotation optionInject(
	"The name of the property to inject. Leave empty to inject based on type only."
	String name = "") => OptionInjectAnnotation(name);

"Annotation class for [[optionInject]]."
shared final annotation class OptionInjectAnnotation(String nameArg = "")
		satisfies OptionalAnnotation<OptionInjectAnnotation,ValueDeclaration>  {
	"The name of the option. Returns null if no name has been given."
	shared String? name {
		if(nameArg.empty) {
			return null;
		}

		return nameArg;
	}

	string => name else "<type-only>";
}
