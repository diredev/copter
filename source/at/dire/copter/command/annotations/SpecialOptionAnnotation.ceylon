import ceylon.language.meta.declaration {
	ClassDeclaration
}

"Annotates [[at.dire.copter.command::Command]] class or [[option group|at.dire.copter.parse.core.annotations::optionGroup]] to add special options to your application.

 When one of these options is encountered, the parsing process is aborted and the given [[at.dire.copter.command::Command]] implementation is executed instead.
 Note that no command-line arguments are passed to this command, so you have to make sure that your command does not require them."
shared annotation SpecialOptionAnnotation specialOption(String name, ClassDeclaration commandClass)
		=> SpecialOptionAnnotation(name, commandClass);

"Annotation class for [[specialOption]] and related annotations."
shared final annotation class SpecialOptionAnnotation(
	"The name of this special option."
	shared String name,
	"The implementing class. Needs to be a [[at.dire.copter.command::Command]]."
	shared ClassDeclaration commandClass)
		satisfies SequencedAnnotation<SpecialOptionAnnotation,ClassDeclaration> {

	string => name;
}
