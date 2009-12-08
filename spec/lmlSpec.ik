use("ispec")
use("../src/lml")

describe("lml",
    it("should render single tags",
        html asText should == "<html/>\n"
    )
    
    it("should render empty tags",
        expected = FileSystem readFully("fixtures/emptyTag")
        html("") asText should == expected
    )
    
    it("should render tags with content",
        expected = FileSystem readFully("fixtures/tagWithContent")
        title("Lazy Markup Language") asText should == expected
    )
    
    it("should render single tags with attributes",
        bean(id: "fooBean") asText should == #[<bean id="fooBean"/>\n]
    )
    
    it("should render empty tags with attributes",
        expected = FileSystem readFully("fixtures/tagWithAttributes")
        bean(id: "fooBean", "") asText should == expected
    )
    
    it("should render inner tags",
        expected = FileSystem readFully("fixtures/innerTag")
    
        html(
            head(
                title("Lazy Markup Language")
            ),
            
            body(
                "Empty"
            )
        ) asText should == expected
    )
    
    it("should render inner tags with attributes",
        expected = FileSystem readFully("fixtures/innerTagAttributes")
        
        beans(
            bean(id: "foo", class: "com.acme.FooImpl",
                property(name: "id", value: "82")
            ),
            
            bean(id: "bar", class: "com.acme.BarImpl",
                property(name: "foo", ref: "foo"),
                
                property(name: "quux",
                    bean(class: "com.acme.QuuxImpl")
                )
            )
        ) asText should == expected
    )
    
    it("should save the generated document to a file",
        outFile = "fixtures/out.xml";
        if(FileSystem exists?(outFile), FileSystem removeFile!(outFile))
        expected = FileSystem readFully("fixtures/innerTagAttributes")
        
        beans(
            bean(id: "foo", class: "com.acme.FooImpl",
                property(name: "id", value: "82")
            ),
            
            bean(id: "bar", class: "com.acme.BarImpl",
                property(name: "foo", ref: "foo"),
                
                property(name: "quux",
                    bean(class: "com.acme.QuuxImpl")
                )
            )
        ) save(outFile)
        
        result = FileSystem readFully(outFile)
        result should == expected
    )
    
    it("should render tags with ':' in the name, like JSP taglibs",
        expected = FileSystem readFully("fixtures/jspTags")
    
        c:choose(
            c:when(test: "${foo.a > quux.b}",
                c:out(value: "${foo.a}")
            ),
            
            c:otherwise(
                c:out(value: "${quux.b}")
            )
        ) asText should == expected
    )
    
    it("should replace '_' by '-' in message name to render tags with '-' in the name",
        expected = FileSystem readFully("fixtures/minusSignTags")
    
        beans(
            bean(id: "foo", class: "com.acme.FooImpl",
                constructor_arg(index: "0", type: "java.lang.Integer", value: "82"),
                constructor_arg(index: "1", type: "java.lang.String", value: "lerolero")
            )
        ) asText should == expected
    )
    
    it("should render default xml header",
        expected = FileSystem readFully("fixtures/xmlHeader")
        
        xml(
            web_app(
                display_name("FooWeb"),
                welcome_file_list(welcome_file("main.jsp"))
            )
        ) asText should == expected
    )
    
    it("should render especified xml header",
        expected = FileSystem readFully("fixtures/especifiedXmlHeader")
        
        xml(version: "0.9", encoding: "ISO-8859-1",
            web_app(
                display_name("FooWeb"),
                welcome_file_list(welcome_file("main.jsp"))
            )
        ) asText should == expected
    )
    
    it("should render default jsp header",
        expected = FileSystem readFully("fixtures/jspHeader")
        
        jsp(
            c:choose(
                c:when(test: "${foo.a > quux.b}",
                    c:out(value: "${foo.a}")
                ),
                
                c:otherwise(
                    c:out(value: "${quux.b}")
                )
            )
        ) asText should == expected
    )
    
    it("should render jsp header with especified contentType",
        expected = FileSystem readFully("fixtures/especifiedJspHeader")
        
        jsp(contentType: "text/xml",
            c:choose(
                c:when(test: "${foo.a > quux.b}",
                    c:out(value: "${foo.a}")
                ),
                
                c:otherwise(
                    c:out(value: "${quux.b}")
                )
            )
        ) asText should == expected
    )
    
    it("should render jsp with taglib imports",
        expected = FileSystem readFully("fixtures/jspTaglibs")
        
        jsp(
            taglib(uri: "http://java.sun.com/jsp/jstl/core", prefix: "c"),
            taglib(uri: "http://java.sun.com/jsp/jstl/functions", prefix: "fn"),
            
            ul(c:forEach(items: "${list}", var: "item",
                c:choose(
                    c:when(test: "${item.a > 140}", li("${fn:substring(item.a, 0, 140)}")),
                    c:otherwise(li("${item.a}"))
                )
            ))
        ) asText should == expected
    )
)
