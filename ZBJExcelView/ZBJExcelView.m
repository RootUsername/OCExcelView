//
//  ZBJExcel.m
//  exceltest
//
//  Created by zbj on 2017/6/28.
//  Copyright © 2017年 zbj. All rights reserved.
//

#import "ZBJExcelView.h"
#import "ZBJCell.h"

@interface ZBJExcelView () {
    
    ZBJCell *_contentView;
    
    NSInteger _numberOfRows;
    NSInteger _numberOfCols;
    NSMutableArray<NSNumber *> *_flexOfRows;
    NSMutableArray<NSNumber *> *_flexOfCols;
    UIColor *_lineColor;
    float _lineWidth;
    
    unsigned int _didTapCellFlag;
    unsigned int _flexOfRowsFlag;
    unsigned int _flexOfColsFlag;
    unsigned int _lineColorFlag;
    unsigned int _lineWidthFlag;
}

@end

@implementation ZBJExcelView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setupGestureRecognizers];
        [self setupView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupGestureRecognizers];
        [self setupView];
    }
    return self;
}

- (void)setupGestureRecognizers {
    
    _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGR:)];
    [self addGestureRecognizer:_tapGestureRecognizer];
}

- (void)setupView {
    _contentView = [[ZBJCell alloc] init];
    [self addSubview:_contentView];
}

//- (void)setupViews {
//    
//    UIView *(^createContentView)(void) = ^{
//        UIView *contentView = [[UIView alloc] init];
//        contentView.backgroundColor = [UIColor clearColor];
//        contentView.clipsToBounds = YES;
//        return contentView;
//    };
//    UIView *view = createContentView();
//    
//    [self addSubview:view];
//}

#pragma mark - handle gesture recognizer

- (ZBJCell *)touchedCellWithGesture:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint point = [gestureRecognizer locationInView:self];
    UIView *inView;
    for (UIView *view in self.subviews[0].subviews) {
        CGRect rect = [view convertRect:view.bounds toView:self];
        if (CGRectContainsPoint(rect, point)) {
            inView = view;
            break;
        }
    }
    if (!inView) {
        return nil;
    }
    ZBJCell *zbjcell;
    for (UIView *subview in inView.subviews) {
        if ([subview isKindOfClass:[ZBJCell class]]) {
            CGRect rect = [subview convertRect:subview.bounds toView:self];
            if (CGRectContainsPoint(rect, point)) {
                zbjcell = (ZBJCell *)subview;
                break;
            }
        }
    }
    
    return zbjcell;
}

- (void)handleTapGR:(UILongPressGestureRecognizer *)tapGR {
    if (_didTapCellFlag) {
        ZBJCell *cell = [self touchedCellWithGesture:tapGR];
        if (cell) {
            [_delegate excelView:self didSelectCellAtIndexPath:cell.indexPath];
        }
    }
}

- (void)didMoveToSuperview {
    if (!self.superview) {
        return;
    }
    [super didMoveToSuperview];
    [self reloadData];
}

#pragma mark - load

- (void)reloadData {
    @autoreleasepool {
        [_contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    if (!_datasource) {
        return;
    }
    
    _numberOfRows = [_datasource numberOfRowsInZBJExcelView:self];
    _numberOfCols = [_datasource numberOfColsInZBJExcelView:self];
    
    if (_numberOfRows * _numberOfCols == 0) {
        return;
    }
    
    _flexOfRowsFlag = [_delegate respondsToSelector:@selector(flexOfRowsForExcelView:)];
    _flexOfColsFlag = [_delegate respondsToSelector:@selector(flexOfColsForExcelView:)];
    _didTapCellFlag = [_delegate respondsToSelector:@selector(excelView:didSelectCellAtIndexPath:)];
    _lineColorFlag = [_delegate respondsToSelector:@selector(colorForExcelView:)];
    _lineWidthFlag = [_delegate respondsToSelector:@selector(widthForExcelView:)];

    if (_flexOfRowsFlag) {
        _flexOfRows = [NSMutableArray<NSNumber *> arrayWithArray:[_delegate flexOfRowsForExcelView:self]];
    }
    else {
        _flexOfRows = [NSMutableArray<NSNumber *> array];
        for (int i = 0; i < _numberOfRows; i++) {
            [_flexOfRows addObject:[NSNumber numberWithInt:1]];
        }
    }
    if (_flexOfColsFlag) {
        _flexOfCols = [NSMutableArray<NSNumber *> arrayWithArray:[_delegate flexOfColsForExcelView:self]];
    }
    else {
        _flexOfCols = [NSMutableArray<NSNumber *> array];
        for (int i = 0; i < _numberOfCols; i++) {
            [_flexOfCols addObject:[NSNumber numberWithInt:1]];
        }
    }
    
    [self loadSubViews];
    [self setNeedsLayout];
}

- (void)loadSubViews {
    
    _contentView.flexDirection = @"column";

    if (_lineColorFlag) {
        _contentView.backgroundColor = [_delegate colorForExcelView:self];
    }
    else {
        _contentView.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1];
    }
    
    float space = 0.5;
    if (_lineWidthFlag) {
        space = [_delegate widthForExcelView:self];
    }
    
    _contentView.space = space;
    _contentView.oriX = space;
    _contentView.oriY = space;

    
    for (int i = 0; i < _numberOfRows; i++) {
        ZBJCell *row = [[ZBJCell alloc] initWithFlex:[_flexOfRows[i] floatValue]];
        row.backgroundColor = _contentView.backgroundColor;
        row.space = _contentView.space;
        
        for (int j = 0; j < _numberOfCols; j++) {
            ZBJCell *col = [[ZBJCell alloc] initWithFlex:[_flexOfCols[j] floatValue]];
            col.indexPath = [NSIndexPath indexPathForRow:j inSection:i];
            [col addSubview:[_datasource excelView:self cellAtIndexPath:col.indexPath]];
            [row addSubview:col];
        }
        
        [_contentView addSubview:row];
    }
}

#pragma mark - layout

- (void)layoutSubviews {
    if (!_datasource) {
        return;
    }
    
    _contentView.frame = self.bounds;
    
    [self setupSubViewFrame:_contentView];
}

/**
 *  递归
 *
 */
- (void)setupSubViewFrame:(UIView *)view {
    for (UIView *subView in view.subviews) {
        if ([subView isKindOfClass:[ZBJCell class]]) {
                [self setupSubViewFrame:subView];
            
        } else {
            subView.frame = view.bounds;
        }
    }
}

#pragma mark - method

- (NSInteger)numberOfRows {
    return _numberOfRows;
}

- (NSInteger)numberOfCols {
    return _numberOfCols;
}

- (UIView *)cellAtIndexPath:(NSIndexPath *)indexPath {
    return [_datasource excelView:self cellAtIndexPath:indexPath];
}

- (CGFloat)flexOfRow:(NSInteger)row {
    NSArray *frs = [_delegate flexOfRowsForExcelView:self];
    if (frs && frs.count >row) {
        return [[NSString stringWithFormat:@"%@",frs[row]] floatValue];
    }
    else {
        return 1.0;
    }
}

- (CGFloat)flexOfCol:(NSInteger)col {
    NSArray *fcs = [_delegate flexOfColsForExcelView:self];
    if (fcs && fcs.count >col) {
        return [[NSString stringWithFormat:@"%@",fcs[col]] floatValue];
    }
    else {
        return 1.0;
    }
}
@end
