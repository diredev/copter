import at.dire.copter.parse.core {
	TargetBuilder
}
import at.dire.copter.parse.core.util {
	getAttributesAndConstructorParams
}

import ceylon.language.meta.declaration {
	ValueDeclaration
}
import ceylon.language.meta.model {
	Class
}

"Decorator for [[at.dire.copter.parse:TargetBuilder]] that injects values into the created object provided by a [[PropertySource]].

 To use this class, you have to anotate your object's values with [[optionInject]]. The created object will
 then have all of the option and operand values as well as all injected values."
shared class InjectingBuilder<out Result>(
	"Class of the created object."
	Class<Result> forClass,
	"The builder used to create the actual object."
	TargetBuilder<Result> inner,
	"Gives access to the values we may inject."
	PropertySource context) satisfies TargetBuilder<Result> {

	// Get all of the values we may inject later, including constructor arguments.
	value injectableAttributes = getAttributesAndConstructorParams<OptionInjectAnnotation>(forClass);
	value injectedAttributesWithKeys = [for (injectableAttribute in injectableAttributes)
			if (exists annotation = injectableAttribute[0].annotations<OptionInjectAnnotation>().first)
				[injectableAttribute, annotation.name]];

	apply(ValueDeclaration attribute, Anything val) => inner.apply(attribute, val);

	shared actual Result build() {
		// Apply all the injectable values prior to build.
		for (value injectedValue in injectedAttributesWithKeys) {
			value targetAttribute = injectedValue[0];
			value propValue = context.getProperty(injectedValue[1], targetAttribute[1]);

			apply(targetAttribute[0], propValue);
		}

		// Now build normally.
		return inner.build();
	}
}
