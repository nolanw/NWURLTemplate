// TestExtended.m
//
// Public domain. https://github.com/nolanw/NWURLTemplate
  
#import <XCTest/XCTest.h>
#import "NWURLTemplate.h"
  
@interface TestExtended : XCTestCase
  
@end
  
@implementation TestExtended

- (void)testAdditionalExamples1
{
    id object = @{ @"id": @"person",
                   @"token": @"12345",
                   @"fields": @[ @"id", @"name", @"picture" ],
                   @"format": @"json",
                   @"q": @"URI Templates",
                   @"page": @"5",
                   @"lang": @"en",
                   @"geocode": @[ @"37.76", @"-122.427" ],
                   @"first_name": @"John",
                   @"last.name": @"Doe",
                   @"Some%20Thing": @"foo",
                   @"number": @6,
                   @"long": @37.76,
                   @"lat": @-122.427,
                   @"group_id": @"12345",
                   @"query": @"PREFIX dc: <http://purl.org/dc/elements/1.1/> SELECT ?book ?who WHERE { ?book dc:creator ?who }",
                   @"uri": @"http://example.org/?uri=http%3A%2F%2Fexample.org%2F",
                   @"word": @"drücken",
                   @"Stra%C3%9Fe": @"Grüner Weg",
                   @"random": @"šöäŸœñê€£¥‡ÑÒÓÔÕÖ×ØÙÚàáâãäåæçÿ",
                   @"assoc_special_chars": @{ @"šöäŸœñê€£¥‡ÑÒÓÔÕ": @"Ö×ØÙÚàáâãäåæçÿ" } };
    
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{/id*}"];
        NSURL *URL = [template URLWithObject:object];
        XCTAssertEqualObjects(URL.absoluteString, @"/person");
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{/id*}{?fields,first_name,last.name,token}"];
        NSURL *URL = [template URLWithObject:object];
        NSArray *possibilities = @[ @"/person?fields=id,name,picture&first_name=John&last.name=Doe&token=12345",
                                    @"/person?fields=id,picture,name&first_name=John&last.name=Doe&token=12345",
                                    @"/person?fields=picture,name,id&first_name=John&last.name=Doe&token=12345",
                                    @"/person?fields=picture,id,name&first_name=John&last.name=Doe&token=12345",
                                    @"/person?fields=name,picture,id&first_name=John&last.name=Doe&token=12345",
                                    @"/person?fields=name,id,picture&first_name=John&last.name=Doe&token=12345" ];
        XCTAssertTrue([possibilities containsObject:URL.absoluteString], @"didn't find %@", URL);
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"/search.{format}{?q,geocode,lang,locale,page,result_type}"];
        NSURL *URL = [template URLWithObject:object];
        NSArray *possibilities = @[ @"/search.json?q=URI%20Templates&geocode=37.76,-122.427&lang=en&page=5",
                                    @"/search.json?q=URI%20Templates&geocode=-122.427,37.76&lang=en&page=5" ];
        XCTAssertTrue([possibilities containsObject:URL.absoluteString], @"didn't find %@", URL);
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"/test{/Some%20Thing}"];
        NSURL *URL = [template URLWithObject:object];
        XCTAssertEqualObjects(URL.absoluteString, @"/test/foo");
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"/set{?number}"];
        NSURL *URL = [template URLWithObject:object];
        XCTAssertEqualObjects(URL.absoluteString, @"/set?number=6");
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"/loc{?long,lat}"];
        NSURL *URL = [template URLWithObject:object];
        XCTAssertEqualObjects(URL.absoluteString, @"/loc?long=37.76&lat=-122.427");
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"/base{/group_id,first_name}/pages{/page,lang}{?format,q}"];
        NSURL *URL = [template URLWithObject:object];
        XCTAssertEqualObjects(URL.absoluteString, @"/base/12345/John/pages/5/en?format=json&q=URI%20Templates");
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"/sparql{?query}"];
        NSURL *URL = [template URLWithObject:object];
        XCTAssertEqualObjects(URL.absoluteString, @"/sparql?query=PREFIX%20dc%3A%20%3Chttp%3A%2F%2Fpurl.org%2Fdc%2Felements%2F1.1%2F%3E%20SELECT%20%3Fbook%20%3Fwho%20WHERE%20%7B%20%3Fbook%20dc%3Acreator%20%3Fwho%20%7D");
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"/go{?uri}"];
        NSURL *URL = [template URLWithObject:object];
        XCTAssertEqualObjects(URL.absoluteString, @"/go?uri=http%3A%2F%2Fexample.org%2F%3Furi%3Dhttp%253A%252F%252Fexample.org%252F");
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"/service{?word}"];
        NSURL *URL = [template URLWithObject:object];
        XCTAssertEqualObjects(URL.absoluteString, @"/service?word=dr%C3%BCcken");
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"/lookup{?Stra%C3%9Fe}"];
        NSURL *URL = [template URLWithObject:object];
        XCTAssertEqualObjects(URL.absoluteString, @"/lookup?Stra%C3%9Fe=Gr%C3%BCner%20Weg");
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{random}"];
        NSURL *URL = [template URLWithObject:object];
        XCTAssertEqualObjects(URL.absoluteString, @"%C5%A1%C3%B6%C3%A4%C5%B8%C5%93%C3%B1%C3%AA%E2%82%AC%C2%A3%C2%A5%E2%80%A1%C3%91%C3%92%C3%93%C3%94%C3%95%C3%96%C3%97%C3%98%C3%99%C3%9A%C3%A0%C3%A1%C3%A2%C3%A3%C3%A4%C3%A5%C3%A6%C3%A7%C3%BF");
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{?assoc_special_chars*}"];
        NSURL *URL = [template URLWithObject:object];
        XCTAssertEqualObjects(URL.absoluteString, @"?%C5%A1%C3%B6%C3%A4%C5%B8%C5%93%C3%B1%C3%AA%E2%82%AC%C2%A3%C2%A5%E2%80%A1%C3%91%C3%92%C3%93%C3%94%C3%95=%C3%96%C3%97%C3%98%C3%99%C3%9A%C3%A0%C3%A1%C3%A2%C3%A3%C3%A4%C3%A5%C3%A6%C3%A7%C3%BF");
    }}
}

- (void)testAdditionalExamples2
{
    id object = @{ @"id": @[ @"person", @"albums" ],
                   @"token": @"12345",
                   @"fields": @[ @"id", @"name", @"picture" ],
                   @"format": @"atom",
                   @"q": @"URI Templates",
                   @"page": @"10",
                   @"start": @"5",
                   @"lang": @"en",
                   @"geocode": @[ @"37.76", @"-122.427" ] };
    
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{/id*}"];
        NSURL *URL = [template URLWithObject:object];
        NSArray *possibilities = @[ @"/person/albums",
                                    @"/albums/person" ];
        XCTAssertTrue([possibilities containsObject:URL.absoluteString], @"didn't find %@", URL);
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{/id*}{?fields,token}"];
        NSURL *URL = [template URLWithObject:object];
        NSArray *possibilities = @[ @"/person/albums?fields=id,name,picture&token=12345",
                                    @"/person/albums?fields=id,picture,name&token=12345",
                                    @"/person/albums?fields=picture,name,id&token=12345",
                                    @"/person/albums?fields=picture,id,name&token=12345",
                                    @"/person/albums?fields=name,picture,id&token=12345",
                                    @"/person/albums?fields=name,id,picture&token=12345",
                                    @"/albums/person?fields=id,name,picture&token=12345",
                                    @"/albums/person?fields=id,picture,name&token=12345",
                                    @"/albums/person?fields=picture,name,id&token=12345",
                                    @"/albums/person?fields=picture,id,name&token=12345",
                                    @"/albums/person?fields=name,picture,id&token=12345",
                                    @"/albums/person?fields=name,id,picture&token=12345" ];
        XCTAssertTrue([possibilities containsObject:URL.absoluteString], @"didn't find %@", URL);
    }}
}

- (void)testAdditionalExamples3EmptyVariables
{
    id object = @{ @"empty_list": @[  ],
                   @"empty_assoc": @{  } };
    
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{/empty_list}"];
        NSURL *URL = [template URLWithObject:object];
        NSArray *possibilities = @[ @"" ];
        XCTAssertTrue([possibilities containsObject:URL.absoluteString], @"didn't find %@", URL);
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{/empty_list*}"];
        NSURL *URL = [template URLWithObject:object];
        NSArray *possibilities = @[ @"" ];
        XCTAssertTrue([possibilities containsObject:URL.absoluteString], @"didn't find %@", URL);
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{?empty_list}"];
        NSURL *URL = [template URLWithObject:object];
        NSArray *possibilities = @[ @"" ];
        XCTAssertTrue([possibilities containsObject:URL.absoluteString], @"didn't find %@", URL);
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{?empty_list*}"];
        NSURL *URL = [template URLWithObject:object];
        NSArray *possibilities = @[ @"" ];
        XCTAssertTrue([possibilities containsObject:URL.absoluteString], @"didn't find %@", URL);
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{?empty_assoc}"];
        NSURL *URL = [template URLWithObject:object];
        NSArray *possibilities = @[ @"" ];
        XCTAssertTrue([possibilities containsObject:URL.absoluteString], @"didn't find %@", URL);
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{?empty_assoc*}"];
        NSURL *URL = [template URLWithObject:object];
        NSArray *possibilities = @[ @"" ];
        XCTAssertTrue([possibilities containsObject:URL.absoluteString], @"didn't find %@", URL);
    }}
}

- (void)testAdditionalExamples4NumericKeys
{
    id object = @{ @"42": @"The Answer to the Ultimate Question of Life, the Universe, and Everything",
                   @"1337": @[ @"leet", @"as", @"it", @"can", @"be" ],
                   @"german": @{ @"11": @"elf", @"12": @"zwölf" } };
    
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{42}"];
        NSURL *URL = [template URLWithObject:object];
        XCTAssertEqualObjects(URL.absoluteString, @"The%20Answer%20to%20the%20Ultimate%20Question%20of%20Life%2C%20the%20Universe%2C%20and%20Everything");
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{?42}"];
        NSURL *URL = [template URLWithObject:object];
        XCTAssertEqualObjects(URL.absoluteString, @"?42=The%20Answer%20to%20the%20Ultimate%20Question%20of%20Life%2C%20the%20Universe%2C%20and%20Everything");
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{1337}"];
        NSURL *URL = [template URLWithObject:object];
        XCTAssertEqualObjects(URL.absoluteString, @"leet,as,it,can,be");
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{?1337*}"];
        NSURL *URL = [template URLWithObject:object];
        XCTAssertEqualObjects(URL.absoluteString, @"?1337=leet&1337=as&1337=it&1337=can&1337=be");
    }}
    {{
        NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:@"{?german*}"];
        NSURL *URL = [template URLWithObject:object];
        NSArray *possibilities = @[ @"?11=elf&12=zw%C3%B6lf",
                                    @"?12=zw%C3%B6lf&11=elf" ];
        XCTAssertTrue([possibilities containsObject:URL.absoluteString], @"didn't find %@", URL);
    }}
}

@end

