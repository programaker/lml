use("ispec")
use("../src/lml")

describe("t",
    it("should render single tags",
        t html asText should == "<html/>\n"
    )
    
    it("should render empty tags",
        expected = FileSystem readFully("fixtures/spec2")
        t html("") asText should == expected
    )
    
    it("should render tags with content",
        expected = FileSystem readFully("fixtures/spec3")
        t title("Lazy Markup Language") asText should == expected
    )
    
    it("should render single tags with attributes",
        t bean(id: "fooBean") asText should == #[<bean id="fooBean"/>\n]
    )
    
    it("should render empty tags with attributes",
        expected = FileSystem readFully("fixtures/spec5")
        t bean(id: "fooBean", "") asText should == expected
    )
    
    it("should render inner tags",
        expected = FileSystem readFully("fixtures/spec6")
    
        tag = t html(
            t head(
                t title("Lazy Markup Language")
            ),
            
            t body("Empty")
        ) 
        
        tag asText should == expected
    )
    
    it("should render inner tags with attributes",
        expected = FileSystem readFully("fixtures/spec7")
        
        tag = t beans(
            t bean(id: "foo", class: "com.acme.FooImpl",
                t property(name: "id", value: "82")
            ),
            
            t bean(id: "bar", class: "com.acme.BarImpl",
                t property(name: "foo", ref: "foo"),
                
                t property(name: "quux",
                    t bean(class: "com.acme.QuuxImpl")
                )
            )
        )
        
        tag asText should == expected
    )
)
