// Profiler.m
//
// Public domain. https://github.com/nolanw/NWURLTemplate

#import "NWURLTemplate.h"
#import <mach/mach_time.h>

static NSTimeInterval Time(NSUInteger reps, void (^block)(void))
{
    static mach_timebase_info_data_t timebaseInfo;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mach_timebase_info(&timebaseInfo);
    });
    
    uint64_t elapsed = 0;
    for (NSUInteger i = 0; i < reps; i++) {
        uint64_t start = mach_absolute_time();
        block();
        uint64_t end = mach_absolute_time();
        elapsed += (end - start);
    }
    
    return (NSTimeInterval)elapsed * timebaseInfo.numer / timebaseInfo.denom / 1e9;
}

int main(void) { @autoreleasepool {
    NSTimeInterval totalTime = 0;
    NSString *fixturePath = [[@(__FILE__) stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"uritemplate-test"];
    NSArray *testFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:fixturePath error:nil];
    for (NSString *filename in testFiles) {
        if (![filename.pathExtension isEqual:@"json"]) continue;
        NSString *path = [fixturePath stringByAppendingPathComponent:filename];
        NSInputStream *stream = [NSInputStream inputStreamWithFileAtPath:path];
        [stream open];
        NSDictionary *groups = [NSJSONSerialization JSONObjectWithStream:stream options:0 error:nil];
        for (NSDictionary *group in groups.allValues) {
            id object = group[@"variables"];
            for (NSArray *test in group[@"testcases"]) {
                NSString *template = test.firstObject;
                totalTime += Time(5, ^{ [NWURLTemplate URLForTemplate:template withObject:object error:nil]; });
            }
        }
    }
    NSLog(@"Total exploding time: %gs", totalTime);
    return 0;
}}
