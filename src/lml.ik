saveToFileMethod = syntax(
    ''(method(filename,
        FileSystem withOpenFile(filename, fn(file, file print(asText)))
    ))
)

Document = Origin mimic do(
    header = ""
    rootTag = nil
    
    initialize = method(header, rootTag,
        @header = header
        @rootTag = rootTag
    )
    
    asText = method(
        "#{header}\n\n#{rootTag}"
    )
    
    save = saveToFileMethod
)

pass = method(+:tagAttributes, +tagValues,
    tag = Origin mimic    
    
    ;; an attempt to call replaceAll directly on 'currentMessage name' causes a weird error o.O
    ;; this workaround solves the problem!
    tag name = "#{currentMessage name}" replaceAll("_", "-")  
    
    tag attributes = tagAttributes
    tag value = tagValues select(kind == "Text") first
    tag innerTags = tagValues select(kind != "Text")
    
    tag do(
        selfIndentationLevel = 0
        innerIndentationLevel = 1
        
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
                
                "%s<%s%:[ %s=\"%s\"%]>\n%s\n%s</%s>\n" format(
                    selfIndentation, name, attributes, indentedValue, selfIndentation, name)
            )
            
            formatInnerTags = fnx(
                innerTags each(increaseIndentations)            
                
                "%s<%s%:[ %s=\"%s\"%]>\n%[%s%]\n%s</%s>\n" format(
                    selfIndentation, name, attributes, innerTags, selfIndentation, name)
            )
            
            result = cond(
                !(value nil?), formatValue,
                !(innerTags empty?), formatInnerTags,
                formatSingleTag
            )
            
            ;; i don't know why, but a \n\n aways appears after the last inner tags
            ;; this workaround solves the problem!
            result replaceAll(#/\n\n/, "\n")
        )
        
        save = saveToFileMethod
    )
)

xml = method(tag, version: "1.0", encoding: "UTF-8",
    Document mimic(#[<?xml version="#{version}" encoding="#{encoding}"?>], tag)
)
