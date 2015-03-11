#import <XCTest/XCTest.h>
#import "FK/FKEither.h"
#import "FK/FKOption.h"

@interface FKEitherUnitTest : XCTestCase {
    NSObject *o1;
    NSObject *o2;
}
@end

@implementation FKEitherUnitTest

- (void)setUp {
    o1 = [[NSObject alloc] init];
    o2 = [[NSObject alloc] init];
}

- (void)testALeftIsLeft {
    FKEither *leftEither = [FKEither leftWithValue:o1];
    XCTAssertTrue(leftEither.isLeft);
    XCTAssertFalse(leftEither.isRight);
    XCTAssertEqualObjects(o1, [leftEither.swap valueOr:nil]);
}

- (void)testARightIsRight {
    FKEither *rightEither = [FKEither rightWithValue:o1];
    XCTAssertTrue(rightEither.isRight);
    XCTAssertFalse(rightEither.isLeft);
    XCTAssertEqualObjects(o1, [rightEither valueOr:nil], );
}

- (void)testTwoLeftsWithEqualValuesAreEqual {
    FKEither *l1 = [FKEither leftWithValue:o1];
    FKEither *l2 = [FKEither leftWithValue:o1];
    XCTAssertEqualObjects(l1, l2, );
}

- (void)testTwoRightsWithEqualValuesAreEqual {
    FKEither *r1 = [FKEither rightWithValue:o1];
    FKEither *r2 = [FKEither rightWithValue:o1];
    XCTAssertEqualObjects(r1, r2);
}

- (void)testTwoLeftsWithUnEqualValuesAreNotEqual {
    FKEither *l1 = [FKEither leftWithValue:o1];
    FKEither *l2 = [FKEither leftWithValue:o2];
    XCTAssertTrue([l1 isEqual:l2] == NO);
}

- (void)testTwoRightsWithUnEqualValuesAreNotEqual {
    FKEither *r1 = [FKEither rightWithValue:o1];
    FKEither *r2 = [FKEither rightWithValue:o2];
    XCTAssertTrue([r1 isEqual:r2] == NO);
}

- (void)testALeftAndARightAreNotEqual {
    FKEither *l = [FKEither leftWithValue:o1];
    FKEither *r = [FKEither rightWithValue:o1];
    XCTAssertTrue([l isEqual:r] == NO);
}

- (void)testAccessingTheRightValueInLeftThrowsAnError {
    FKEither *l = [FKEither leftWithValue:o1];
    XCTAssertThrows([l valueOrFailWithMessage:@""]);
}

- (void)testAccessingTheLeftValueInLeftThrowsAnError {
    FKEither *r = [FKEither rightWithValue:o1];
    XCTAssertThrows([r.swap valueOrFailWithMessage:@""]);
}

- (void)testAccessingTheLeftOrValue {
	FKEither *left = [FKEither leftWithValue:o1];
	FKEither *right = [FKEither rightWithValue:o1];
	XCTAssertEqualObjects([right.swap valueOr:@"54"], @"54");
	XCTAssertEqualObjects([left valueOr:@"54"], @"54");
}

- (void)testMappingAcrossTheLeft {
	FKEither *either = [FKEither leftWithValue:[NSNumber numberWithInt:54]];
	FKEither *mapped = [either.swap map:^(id v) { return [v description]; }].swap;
	XCTAssertTrue(mapped.isLeft);
	XCTAssertEqualObjects([mapped.swap valueOr:nil], @"54");
}

- (void)testMappingAcrossTheRightOfALeftIsIdentity {
	FKEither *either = [FKEither leftWithValue:[NSNumber numberWithInt:54]];
	FKEither *mapped = [either map:^(id v) { return [v description]; }];
	XCTAssertEqualObjects(either, mapped);
}

- (void)testMappingAcrossTheRight {
	FKEither *either = [FKEither rightWithValue:[NSNumber numberWithInt:54]];
	FKEither *mapped = [either map:^(id v) { return [v description]; }];
	XCTAssertTrue(mapped.isRight);
	XCTAssertEqualObjects([mapped valueOr:nil], @"54");
}

- (void)testToOption {
	FKEither *either = [FKEither rightWithValue:@"v"];
	XCTAssertTrue([[either toOption] isSome]);
	XCTAssertTrue([[either.swap toOption] isNone]);
}

- (void)testBindRightConcatentatesToProduceASingleEither {
	FKEither *either = [FKEither rightWithValue:@"v"];
    FKEither *afterBind = [either bind:^(id v) { return [self toRight:v]; }];
    XCTAssertEqualObjects(either, afterBind);
}

- (FKEither *)toLeft:(NSString *)string {
    return [FKEither leftWithValue:string];
}

- (FKEither *)toRight:(NSString *)string {
    return [FKEither rightWithValue:string];
}

@end
