"[[Parse|OptionParser]] command line arguments into objects.

 # Using Annotations
 The easiest way to use this library is to create an option object and annotate it's attributes:
  * Apply [[at.dire.copter.parse.core.annotations::flag]], [[at.dire.copter.parse.core.annotations::nonFlag]] or [[at.dire.copter.parse.core.annotations::customFlag]] to make this an
    option without value. Typically used with Booleans.
  * Apply [[at.dire.copter.parse.core.annotations::option]] to parse as an option with value.
  * Apply [[at.dire.copter.parse.core.annotations::operand]] to parse as an operand.
  * Apply [[at.dire.copter.parse.core.annotations::optionGroup]] to create an option group.
  * Apply [[at.dire.copter.parse.core.annotations::optionalValue]] to make the value optional and provide a default value. Can be applied to both required and optional options.

 You can add the attributes in the default constructor of your type. This way you can also apply default values to the attributes, causing the parser to treat the value
 as an optional option.

 Here's a very simple option class:

 ~~~
 shared class SimpleOptions(
 	\"Required option.\"
 	option(\"n\", \"name\")
 	shared String name,

 	\"A required operand.\"
 	operand(0)
 	shared String fileName,

 	\"An optional option. Nullable in this case.\"
 	option(\"description\")
 	shared String? description = null,

 	\"A flag\"
 	flag(\"v\", \"verbose\")
 	shared Boolean verbose = false,

 	\"More operands. This one allows 0 or more values.\"
 	operand(1)
 	shared String[] otherOperands = []) {}
 ~~~

 You can then create a parser for this type and parse the command line arguments:

 ~~~
 // Parser for the type, without any special options available.
 value parser = createOptionParser(\`SimpleOptions\`);
 value result = parser.parse(gnuOptions.createReader(process.arguments));

 if(is ParseException result) {
 	// Parsing has failed.
 	print(result.message);
 } else {
 	// Parsing has succeeded.
 	print(result.name);
 }
 ~~~

 ## Grouping options
 Use the [[at.dire.copter.parse.core.annotations::optionGroup]] annotation to mark attributes as a group of options. This causes the parser to create an object for this group, applying
 the same parsing rules as for the original object. You also have to apply annotations to that class' members.

 The complete list of options and operands is determined by collecting all options and operands accross all levels. This also means that you cannot specify the same option or
 operand multiple times and also affects things like operand order.

 # Parsing rules
 Copter uses Ceylon's meta model to make assumptions for the parsing operation:
  * Non-defaulted constructor arguments are considered required.
  * Defaulted arguments are considered optional and will be set to their default-value if not supplied.
  * Values are parsed depending on their type.
  * Attributes that allow multiple values ([[Sequential]], [[Iterable]], etc.) are supplied with all values given on the command line. They
    are also allowed to have multiple values if an operand.
  * Non-empty [[sequences|Sequence]] are considered required. This applies to both options and operands.
  * Union types are handled automatically. This also includes nullable types.
  * Case values (i.e. enumerated types) are handled, but you have to apply the [[at.dire.copter.parse.core.annotations::optionValue]] annotation to all usable values.

 ## Custom parsing
 The parsers included by default take care of most default types in Ceylon's type system as well as common collection types and case-values.

 You can provide your own parser by implementing either [[ValueParser]] or [[ValueParserFactory]]. They should automatically be picked up if you mark them
 as [[service]]. You can also use [[at.dire.copter.parse.core.annotations::valueParser]] to specify what parser to use for an attribute.

 # Special options
 Some options like *--help* and *--version* aren't considered a part of the resulting object because the parsing operation should be stopped when we encounter one of those.
 These are called \"special options\" here. You provide them to the parser itself and they will be included in the list of available options.

 # Building Applications
 Check out `at.dire.copter.command` which expands on the functionality here by providing a full command implementation, including *Git*-style commands and
 automatic `--help` and `--version` output."
see(`class OptionParser`, `function createOptionParser`)
module at.dire.copter.parse.core "1.0.0" {
	shared import at.dire.copter.read "1.0.0";
	import ceylon.logging "1.3.3";
	import ceylon.collection "1.3.3";
}
