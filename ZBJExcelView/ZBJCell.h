//
//  ZBJRow.h
//  exceltest
//
//  Created by zbj on 2017/6/27.
//  Copyright © 2017年 zbj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZBJCell : UIView

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) float space;
@property (nonatomic, copy) NSString *flexDirection;
@property(nonatomic,assign) float flex;
@property(nonatomic,assign) float oriX;
@property(nonatomic,assign) float oriY;

- (instancetype)initWithFlex:(float)flex;

@end
