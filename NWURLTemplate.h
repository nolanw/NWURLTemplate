// NWURLTemplate.h
//
// Public domain. https://github.com/nolanw/NWURLTemplate

#import <Foundation/Foundation.h>

/**
 * An NWURLTemplate turns a URL with variables into a proper URL per RFC 6570 - URI Template.
 *
 * For example, given the dictionary:
 *
 *     NSDictionary *context = @{ @"hello": @"Hello World!",
 *                                @"path": @"/foo/bar",
 *                                @"x": @1024,
 *                                @"y": @768,
 *                                @"colors": @[ @"red", @"green", @"blue" ],
 *                                @"punctuation": @{ @"semicolon": @";", @"dot": @".", @"comma": @"," } }
 *
 * the following templates are proccessed as follows:
 *
 *     {hello}         => Hello%20World%21
 *     {hello:3}       => Hel
 *     {punctuation}   => semicolon,%3B,dot,.,comma,%2C
 *     {+punctuation}  => semicolon,;,dot,.,comma,,
 *     {+punctuation*} => semicolon=;,dot=.,comma=,
 *     {#path:6}/here  => #/foo/b/here
 *     X{.colors}      => X.red,green,blue
 *     {/colors*}      => /red/green/blue
 *     {;hello:5}      => ;hello=Hello
 *     {?hello:5,x,y}  => ?hello=Hello&x=1024&y=768
 *     {&hello:4,colors*} => &hello=hell&colors=red&colors=green&colors=blue
 *
 * which you may obtain with, for example,
 *
 *     [NWURLTemplate URLForTemplate:@"{/colors*}" withObject:context error:nil]
 *
 * Please see http://tools.ietf.org/html/rfc6570 for more information.
 */
@interface NWURLTemplate : NSObject

/**
 * Processes a template string into a URL.
 *
 * @param string A template string conforming to RFC 6570.
 * @param object The Key-Value Coding-compliant source of variables for template processing.
 * @param error  When not NULL, contains error information if template processing fails. The error is in the NSCocoaErrorDomain, has code NSFormattingError, and its userInfo dictionary will include NWURLTemplateErrorRangeKey and may include NWURLTemplateSubsequentErrorsKey.
 *
 * @return The resulting URL, or nil if there was an error during template processing.
 */
+ (NSURL *)URLForTemplate:(NSString *)string withObject:(id)object error:(out NSError **)error;

/**
 * Designated initialzer.
 */
- (id)initWithString:(NSString *)string;

/**
 * The template string, for future processing.
 */
@property (readonly, copy, nonatomic) NSString *string;

/**
 * The first error encountered while attempting to process the template string, or nil if there were no errors. Subsequent errors can be found in the first error's userInfo dictionary under the NWURLTemplateSubsequentErrorsKey. All errors are in the NSCocoaErrorDomain, have code NSFormattingError, and their userInfo dictionaries all have the NWURLTemplateErrorRangeKey.
 */
@property (readonly, strong, nonatomic) NSError *error;

/**
 * Returns a URL expanded from the template string with values obtained from an object using Key-Value Coding, or nil if an error occurs.
 */
- (NSURL *)URLWithObject:(id)object;

@end

/**
 * An NSValue containing an NSRange that indicates the part of the template string where the error occurred.
 */
extern NSString * const NWURLTemplateErrorRangeKey;

/**
 * An NSArray listing the other errors that occurred during processing.
 */
extern NSString * const NWURLTemplateSubsequentErrorsKey;
