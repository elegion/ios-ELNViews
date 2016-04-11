//
//  ELNPINTextField.m
//  ELNViews
//
//  Created by Dmitry Nesterenko on 11.04.16.
//  Copyright © 2016 e-legion. All rights reserved.
//

#import "ELNPINTextField.h"
#import "ELNPINView.h"

@interface ELNPINTextField ()

@property (nonatomic, strong) NSArray<ELNPINView *> *characterSubviews;

@end

@implementation ELNPINTextField

#pragma mark - Initialization

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self __initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self __initialize];
    }
    return self;
}

- (void)__initialize {
    self.keyboardType = UIKeyboardTypeNumberPad;
    self.keyboardAppearance = UIKeyboardAppearanceDefault;
    self.returnKeyType = UIReturnKeyDefault;
    
    self.numberOfCharacters = 4;
}

#pragma mark - Text

- (void)setText:(NSString *)text {
    _text = text;
    
    [self textValueChanged];
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    for (ELNPINView *subview in self.characterSubviews) {
        subview.textColor = self.textColor;
    }
}

- (void)setTextSize:(CGFloat)textSize {
    _textSize = textSize;
    for (ELNPINView *subview in self.characterSubviews) {
        subview.textSize = self.textSize;
    }
}

#pragma mark - Character Views

- (void)setNumberOfCharacters:(NSUInteger)numberOfCharacters {
    _numberOfCharacters = numberOfCharacters;
    
    [self.characterSubviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.characterSubviews = @[];
    
    for (NSUInteger i = 0; i < self.numberOfCharacters; i++) {
        ELNPINView *subview = [ELNPINView new];
        subview.userInteractionEnabled = NO;
        subview.textColor = self.textColor;
        subview.textSize = self.textSize;
        [self addSubview:subview];
        self.characterSubviews = [self.characterSubviews arrayByAddingObject:subview];
    }
    
    [self setNeedsLayout];
}

#pragma mark - UIKeyInput

- (BOOL)hasText {
    return self.text.length > 0;
}

- (void)insertText:(NSString *)text {
    NSString *value = [self.text ?: @"" stringByAppendingString:text];
    
    NSInteger clippedCharactersCount = (NSInteger)value.length - (NSInteger)self.numberOfCharacters;
    if (clippedCharactersCount > 0) {
        value = [value stringByReplacingCharactersInRange:NSMakeRange(value.length - (NSUInteger)clippedCharactersCount, (NSUInteger)clippedCharactersCount) withString:@""];
    }
    
    self.text = value;
    [self sendActionsForControlEvents:UIControlEventEditingChanged];
}

- (void)deleteBackward {
    if (self.text.length == 0) {
        return;
    }
    
    self.text = [self.text stringByReplacingCharactersInRange:NSMakeRange(self.text.length - 1, 1) withString:@""];
    [self sendActionsForControlEvents:UIControlEventEditingChanged];
}

- (void)textValueChanged {
    NSUInteger count = self.text.length;
    
    // Merge all selections in the single animation group.
    // This allows to perform the delegate callback when all animations have completed.
    dispatch_group_t dispatch_group = dispatch_group_create();
    
    dispatch_group_enter(dispatch_group);
    for (NSUInteger i = 0; i < self.characterSubviews.count; i++) {
        ELNPINView *subview = self.characterSubviews[i];
        BOOL selected = i < count;
        dispatch_group_enter(dispatch_group);
        [subview setSelected:selected animated:YES completion:^{
            dispatch_group_leave(dispatch_group);
        }];
    }
    
    dispatch_group_notify(dispatch_group, dispatch_get_main_queue(), ^{
        if (count >= self.numberOfCharacters) {
            if ([self.delegate respondsToSelector:@selector(textFieldDidComplete:)]) {
                [self.delegate textFieldDidComplete:self];
            }
        }
    });
    dispatch_group_leave(dispatch_group);
}

#pragma mark - Managing the Responder Chain

- (BOOL)canBecomeFirstResponder {
    return self.enabled;
}

#pragma mark - Measuring in Constraint-Based Layout

- (CGSize)intrinsicContentSize {
    return CGSizeMake(20, 44);
}

#pragma mark - Tracking Touches and Redrawing Controls

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    BOOL result = [super beginTrackingWithTouch:touch withEvent:event];
    if (result) {
        [self becomeFirstResponder];
    }
    return result;
}

#pragma mark - Laying out Subviews

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = self.bounds.size.width / self.numberOfCharacters;
    CGFloat height = self.bounds.size.height;
    
    for (NSUInteger i = 0; i < self.characterSubviews.count; i++) {
        ELNPINView *subview = self.characterSubviews[i];
        subview.frame = CGRectMake(i * width, 0, width, height);
    }
}

#pragma mark - Accessibility

- (NSString *)accessibilityValue {
    return [@"" stringByPaddingToLength:self.text.length withString:@"•" startingAtIndex:0];
}

@end
