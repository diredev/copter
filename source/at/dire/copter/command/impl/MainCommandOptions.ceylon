import at.dire.copter.parse.core.annotations {
	optionGroup,
	operand
}

"Used internally to read the global options and the name of the command of *git*-style
 command-line arguments.

 Use this together with [[ReadToOperandReader]] to ignore the remainding options and operands."
shared class MainCommandOptions<GlobalOptions=Null>(
	"The global options (if any) for this command."
	optionGroup (true)
	shared GlobalOptions globalOptions,
	"The name of the command we want to execute."
	operand (0)
	shared String commandName) {}
