saveToFileMethod = syntax(
    ''(method(filename,
        if(FileSystem exists?(filename), FileSystem removeFile!(filename))
        FileSystem withOpenFile(filename, fn(file, file print(asText)))
    ))
)

Document = Origin mimic do(
    _header = ""
    _rootTag = nil
    
    initialize = method(header:, rootTag:,
        @_header = header
        @_rootTag = rootTag
    )
    
    save = saveToFileMethod
    
    asText = method(
        "#{_header}\n\n#{_rootTag}"
    )
)

Tag = Origin mimic do(
    _name = ""
    _attributes = {}
    _value = ""
    _innerTags = []    
    _selfIndentationLevel = 0
    _innerIndentationLevel = 1
    
    initialize = method(name:, attributes:, value:, innerTags:,
        @_name = name
        @_attributes = attributes
        @_value = value
        @_innerTags = innerTags
    )
    
    _increaseIndentations = method(
        _selfIndentationLevel++
        _innerIndentationLevel++
        _innerTags each(_increaseIndentations)
    )
    
    save = saveToFileMethod
    
    asText = method(
        indentation = " " * 4
        selfIndentation = indentation * _selfIndentationLevel
        innerIndentation = indentation * _innerIndentationLevel
        
        formatSingleTag = fnx(
            "%s<%s%:[ %s=\"%s\"%]/>\n" format(selfIndentation, _name, _attributes)
        )        
        
        formatValue = fnx(
            indentedValue = innerIndentation + _value
            
            "%s<%s%:[ %s=\"%s\"%]>\n%s\n%s</%s>\n" format(
                selfIndentation, _name, _attributes, indentedValue, selfIndentation, _name)
        )
        
        formatInnerTags = fnx(
            _innerTags each(_increaseIndentations)            
            
            "%s<%s%:[ %s=\"%s\"%]>\n%[%s%]\n%s</%s>\n" format(
                selfIndentation, _name, _attributes, _innerTags, selfIndentation, _name)
        )
        
        result = cond(
            !(_value nil?), formatValue,
            !(_innerTags empty?), formatInnerTags,
            formatSingleTag
        )
        
        ;; i don't know why, but a \n\n aways appears after the last inner tags
        ;; this workaround solves the problem!
        result replaceAll(#/\n\n/, "\n")
    )
)

pass = method(+:tagAttributes, +tagValues,
    Tag mimic(
        ;; an attempt to call replaceAll directly on 'currentMessage name' causes a weird error o.O
        ;; this workaround solves the problem!
        name: "#{currentMessage name}" replaceAll("_", "-"),
        
        attributes: tagAttributes,
        value: tagValues select(kind == "Text") first,
        innerTags: tagValues select(kind != "Text")
    )
)


;; xml support
xml = method(rootTag, version: "1.0", encoding: "UTF-8",
    Document mimic(header: #[<?xml version="#{version}" encoding="#{encoding}"?>], rootTag: rootTag)
)


;; jsp support
taglib = method(uri:, prefix:,
    #[<%@taglib uri="#{uri}" prefix="#{prefix}"%>]
)

jsp = method(contentType: "text/html;charset=UTF-8", +taglibsAndRootTag,
    page = #[<%@page language="java" contentType="#{contentType}"%>]
    taglibs = taglibsAndRootTag[0..-2]
    taglibImports = if(taglibs empty?, "", "\n\n" + taglibs join("\n"))

    Document mimic(
        header: "#{page}#{taglibImports}", 
        rootTag: taglibsAndRootTag[-1]
    )
)
