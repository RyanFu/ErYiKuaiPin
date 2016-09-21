//
//  KPChooseProductNumView.m
//  KuaiPin
//
//  Created by 21_xm on 16/9/9.
//  Copyright © 2016年 21_xm. All rights reserved.
//

#import "KPChooseProductNumView.h"
#import "KPSelecteGoodButton.h"

@interface KPChooseProductNumView ()<UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *numberBgView;

@property (nonatomic, strong) UIButton *reduceBtn;

@property (nonatomic, strong) UIButton *addBtn;

@property (nonatomic, strong) UILabel *numberLB;

@property (nonatomic, strong) KPSelecteGoodButton *selectedBtn;

@property (nonatomic, strong) UILabel *numTitleLab;

@end

@implementation KPChooseProductNumView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        [self addSubview:self.numberBgView];
        [self addSubview:self.reduceBtn];
        [self addSubview:self.numberLB];
        [self addSubview:self.addBtn];
        [self addSubview:self.numTitleLab];
        
        UIView *bottomLine = [UIView line];
        [self addSubview:bottomLine];
        
//        self.maxNum = 10;
//        self.num = 1;

        __weak typeof (self) weakSelf = self;
        [self.numberBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(weakSelf).offset(-15);
            make.bottom.mas_equalTo(weakSelf).offset(-13);
            make.width.mas_equalTo(78);
            make.height.mas_equalTo(24);
        }];
        
        [self.numberLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(weakSelf.numberBgView);
            make.top.bottom.mas_equalTo(weakSelf.numberBgView);
            make.width.mas_equalTo(29);
        }];
        
        [self.reduceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.mas_equalTo(weakSelf.numberBgView);
            make.right.mas_equalTo(weakSelf.numberLB.mas_left);
        }];
        
        [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.mas_equalTo(weakSelf.numberBgView);
            make.left.mas_equalTo(weakSelf.numberLB.mas_right);
        }];
        
        [self.numTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf).offset(12);
            make.top.mas_equalTo(weakSelf).offset(17);
        }];
        
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(weakSelf);
            make.left.mas_equalTo(weakSelf).offset(CommonMargin);
            make.right.mas_equalTo(weakSelf).offset(-CommonMargin);
            make.height.mas_equalTo(1);
        }];
    }
    return self;
}

- (void)clickReduceButton
{
    self.num--;
}

- (void)clickAddButton
{
    self.num++;
}

- (void)setNum:(NSInteger)num {

    _num = num;

    if (num < 1) {
        _num = 1;
    }

    self.reduceBtn.enabled = (_num > 1) ? YES : NO;
    self.addBtn.enabled = (_num < self.maxNum) ? YES : NO;

    self.numberLB.text = [NSString stringWithFormat:@"%zd", _num];
    
}

- (void)setMaxNum:(NSInteger)maxNum {
    
    _maxNum = maxNum > 99 ? 99 : maxNum;

    self.num = maxNum > 0 ? 1 : 0;

}

// UI控件
- (UIImageView *)numberBgView {
    if (_numberBgView == nil) {
        _numberBgView = [UIImageView new];
        [_numberBgView setImage:[UIImage imageNamed:@"cart_numberbg"]];
    }
    return _numberBgView;
}

- (UIButton *)reduceBtn {
    if (_reduceBtn == nil) {
        _reduceBtn = [UIButton new];
        [_reduceBtn setImage:[UIImage imageNamed:@"cart_num_minus_select"] forState:UIControlStateNormal];
        [_reduceBtn setImage:[UIImage imageNamed:@"cart_num_minus_unselect"] forState:UIControlStateDisabled];
        [_reduceBtn addTarget:self action:@selector(clickReduceButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reduceBtn;
}

- (UILabel *)numberLB {
    if (_numberLB == nil) {
        _numberLB = [UILabel addLabelWithTitle:nil textColor:BlackColor font:UIFont_13];
        _numberLB.textAlignment = NSTextAlignmentCenter;
        _numberLB.text = [NSString stringWithFormat:@"1"];
    }
    return _numberLB;
}

- (UIButton *)addBtn {
    if (_addBtn == nil) {
        _addBtn = [UIButton new];
        [_addBtn setImage:[UIImage imageNamed:@"cart_number_plus_select"] forState:UIControlStateNormal];
        [_addBtn setImage:[UIImage imageNamed:@"cart_number_plus_unselect"] forState:UIControlStateDisabled];
        [_addBtn addTarget:self action:@selector(clickAddButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;
}


- (UILabel *)numTitleLab {
    if (_numTitleLab == nil) {
        _numTitleLab = [UILabel addLabelWithTitle:nil textColor:HexColor(8a8a8a) font:UIFont_15];
        _numTitleLab.text = @"数量";
    }
    return _numTitleLab;
}

@end
