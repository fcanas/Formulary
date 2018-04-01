//
//  TestFullSuite.m
//  Formulary
//
//  Created by Fabian Canas on 12/30/15.
//  Copyright © 2015 Fabian Canas. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface TestFullSuite : XCTestCase
@property (nonatomic) XCUIApplication *app;
@end

@implementation TestFullSuite

- (void)setUp
{
    [super setUp];
    self.continueAfterFailure = NO;
    self.app = [[XCUIApplication alloc] init];
    [self.app launch];
}

- (void)testFullExampleForm
{
    XCUIApplication *app = self.app;
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
    
    [app.tables.staticTexts[@"House"] swipeUp]; // swipe up on inocuous text
    
    [tablesQuery.pickerWheels.element adjustToPickerWheelValue:@"Ravenclaw"];
    
    [app.tables.staticTexts[@"House"] swipeUp]; // swipe up on inocuous text
    
    [[tablesQuery.cells containingType:XCUIElementTypeButton identifier:@"Show Values"].element tap];

    XCUIElement *element = [[app.alerts.staticTexts matchingPredicate:[NSPredicate predicateWithFormat:@"label = %@", @"{\"name\":\"Testy\",\"likesGoats\":true,\"email\":\"Test@example.com\",\"thoughts\":\"Some thoughts\",\"favoriteNumber\":\"12\",\"Food\":[\"Ice Cream\",\"Pizza\"],\"House\":\"Ravenclaw\",\"age\":\"28\"}"]] element];
    XCTAssertTrue(element.exists);
}

@end
