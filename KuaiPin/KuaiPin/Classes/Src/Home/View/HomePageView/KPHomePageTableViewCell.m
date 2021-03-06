//
//  KPHomePageTableViewCell.m
//  KuaiPin
//
//  Created by 21_xm on 16/9/2.
//  Copyright © 2016年 21_xm. All rights reserved.
//

#import "KPHomePageTableViewCell.h"
#import "KPBrand.h"

@interface KPHomePageTableViewCell ()

@property (nonatomic, weak) UIImageView *topImage;

@property (nonatomic, weak) UILabel *title;

@end
@implementation KPHomePageTableViewCell

+ (instancetype)cellWithTable:(UITableView *)table
{
    static NSString *homePageTableViewCell = @"homePageTableViewCell";
    KPHomePageTableViewCell *cell = [table dequeueReusableCellWithIdentifier:homePageTableViewCell];
    if (cell == nil) {
        cell = [[KPHomePageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:homePageTableViewCell];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIImageView *topImage = [[UIImageView alloc] init];
        [self.contentView addSubview:topImage];
        self.topImage = topImage;
        
        UILabel *title = [UILabel addLabelWithTitle:nil textColor:BlackColor font:UIFont_14];
//        title.backgroundColor = RandomColor;
        [self.contentView addSubview:title];
        self.title = title;
        
        __weak typeof (self.contentView) weakSelf = self.contentView;
        [topImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(weakSelf);
            make.height.mas_equalTo(ScaleHeight(172));
        }];
        
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(weakSelf);
            make.top.mas_equalTo(topImage.mas_bottom);
            make.left.mas_equalTo(weakSelf).offset(CommonMargin);
            make.right.mas_equalTo(weakSelf).offset(-CommonMargin);
        }];
        
    }
    
    return self;
}

- (void)setBrand:(KPBrand *)brand
{
    _brand = brand;
    [self.topImage sd_setImageWithURL:[NSURL URLWithString:brand.brandImage] placeholderImage:[UIImage imageNamed:@"find_Placeholder"]];
    self.title.text = brand.remark.length > 0 ? brand.remark : @"二一快品";
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated { }

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated { }

@end
