//
//  ZBJExcel.h
//  exceltest
//
//  Created by zbj on 2017/6/28.
//  Copyright © 2017年 zbj. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZBJExcelView;

@protocol ZBJExcelViewDatasource <NSObject>

@required
//行数
- (NSInteger)numberOfRowsInZBJExcelView:(ZBJExcelView *)excelView;
//列数
- (NSInteger)numberOfColsInZBJExcelView:(ZBJExcelView *)excelView;
//cell内容
- (UIView *)excelView:(ZBJExcelView *)excelView cellAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol ZBJExcelViewDelegate <NSObject>

@optional
//每行的flex比例
- (NSArray<NSNumber *> *)flexOfRowsForExcelView:(ZBJExcelView *)excelView;
//每列的flex比例
- (NSArray<NSNumber *> *)flexOfColsForExcelView:(ZBJExcelView *)excelView;
//表格线条颜色
- (UIColor *)colorForExcelView:(ZBJExcelView *)excelView;
//表格线条宽度
- (float )widthForExcelView:(ZBJExcelView *)excelView;
//点击index
- (void)excelView:(ZBJExcelView *)excelView didSelectCellAtIndexPath:(NSIndexPath *)indexPath;

@end


@interface ZBJExcelView : UIView

@property (nonatomic, weak) id<ZBJExcelViewDatasource> datasource;
@property (nonatomic, weak) id<ZBJExcelViewDelegate> delegate;

@property (nonatomic, readonly) UITapGestureRecognizer *tapGestureRecognizer;

- (instancetype)initWithFrame:(CGRect)frame;
- (void)reloadData;

- (NSInteger)numberOfRows;
- (NSInteger)numberOfCols;
- (UIView *)cellAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)flexOfRow:(NSInteger)row;
- (CGFloat)flexOfCol:(NSInteger)col;

@end
