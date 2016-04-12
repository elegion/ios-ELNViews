//
//  ELNPINTextField.h
//  ELNViews
//
//  Created by Dmitry Nesterenko on 11.04.16.
//  Copyright © 2016 e-legion. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ELNPINTextField;

@protocol ELNPINTextFieldDelegate  <NSObject>

@optional
- (void)textFieldDidComplete:(ELNPINTextField *)textField;

@end

@interface ELNPINTextField : UIControl <UIKeyInput>

@property (nonatomic, weak, nullable) IBOutlet id<ELNPINTextFieldDelegate> delegate;

/// Default value is 4.
@property (nonatomic, assign) NSUInteger numberOfCharacters;

@property (nonatomic, copy, nullable) NSString *text;

/// Default value is `darkTextColor`.
@property (nonatomic, copy, nullable) IBInspectable UIColor *textColor;

/// Default value is 15.
@property (nonatomic, assign) IBInspectable CGFloat textSize;

/// Default value is UIKeyboardTypeNumberPad.
@property (nonatomic, assign) UIKeyboardType keyboardType;

/// Default value is UIKeyboardAppearanceDefault.
@property (nonatomic, assign) UIKeyboardAppearance keyboardAppearance;

/// Default value is UIReturnKeyDefault.
@property (nonatomic, assign) UIReturnKeyType returnKeyType;

/// Default value is ELNPINTextFieldCell.
@property (nonatomic, assign) Class cellClass;

@end

NS_ASSUME_NONNULL_END
