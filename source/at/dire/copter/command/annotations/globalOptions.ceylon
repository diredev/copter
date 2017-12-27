import at.dire.copter.parse.core.inject {
	OptionInjectAnnotation
}


"Keyword used to inject global options."
see(`function globalOptions`)
shared String globalOptionsInjectName = "at.dire.copter.globalOptions";

"Apply to a value to [[inject|at.dire.copter.parse.core.inject::optionInject]] a [[git-style command's|at.dire.copter.command::MultiCommandApplication]] global options."
shared annotation OptionInjectAnnotation globalOptions() => OptionInjectAnnotation("at.dire.copter.globalOptions");
