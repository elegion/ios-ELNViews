//
//  Tests.m
//  Tests
//
//  Created by Dmitry Nesterenko on 11.04.16.
//  Copyright © 2016 e-legion. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ELNPINTextField.h"

@interface TextFieldDelegate : NSObject <ELNPINTextFieldDelegate>

@property (nonatomic, assign) BOOL didComplete;

@end

@implementation TextFieldDelegate

- (void)textFieldDidComplete:(ELNPINTextField *)textField {
    self.didComplete = YES;
}

@end


@interface ELNPINTextFieldTests : XCTestCase

@end

@implementation ELNPINTextFieldTests

- (void)testPINTextFieldCallsDelegateWhenCompleted {
    TextFieldDelegate *delegate = [TextFieldDelegate new];
    
    ELNPINTextField *textField = [ELNPINTextField new];
    textField.numberOfCharacters = 4;
    textField.delegate = delegate;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@""];
    
    [textField insertText:@"1"];
    [textField insertText:@"1"];
    [textField insertText:@"1"];
    [textField insertText:@"1"];
    
    CFTimeInterval duration = [CATransaction animationDuration];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        XCTAssertTrue(delegate.didComplete);
        [expectation fulfill];
    });
    
    [self waitForExpectationsWithTimeout:duration + 0.1 handler:nil];
}


@end
