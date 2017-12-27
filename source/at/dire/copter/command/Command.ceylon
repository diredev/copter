"An executable command."
shared interface Command {
	"Execute the command and return an exit code."
 	shared formal Integer run();
}
