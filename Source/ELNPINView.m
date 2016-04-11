//
//  ELNPINView.m
//  ELNViews
//
//  Created by Dmitry Nesterenko on 11.04.16.
//  Copyright © 2016 e-legion. All rights reserved.
//

#import "ELNPINView.h"

@interface ELNPINView ()

@property (nonatomic, strong) CAShapeLayer *selectedShape;
@property (nonatomic, strong) CAShapeLayer *notSelectedShape;

@end

@implementation ELNPINView

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
    self.textSize = 15;
    self.textColor = [UIColor darkTextColor];
    
    self.backgroundColor = [UIColor clearColor];
    
    self.notSelectedShape = [CAShapeLayer new];
    self.notSelectedShape.lineWidth = 2 / [UIScreen mainScreen].scale;
    self.notSelectedShape.lineCap = kCALineCapButt;
    self.notSelectedShape.lineJoin = kCALineJoinMiter;
    [self.layer addSublayer:self.notSelectedShape];
    
    self.selectedShape = [CAShapeLayer new];
    [self.layer addSublayer:self.selectedShape];
}

#pragma mark - Accessors

- (void)setTextSize:(CGFloat)textSize {
    _textSize = textSize;
    [self setNeedsLayout];
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    [self updateAppearanceAnimated:NO completion:nil];
}

#pragma mark - Selection

- (void)setSelected:(BOOL)selected {
    [self setSelected:selected animated:NO completion:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated completion:(void (^)())completion {
    if (_selected == selected) {
        if (completion) {
            completion();
        }
        return;
    }
    _selected = selected;
    
    [self updateAppearanceAnimated:animated completion:completion];
}

#pragma mark - Appearance

- (void)updateAppearanceAnimated:(BOOL)animated completion:(void (^)())completion {
    void (^animations)() = ^{
        self.notSelectedShape.strokeColor = self.textColor.CGColor;
        self.notSelectedShape.fillColor = [UIColor clearColor].CGColor;
        self.selectedShape.strokeColor = self.textColor.CGColor;
        self.selectedShape.fillColor = self.textColor.CGColor;
        
        if (self.selected) {
            self.notSelectedShape.hidden = YES;
            self.selectedShape.hidden = NO;
        } else {
            self.notSelectedShape.hidden = NO;
            self.selectedShape.hidden = YES;
        }
    };
    
    if (animated) {
        [CATransaction begin];
        [CATransaction setCompletionBlock:completion];
        animations();
        [CATransaction commit];
    } else {
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        [CATransaction setCompletionBlock:completion];
        animations();
        [CATransaction commit];
    }
}

#pragma mark - Laying out Subviews

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect rect = CGRectMake(CGRectGetMidX(self.bounds) - self.textSize / 2, CGRectGetMidY(self.bounds) - self.textSize / 2, self.textSize, self.textSize);
    
    self.notSelectedShape.path = [UIBezierPath bezierPathWithOvalInRect:rect].CGPath;
    self.selectedShape.path = [UIBezierPath bezierPathWithOvalInRect:rect].CGPath;
}

@end
