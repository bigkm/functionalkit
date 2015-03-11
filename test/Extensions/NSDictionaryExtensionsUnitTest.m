#import <XCTest/XCTest.h>
#import "NSDictionary+FunctionalKit.h"
#import "FKP2.h"

@interface NSDictionaryExtensions : XCTestCase
@end

@implementation NSDictionaryExtensions

- (void)testDictionaryToArray {
    NSDictionary *dict = @{@"k1": @"v1", @"k2": @"v2"};
    NSArray *expected = @[[[FKP2 alloc] initWith_1:@"k2" _2:@"v2"], [[FKP2 alloc] initWith_1:@"k1" _2:@"v1"]];
    XCTAssertEqualObjects(expected, [dict toArray]);
}

- (void)testAskingForANonExistentValueReturnsANone {
    NSDictionary *dict = @{@"key" : @"value"};
    XCTAssertTrue([[dict maybeObjectForKey:@"not_there"] isNone]);
}

- (void)testAskingForANonExistentValueReturnsASomeWithTheValue {
    NSDictionary *dict = @{@"key" : @"value"};
    FKOption *maybeValue = [dict maybeObjectForKey:@"key"];
    XCTAssertTrue([maybeValue isSome]);
    XCTAssertEqualObjects(@"value", maybeValue.some);
}

@end