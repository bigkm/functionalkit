#import <XCTest/XCTest.h>
#import "FKNewtype.h"


NEWTYPE(Age, NSString, age);
NEWTYPE(Name, NSString, name);
NEWTYPE2(Person, Age, age, Name, name);
NEWTYPE3(Position, Person, occupier, NSString, title, NSDate, started);

NEWTYPE2(Simple2, NSString, a, NSString, b); 
NEWTYPE3(Simple3, NSString, a, NSString, b, NSString, c); 

@interface FKNewtypeTests : XCTestCase
@end

@implementation FKNewtypeTests
- (void)testTypes {
	Age *age = [Age age:@"54"];
	Name *name = [Name name:@"Nick"];
	Person *nick = [Person age:age name:name];
	Position *p = [Position occupier:nick title:@"Dev" started:[NSDate date]];
	XCTAssertEqualObjects(age.age, @"54");
	XCTAssertEqualObjects(nick.name.name, @"Nick");
	XCTAssertEqualObjects(p.title, @"Dev");
}

- (void)testValidArrayCreation {
	id fromValid = NSArrayToAge([NSArray arrayWithObject:@"54"]);
    
	XCTAssertTrue([fromValid isSome]);
	XCTAssertEqualObjects([fromValid some], [Age age:@"54"]);
	
	id fromValid2 = NSArrayToPerson([NSArray arrayWithObjects:[Age age:@"54"], [Name name:@"Nick"], nil]);
	XCTAssertTrue([fromValid2 isSome]);
	XCTAssertEqualObjects([fromValid2 some], [Person age:[Age age:@"54"] name:[Name name:@"Nick"]]);
	
	id fromValid3 = NSArrayToSimple3([NSArray arrayWithObjects:@"a", @"b", @"c", nil]);
	XCTAssertTrue([fromValid3 isSome]);
	XCTAssertEqualObjects([fromValid3 some], [Simple3 a:@"a" b:@"b" c:@"c"]);
}

- (void)testWrongSizeArrayCreation {

	id fromEmpty = NSArrayToAge(@[]);
	XCTAssertTrue([fromEmpty isKindOfClass:[FKOption class]]);
	XCTAssertTrue([fromEmpty isNone]);
	
	id fromTooBig = NSArrayToAge(@[@"54", @"55"]);
	XCTAssertTrue([fromTooBig isKindOfClass:[FKOption class]]);
	XCTAssertTrue([fromTooBig isNone]);
}

- (void)testWrongTypeArrayCreation {
	id fromWrongType = NSArrayToAge(@[[NSNumber numberWithInt:54]]);
	XCTAssertTrue([fromWrongType isKindOfClass:[FKOption class]]);
	XCTAssertTrue([fromWrongType isNone]);
}

- (void)testValidDictionaryCreation {
	FKOption *result = NSDictionaryToAge(@{@"age": @"54"});
	XCTAssertTrue(result.isSome);
	XCTAssertEqualObjects(result.some,[Age age:@"54"]);
	
	result = NSDictionaryToSimple2(@{@"b": @"bval", @"a": @"aval"});
	XCTAssertTrue([result isSome]);
	XCTAssertEqualObjects([result some], [Simple2 a:@"aval" b:@"bval"]);
	
	result = NSDictionaryToSimple3(@{@"b": @"bval", @"a": @"aval", @"c": @"cval"});
	XCTAssertTrue([result isSome]);
	XCTAssertEqualObjects([result some], [Simple3 a:@"aval" b:@"bval" c:@"cval"]);
}

- (void)testInvalidDictionaryCreation {
	FKOption *result = NSDictionaryToAge(@{@"ages": @"54"});
	XCTAssertTrue(result.isNone);
}
@end

