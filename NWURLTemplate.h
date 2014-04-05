// NWURLTemplate.h
//
// Public domain. https://github.com/nolanw/NWURLTemplate

#import <Foundation/Foundation.h>

@interface NWURLTemplate : NSObject

+ (NSURL *)URLForTemplate:(NSString *)string withObject:(id)object;

- (id)initWithString:(NSString *)string;

@property (readonly, copy, nonatomic) NSString *string;

@property (readonly, strong, nonatomic) NSError *error;

- (NSURL *)URLWithObject:(id)object;

@end

extern NSString * const NWURLTemplateRangeKey;
