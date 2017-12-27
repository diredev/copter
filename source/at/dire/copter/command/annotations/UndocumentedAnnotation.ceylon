import ceylon.language.meta.declaration {
	ValueDeclaration
}

"Use this annotation to mark [[options|at.dire.copter.parse.core.annotations::option]], [[operands|at.dire.copter.parse.core.annotations::operand]] and even
 [[groups|at.dire.copter.parse.core.annotations::optionGroup]] and [[commands|at.dire.copter.command.annotations::command]] as undocumented.
 They will be skipped when printing documentation."
shared annotation UndocumentedAnnotation undocumented() => UndocumentedAnnotation();

"Annotation class for [[undocumented]]."
shared final annotation class UndocumentedAnnotation() satisfies OptionalAnnotation<UndocumentedAnnotation,ValueDeclaration> {}
