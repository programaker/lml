Tag = Origin mimic do(
    ;;content = ""
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
    
        ;;tag = currentMessage name
        
        ;;@content += unless(tagValues empty?,
            ;;"<%s%:[ %s=\"%s\"%]>\n    %[%s%]\n</%s>\n" format(tag, tagAttributes, tagValues, tag),
            ;;"<%s%:[ %s=\"%s\"%]/>\n" format(tag, tagAttributes)
        ;;)
    )
    
    increaseIndentations = method(
        selfIndentationLevel++
        innerIndentationLevel++
    )
    
    asText = method(
        ;;content
        
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
            innerTags each(tag, tag increaseIndentations)            
            "%s<%s%:[ %s=\"%s\"%]>\n%[%s%]\n%s</%s>\n" format(selfIndentation, name, attributes, innerTags, selfIndentation, name)
        )
        
        cond(
            !(value nil?), formatValue,
            !(innerTags empty?), formatInnerTags,
            formatSingleTag
        )
    )
)
