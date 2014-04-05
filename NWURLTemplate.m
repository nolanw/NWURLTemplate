// NWURLTemplate.m
//
// Public domain. https://github.com/nolanw/NWURLTemplate

#import "NWURLTemplate.h"

@implementation NWURLTemplate

+ (NSURL *)URLForTemplate:(NSString *)string withObject:(id)object error:(NSError **)error
{
    return URLWithTemplateAndObject(string, object, error);
}

- (id)initWithString:(NSString *)string
{
    self = [super init];
    if (!self) return nil;
    
    _string = [string copy];
    
    return self;
}

- (NSURL *)URLWithObject:(id)object
{
    NSError *error;
    NSURL *URL = URLWithTemplateAndObject(self.string, object, &error);
    _error = error;
    return URL;
}

static NSURL * URLWithTemplateAndObject(NSString *template, id object, NSError **error)
{
    NSMutableString *accumulator = [NSMutableString new];
    NSMutableArray *errors = [NSMutableArray new];
    void (^recordError)(NSString *, NSRange) = ^(NSString *description, NSRange range) {
        if (!error) return;
        NSValue *boxedRange = [NSValue valueWithRange:range];
        [errors addObject:[NSError errorWithDomain:NSCocoaErrorDomain
                                              code:NSFormattingError
                                          userInfo:@{ NSLocalizedDescriptionKey: description,
                                                      NWURLTemplateErrorRangeKey: boxedRange }]];
    };
    
    NSScanner *scanner = [NSScanner scannerWithString:template];
    scanner.charactersToBeSkipped = nil;
    scanner.caseSensitive = YES;
    NSCharacterSet *nonliteralsCharacterSet = NonliteralsCharacterSet();
    for (;;) {
        
        // Scanning up to a nonliteral ended up being much faster than scanning literals.
        // TODO This does not check for improper percent-encodings (i.e. 0-1 hex digits after a %).
        NSString *literal;
        if ([scanner scanUpToCharactersFromSet:nonliteralsCharacterSet intoString:&literal]) {
            [accumulator appendString:EscapeLiteral(literal)];
        }
        
        NSUInteger expressionStart = scanner.scanLocation;
        if (![scanner scanString:@"{" intoString:nil]) {
            if (!scanner.isAtEnd) {
                recordError(@"Invalid literal character", NSMakeRange(scanner.scanLocation, 1));
            }
            break;
        }
        
        NSString *expression;
        [scanner scanUpToString:@"}" intoString:&expression];
        if (![scanner scanString:@"}" intoString:nil]) {
            [accumulator appendFormat:@"{%@", expression];
            recordError(@"Expression doesn't end eith }", NSMakeRange(expressionStart, scanner.scanLocation - expressionStart));
        }
        
        NSScanner *expressionScanner = [NSScanner scannerWithString:expression];
        expressionScanner.charactersToBeSkipped = nil;
        expressionScanner.caseSensitive = YES;
        unichar operator = '\0';
        ScanOperator(expressionScanner, &operator);
        
        NSString *first = @"";
        NSString *separator = @",";
        NSString *ifEmpty = @"";
        BOOL named = NO;
        NSString * (*Escape)(NSString *) = EscapeURLAndReserved;
        switch (operator) {
            case '+':
                Escape = EscapeLiteral;
                break;
            case '.':
                first = @".";
                separator = @".";
                break;
            case '/':
                first = @"/";
                separator = @"/";
                break;
            case ';':
                first = @";";
                separator = @";";
                named = YES;
                break;
            case '?':
                first = @"?";
                separator = @"&";
                named = YES;
                ifEmpty = @"=";
                break;
            case '&':
                first = @"&";
                separator = @"&";
                named = YES;
                ifEmpty = @"=";
                break;
            case '#':
                first = @"#";
                Escape = EscapeLiteral;
                break;
        }
        
        NSUInteger definedVariables = 0;
        for (NSUInteger i = 0; ; i++) {
            NSUInteger varspecStart = expressionScanner.scanLocation;
            NSString *variableName;
            if (!ScanVariableName(expressionScanner, &variableName)) {
                if (i == 0 && operator == '\0') {
                    [accumulator appendFormat:@"{%@}", expression];
                    if (expression.length == 0) {
                        recordError(@"Empty expression", NSMakeRange(expressionStart, 0));
                    } else {
                        recordError(@"Unexpected character in variable name", NSMakeRange(expressionStart, scanner.scanLocation - expressionStart));
                    }
                    break;
                } else if (expressionScanner.isAtEnd) {
                    break;
                }
            }
            
            BOOL explode = NO;
            NSUInteger prefixLength = NSUIntegerMax;
            if ([expressionScanner scanString:@"*" intoString:nil]) {
                explode = YES;
            } else if ([expressionScanner scanString:@":" intoString:nil]) {
                NSUInteger integerStart = expressionScanner.scanLocation;
                NSString *integerString;
                if ([expressionScanner scanCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] intoString:&integerString]) {
                    if (integerString.length > 4) {
                        expressionScanner.scanLocation = integerStart + 4;
                        integerString = [integerString substringToIndex:4];
                    }
                    prefixLength = [integerString integerValue];
                }
            }
            NSUInteger varspecEnd = expressionScanner.scanLocation;
            
            if (!([expressionScanner scanString:@"," intoString:nil] || expressionScanner.isAtEnd)) {
                [accumulator appendFormat:@"{%@}", expression];
                recordError(@"Expected comma or end of expression", NSMakeRange(expressionStart + expressionScanner.scanLocation, expression.length - expressionScanner.scanLocation));
                break;
            }
            
            id value;
            @try {
                
                // NSDictionary returns nil for invalid key paths, but we want NSNull to indicate undefined variables.
                value = [object valueForKeyPath:variableName] ?: [NSNull null];
            } @catch (id _) {
                
                // Most everything else throws an NSUnknownKeyException for invalid key paths. We'll make a final try by interpreting a key path as just a key.
                @try {
                    
                    // Default to NSNull again for NSDictionary.
                    value = [object valueForKey:variableName] ?: [NSNull null];
                } @catch (id _) {
                    value = [NSNull null];
                }
            }
            BOOL isCollection = [value conformsToProtocol:@protocol(NSFastEnumeration)] && [value respondsToSelector:@selector(count)];
            
            // The spec treats an empty collection as if the variable was undefined.
            if ([[NSNull null] isEqual:value] || (isCollection && [value count] == 0)) continue;
            
            // The only non-collection we handle is a string, so make sure we got a string.
            if (!isCollection) {
                value = [value description];
            }
            
            definedVariables++;
            if (definedVariables == 1) {
                [accumulator appendString:first];
            } else {
                [accumulator appendString:separator];
            }
            
            if ([value isKindOfClass:[NSString class]]) {
                if (named) {
                    [accumulator appendString:EscapeLiteral(variableName)];
                    if ([value length] == 0) {
                        [accumulator appendString:ifEmpty];
                        continue;
                    } else {
                        [accumulator appendString:@"="];
                    }
                }
                NSString *output = value;
                if (prefixLength < [value length]) {
                    output = [value substringToIndex:prefixLength];
                }
                [accumulator appendString:Escape(output)];
            } else {
                if (prefixLength != NSUIntegerMax) {
                    recordError(@"Prefix modifier \":\" is invalid for collections", NSMakeRange(expressionStart + varspecStart, varspecEnd - varspecStart));
                    continue;
                }
                
                BOOL isDictionary = isCollection && [value isKindOfClass:[NSDictionary class]];
                if (!explode) {
                    if (named) {
                        [accumulator appendString:EscapeLiteral(variableName)];
                        if ([value count] == 0) {
                            [accumulator appendString:ifEmpty];
                            continue;
                        } else {
                            [accumulator appendString:@"="];
                        }
                    }
                    NSUInteger i = 0;
                    for (id key in value) {
                        if ([[NSNull null] isEqual:key]) continue;
                        id object = key;
                        if (isDictionary) {
                            object = [value objectForKey:key];
                            if ([[NSNull null] isEqual:object]) continue;
                        }
                        if (i > 0) {
                            [accumulator appendString:@","];
                        }
                        if (isDictionary) {
                            [accumulator appendFormat:@"%@,%@", Escape([key description]), Escape([object description])];
                        } else {
                            [accumulator appendString:Escape([object description])];
                        }
                        i++;
                    }
                } else {
                    if (named) {
                        NSUInteger i = 0;
                        for (id key in value) {
                            if ([[NSNull null] isEqual:key]) continue;
                            id object = key;
                            if (isDictionary) {
                                object = [value objectForKey:key];
                                if ([[NSNull null] isEqual:object]) continue;
                            }
                            if (i > 0) {
                                [accumulator appendString:separator];
                            }
                            if (isDictionary) {
                                [accumulator appendString:EscapeLiteral([key description])];
                            } else {
                                [accumulator appendString:EscapeLiteral(variableName)];
                            }
                            if ([object description].length == 0) {
                                [accumulator appendString:ifEmpty];
                            } else {
                                [accumulator appendFormat:@"=%@", Escape([object description])];
                            }
                            i++;
                        }
                    } else {
                        NSUInteger i = 0;
                        for (id key in value) {
                            if ([[NSNull null] isEqual:key]) continue;
                            id object = key;
                            if (isDictionary) {
                                object = [value objectForKey:key];
                                if ([[NSNull null] isEqual:object]) continue;
                            }
                            if (i > 0) {
                                [accumulator appendString:separator];
                            }
                            if (isDictionary) {
                                [accumulator appendFormat:@"%@=%@", Escape([key description]), Escape([object description])];
                            } else {
                                [accumulator appendString:Escape([object description])];
                            }
                            i++;
                        }
                    }
                }
            }
        }
    }
    
    if (error) {
        if (errors.count == 1) {
            *error = errors.firstObject;
        } else if (errors.count > 1) {
            NSError *firstError = errors.firstObject;
            NSMutableDictionary *userInfo = firstError.mutableCopy;
            userInfo[NWURLTemplateSubsequentErrorsKey] = [errors subarrayWithRange:NSMakeRange(1, errors.count - 1)];
            *error = [NSError errorWithDomain:firstError.domain code:firstError.code userInfo:userInfo];
        }
    }
    
    return [NSURL URLWithString:accumulator];
}

static inline NSString * EscapeLiteral(NSString *string)
{
    string = [string stringByReplacingOccurrencesOfString:@"%(?![0-9A-Fa-f]{2})" withString:@"%25" options:NSRegularExpressionSearch range:NSMakeRange(0, string.length)];
    return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(nil, (__bridge CFStringRef)string, CFSTR("%"), nil, kCFStringEncodingUTF8);
}

static inline NSString * EscapeURLAndReserved(NSString *string)
{
    return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(nil, (__bridge CFStringRef)string, nil, CFSTR(":/?#[]@!$&'()*+,;="), kCFStringEncodingUTF8);
}

static inline BOOL ScanOperator(NSScanner *scanner, unichar *outOperator)
{
    if (scanner.isAtEnd) return NO;
    
    unichar first = [scanner.string characterAtIndex:0];
    switch (first) {
        case '+':
        case '.':
        case '/':
        case ';':
        case '?':
        case '&':
        case '#':
            scanner.scanLocation++;
            if (outOperator) *outOperator = first;
            return YES;
        default:
            return NO;
    }
}

static inline BOOL ScanVariableName(NSScanner *scanner, NSString **variableName)
{
    if (scanner.isAtEnd) return NO;
    
    NSUInteger start = scanner.scanLocation;
    NSString *candidate;
    BOOL any = [scanner scanCharactersFromSet:VarnameCharacterSet() intoString:&candidate];
    if (!any) return NO;
    if ([candidate hasPrefix:@"."] || [candidate hasSuffix:@"."]) {
        scanner.scanLocation = start;
        return NO;
    }
    
    NSRange badPercentEncodingRange = [candidate rangeOfString:@"%(?![0-9A-Fa-f]{2})" options:NSRegularExpressionSearch];
    if (badPercentEncodingRange.location != NSNotFound) {
        scanner.scanLocation = start + badPercentEncodingRange.location;
        candidate = [scanner.string substringWithRange:NSMakeRange(start, scanner.scanLocation - start)];
    }
    
    if (variableName) *variableName = candidate;
    return YES;
}

static inline NSCharacterSet * NonliteralsCharacterSet(void)
{
    NSMutableCharacterSet *nonliterals = [NSMutableCharacterSet controlCharacterSet];
    [nonliterals addCharactersInString:@" \"'%<>\\^`{|}"];
    return [nonliterals copy];
}

static inline NSCharacterSet * VarnameCharacterSet(void)
{
    return [NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_%."];
}

@end

NSString * const NWURLTemplateErrorRangeKey = @"Template error range";

NSString * const NWURLTemplateSubsequentErrorsKey = @"Subsequent errors";
