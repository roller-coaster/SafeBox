//
//  CustomButtonTableViewCell.m
//  SafeBox
//
//  Created by 丁嘉睿 on 16/7/18.
//  Copyright © 2016年 Mr.D. All rights reserved.
//

#import "CustomButtonTableViewCell.h"
/** 标题的高度 */
#define LABEL_HEIGHT 30
/** 按钮的高度 */
#define BUTTON_HEIGHT 50
/** 字体的大小 */
#define LABEL_FONT [UIFont systemFontOfSize:15.0f]
/** 标题和view的宽度 */
#define MAIN_WIDTH [[UIScreen mainScreen] bounds].size.width - 20

@interface CustomButtonTableViewCell ()


@property (strong, nonatomic) UIView *btnBackgroundView;


@property (strong ,nonatomic) UILabel *headLab;



@end
@implementation CustomButtonTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor colorWithRed:227.0/255.0 green:228.0/255.0 blue:229.0/255.0 alpha:0.9f];
    _headLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, MAIN_WIDTH, LABEL_HEIGHT)];
    _headLab.font = LABEL_FONT;
    [self.contentView addSubview:_headLab];
    _btnBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_headLab.frame), CGRectGetMaxY(_headLab.frame), MAIN_WIDTH, BUTTON_HEIGHT)];
    _btnBackgroundView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_btnBackgroundView];

}
#pragma mark - Public Methods

#pragma mark 显示标题和按钮
- (void)showCustomViewWithHeaders:(NSString *)headers titles:(NSArray <NSString *>*)titles{
    if (titles.count == 0) return;
    /** 自适应标题大小长度 */
    if (headers.length > 0) {
        _headLab.text = headers;
        CGSize headersSize = CGSizeZero;
        if (NLSystemVersionGreaterOrEqualThan(7.0)) {
            headersSize  = [headers sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:_headLab.font,NSFontAttributeName, nil]];
        }else{
            CGRect tmpRect = [headers boundingRectWithSize:CGSizeMake(CGRectGetWidth(_headLab.frame), 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:_headLab.font,NSFontAttributeName, nil] context:nil];
            headersSize = tmpRect.size;
        }
        CGRect rect = _headLab.frame;
        rect.size = headersSize;
        _headLab.frame = rect;
    }
    
    /** 按钮的宽度 （如果需要修改按钮大小，在这里修改和修改按钮的高度宏。记住下面的类方法也得一并修改,不然cell不会自适应）*/
    CGFloat witdh = (CGRectGetWidth(_btnBackgroundView.frame) - 60) / 5;
    
    CGFloat reslutHeight = CGRectGetHeight(_btnBackgroundView.frame);
    
    for (NSInteger i = 0; i < titles.count; i ++) {
        UIButton *titlebtn = [UIButton buttonWithType:UIButtonTypeCustom];
        titlebtn.frame = CGRectMake((i % 5) * (witdh + 10) + 10, (i / 5) * (BUTTON_HEIGHT + 10) + 10, witdh, BUTTON_HEIGHT);
        [titlebtn setBackgroundColor:[UIColor greenColor]];
        [titlebtn setTitle:titles[i] forState:UIControlStateNormal];
        if ([titles.lastObject isEqualToString:titles[i]]) {
            reslutHeight = CGRectGetMaxY(titlebtn.frame) + 10;
        }
        [titlebtn addTarget:self action:@selector(bbq:) forControlEvents:UIControlEventTouchUpInside];
        [_btnBackgroundView addSubview:titlebtn];
    }
    CGRect rect = _btnBackgroundView.frame;
    rect.size.height = reslutHeight;
    _btnBackgroundView.frame = rect;    
}

#pragma mark 计算当前cell的高度
+ (CGFloat)customCellForHeightWithHeaders:(NSString *)headers titles:(NSArray *)titles{
    if (titles.count == 0) return 0.0;
    CGSize headersSize = CGSizeZero;
    /** 自适应标题大小长度 */
    if (headers.length > 0) {
        if (NLSystemVersionGreaterOrEqualThan(7.0)) {/** 计算文字大小iOS7.0之后 */
            headersSize  = [headers sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:LABEL_FONT,NSFontAttributeName, nil]];
        }else{/** 计算文字大小iOS7.0之前 */
            CGRect tmpRect = [headers boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 20, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:LABEL_FONT,NSFontAttributeName, nil] context:nil];
            headersSize = tmpRect.size;
        }
    }
    CGFloat witdh = (MAIN_WIDTH - 60) / 5;
    CGFloat resultHeight = 0.0;
    for (NSInteger i = 0; i < titles.count; i ++) {
        CGRect frame = CGRectMake((i % 5) * (witdh + 10) + 10, (i / 5) * (BUTTON_HEIGHT + 10) + 10, witdh, BUTTON_HEIGHT);
        if ([titles.lastObject isEqualToString:titles[i]]) {
            resultHeight = CGRectGetMaxY(frame);
        }
    }
    return headersSize.height + resultHeight + 50;
}

#pragma mark - 获取类名
+ (NSString *)identifier
{
    return NSStringFromClass([self class]);
}


#pragma mark - Private Methods
#pragma mark 按钮点击事件
- (void)bbq:(UIButton *)btn{
    NSString *text = btn.titleLabel.text;
    if ([self.delegate respondsToSelector:@selector(customButtonTableViewCellWithText:)]) {
        [self.delegate customButtonTableViewCellWithText:text];
    }
}
@end
