//
//  ELNLabel.h
//  e-legion
//
//  Created by Dmitry Nesterenko on 12.10.15.
//  Copyright © 2015 e-legion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ELNLabel : UILabel

/**
 Automatically calculates preferred max layout width on `layoutSubviews` pass.
 
 Default value is YES

 @warning Remove this method for iOS8+ deplyoment targets.
 
 @see http://www.objc.io/issue-3/advanced-auto-layout-toolbox.html
 */
@property (nonatomic, assign) BOOL calculatesPreferredMaxLayoutWidthAutomatically;

@end
