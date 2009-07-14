pass = method(+:tagAttributes, +tagValues,
    tag = Origin mimic
    
    tag name = currentMessage name
    tag attributes = tagAttributes
    tag value = tagValues select(kind == "Text") first
    tag innerTags = tagValues select(kind != "Text")
    tag selfIndentationLevel = 0
    tag innerIndentationLevel = 1
    
    tag increaseIndentations = method(
        selfIndentationLevel++
        innerIndentationLevel++
        innerTags each(increaseIndentations)
    )
    
    tag asText = method(
        indentation = " " * 4
        selfIndentation = indentation * selfIndentationLevel
        innerIndentation = indentation * innerIndentationLevel
        
        formatSingleTag = fnx(
            "%s<%s%:[ %s=\"%s\"%]/>\n" format(selfIndentation, name, attributes)
        )        
        
        formatValue = fnx(
            indentedValue = innerIndentation + value
            "%s<%s%:[ %s=\"%s\"%]>\n%s\n%s</%s>\n" format(selfIndentation, name, attributes, indentedValue, selfIndentation, name)
        )
        
        formatInnerTags = fnx(
            innerTags each(increaseIndentations)            
            "%s<%s%:[ %s=\"%s\"%]>\n%[%s%]\n%s</%s>\n" format(selfIndentation, name, attributes, innerTags, selfIndentation, name)
        )
        
        result = cond(
            !(value nil?), formatValue,
            !(innerTags empty?), formatInnerTags,
            formatSingleTag
        )
        
        ;; i don't know why, but a \n\n aways appears after the last inner tags
        ;; this workaround solves the problem =P
        result replace(#/\n\n/, "\n")
    )
    
    tag
)
