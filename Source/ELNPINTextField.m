//
//  ELNPINTextField.m
//  ELNViews
//
//  Created by Dmitry Nesterenko on 11.04.16.
//  Copyright © 2016 e-legion. All rights reserved.
//

#import "ELNPINTextField.h"
#import "ELNPINTextFieldCell.h"

@interface ELNPINTextField ()

@property (nonatomic, strong) NSArray<ELNPINTextFieldCell *> *cells;

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
    self.cellClass = [ELNPINTextFieldCell class];
    
    self.textSize = 15;
    self.numberOfCharacters = 4;
}

#pragma mark - Creating Text Field Cells

- (void)setCellClass:(Class)cellClass {
    if (_cellClass == cellClass) {
        return;
    }
    NSAssert([cellClass isSubclassOfClass:[ELNPINTextFieldCell class]], @"Cell class must be a subclass of the ELNPINTextFieldCell class.");
    _cellClass = cellClass;
}

#pragma mark - Accessing the Text Attributes

- (void)setText:(NSString *)text {
    [self setText:text animated:NO completion:nil];
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    for (ELNPINTextFieldCell *cell in self.cells) {
        cell.textColor = self.textColor;
    }
}

- (void)setTextSize:(CGFloat)textSize {
    _textSize = textSize;
    for (ELNPINTextFieldCell *cell in self.cells) {
        cell.textSize = self.textSize;
    }
}

#pragma mark - Text Updating

- (void)setText:(NSString *)text animated:(BOOL)animated completion:(void (^)())completion {
    if (_text == text) {
        return;
    }
    
    [self willChangeValueForKey:@"text"];
    _text = [text copy];
    [self didChangeValueForKey:@"text"];

    [self textValueChangedAnimated:animated completion:completion];
}

- (void)textValueChangedAnimated:(BOOL)animated completion:(void (^)())completion {
    NSUInteger count = self.text.length;
    
    // Merge all selections in the single animation group.
    // This allows to perform the delegate callback when all animations have completed.
    dispatch_group_t dispatch_group = dispatch_group_create();
    
    dispatch_group_enter(dispatch_group);
    for (NSUInteger i = 0; i < self.cells.count; i++) {
        ELNPINTextFieldCell *cell = self.cells[i];
        BOOL selected = i < count;
        dispatch_group_enter(dispatch_group);
        [cell setSelected:selected animated:animated completion:^{
            dispatch_group_leave(dispatch_group);
        }];
    }
    
    dispatch_group_notify(dispatch_group, dispatch_get_main_queue(), ^{
        if (completion) {
            completion();
        }
    });
    dispatch_group_leave(dispatch_group);
}

#pragma mark - Character Views

- (void)setNumberOfCharacters:(NSUInteger)numberOfCharacters {
    _numberOfCharacters = numberOfCharacters;
    
    [self.cells makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.cells = @[];
    
    for (NSUInteger i = 0; i < self.numberOfCharacters; i++) {
        ELNPINTextFieldCell *cell = [self.cellClass new];
        cell.userInteractionEnabled = NO;
        cell.textColor = self.textColor;
        cell.textSize = self.textSize;
        [self addSubview:cell];
        self.cells = [self.cells arrayByAddingObject:cell];
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
    
    __weak __typeof__(self) weakSelf = self;
    [self setText:value animated:YES completion:^{
        [weakSelf sendActionsForControlEvents:UIControlEventEditingChanged];

        if (value.length >= self.numberOfCharacters) {
            if ([weakSelf.delegate respondsToSelector:@selector(textFieldDidComplete:)]) {
                [weakSelf.delegate textFieldDidComplete:weakSelf];
            }
        }
    }];
}

- (void)deleteBackward {
    if (self.text.length == 0) {
        return;
    }
    
    NSString *value = [self.text stringByReplacingCharactersInRange:NSMakeRange(self.text.length - 1, 1) withString:@""];
    
    __weak __typeof__(self) weakSelf = self;
    [self setText:value animated:YES completion:^{
        [weakSelf sendActionsForControlEvents:UIControlEventEditingChanged];
    }];
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
    
    for (NSUInteger i = 0; i < self.cells.count; i++) {
        ELNPINTextFieldCell *cell = self.cells[i];
        cell.frame = CGRectMake(i * width, 0, width, height);
    }
}

#pragma mark - Accessibility

- (NSString *)accessibilityValue {
    return [@"" stringByPaddingToLength:self.text.length withString:@"•" startingAtIndex:0];
}

@end
