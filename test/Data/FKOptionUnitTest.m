#import <XCTest/XCTest.h>
#import "FK/FKOption.h"
#import "FK/FKMacros.h"

@interface FKOptionUnitTest : XCTestCase {
    NSObject *object;
}
@end

@implementation FKOptionUnitTest

- (void)setUp {
    object = [[NSObject alloc] init];
}

- (void)testANoneIsNone {
    XCTAssertTrue([[FKOption none] isNone]);
    XCTAssertFalse([[FKOption none] isSome]);
}

- (void)testASomeIsSome {
    XCTAssertTrue([[FKOption some:object] isSome]);
    XCTAssertFalse([[FKOption some:object] isNone]);
}

- (void)testCanPullTheSomeValueOutOfASome {
    XCTAssertEqualObjects(object, [[FKOption some:object] some]);
}

- (void)testTransformsNilsIntoNones {
    XCTAssertTrue([[FKOption fromNil:nil] isNone]);
    XCTAssertTrue([[FKOption fromNil:object] isSome]);
}

- (void)testMaps {
	XCTAssertTrue([[[FKOption none] map:^(id v) { return [v description]; }] isNone]);
	NSString *description = [object description];
	FKOption *r = [[FKOption some:object] map:^(id v) { return [v description]; }];
	XCTAssertTrue([r isSome]);	
	XCTAssertEqualObjects([r some], description);
}

- (void)testTypes {
	XCTAssertTrue([[FKOption fromNil:@"54" ofType:[NSString class]] isSome]);
	XCTAssertTrue([[FKOption fromNil:nil ofType:[NSString class]] isNone]);
	XCTAssertTrue([[FKOption fromNil:@"54" ofType:[NSArray class]] isNone]);
}

- (void)testBindingAcrossANoneGivesANone {
    id result = [[FKOption none] bind:^(id v) { return [FKOption none]; }];
    XCTAssertTrue([result isKindOfClass:[FKOption class]]);
    XCTAssertTrue([result isNone]);
}

- (void)testBindingAcrossASomeWithANoneGivesANone {
    id result = [[FKOption some:@"foo"] bind:^(id v) { return [FKOption none]; }];
    XCTAssertTrue([result isKindOfClass:[FKOption class]]);
    XCTAssertTrue([result isNone]);
}

- (void)testBindingAcrossASomeWithASomeGivesANone {
    id result = [[FKOption some:@"foo"] bind:^(id v) { return [FKOption some:v]; }];
    XCTAssertTrue([result isKindOfClass:[FKOption class]]);
    XCTAssertTrue([result isSome]);
    XCTAssertEqualObjects(@"foo", [result some]);
}

- (void)testSomes {
	NSArray *options = @[[FKOption some:@"54"], [FKOption none]];
	NSArray *somes = [FKOption somes:options];
	XCTAssertEqualObjects(@[@"54" ], somes);
}

- (BOOL)isString:(id)arg {
    return [arg isKindOfClass:[NSString class]];
}

- (void)testFilter {
    FKOption *o1 = [FKOption some:[NSNumber numberWithInt:5]];
    FKOption *o2 = [FKOption some:@"Okay"];
    XCTAssertTrue([[[FKOption none] filter:^(id v){return [self isString:v];}] isNone]);
    XCTAssertTrue([[o1 filter:^(id v){return [self isString:v];}] isNone]);
    XCTAssertTrue([[o2 filter:^(id v){return [self isString:v];}] isSome]);
}
@end
