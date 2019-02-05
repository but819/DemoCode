//
//  ViewController.m
//  UIPickerViewTest
//
//  Created by mac on 15-4-27.
//  Copyright (c) 2015年 but. All rights reserved.
//

#import "ViewController.h"

#pragma mark -  MainScreen

#define myMainScreen    [[UIScreen mainScreen] bounds]

#define globleWidth     [[UIScreen mainScreen] bounds].size.width

#define globleHeight    [[UIScreen mainScreen] bounds].size.height

@interface ViewController ()
{
    int nowChoose;

    UIView *topView;

    UIView *bottomView;

    UIImageView *leftArrow;

    UIImageView *rightArrow;

    UILabel *selectedText;

    UIPickerView *pickerView;

    NSArray *pickerData;

    NSArray *totalArray;

    NSMutableArray *BtnArray;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    // 初始化数据
    [self initData];

    // 初始化界面
    [self initView];

    // 显示默认的结果
    [self getAndShowSelectedText];
}

// 初始化数据
- (void)initData
{
    nowChoose = 0;

    NSArray *pickerData1 = [[NSArray alloc]initWithObjects:@"购买/提现", @"购买", @"提现", nil];

    NSArray *pickerData3 = [[NSArray alloc]initWithObjects:@"支付宝", @"火球", @"余额宝", @"点融", nil];

    NSArray *pickerData2 = [[NSArray alloc]initWithObjects:@"所有月份", @"2015年1月", @"2015年2月", @"2015年3月", @"2015年4月", @"2015年5月", nil];

    totalArray = [[NSArray alloc] initWithObjects:pickerData1, pickerData2, pickerData3, nil];

    BtnArray = [[NSMutableArray alloc] initWithCapacity:totalArray.count];
}

// 初始化界面
- (void)initView
{
    // 顶部-明显选择
    topView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, globleWidth, 30)];
    [topView setBackgroundColor:[UIColor colorWithRed:245.0 / 255.0 green:245.0 / 255.0 blue:245.0 / 255.0 alpha:1.0]];
    [self.view addSubview:topView];

    UILabel *topViewLineOne = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, globleWidth, 0.5)];
    [topViewLineOne setBackgroundColor:[UIColor colorWithRed:168.0 / 255.0 green:170.0 / 255.0 blue:173.0 / 255.0 alpha:1.0]];
    [topView addSubview:topViewLineOne];

    UILabel *topViewLineTwo = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, globleWidth, 0.5)];
    [topViewLineTwo setBackgroundColor:[UIColor colorWithRed:168.0 / 255.0 green:170.0 / 255.0 blue:173.0 / 255.0 alpha:1.0]];
    [topView addSubview:topViewLineTwo];

    float gap = globleWidth / totalArray.count;

    // 动态加载不同按钮
    for (int count = 0; count < totalArray.count; count++) {
        // 分割线
        if (count != 0) {
            UILabel *topViewGapLine = [[UILabel alloc]initWithFrame:CGRectMake(count * gap, 2, 0.5, 26)];
            [topViewGapLine setBackgroundColor:[UIColor colorWithRed:168.0 / 255.0 green:170.0 / 255.0 blue:173.0 / 255.0 alpha:1.0]];
            [topView addSubview:topViewGapLine];
        }

        //按钮
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(count * gap, 0, gap, 30)];
        [btn setTag:count];
        [btn addTarget:self action:@selector(handleClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:[[totalArray objectAtIndex:count] objectAtIndex:0] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setTitleColor:[UIColor colorWithRed:79.0 / 255.0 green:79.0 / 255.0 blue:79.0 / 255.0 alpha:1.0] forState:UIControlStateNormal];
        [topView addSubview:btn];
        [BtnArray addObject:btn];

        //下降图标
        CGSize      size = [self findMaxLengthStrSizeWithArray:[totalArray objectAtIndex:count] WithFontSize:(int)15];
        UIImageView *tip = [[UIImageView alloc]initWithFrame:CGRectMake(count * gap + (gap + size.width) / 2 + 2, 14, 10, 5)];
        [tip setImage:[UIImage imageNamed:@"down.png"]];
        [topView addSubview:tip];
    }

    // 中间-结果显示部分
    selectedText = [[UILabel alloc]initWithFrame:CGRectMake(0, globleHeight / 2 - 100, globleWidth, 50)];
    [selectedText setFont:[UIFont boldSystemFontOfSize:20]];
    [selectedText setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:selectedText];

    // 底部-选择部分
    bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, globleHeight - 240 + 20, globleWidth, 240)];
    [bottomView setAlpha:0.0];
    [bottomView setBackgroundColor:[UIColor colorWithRed:240.0 / 255.0 green:241.0 / 255.0 blue:242.0 / 255.0 alpha:1.0]];
    [self.view addSubview:bottomView];

    UILabel *bottomViewLineOne = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, globleWidth, 0.5)];
    [bottomViewLineOne setBackgroundColor:[UIColor colorWithRed:168.0 / 255.0 green:170.0 / 255.0 blue:173.0 / 255.0 alpha:1.0]];
    [bottomView addSubview:bottomViewLineOne];

    // 点击事件

    // 左箭头
    leftArrow = [[UIImageView alloc]initWithFrame:CGRectMake(15, 6, 13, 20)];
    [leftArrow setImage:[UIImage imageNamed:@"left_after.png"]];
    leftArrow.userInteractionEnabled = YES;
    UITapGestureRecognizer *leftArrowArrowTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changePickerViewData:)];
    [leftArrow addGestureRecognizer:leftArrowArrowTap];
    UIView *leftArrowTapView = [leftArrowArrowTap view];
    leftArrowTapView.tag = 0;
    [bottomView addSubview:leftArrow];

    // 右箭头
    rightArrow = [[UIImageView alloc]initWithFrame:CGRectMake(50, 6, 13, 20)];
    [rightArrow setTag:1];
    [rightArrow setImage:[UIImage imageNamed:@"right_after.png"]];
    rightArrow.userInteractionEnabled = YES;
    UITapGestureRecognizer *rightArrowArrowTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changePickerViewData:)];
    [rightArrow addGestureRecognizer:rightArrowArrowTap];
    UIView *rightArrowTapView = [rightArrowArrowTap view];
    rightArrowTapView.tag = 1;
    [bottomView addSubview:rightArrow];

    CGSize      size = [self boundingRectWithText:@"完成" WithSize:CGSizeMake(globleWidth, 0) WithFont:[UIFont systemFontOfSize:15]];
    UIButton    *finshBtn = [[UIButton alloc] initWithFrame:CGRectMake(globleWidth - size.width - 10, (33 - 15) / 2, size.width, size.height)];
    [finshBtn addTarget:self action:@selector(finishChoose) forControlEvents:UIControlEventTouchUpInside];
    [finshBtn setTitle:@"完成" forState:UIControlStateNormal];
    finshBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [finshBtn setTitleColor:[UIColor colorWithRed:0.0 / 255.0 green:120.0 / 255.0 blue:255.0 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    [bottomView addSubview:finshBtn];

    UILabel *bottomViewLineTwo = [[UILabel alloc]initWithFrame:CGRectMake(0, 33, globleWidth, 0.5)];
    [bottomViewLineTwo setBackgroundColor:[UIColor colorWithRed:168.0 / 255.0 green:170.0 / 255.0 blue:173.0 / 255.0 alpha:1.0]];
    [bottomView addSubview:bottomViewLineTwo];

    pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, globleWidth, 200)];
    [pickerView setBackgroundColor:[UIColor colorWithRed:209.0 / 255.0 green:212.0 / 255.0 blue:217.0 / 255.0 alpha:1.0]];
    pickerView.delegate = self;
    pickerView.showsSelectionIndicator = YES;
    [bottomView addSubview:pickerView];
}

#pragma mark - Click

// 顶部点击事件
- (void)handleClick:(id)sender
{
    // 确保只有一个
    if (bottomView.alpha == 0.0) {
        UIButton *btn = sender;
        // 提取按钮点击标志
        nowChoose = (int)btn.tag;
        // 重新加载数据
        [pickerView reloadAllComponents];

        [self fadeHideIn];
    }

    // 初始化箭头状态
    [self initArrowState];
}

// 箭头切换数据
- (void)changePickerViewData:(id)sender
{
    UITapGestureRecognizer *imageViewTap = (UITapGestureRecognizer *)sender;

    int testNowChoose = nowChoose + 1;

    // 确定状态
    if ([imageViewTap view].tag == 0) {
        if (testNowChoose - 1 >= 1) {
            // 默认情况
            [leftArrow setImage:[UIImage imageNamed:@"left_after.png"]];

            if (testNowChoose - 1 == 1) {
                [leftArrow setImage:[UIImage imageNamed:@"left_before.png"]];
            }

            // 默认情况
            [rightArrow setImage:[UIImage imageNamed:@"right_after.png"]];

            nowChoose--;
        }
    } else if ([imageViewTap view].tag == 1) {
        if (testNowChoose + 1 <= totalArray.count) {
            // 默认情况
            [rightArrow setImage:[UIImage imageNamed:@"right_after.png"]];

            if (testNowChoose + 1 == totalArray.count) {
                [rightArrow setImage:[UIImage imageNamed:@"right_before.png"]];
            }

            // 默认情况
            [leftArrow setImage:[UIImage imageNamed:@"left_after.png"]];

            nowChoose++;
        }
    }

    // 如果发生变化，则需要更新数据
    if (testNowChoose != nowChoose + 1) {
        // 重新加载数据
        [pickerView reloadAllComponents];
    }
}

// 完成选择
- (void)finishChoose
{
    [self fadeHideOut];
}

#pragma mark - UIPickerView Date Source delegate

// 当前数据需要显示的列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// 当前列所有数据的总行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [[totalArray objectAtIndex:nowChoose] count];
}

#pragma mark - UIPickerView delegate

// 当前行所对应的cotent
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [[totalArray objectAtIndex:nowChoose] objectAtIndex:row];
}

// 用户滑动响应
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // 显示最新的结果
    UIButton *btn = [BtnArray objectAtIndex:nowChoose];

    [btn setTitle:[[totalArray objectAtIndex:nowChoose] objectAtIndex:row] forState:UIControlStateNormal];

    // 显示最后的结果
    [self getAndShowSelectedText];
}

#pragma mark - Animate

// 出现动画
- (void)fadeHideIn
{
    bottomView.transform = CGAffineTransformMakeScale(1.3, 1.3);
    bottomView.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        bottomView.alpha = 1;
        bottomView.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

// 消失动画
- (void)fadeHideOut
{
    [UIView animateWithDuration:.35 animations:^{
        bottomView.transform = CGAffineTransformMakeScale(1.3, 1.3);
        bottomView.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {}
    }];
}

#pragma mark - Function

// 预设箭头状态
- (void)initArrowState
{
    if (totalArray.count == 0) {
        
        [leftArrow setImage:[UIImage imageNamed:@"left_before.png"]];

        [rightArrow setImage:[UIImage imageNamed:@"right_before.png"]];
        
        return;
    }
    
    if (nowChoose == 0) {
        
        [leftArrow setImage:[UIImage imageNamed:@"left_before.png"]];
        
        return;
    }
    
    if (nowChoose == totalArray.count-1) {
        
        [leftArrow setImage:[UIImage imageNamed:@"left_after.png"]];
        
        [rightArrow setImage:[UIImage imageNamed:@"right_before.png"]];
        
        return;
    }
    

    if ((nowChoose> 0) && (nowChoose < totalArray.count-1)) {
        [leftArrow setImage:[UIImage imageNamed:@"left_after.png"]];

        [rightArrow setImage:[UIImage imageNamed:@"right_after.png"]];
    }
}

// 获取并显示最后拼接结果
- (void)getAndShowSelectedText
{
    UIButton *btn;

    NSString *lastResult = @"";

    // 动态显示最后的结果
    for (int count = 0; count < BtnArray.count; count++) {
        btn = [BtnArray objectAtIndex:count];

        lastResult = [lastResult stringByAppendingString:btn.titleLabel.text];
        lastResult = [lastResult stringByAppendingString:@" "];
    }

    [selectedText setText:lastResult];
}

// 计算字体宽高
- (CGSize)boundingRectWithText:(NSString *)text WithSize:(CGSize)size WithFont:(UIFont *)font
{
    NSDictionary *attribute = @{NSFontAttributeName: font};

    CGSize retSize = [text
        boundingRectWithSize:size
        options             :
        NSStringDrawingTruncatesLastVisibleLine |
        NSStringDrawingUsesLineFragmentOrigin |
        NSStringDrawingUsesFontLeading
        attributes:attribute
        context:nil].size;

    return retSize;
}

// 计算数组最长字段的大小
- (CGSize)findMaxLengthStrSizeWithArray:(NSArray *)array WithFontSize:(int)fonsize
{
    int i = 0;

    NSString *indexStr;

    NSString *maxStr;

    for (int j = 0; j < array.count; j++) {
        indexStr = [array objectAtIndex:j];

        maxStr = [array objectAtIndex:i];

        if (indexStr.length > maxStr.length) {
            i = j;
        }
    }

    CGSize size = [self boundingRectWithText:[array objectAtIndex:i] WithSize:CGSizeMake(globleWidth, 0) WithFont:[UIFont systemFontOfSize:fonsize]];

    return size;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end