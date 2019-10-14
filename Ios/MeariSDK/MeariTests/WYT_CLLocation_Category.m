//
//  WYT_CLLocation_Category.m
//  MeariTests
//
//  Created by 李兵 on 2017/6/15.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WYMacroA.h"
#import "WYMacroB.h"
#import "CLLocation+Extension.h"

@interface WYT_CLLocation_Category : XCTestCase

@end

@implementation WYT_CLLocation_Category

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}
- (void)testwy_sortedDistanceToLocationByAscending {
    NSArray *tmpArr = @[
                        [[CLLocation alloc] initWithLatitude:0 longitude:0],
                        [[CLLocation alloc] initWithLatitude:1 longitude:1],
                        [[CLLocation alloc] initWithLatitude:2 longitude:2],
                        [[CLLocation alloc] initWithLatitude:3 longitude:3],
                        [[CLLocation alloc] initWithLatitude:4 longitude:4]
                        ];
    CLLocation *one = [[CLLocation alloc] initWithLatitude:0 longitude:1];
    [self logDistanceInLocations:tmpArr location:one];
    
    NSArray *resArr = [tmpArr wy_sortedDistanceToLocationByAscending:one];
    
    [self logDistanceInLocations:resArr location:one];
}
- (void)logDistanceInLocations:(NSArray <CLLocation *>*)locations location:(CLLocation *)location {
    for (CLLocation *l in locations) {
        CLLocationDistance d = [l distanceFromLocation:location];
        NSLog(@"%@  d:%lf", l, d);
    }
}
@end
