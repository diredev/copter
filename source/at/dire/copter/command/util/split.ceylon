"This method splits the given stream using a given predicate function. It then returns two sequences
 containing the elements returning true and false."
shared [[Element*], [Element*]] split<Element>({Element*} iterable, Boolean(Element) selecting) {
	// Use grouping here. TODO: This is probably not the most efficient way to do this...
	value grouped = iterable.group(selecting);
	value trueValues = grouped[true] else [];
	value falseValues = grouped[false] else [];

	return[trueValues, falseValues];
}
