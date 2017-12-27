"An advanced, *Git*-style application that provides multiple [[sub-commands|SubCommand]]."
see(`class DefaultMultiCommandApplication`,`class MultiCommandHelpCommand`)
shared interface MultiCommandApplication satisfies Application {
	"The list of available commands."
	shared formal [SubCommand+] commands;
}
