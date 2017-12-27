//TODO: Cannot use ranges or sub-structures as a sequence. Is this a Ceylon bug...?

"A basic copyright notice line, consisting of a copyright holder and a list of years. Will be printed as ranges automatically."
shared class CopyrightNotice(
	"The copyright holder."
	String holder,
	"List of single years or year ranges."
	Range<Integer>+ years) {
	shared actual String string {
		value formattedRanges = { for (range in years) if (range.longerThan(1)) then "``range.first``-``range.last``" else range.first };
		return "Copyright (C) ``(", ".join(formattedRanges))`` ``holder``";
	}
}
