Tag = Origin mimic do(
    content = ""

    pass = method(+:tagAttributes, +tagValues,
        tag = currentMessage name
        
        @content += unless(tagValues empty?,
            "<%s%:[ %s=\"%s\"%]>\n    %[%s%]\n</%s>\n" format(tag, tagAttributes, tagValues, tag),
            "<%s%:[ %s=\"%s\"%]/>\n" format(tag, tagAttributes)
        )
    )
    
    asText = method(content)
)
