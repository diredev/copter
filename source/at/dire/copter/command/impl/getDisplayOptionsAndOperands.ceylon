
import at.dire.copter.command.annotations {
	UndocumentedAnnotation
}
import at.dire.copter.parse.core {
	MappedAttribute,
	OrderedOperand,
	MappedOptions
}
import at.dire.copter.read.collect {
	AvailableOption
}

"Returns all visible options and operands, including the items of absorbed groups."
[{AvailableOption<MappedAttribute|SpecialOption>*},{OrderedOperand*}] getDisplayOptionsAndOperands<SpecialOption>(
	"List of groups, options and operands."
	MappedOptions<Anything, SpecialOption> mappedOptions,
	"True to force [[absorb|at.dire.copter.parse.core::MappedGroup.absorbed]] all groups into the top-level."
	Boolean absorbAll = false) {

	value absorbedGroups = {for(group in mappedOptions.groups) if(group.absorbed || absorbAll, exists groupMapper=group.innerMapper) getDisplayOptionsAndOperands(groupMapper) };

	// Filter out any undocumented options.
	value displayOptions = mappedOptions.options.filter((AvailableOption<MappedAttribute|SpecialOption> element) => if(is MappedAttribute key = element.key) then
			!key.targetValue.annotated<UndocumentedAnnotation>() else true);
	value displayOperands = mappedOptions.operands.filter((OrderedOperand element) => !element.key.targetValue.annotated<UndocumentedAnnotation>());

	//TODO: Skip undocumented groups!?
	// Merge with sub-groups and sort
	value allOptions = displayOptions.chain(absorbedGroups.flatMap((element) => element[0])).sort((x,y)=>x.names.first.compareIgnoringCase(y.names.first));
	value allOperands = sort(displayOperands.chain(absorbedGroups.flatMap((element) => element[1])));

	return [allOptions,allOperands];
}
