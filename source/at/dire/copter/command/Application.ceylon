"Command line application."
see(`interface MultiCommandApplication`, `interface Command`, `class BasicApplication`)
shared interface Application {
	"List of provided special options."
	shared formal SubCommand[] specialOptions;

	"Return additional information on your application."
	shared formal ApplicationInfo getInfo();

	"Interpret the command line, perform your action and return an exit code.

	 This must also take care of handling special-options (like `--help`) if needed."
	shared formal Integer run({String*} arguments);
}
