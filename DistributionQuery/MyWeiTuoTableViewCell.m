//
//  MyWeiTuoTableViewCell.m
//  DistributionQuery
//
//  Created by Macx on 16/11/29.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "MyWeiTuoTableViewCell.h"
@interface MyWeiTuoTableViewCell ()
@property(nonatomic,strong)UIImageView * leftImage;//左边图片
@property(nonatomic,strong)UILabel * titleLabel;//标题
@property(nonatomic,strong)UIImageView * imagedan;//起拍价图标
@property(nonatomic,strong)UILabel * qipaiLabel;//起拍价
@property(nonatomic,strong)UILabel * priceLabel;//价格
@property(nonatomic,strong)UIImageView * imagedw;//定位图标
@property(nonatomic,strong)UILabel * paimaiLabel;//拍卖地区
@property(nonatomic,strong)UILabel * cityLabel;//定位城市
@property(nonatomic,strong)UIImageView * strImage;//开拍图标
@property(nonatomic,strong)UILabel * strLabel;//开拍时间
@property(nonatomic,strong)UILabel * timeLabel;//时间




@end
@implementation MyWeiTuoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+(instancetype)cellWithTableView:(UITableView*)tableView CellID:(NSString*)cellID{
    MyWeiTuoTableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell=[[MyWeiTuoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //  self.backgroundColor=[UIColor colorWithRed:254/255.0 green:251/255.0 blue:224/255.0 alpha:1];
        [self CreatStar];
    }
    return self;
}
-(void)CreatStar{
    /*
     leftImage;//左边图片
     titleLabel;//标题
     imagedan;//起拍价图标
     qipaiLabel;//起拍价
     priceLabel;//价格
     imagedw;//定位图标
     paimaiLabel;//拍卖地区
     cityLabel;//定位城市
     strImage;//开拍图标
     strLabel;//开拍时间
     timeLabel;//时间
     */
    
    _leftImage=[UIImageView new];
    _titleLabel=[UILabel new];
    _imagedan=[UIImageView new];
    _qipaiLabel=[UILabel new];
    _priceLabel=[UILabel new];
    _imagedw=[UIImageView new];
    _paimaiLabel=[UILabel new];
    _cityLabel=[UILabel new];
    _strImage=[UIImageView new];
    _strLabel=[UILabel new];
    _timeLabel=[UILabel new];
    
    [self.contentView sd_addSubviews:@[_leftImage,_titleLabel,_imagedan,_qipaiLabel,_priceLabel]];
    [self.contentView sd_addSubviews:@[_imagedw,_paimaiLabel,_cityLabel,_strImage,_strLabel,_timeLabel]];
    //属性
    _titleLabel.font=[UIFont systemFontOfSize:16];
    _titleLabel.alpha=.8;
    _titleLabel.numberOfLines=1;
    _qipaiLabel.font=[UIFont systemFontOfSize:13];
    _qipaiLabel.alpha=.6;
    _priceLabel.font=[UIFont systemFontOfSize:17];
    _priceLabel.textColor=[UIColor redColor];
    _priceLabel.alpha=.8;
    _paimaiLabel.font=[UIFont systemFontOfSize:13];
    _paimaiLabel.alpha=.6;
    _cityLabel.font=[UIFont systemFontOfSize:13];
    _cityLabel.alpha=.6;
    _strLabel.font=[UIFont systemFontOfSize:13];
    _strLabel.alpha=.6;
    _timeLabel.font=[UIFont systemFontOfSize:13];
    _timeLabel.textColor=[UIColor redColor];
    _timeLabel.alpha=.8;
    //赋值
    _leftImage.image=[UIImage imageNamed:@"liebiao_pic1"];
    _titleLabel.text=@"出售海泰500T注塑机王璇山炮大傻子";
    _imagedan.image=[UIImage imageNamed:@"liebiao_qipai"];
    _qipaiLabel.text=@"起拍价";
    _priceLabel.text=@"8000元";
    _imagedw.image=[UIImage imageNamed:@"liebiao_dizhi"];
    _paimaiLabel.text=@"拍卖地区";
    _cityLabel.text=@"山东";
    _strImage.image=[UIImage imageNamed:@"liebiao_tiem"];
    _strLabel.text=@"开始拍卖";
    _timeLabel.text=@"2016/11/17";
    
    [self frameLabel];
}
-(void)frameLabel{
    int g =15;
    //左边图片
    _leftImage.sd_layout
    .leftSpaceToView(self.contentView,10)
    .centerYEqualToView(self.contentView)
    .widthIs(280/2)
    .heightIs(210/2);
    //titleLabel
    _titleLabel.sd_layout
    .leftSpaceToView(_leftImage,15)
    .topSpaceToView(self.contentView,10)
    .heightIs(20);
    [_titleLabel setSingleLineAutoResizeWithMaxWidth:ScreenWidth-150];
    //起拍价图标
    _imagedan.sd_layout
    .leftEqualToView(_titleLabel)
    .topSpaceToView(_titleLabel,g)
    .widthIs(24/2)
    .heightIs(24/2);
    //起拍价
    _qipaiLabel.sd_layout
    .leftSpaceToView(_imagedan,5)
    .centerYEqualToView(_imagedan)
    .heightIs(20);
    [_qipaiLabel setSingleLineAutoResizeWithMaxWidth:100];
    //价格
    _priceLabel.sd_layout
    .leftSpaceToView(_qipaiLabel,25)
    .centerYEqualToView(_imagedan)
    .heightIs(20);
    [_priceLabel setSingleLineAutoResizeWithMaxWidth:250];
    
    //拍卖地区图标
    _imagedw.sd_layout
    .leftEqualToView(_imagedan)
    .topSpaceToView(_imagedan,g)
    .widthIs(20/2)
    .heightIs(24/2);
    //拍卖地区
    _paimaiLabel.sd_layout
    .leftEqualToView(_qipaiLabel)
    .centerYEqualToView(_imagedw)
    .heightIs(20);
    [_paimaiLabel setSingleLineAutoResizeWithMaxWidth:100];
    //城市
    _cityLabel.sd_layout
    .leftEqualToView(_priceLabel)
    .centerYEqualToView(_paimaiLabel)
    .heightIs(20);
    [_cityLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    //开始拍卖图标
    _strImage.sd_layout
    .leftEqualToView(_imagedw)
    .topSpaceToView(_imagedw,g)
    .widthIs(24/2)
    .heightIs(26/2);
    //开始拍卖时间
    _strLabel.sd_layout
    .leftEqualToView(_paimaiLabel)
    .centerYEqualToView(_strImage)
    .heightIs(20);
    [_strLabel setSingleLineAutoResizeWithMaxWidth:100];
    //时间
    _timeLabel.sd_layout
    .leftEqualToView(_cityLabel)
    .centerYEqualToView(_strLabel)
    .heightIs(20);
    [_strLabel setSingleLineAutoResizeWithMaxWidth:250];
    
    [self setupAutoHeightWithBottomView:_strLabel bottomMargin:10];
}
-(void)setModel:(BuyBiaoDiModel *)model
{
    _model=model;
    /*
     _leftImage.image=[UIImage imageNamed:@"liebiao_pic1"];
     _titleLabel.text=@"出售海泰500T注塑机王璇山炮大傻子";
     _imagedan.image=[UIImage imageNamed:@"liebiao_qipai"];
     _qipaiLabel.text=@"起拍价";
     _priceLabel.text=@"8000元";
     _imagedw.image=[UIImage imageNamed:@"liebiao_dizhi"];
     _paimaiLabel.text=@"拍卖地区";
     _cityLabel.text=@"山东";
     _strImage.image=[UIImage imageNamed:@"liebiao_tiem"];
     _strLabel.text=@"开始拍卖";
     _timeLabel.text=@"2016/11/17";
     */
    [_leftImage setImageWithURL:[NSURL URLWithString:model.leftImage] placeholderImage:[UIImage imageNamed:@"liebiao_pic1"]];
    _titleLabel.text=model.titleName;
    _priceLabel.text=model.price;
    _cityLabel.text=model.diqu;
    _timeLabel.text=model.time;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
