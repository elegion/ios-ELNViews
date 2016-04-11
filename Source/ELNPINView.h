//
//  ELNPINView.h
//  ELNViews
//
//  Created by Dmitry Nesterenko on 11.04.16.
//  Copyright © 2016 e-legion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ELNPINView : UIView

@property (nonatomic, assign) CGFloat textSize;
@property (nonatomic, copy) UIColor *textColor;
@property (nonatomic, assign) BOOL selected;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated completion:(void (^)())completion;

@end
