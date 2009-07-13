use("ispec")
use("../src/tag")

describe(Tag,
    it("should render single tags",
        Tag mimic html asText should == "<html/>\n"
    )
    
    it("should render empty tags",
        expected = FileSystem readFully("fixtures/spec2")
        Tag mimic html("") asText should == expected
    )
    
    it("should render tags with content",
        expected = FileSystem readFully("fixtures/spec3")
        Tag mimic title("Lazy Markup Language") asText should == expected
    )
    
    it("should render single tags with attributes",
        Tag mimic bean(id: "fooBean") asText should == #[<bean id="fooBean"/>\n]
    )
    
    it("should render empty tags with attributes",
        expected = FileSystem readFully("fixtures/spec5")
        Tag mimic bean(id: "fooBean", "") asText should == expected
    )
    
    it("should render inner tags",
        expected = FileSystem readFully("fixtures/spec6")
    
        tag = Tag mimic html(
            Tag mimic head(
                Tag mimic title("Lazy Markup Language")
            ),
            
            Tag mimic body("Empty")
        ) 
        
        tag asText should == expected
    )
    
    it("should render inner tags with attributes",
        expected = FileSystem readFully("fixtures/spec7")
        
        tag = Tag mimic beans(
            Tag mimic bean(id: "foo", class: "com.acme.FooImpl",
                Tag mimic property(name: "id", value: "82")
            ),
            
            Tag mimic bean(id: "bar", class: "com.acme.BarImpl",
                Tag mimic property(name: "foo", ref: "foo"),
                
                Tag mimic property(name: "quux",
                    Tag mimic bean(class: "com.acme.QuuxImpl")
                )
            )
        )
        
        tag asText should == expected
    )
)
