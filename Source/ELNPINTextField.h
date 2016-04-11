//
//  ELNPINTextField.h
//  ELNViews
//
//  Created by Dmitry Nesterenko on 11.04.16.
//  Copyright © 2016 e-legion. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ELNPINTextField;

@protocol ELNPINTextFieldDelegate  <NSObject>

@optional
- (void)textFieldDidComplete:(ELNPINTextField *)textField;

@end

@interface ELNPINTextField : UIControl <UIKeyInput>

@property (nonatomic, weak) IBOutlet id<ELNPINTextFieldDelegate> delegate;

/// Default value is 4.
@property (nonatomic, assign) NSUInteger numberOfCharacters;

@property (nonatomic, copy) NSString *text;

/// Default value is `darkTextColor`.
@property (nonatomic, copy) IBInspectable UIColor *textColor;

/// Default value is 15.
@property (nonatomic, assign) IBInspectable CGFloat textSize;

/// Default value is UIKeyboardTypeNumberPad.
@property (nonatomic, assign) UIKeyboardType keyboardType;

/// Default value is UIKeyboardAppearanceDefault.
@property (nonatomic, assign) UIKeyboardAppearance keyboardAppearance;

/// Default value is UIReturnKeyDefault.
@property (nonatomic, assign) UIReturnKeyType returnKeyType;

@end
