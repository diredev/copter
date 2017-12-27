import at.dire.copter.command {
	CopyrightNotice
}
import at.dire.copter.command.util {
	buildRanges
}

import ceylon.language.meta.declaration {
	Module
}

"Annotate your module with this to include a copyright notice in the documentation output.

 Can be specified multiple times to add multiple copyright holders. You can provide a list of years for your copyright notice. Note that consecutive years will
 be converted to ranges automatically."
shared annotation CopyrightAnnotation copyright(
	"Copyright holder"
	String holder,
	"List of copyrighted years"
	Integer+ years) => CopyrightAnnotation(holder, years);

"Annotation class for [[copyright]]."
shared final annotation class CopyrightAnnotation(
	"Copyright holder"
	shared String holder,
	"List of copyrighted years"
	shared Integer[] years) satisfies SequencedAnnotation<CopyrightAnnotation,Module> {

	"Translates this annotation into a copyright notice."
	shared CopyrightNotice toCopyrightNotice() {
		value ranges = buildRanges(years);
		assert (nonempty ranges);

		return CopyrightNotice(holder, *ranges);
	}
}
