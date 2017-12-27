import at.dire.copter.command.annotations {
	CommandDocAnnotation
}
import at.dire.copter.parse.core {
	MappedAttribute
}

import ceylon.language.meta.declaration {
	AnnotatedDeclaration
}
import ceylon.language.meta.model {
	Class
}

"Extract a description for the given declaration. It does so by reading the [[doc]]- or [[at.dire.copter.command.annotations::commandDoc]]-annotations."
shared String extractDescription(AnnotatedDeclaration declaration) {
	value description = declaration.annotations<CommandDocAnnotation>().first?.description else declaration.annotations<DocAnnotation>().first?.description;

	if(exists description) {
		//TODO: Improve this and make sure to use ceylon.markdown, should they ever finish it...
		return simplifyMarkdown(description);
	} else {
		return "(no description available)";
	}
}

"Very limited utility method to improve the markdown documentation."
String simplifyMarkdown(String text) {
	value result = StringBuilder();

	// Use variables to collect spaces and newlines.
	variable Boolean inWhitespaceGroup = false;
	variable Integer numNewLines = 0;

	for(char in text) {
		// whitespace-character, including newline?
		if(char.whitespace) {
			// Count newlines for later.
			if(char == '\n') {
				numNewLines++;
			}

			inWhitespaceGroup = true;
		} else {
			// If the previous whitespace group contains at least two newlines, we add one here.
			if(inWhitespaceGroup) {
				if(numNewLines > 1) {
					result.append("\n\n");
				} else {
					// Only spaces or a single newline. Append space only.
					result.appendCharacter(' ');
				}

				// Reset whitespace variables.
				inWhitespaceGroup = false;
				numNewLines = 0;
			}

			// Not a whitespace character. Append it.
			result.appendCharacter(char);
		}
	}

	 return result.string;
}

"Extract the description of the given element."
String extractDescriptionFrom(MappedAttribute|Class<> option) {
	if(is MappedAttribute option) {
		return extractDescription(option.targetValue);
	} else {
		return extractDescription(option.declaration);
	}
}
