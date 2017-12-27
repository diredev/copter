import ceylon.language.meta {
	type
}
import ceylon.language.meta.model {
	Type
}

"Simple implementation of [[PropertySource]] based on a map."
shared class MapPropertySource(Map<String, Anything> properties) satisfies PropertySource {
	shared actual Result? getProperty<out Result = Anything>(String? name, Type<Result> ofType) {
		if(exists name) {
			value result = properties[name];

			"Property \"``name``\" of the type ``type(result)`` is not compatible with result type ``ofType``."
			assert(is Result result);

			return result;
		} else {
			// Find a matching property based on type alone.
			value result = properties.find((key->item) => ofType.typeOf(item))?.item;
			assert(is Result result);

			return result;
		}
	}
}