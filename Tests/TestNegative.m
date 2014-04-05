// TestNegative.m
//
// Public domain. https://github.com/nolanw/NWURLTemplate
  
#import <XCTest/XCTest.h>
#import "NWURLTemplate.h"
  
@interface TestNegative : XCTestCase
  
@end
  
@implementation TestNegative

- (void)testFailureTests
{
    id object = @{ @"id": @"thing",
                   @"var": @"value",
                   @"hello": @"Hello World!",
                   @"with space": @"fail",
                   @" leading_space": @"Hi!",
                   @"trailing_space ": @"Bye!",
                   @"empty": @"",
                   @"path": @"/foo/bar",
                   @"x": @"1024",
                   @"y": @"768",
                   @"list": @[ @"red", @"green", @"blue" ],
                   @"keys": @{ @"semi": @";", @"dot": @".", @"comma": @"," },
                   @"example": @"red",
                   @"searchTerms": @"uri templates",
                   @"~thing": @"some-user",
                   @"default-graph-uri": @[ @"http://www.example/book/", @"http://www.example/papers/" ],
                   @"query": @"PREFIX dc: <http://purl.org/dc/elements/1.1/> SELECT ?book ?who WHERE { ?book dc:creator ?who }" };
    
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{/id*"];
        NSURL *URL = [template URLWithObject:object];
        (void)URL;
        XCTAssertNotNil(template.error);
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"/id*}"];
        NSURL *URL = [template URLWithObject:object];
        (void)URL;
        XCTAssertNotNil(template.error);
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{/?id}"];
        NSURL *URL = [template URLWithObject:object];
        (void)URL;
        XCTAssertNotNil(template.error);
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{var:prefix}"];
        NSURL *URL = [template URLWithObject:object];
        (void)URL;
        XCTAssertNotNil(template.error);
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{hello:2*}"];
        NSURL *URL = [template URLWithObject:object];
        (void)URL;
        XCTAssertNotNil(template.error);
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{??hello}"];
        NSURL *URL = [template URLWithObject:object];
        (void)URL;
        XCTAssertNotNil(template.error);
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{!hello}"];
        NSURL *URL = [template URLWithObject:object];
        (void)URL;
        XCTAssertNotNil(template.error);
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{with space}"];
        NSURL *URL = [template URLWithObject:object];
        (void)URL;
        XCTAssertNotNil(template.error);
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{ leading_space}"];
        NSURL *URL = [template URLWithObject:object];
        (void)URL;
        XCTAssertNotNil(template.error);
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{trailing_space }"];
        NSURL *URL = [template URLWithObject:object];
        (void)URL;
        XCTAssertNotNil(template.error);
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{=path}"];
        NSURL *URL = [template URLWithObject:object];
        (void)URL;
        XCTAssertNotNil(template.error);
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{$var}"];
        NSURL *URL = [template URLWithObject:object];
        (void)URL;
        XCTAssertNotNil(template.error);
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{|var*}"];
        NSURL *URL = [template URLWithObject:object];
        (void)URL;
        XCTAssertNotNil(template.error);
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{*keys?}"];
        NSURL *URL = [template URLWithObject:object];
        (void)URL;
        XCTAssertNotNil(template.error);
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{?empty=default,var}"];
        NSURL *URL = [template URLWithObject:object];
        (void)URL;
        XCTAssertNotNil(template.error);
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{var}{-prefix|/-/|var}"];
        NSURL *URL = [template URLWithObject:object];
        (void)URL;
        XCTAssertNotNil(template.error);
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"?q={searchTerms}&amp;c={example:color?}"];
        NSURL *URL = [template URLWithObject:object];
        (void)URL;
        XCTAssertNotNil(template.error);
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"x{?empty|foo=none}"];
        NSURL *URL = [template URLWithObject:object];
        (void)URL;
        XCTAssertNotNil(template.error);
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"/h{#hello+}"];
        NSURL *URL = [template URLWithObject:object];
        (void)URL;
        XCTAssertNotNil(template.error);
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"/h#{hello+}"];
        NSURL *URL = [template URLWithObject:object];
        (void)URL;
        XCTAssertNotNil(template.error);
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{keys:1}"];
        NSURL *URL = [template URLWithObject:object];
        (void)URL;
        XCTAssertNotNil(template.error);
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{+keys:1}"];
        NSURL *URL = [template URLWithObject:object];
        (void)URL;
        XCTAssertNotNil(template.error);
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{;keys:1*}"];
        NSURL *URL = [template URLWithObject:object];
        (void)URL;
        XCTAssertNotNil(template.error);
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"?{-join|&|var,list}"];
        NSURL *URL = [template URLWithObject:object];
        (void)URL;
        XCTAssertNotNil(template.error);
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"/people/{~thing}"];
        NSURL *URL = [template URLWithObject:object];
        (void)URL;
        XCTAssertNotNil(template.error);
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"/{default-graph-uri}"];
        NSURL *URL = [template URLWithObject:object];
        (void)URL;
        XCTAssertNotNil(template.error);
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"/sparql{?query,default-graph-uri}"];
        NSURL *URL = [template URLWithObject:object];
        (void)URL;
        XCTAssertNotNil(template.error);
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"/sparql{?query){&default-graph-uri*}"];
        NSURL *URL = [template URLWithObject:object];
        (void)URL;
        XCTAssertNotNil(template.error);
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"/resolution{?x, y}"];
        NSURL *URL = [template URLWithObject:object];
        (void)URL;
        XCTAssertNotNil(template.error);
    }}
}

@end

