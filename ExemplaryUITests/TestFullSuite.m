//
//  TestFullSuite.m
//  Formulary
//
//  Created by Fabian Canas on 12/30/15.
//  Copyright © 2015 Fabian Canas. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface TestFullSuite : XCTestCase

@end

@implementation TestFullSuite

- (void)setUp
{
    [super setUp];
    self.continueAfterFailure = NO;
    [[[XCUIApplication alloc] init] launch];
}

- (void)testFullExampleForm
{
    XCUIApplication *app = [[XCUIApplication alloc] init];
    XCUIElementQuery *tablesQuery = app.tables;
    [tablesQuery.textFields[@"Name"] tap];
    [tablesQuery.textFields[@"Name"] typeText:@"Testy"];
    XCTAssertTrue(tablesQuery.textFields[@"Name, Testy"].exists);
    
    [tablesQuery.textFields[@"Email"] tap];

    [tablesQuery.textFields[@"Email"] typeText:@"Test@example.com"];

    XCTAssertTrue(tablesQuery.textFields[@"Email, Test@example.com"].exists);
    
    [tablesQuery.textFields[@"Age"] tap];
    [tablesQuery.textFields[@"Age"] typeText:@"28"];
    XCTAssertTrue(tablesQuery.textFields[@"Age, 28"].exists);
    
    XCUIElement *favoriteNumberTextField = tablesQuery.textFields[@"Favorite Number"];
    [favoriteNumberTextField tap];
    [favoriteNumberTextField typeText:@"12"];
    // Drag to lose focus
    [[[tablesQuery childrenMatchingType:XCUIElementTypeCell] elementBoundByIndex:0] pressForDuration:0 thenDragToElement:[[tablesQuery childrenMatchingType:XCUIElementTypeCell] elementBoundByIndex:1]];
    XCTAssertTrue(tablesQuery.textFields[@"Favorite Number, 12, Your favorite number must be at least 47"].exists);
    
    [tablesQuery.switches[@"Do you like goats?"] tap];
    
    XCUIElement *otherThoughtsTextField = tablesQuery.textFields[@"Other Thoughts?"];
    [otherThoughtsTextField tap];
    [otherThoughtsTextField typeText:@"Some thoughts"];

    [tablesQuery.staticTexts[@"Pizza"] tap];
    [tablesQuery.staticTexts[@"Ice Cream"] tap];
    [tablesQuery.staticTexts[@"Ice Cream"] pressForDuration:0 thenDragToElement:tablesQuery.switches[@"Do you like goats?"]];
    
    [tablesQuery.pickerWheels.element adjustToPickerWheelValue:@"Ravenclaw"];
    
    [[tablesQuery.cells containingType:XCUIElementTypeButton identifier:@"Show Values"].element tap];
    
    XCUIElement *formValuesAlert = app.alerts[@"Form Values"];
    XCUIElement *staticTextResult = formValuesAlert.staticTexts[@"{\"likesGoats\":true,\"Food\":[\"Ice Cream\",\"Pizza\"],\"age\":\"28\",\"favoriteNumber\":\"12\",\"House\":\"Ravenclaw\",\"email\":\"Test@example.com\",\"thoughts\":\"Some thoughts\",\"name\":\"Testy\"}"];
    XCTAssertTrue(staticTextResult.exists);
    
    [formValuesAlert.collectionViews.buttons[@"Ok"] tap];
}

@end
