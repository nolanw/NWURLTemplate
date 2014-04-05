// NWURLTemplate.h
//
// Public domain. https://github.com/nolanw/NWURLTemplate

#import <Foundation/Foundation.h>

/**
 * An NWURLTemplate turns a URL with variables into a proper URL per RFC 6570 - URI Template.
 *
 * For example, from a dictionary of `@{ @"year": @[ @1965, @2000, @2012 ] }`
 * with a template of `@"find{?year*}"`
 * it will expand into the URL `find?year=1965&year=2000&year=2012`.
 *
 * See http://tools.ietf.org/html/rfc6570 for all supported expansions.
 */
@interface NWURLTemplate : NSObject

/**
 * Processes a template string into a URL.
 *
 * @return The expanded URL on success, or nil if there was an error during expansion.
 */
+ (NSURL *)URLForTemplate:(NSString *)string withObject:(id)object error:(out NSError **)error;

/**
 * Designated initialzer.
 */
- (id)initWithString:(NSString *)string;

/**
 * The template string, for future expansion.
 */
@property (readonly, copy, nonatomic) NSString *string;

/**
 * The last error encountered while attempting to process the template string. If there were no errors, returns nil.
 *
 * The error's userInfo will include NWURLTemplateErrorRangeKey, which is an NSValue containing an NSRange that indicates the part of the template string where the error occurs.
 */
@property (readonly, strong, nonatomic) NSError *error;

/**
 * Returns a URL expanded from the template string with values obtained from an object using Key-Value Coding, or nil if an error occurs.
 */
- (NSURL *)URLWithObject:(id)object;

@end

extern NSString * const NWURLTemplateErrorRangeKey;
