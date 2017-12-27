"This utility method translates an attribute name to a long-option name, i.e. change all characters
 to lowercase and add hyphens in between words."
shared String toOptionName(String memberName) {
	value firstChar = memberName.first;
	
	"Invalid argument. Must have at least one character."
	assert(exists firstChar);
	
	value result = StringBuilder();
	result.appendCharacter(firstChar.lowercased);
	
	for(char in memberName.rest) {
		if(char.uppercase) {
			// For every upper-case character, we 
			result.appendCharacter('-').appendCharacter(char.lowercased);
		} else {
			// Append the character normally.
			result.appendCharacter(char);
		}
	}
	
	return result.string;
}