//
//  TestValidations.m
//  Formulary
//
//  Created by Fabian Canas on 12/27/15.
//  Copyright © 2015 Fabian Canas. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface TextInput : XCTestCase
@property (nonatomic) XCUIElementQuery *tablesQuery;
@end

@implementation TextInput

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.

    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];

    self.tablesQuery = [[XCUIApplication alloc] init].tables;
}

- (void)testRequiredStringValidation {
    [self.tablesQuery.textFields[@"Name"] tap];
    
    XCUIElement *textField = [[[self.tablesQuery childrenMatchingType:XCUIElementTypeCell] elementBoundByIndex:0] childrenMatchingType:XCUIElementTypeTextField].element;
    
    // Drag to lose focus
    [[[self.tablesQuery childrenMatchingType:XCUIElementTypeCell] elementBoundByIndex:0] pressForDuration:0 thenDragToElement:[[self.tablesQuery childrenMatchingType:XCUIElementTypeCell] elementBoundByIndex:1]];
    
    [self.tablesQuery.textFields[@"Name Name can't be empty"] tap];
    
    [textField typeText:@"Joe"];

    // Drag to lose focus
    [[[self.tablesQuery childrenMatchingType:XCUIElementTypeCell] elementBoundByIndex:0] pressForDuration:0 thenDragToElement:[[self.tablesQuery childrenMatchingType:XCUIElementTypeCell] elementBoundByIndex:1]];

    XCTAssertTrue(self.tablesQuery.textFields[@"Name, Joe"].exists);
}

- (void)testMaxMinNumericValidations
{
    [self.tablesQuery.textFields[@"Favorite Number"] tap];
    
    XCUIElement *textField = [[[self.tablesQuery childrenMatchingType:XCUIElementTypeCell] elementBoundByIndex:3] childrenMatchingType:XCUIElementTypeTextField].element;
    
    [textField typeText:@"12"];

    // Drag to lose focus
    [[[self.tablesQuery childrenMatchingType:XCUIElementTypeCell] elementBoundByIndex:0] pressForDuration:0 thenDragToElement:[[self.tablesQuery childrenMatchingType:XCUIElementTypeCell] elementBoundByIndex:1]];
    
    [self.tablesQuery.textFields[@"Favorite Number, 12, Your favorite number must be at least 47"] tap];
    
    [textField typeText:@"\b\b50"];
    
    // Drag to lose focus
    [[[self.tablesQuery childrenMatchingType:XCUIElementTypeCell] elementBoundByIndex:0] pressForDuration:0 thenDragToElement:[[self.tablesQuery childrenMatchingType:XCUIElementTypeCell] elementBoundByIndex:1]];
    
    [self.tablesQuery.textFields[@"Favorite Number, 50, Your favorite number must be at most 47"] tap];
    
    [textField typeText:@"\b\b47"];
    XCTAssertTrue(self.tablesQuery.textFields[@"Favorite Number, 47"].exists);
    
    // Drag to lose focus
    [[[self.tablesQuery childrenMatchingType:XCUIElementTypeCell] elementBoundByIndex:0] pressForDuration:0 thenDragToElement:[[self.tablesQuery childrenMatchingType:XCUIElementTypeCell] elementBoundByIndex:1]];
    
    XCTAssertTrue(self.tablesQuery.textFields[@"Favorite Number, 47"].exists);
}

@end
