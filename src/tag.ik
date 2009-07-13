Tag = Origin mimic do(
    name = nil
    attributes = nil
    innerTags = nil
    value = nil
    selfIndentationLevel = 0
    innerIndentationLevel = 1

    pass = method(+:tagAttributes, +tagValues,
        let(
            Origin tag?, false,
            Tag tag?, true,
            
            @name = currentMessage name
            @attributes = tagAttributes
            @innerTags = tagValues select(tag?)
            @value = (tagValues - innerTags) first
            
            @            
        )
    )
    
    increaseIndentations = method(
        selfIndentationLevel++
        innerIndentationLevel++
        innerTags each(increaseIndentations)
    )
    
    asText = method(
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
)
