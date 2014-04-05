// TestExamples.m
//
// Public domain. https://github.com/nolanw/NWURLTemplate
  
#import <XCTest/XCTest.h>
#import "NWURLTemplate.h"
  
@interface TestExamples : XCTestCase
  
@end
  
@implementation TestExamples

- (void)testLevel1Examples
{
    id object = @{ @"var": @"value",
                   @"hello": @"Hello World!" };
    
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{var}"];
        NSURL *URL = [template URLWithObject:object];
        XCTAssertEqualObjects(URL.absoluteString, @"value");
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{hello}"];
        NSURL *URL = [template URLWithObject:object];
        XCTAssertEqualObjects(URL.absoluteString, @"Hello%20World%21");
    }}
}

- (void)testLevel2Examples
{
    id object = @{ @"var": @"value",
                   @"hello": @"Hello World!",
                   @"path": @"/foo/bar" };
    
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{+var}"];
        NSURL *URL = [template URLWithObject:object];
        XCTAssertEqualObjects(URL.absoluteString, @"value");
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{+hello}"];
        NSURL *URL = [template URLWithObject:object];
        XCTAssertEqualObjects(URL.absoluteString, @"Hello%20World!");
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{+path}/here"];
        NSURL *URL = [template URLWithObject:object];
        XCTAssertEqualObjects(URL.absoluteString, @"/foo/bar/here");
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"here?ref={+path}"];
        NSURL *URL = [template URLWithObject:object];
        XCTAssertEqualObjects(URL.absoluteString, @"here?ref=/foo/bar");
    }}
}

- (void)testLevel3Examples
{
    id object = @{ @"var": @"value",
                   @"hello": @"Hello World!",
                   @"empty": @"",
                   @"path": @"/foo/bar",
                   @"x": @"1024",
                   @"y": @"768" };
    
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"map?{x,y}"];
        NSURL *URL = [template URLWithObject:object];
        XCTAssertEqualObjects(URL.absoluteString, @"map?1024,768");
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{x,hello,y}"];
        NSURL *URL = [template URLWithObject:object];
        XCTAssertEqualObjects(URL.absoluteString, @"1024,Hello%20World%21,768");
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{+x,hello,y}"];
        NSURL *URL = [template URLWithObject:object];
        XCTAssertEqualObjects(URL.absoluteString, @"1024,Hello%20World!,768");
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{+path,x}/here"];
        NSURL *URL = [template URLWithObject:object];
        XCTAssertEqualObjects(URL.absoluteString, @"/foo/bar,1024/here");
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{#x,hello,y}"];
        NSURL *URL = [template URLWithObject:object];
        XCTAssertEqualObjects(URL.absoluteString, @"#1024,Hello%20World!,768");
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{#path,x}/here"];
        NSURL *URL = [template URLWithObject:object];
        XCTAssertEqualObjects(URL.absoluteString, @"#/foo/bar,1024/here");
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"X{.var}"];
        NSURL *URL = [template URLWithObject:object];
        XCTAssertEqualObjects(URL.absoluteString, @"X.value");
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"X{.x,y}"];
        NSURL *URL = [template URLWithObject:object];
        XCTAssertEqualObjects(URL.absoluteString, @"X.1024.768");
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{/var}"];
        NSURL *URL = [template URLWithObject:object];
        XCTAssertEqualObjects(URL.absoluteString, @"/value");
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{/var,x}/here"];
        NSURL *URL = [template URLWithObject:object];
        XCTAssertEqualObjects(URL.absoluteString, @"/value/1024/here");
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{;x,y}"];
        NSURL *URL = [template URLWithObject:object];
        XCTAssertEqualObjects(URL.absoluteString, @";x=1024;y=768");
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{;x,y,empty}"];
        NSURL *URL = [template URLWithObject:object];
        XCTAssertEqualObjects(URL.absoluteString, @";x=1024;y=768;empty");
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{?x,y}"];
        NSURL *URL = [template URLWithObject:object];
        XCTAssertEqualObjects(URL.absoluteString, @"?x=1024&y=768");
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{?x,y,empty}"];
        NSURL *URL = [template URLWithObject:object];
        XCTAssertEqualObjects(URL.absoluteString, @"?x=1024&y=768&empty=");
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"?fixed=yes{&x}"];
        NSURL *URL = [template URLWithObject:object];
        XCTAssertEqualObjects(URL.absoluteString, @"?fixed=yes&x=1024");
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{&x,y,empty}"];
        NSURL *URL = [template URLWithObject:object];
        XCTAssertEqualObjects(URL.absoluteString, @"&x=1024&y=768&empty=");
    }}
}

- (void)testLevel4Examples
{
    id object = @{ @"var": @"value",
                   @"hello": @"Hello World!",
                   @"path": @"/foo/bar",
                   @"list": @[ @"red", @"green", @"blue" ],
                   @"keys": @{ @"semi": @";", @"dot": @".", @"comma": @"," } };
    
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{var:3}"];
        NSURL *URL = [template URLWithObject:object];
        XCTAssertEqualObjects(URL.absoluteString, @"val");
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{var:30}"];
        NSURL *URL = [template URLWithObject:object];
        XCTAssertEqualObjects(URL.absoluteString, @"value");
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{list}"];
        NSURL *URL = [template URLWithObject:object];
        XCTAssertEqualObjects(URL.absoluteString, @"red,green,blue");
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{list*}"];
        NSURL *URL = [template URLWithObject:object];
        XCTAssertEqualObjects(URL.absoluteString, @"red,green,blue");
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{keys}"];
        NSURL *URL = [template URLWithObject:object];
        NSArray *possibilities = @[ @"comma,%2C,dot,.,semi,%3B",
                                    @"comma,%2C,semi,%3B,dot,.",
                                    @"dot,.,comma,%2C,semi,%3B",
                                    @"dot,.,semi,%3B,comma,%2C",
                                    @"semi,%3B,comma,%2C,dot,.",
                                    @"semi,%3B,dot,.,comma,%2C" ];
        XCTAssertTrue([possibilities containsObject:URL.absoluteString], @"didn't find %@", URL);
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{keys*}"];
        NSURL *URL = [template URLWithObject:object];
        NSArray *possibilities = @[ @"comma=%2C,dot=.,semi=%3B",
                                    @"comma=%2C,semi=%3B,dot=.",
                                    @"dot=.,comma=%2C,semi=%3B",
                                    @"dot=.,semi=%3B,comma=%2C",
                                    @"semi=%3B,comma=%2C,dot=.",
                                    @"semi=%3B,dot=.,comma=%2C" ];
        XCTAssertTrue([possibilities containsObject:URL.absoluteString], @"didn't find %@", URL);
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{+path:6}/here"];
        NSURL *URL = [template URLWithObject:object];
        XCTAssertEqualObjects(URL.absoluteString, @"/foo/b/here");
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{+list}"];
        NSURL *URL = [template URLWithObject:object];
        XCTAssertEqualObjects(URL.absoluteString, @"red,green,blue");
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{+list*}"];
        NSURL *URL = [template URLWithObject:object];
        XCTAssertEqualObjects(URL.absoluteString, @"red,green,blue");
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{+keys}"];
        NSURL *URL = [template URLWithObject:object];
        NSArray *possibilities = @[ @"comma,,,dot,.,semi,;",
                                    @"comma,,,semi,;,dot,.",
                                    @"dot,.,comma,,,semi,;",
                                    @"dot,.,semi,;,comma,,",
                                    @"semi,;,comma,,,dot,.",
                                    @"semi,;,dot,.,comma,," ];
        XCTAssertTrue([possibilities containsObject:URL.absoluteString], @"didn't find %@", URL);
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{+keys*}"];
        NSURL *URL = [template URLWithObject:object];
        NSArray *possibilities = @[ @"comma=,,dot=.,semi=;",
                                    @"comma=,,semi=;,dot=.",
                                    @"dot=.,comma=,,semi=;",
                                    @"dot=.,semi=;,comma=,",
                                    @"semi=;,comma=,,dot=.",
                                    @"semi=;,dot=.,comma=," ];
        XCTAssertTrue([possibilities containsObject:URL.absoluteString], @"didn't find %@", URL);
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{#path:6}/here"];
        NSURL *URL = [template URLWithObject:object];
        XCTAssertEqualObjects(URL.absoluteString, @"#/foo/b/here");
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{#list}"];
        NSURL *URL = [template URLWithObject:object];
        XCTAssertEqualObjects(URL.absoluteString, @"#red,green,blue");
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{#list*}"];
        NSURL *URL = [template URLWithObject:object];
        XCTAssertEqualObjects(URL.absoluteString, @"#red,green,blue");
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{#keys}"];
        NSURL *URL = [template URLWithObject:object];
        NSArray *possibilities = @[ @"#comma,,,dot,.,semi,;",
                                    @"#comma,,,semi,;,dot,.",
                                    @"#dot,.,comma,,,semi,;",
                                    @"#dot,.,semi,;,comma,,",
                                    @"#semi,;,comma,,,dot,.",
                                    @"#semi,;,dot,.,comma,," ];
        XCTAssertTrue([possibilities containsObject:URL.absoluteString], @"didn't find %@", URL);
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{#keys*}"];
        NSURL *URL = [template URLWithObject:object];
        NSArray *possibilities = @[ @"#comma=,,dot=.,semi=;",
                                    @"#comma=,,semi=;,dot=.",
                                    @"#dot=.,comma=,,semi=;",
                                    @"#dot=.,semi=;,comma=,",
                                    @"#semi=;,comma=,,dot=.",
                                    @"#semi=;,dot=.,comma=," ];
        XCTAssertTrue([possibilities containsObject:URL.absoluteString], @"didn't find %@", URL);
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"X{.var:3}"];
        NSURL *URL = [template URLWithObject:object];
        XCTAssertEqualObjects(URL.absoluteString, @"X.val");
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"X{.list}"];
        NSURL *URL = [template URLWithObject:object];
        XCTAssertEqualObjects(URL.absoluteString, @"X.red,green,blue");
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"X{.list*}"];
        NSURL *URL = [template URLWithObject:object];
        XCTAssertEqualObjects(URL.absoluteString, @"X.red.green.blue");
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"X{.keys}"];
        NSURL *URL = [template URLWithObject:object];
        NSArray *possibilities = @[ @"X.comma,%2C,dot,.,semi,%3B",
                                    @"X.comma,%2C,semi,%3B,dot,.",
                                    @"X.dot,.,comma,%2C,semi,%3B",
                                    @"X.dot,.,semi,%3B,comma,%2C",
                                    @"X.semi,%3B,comma,%2C,dot,.",
                                    @"X.semi,%3B,dot,.,comma,%2C" ];
        XCTAssertTrue([possibilities containsObject:URL.absoluteString], @"didn't find %@", URL);
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{/var:1,var}"];
        NSURL *URL = [template URLWithObject:object];
        XCTAssertEqualObjects(URL.absoluteString, @"/v/value");
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{/list}"];
        NSURL *URL = [template URLWithObject:object];
        XCTAssertEqualObjects(URL.absoluteString, @"/red,green,blue");
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{/list*}"];
        NSURL *URL = [template URLWithObject:object];
        XCTAssertEqualObjects(URL.absoluteString, @"/red/green/blue");
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{/list*,path:4}"];
        NSURL *URL = [template URLWithObject:object];
        XCTAssertEqualObjects(URL.absoluteString, @"/red/green/blue/%2Ffoo");
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{/keys}"];
        NSURL *URL = [template URLWithObject:object];
        NSArray *possibilities = @[ @"/comma,%2C,dot,.,semi,%3B",
                                    @"/comma,%2C,semi,%3B,dot,.",
                                    @"/dot,.,comma,%2C,semi,%3B",
                                    @"/dot,.,semi,%3B,comma,%2C",
                                    @"/semi,%3B,comma,%2C,dot,.",
                                    @"/semi,%3B,dot,.,comma,%2C" ];
        XCTAssertTrue([possibilities containsObject:URL.absoluteString], @"didn't find %@", URL);
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{/keys*}"];
        NSURL *URL = [template URLWithObject:object];
        NSArray *possibilities = @[ @"/comma=%2C/dot=./semi=%3B",
                                    @"/comma=%2C/semi=%3B/dot=.",
                                    @"/dot=./comma=%2C/semi=%3B",
                                    @"/dot=./semi=%3B/comma=%2C",
                                    @"/semi=%3B/comma=%2C/dot=.",
                                    @"/semi=%3B/dot=./comma=%2C" ];
        XCTAssertTrue([possibilities containsObject:URL.absoluteString], @"didn't find %@", URL);
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{;hello:5}"];
        NSURL *URL = [template URLWithObject:object];
        XCTAssertEqualObjects(URL.absoluteString, @";hello=Hello");
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{;list}"];
        NSURL *URL = [template URLWithObject:object];
        XCTAssertEqualObjects(URL.absoluteString, @";list=red,green,blue");
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{;list*}"];
        NSURL *URL = [template URLWithObject:object];
        XCTAssertEqualObjects(URL.absoluteString, @";list=red;list=green;list=blue");
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{;keys}"];
        NSURL *URL = [template URLWithObject:object];
        NSArray *possibilities = @[ @";keys=comma,%2C,dot,.,semi,%3B",
                                    @";keys=comma,%2C,semi,%3B,dot,.",
                                    @";keys=dot,.,comma,%2C,semi,%3B",
                                    @";keys=dot,.,semi,%3B,comma,%2C",
                                    @";keys=semi,%3B,comma,%2C,dot,.",
                                    @";keys=semi,%3B,dot,.,comma,%2C" ];
        XCTAssertTrue([possibilities containsObject:URL.absoluteString], @"didn't find %@", URL);
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{;keys*}"];
        NSURL *URL = [template URLWithObject:object];
        NSArray *possibilities = @[ @";comma=%2C;dot=.;semi=%3B",
                                    @";comma=%2C;semi=%3B;dot=.",
                                    @";dot=.;comma=%2C;semi=%3B",
                                    @";dot=.;semi=%3B;comma=%2C",
                                    @";semi=%3B;comma=%2C;dot=.",
                                    @";semi=%3B;dot=.;comma=%2C" ];
        XCTAssertTrue([possibilities containsObject:URL.absoluteString], @"didn't find %@", URL);
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{?var:3}"];
        NSURL *URL = [template URLWithObject:object];
        XCTAssertEqualObjects(URL.absoluteString, @"?var=val");
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{?list}"];
        NSURL *URL = [template URLWithObject:object];
        XCTAssertEqualObjects(URL.absoluteString, @"?list=red,green,blue");
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{?list*}"];
        NSURL *URL = [template URLWithObject:object];
        XCTAssertEqualObjects(URL.absoluteString, @"?list=red&list=green&list=blue");
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{?keys}"];
        NSURL *URL = [template URLWithObject:object];
        NSArray *possibilities = @[ @"?keys=comma,%2C,dot,.,semi,%3B",
                                    @"?keys=comma,%2C,semi,%3B,dot,.",
                                    @"?keys=dot,.,comma,%2C,semi,%3B",
                                    @"?keys=dot,.,semi,%3B,comma,%2C",
                                    @"?keys=semi,%3B,comma,%2C,dot,.",
                                    @"?keys=semi,%3B,dot,.,comma,%2C" ];
        XCTAssertTrue([possibilities containsObject:URL.absoluteString], @"didn't find %@", URL);
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{?keys*}"];
        NSURL *URL = [template URLWithObject:object];
        NSArray *possibilities = @[ @"?comma=%2C&dot=.&semi=%3B",
                                    @"?comma=%2C&semi=%3B&dot=.",
                                    @"?dot=.&comma=%2C&semi=%3B",
                                    @"?dot=.&semi=%3B&comma=%2C",
                                    @"?semi=%3B&comma=%2C&dot=.",
                                    @"?semi=%3B&dot=.&comma=%2C" ];
        XCTAssertTrue([possibilities containsObject:URL.absoluteString], @"didn't find %@", URL);
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{&var:3}"];
        NSURL *URL = [template URLWithObject:object];
        XCTAssertEqualObjects(URL.absoluteString, @"&var=val");
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{&list}"];
        NSURL *URL = [template URLWithObject:object];
        XCTAssertEqualObjects(URL.absoluteString, @"&list=red,green,blue");
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{&list*}"];
        NSURL *URL = [template URLWithObject:object];
        XCTAssertEqualObjects(URL.absoluteString, @"&list=red&list=green&list=blue");
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{&keys}"];
        NSURL *URL = [template URLWithObject:object];
        NSArray *possibilities = @[ @"&keys=comma,%2C,dot,.,semi,%3B",
                                    @"&keys=comma,%2C,semi,%3B,dot,.",
                                    @"&keys=dot,.,comma,%2C,semi,%3B",
                                    @"&keys=dot,.,semi,%3B,comma,%2C",
                                    @"&keys=semi,%3B,comma,%2C,dot,.",
                                    @"&keys=semi,%3B,dot,.,comma,%2C" ];
        XCTAssertTrue([possibilities containsObject:URL.absoluteString], @"didn't find %@", URL);
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{&keys*}"];
        NSURL *URL = [template URLWithObject:object];
        NSArray *possibilities = @[ @"&comma=%2C&dot=.&semi=%3B",
                                    @"&comma=%2C&semi=%3B&dot=.",
                                    @"&dot=.&comma=%2C&semi=%3B",
                                    @"&dot=.&semi=%3B&comma=%2C",
                                    @"&semi=%3B&comma=%2C&dot=.",
                                    @"&semi=%3B&dot=.&comma=%2C" ];
        XCTAssertTrue([possibilities containsObject:URL.absoluteString], @"didn't find %@", URL);
    }}
}

@end

