# NWURLTemplate

An implementation of [RFC 6570 – URI Template][RFC 6570] Level 4 in Objective-C and Foundation.

[RFC 6570]: http://tools.ietf.org/html/rfc6570

## Usage

```objc
#import "NWURLTemplate.h"

id object = @{ @"tip": @"Talk loudly", @"when": @"today" };
NSURL *URL = [NWURLTemplate URLForTemplate:@"example.org/thinger{?when,tip}" withObject:object];
NSLog(@"%@", URL); // => example.org/thinger?when=today&tip=Talk%20Loudly
```

## Why

URI templates seem useful, and implementing them seemed like a good one-day project.

I chose to call them "URL templates" in this library because they return instances of `NSURL`.

## The alternatives

[CSURITemplate](https://github.com/cogenta/CSURITemplate) seems to be the most mature. There is also [URITemplateKit](https://github.com/BennettSmith/URITemplateKit), and [part of some code called "CitySDK Tourism Client API in Objective-C"](https://github.com/pcruz7/citysdk-wp5-objc/blob/master/UriTemplate.h).

## Installation

One of:

* Copy `NWURLTemplate.h` and `NWURLTemplate.m` into your project.
* Add the following line to your [Podfile][]:
    
    `pod "NWURLTemplate", :git => "https://github.com/nolanw/NWURLTemplate"`

[Podfile]: http://docs.cocoapods.org/podfile.html#pod

## Does it work?

NWURLTemplate continuously runs all [URI Template Tests][] on iOS 7 and OS X version 10.9 and 10.8. NWURLTemplate is continuously built (but not tested, due to XCTest's availability) on iOS versions 6.1 and 5.1. [![Build Status](https://travis-ci.org/nolanw/NWURLTemplate.png?branch=master)](https://travis-ci.org/nolanw/NWURLTemplate)

The tests are transformed by [a script](Tests/Support/transform-tests.rb) into XCTest test cases, with the [resulting](Tests/TestExamples.m) [test](Tests/TestExtended.m) [classes](Tests/TestNegative.m) included in this repository. The URI Template Tests are included as a submodule but are not necessary for running tests. If you do pull updated tests from the URI Template Tests repository, update the submodule then run the transformation script.

[URI Template Tests]: https://github.com/uri-templates/uritemplate-test
