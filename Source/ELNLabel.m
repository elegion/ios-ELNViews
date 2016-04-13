//
//  ELNLabel.m
//  e-legion
//
//  Created by Dmitry Nesterenko on 12.10.15.
//  Copyright © 2015 e-legion. All rights reserved.
//

#import "ELNLabel.h"

#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_8_0

@implementation ELNLabel

#pragma mark - Initialization

- (void)awakeFromNib {
    [super awakeFromNib];
    [self __initialize];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self __initialize];
    }
    return self;
}

- (void)__initialize {
    self.calculatesPreferredMaxLayoutWidthAutomatically = YES;
}

#pragma mark - Laying Out

- (void)layoutSubviews {
    if (self.calculatesPreferredMaxLayoutWidthAutomatically) {
        self.preferredMaxLayoutWidth = self.frame.size.width;
    }

    [super layoutSubviews];
}

@end

#endif
