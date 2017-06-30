//
//  ViewController.m
//  exceltest
//
//  Created by zbj on 2017/6/27.
//  Copyright © 2017年 zbj. All rights reserved.
//

#import "ViewController.h"
#import "ZBJExcelView.h"

@interface ViewController ()<ZBJExcelViewDelegate,ZBJExcelViewDatasource>

@property (nonatomic, strong) ZBJExcelView *excelView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.excelView = [[ZBJExcelView alloc] init];
    self.excelView.datasource = self;
    self.excelView.delegate = self;
    [self.view addSubview:self.excelView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGRect rect = self.view.bounds;
    rect = CGRectInset(rect, 16, 16);
    rect.origin.y += 60;
    rect.size.height -= 64;
    self.excelView.frame = rect;
}

#pragma mark - <ZBJExcelViewDatasource>

- (NSInteger)numberOfRowsInZBJExcelView:(ZBJExcelView *)excelView {
    return 5;
}

- (NSInteger)numberOfColsInZBJExcelView:(ZBJExcelView *)excelView {
    return 4;
}

- (UIView *)excelView:(ZBJExcelView *)excelView cellAtIndexPath:(NSIndexPath *)indexPath {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    view.backgroundColor = [UIColor yellowColor];
    
    //创建子view
    UILabel *label = [[UILabel alloc] init];
    [label setBackgroundColor:[UIColor lightGrayColor]];
    [label setText:@"hello"];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setTextColor:[UIColor purpleColor]];
    //将子view添加到父视图上
    [view addSubview:label];
    //使用Auto Layout约束，禁止将Autoresizing Mask转换为约束
    [label setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    
    NSLayoutConstraint *contraint1 = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTop multiplier:1.0 constant:5.0];
    NSLayoutConstraint *contraint2 = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:5.0];
    NSLayoutConstraint *contraint3 = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-5.0];
    NSLayoutConstraint *contraint4 = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeRight multiplier:1.0 constant:-5.0];
    
    NSArray *array = [NSArray arrayWithObjects:contraint1, contraint2, contraint3, contraint4, nil ,nil];
    
    [view addConstraints:array];
    
    return view;
}

#pragma mark - <ZBJExcelViewDelegate>
//每行的flex比例
- (NSArray<NSNumber *> *)flexOfRowsForExcelView:(ZBJExcelView *)excelView {
    NSArray *array = [NSArray<NSNumber *> arrayWithObjects:[NSNumber numberWithInt:1],[NSNumber numberWithInt:2],[NSNumber numberWithInt:2],[NSNumber numberWithInt:2],[NSNumber numberWithInt:3], nil];
    return array;
}
//每列的flex比例
- (NSArray<NSNumber *> *)flexOfColsForExcelView:(ZBJExcelView *)excelView {
    NSArray *array = [NSArray<NSNumber *> arrayWithObjects:[NSNumber numberWithInt:1],[NSNumber numberWithInt:2],[NSNumber numberWithInt:2],[NSNumber numberWithInt:2], nil];
    return array;
}
//表格线条颜色
- (UIColor *)colorForExcelView:(ZBJExcelView *)excelView {
    return [UIColor colorWithWhite:0 alpha:1];
}
//表格线条宽度
- (float )widthForExcelView:(ZBJExcelView *)excelView {
    return 1;
}
//点击index
- (void)excelView:(ZBJExcelView *)excelView didSelectCellAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"hello");
}

@end
