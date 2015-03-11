#import <XCTest/XCTest.h>
#import "NSArray+FunctionalKit.h"
#import "FKP2.h"

@interface NSArrayExtensionsUnitTest : XCTestCase
@end

@implementation NSArrayExtensionsUnitTest

- (void)testCanGetTheHeadOfAnArray {
    NSArray *source = @[@"1", @"2", @"3", @"4"];
    XCTAssertEqualObjects(@"1", source.head);
}

- (void)testCanGetTheTailOfAnArray {
    NSArray *source = @[@"1", @"2", @"3", @"4"];
    NSArray *expected = @[@"2", @"3", @"4"];
    XCTAssertEqualObjects(expected, source.tail);
}

- (void)testCanGetASpanMatchingAPredicate {
    NSArray *source = @[@"1", @"1", @"2", @"4"];
    FKP2 *span = [source span:^(id v) { return [self isStringContainingOne:v]; }];
    FKP2 *expected = [[FKP2 alloc] initWith_1:@[@"1", @"1"] _2:@[@"2", @"4"]];
    XCTAssertEqualObjects(expected, span);
}

- (void)testCanTestAPredicateAgainstAllItems {
    NSArray *source = @[@"1", @"1"];
    BOOL allOnes = [source all:^(id v) { return [self isStringContainingOne:v]; }];
    XCTAssertTrue(allOnes);
}

- (void)testCanFilterUsingAPredicate {
    NSArray *source = @[@"1", @"1", @"2", @"1"];
    NSArray *onlyOnes = [source filter:^(id v) { return [self isStringContainingOne:v]; }];
    NSArray *expected = @[@"1", @"1", @"1"];
    XCTAssertEqualObjects(expected, onlyOnes);
}

- (void)testCanGroupItemsUsingAKeyFunctionIntoADictionary {
    NSArray *source = @[@"1", @"1", @"2", @"1", @"3", @"3", @"4"];
    NSDictionary *grouped = [source groupByKey:^(id v) { return [v description]; }];
    NSDictionary *expected = @{@"1": @[@"1", @"1", @"1"],@"2":@[@"2"], @"3": @[@"3", @"3"], @"4": @[@"4"]};
    XCTAssertEqualObjects(expected, grouped);
}

- (void)testCanMapAFunctionAcrossAnArray {
    id (^foo)(id) = ^(id v) { return [v uppercaseString]; };
	XCTAssertEqualObjects([@[@"test"] map:foo], @[@"TEST"]);
}

- (void)testCanCreateANewArrayByConcatenatingAnotherOne {
    NSArray *source = @[@[@"1", @"2"], @[@"3", @"4"]];
    NSArray *expected = @[@"1", @"2", @"3", @"4"];
    XCTAssertEqualObjects(expected, [NSArray concat:source]);
}

- (void)testConcatFailsOnNonArray {
    NSArray *source = @[@[@"1", @"2"], @"3"];
    XCTAssertThrows([NSArray concat:source], @"Expected concat to fail with no-array argument");
}

- (void)testCanLiftAFunctionIntoAnArray {
    NSArray *array = @[@"a", @"b", @"c"];
    id (^liftedF)(id) = [NSArray liftFunction:^(id v) { return [v uppercaseString]; }];
    NSArray *expected = @[@"A", @"B", @"C"];
    XCTAssertEqualObjects(expected, liftedF(array));
}

- (void)testCanIntersperseAnObjectWithinAnArray {
    NSArray *array = @[@"A", @"B", @"C"];
    NSArray *expected = @[@"A", @",", @"B", @",", @"C"];
    XCTAssertEqualObjects(expected, [array intersperse:@","]);
}

- (void)testCanFoldAcrossAnArray {
    NSArray *array = @[@"A", @"B", @"C"];
    XCTAssertEqualObjects(@"ABC", [array foldLeft:@"" f:^(NSString *a, NSString *b) { return [a stringByAppendingString:b]; }]);
}

- (void)testCanReverseAnArray {
    NSArray *array = @[@"A", @"B", @"C"];
    NSArray *expected = @[@"C", @"B", @"A"];
    XCTAssertEqualObjects(expected, [array reverse]);
}
//
//- (void)testCanUniquifyAnArray {
//    NSArray *array = @[@"A", @"B", @"C", @"C", @"A", @"A", @"B"];
//    XCTAssertEqualObjects(NSARRAY(@"A", @"B", @"C", [array unique]);
//}

- (void)testAnyReturnsTrue {
    BOOL (^pred)(id) = ^(id v) { return [v boolValue]; };
    NSArray *a = @[@1,@NO,@2];
    XCTAssertTrue([a any:pred]);
    a = @[@NO,@NO,@NO,@1];
    XCTAssertTrue([a any:pred]);
    a = @[@2,@1,@5,@1];
    XCTAssertTrue([a any:pred]);
}

- (void)testAnyReturnsFalse {
    BOOL (^pred)(id) = ^(id v) { return [v boolValue]; };
    NSArray *array = @[@NO, @NO, @NO];
    XCTAssertFalse([array any:pred], @"array %@ should return false", array);
}

- (void)testDropKeepsFalseEvaluations {
    NSArray *a = @[@1,@NO,@2];
    BOOL (^pred)(id) = ^(id v) { return [v boolValue]; };

    XCTAssertEqualObjects(@[@NO], [a drop:pred]);
}

- (void)testDropReturnsEmpty {
    NSArray *a = @[@1,@2,@3];
    BOOL (^pred)(id) = ^(id v) { return [v boolValue]; };

    XCTAssertEqualObjects(@[], [a drop:pred]);
}

- (void)testTakeTooMany {
    NSArray *a = @[@1,@2,@3];
    XCTAssertEqual(3U, [[a take:4] count]);
}

- (void)testTakeReturnsCorrectSizedArray {
    NSArray *a = @[@1,@2,@3];
    XCTAssertEqual(0U, [[a take:0] count]);
    XCTAssertEqual(1U, [[a take:1] count]);
    XCTAssertEqual(2U, [[a take:2] count]);
    XCTAssertEqual(3U, [[a take:3] count]);
}

- (void)testTakeFromEmptyArray {
    NSArray *a = @[];
    XCTAssertEqual(0U, [[a take:42] count]);
}

- (BOOL)isStringContainingOne:(id)string {
    return [string isEqual:@"1"];
}

@end
