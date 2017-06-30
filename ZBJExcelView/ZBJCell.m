//
//  ZBJRow.m
//  exceltest
//
//  Created by zbj on 2017/6/27.
//  Copyright © 2017年 zbj. All rights reserved.
//

#import "ZBJCell.h"

@interface ZBJCell ()

@end

@implementation ZBJCell


- (instancetype)initWithFlex:(float)flex {
    self = [super init];
    
    if (self){
        self.flex = flex;
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

- (void)layoutSubviews {
    
    float allFlex = 0;
    float flexCount = 0;
    
    float selfX = self.oriX;
    float selfY = self.oriY;
    
    float selfWidth = self.frame.size.width - 2 * self.oriX;;
    float selfHeight = self.frame.size.height - 2 * self.oriY;
    
    for (ZBJCell *sbv in self.subviews) {
        if ([sbv isKindOfClass:[ZBJCell class]] && sbv.flex > 0) {
            flexCount += 1;
            allFlex += sbv.flex;
        }
    }
    
    if ([self.flexDirection isEqualToString:@"row"]) {
        for (ZBJCell *sbv in self.subviews) {
            if ([sbv isKindOfClass:[ZBJCell class]] && sbv.flex > 0) {
                float width = (selfWidth - (flexCount-1) * self.space) * sbv.flex / allFlex;
                sbv.frame = CGRectMake(selfX, selfY, width, selfHeight);
                selfX += width + self.space;
            }
        }
    }
    else if ([self.flexDirection isEqualToString:@"column"]) {
        for (ZBJCell *sbv in self.subviews) {
            if ([sbv isKindOfClass:[ZBJCell class]] && sbv.flex > 0) {
                float height = (selfHeight - (flexCount-1) * self.space) * sbv.flex / allFlex;
                sbv.frame = CGRectMake(selfX, selfY, selfWidth, height);
                selfY += height + self.space;
            }
        }
    }
    else{
        for (ZBJCell *sbv in self.subviews) {
            if ([sbv isKindOfClass:[ZBJCell class]] && sbv.flex > 0) {
                float width = (selfWidth - (flexCount-1) * self.space) * sbv.flex / allFlex;
                sbv.frame = CGRectMake(selfX, selfY, width, selfHeight);
                selfX += width + self.space;
            }
        }
    }
    
}

@end
