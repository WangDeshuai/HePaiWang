//
//  PaiMaiGongGaoCell.m
//  DistributionQuery
//
//  Created by Macx on 16/11/23.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "PaiMaiGongGaoCell.h"
@interface PaiMaiGongGaoCell()
@property(nonatomic,strong)UILabel * titleLabel;//标题
@property(nonatomic,strong)UIImageView * baomingImage;//开始图标
@property(nonatomic,strong)UILabel * baoMingLabel;//报名开始
@property(nonatomic,strong)UIImageView *jiezhiImage;//截止图标
@property(nonatomic,strong)UILabel * jieZhiLabel;//报名截止
@property(nonatomic,strong)UIImageView * dwImage;//定位图标
@property(nonatomic,strong)UILabel *cityLabel;//所在地区

@end
@implementation PaiMaiGongGaoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+(instancetype)cellWithTableView:(UITableView*)tableView CellID:(NSString*)cellID{
    PaiMaiGongGaoCell * cell =[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell=[[PaiMaiGongGaoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
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
     titleLabel;//标题
     baomingImage;//开始图标
     baoMingLabel;//报名开始
     jiezhiImage;//截止图标
     jieZhiLabel;//报名截止
     dwImage;//定位图标
     cityLabel;//所在地区
     */
    
    _titleLabel=[UILabel new];
    _baomingImage=[UIImageView  new];
    _baoMingLabel=[UILabel new];
    _jiezhiImage=[UIImageView  new];
    _jieZhiLabel=[UILabel new];
    _dwImage=[UIImageView  new];
    _cityLabel=[UILabel new];
    _lijiBaoMiang=[UIButton buttonWithType:UIButtonTypeCustom];
    
    [self.contentView sd_addSubviews:@[_titleLabel,_baomingImage,_baoMingLabel,_jiezhiImage]];
    [self.contentView sd_addSubviews:@[_jieZhiLabel,_dwImage,_cityLabel,_lijiBaoMiang]];
    //属性
    _titleLabel.font=[UIFont systemFontOfSize:16];
    _titleLabel.alpha=.8;
    _baoMingLabel.font=[UIFont systemFontOfSize:13];
    _baoMingLabel.alpha=.6;
    _jieZhiLabel.font=[UIFont systemFontOfSize:13];
    _jieZhiLabel.alpha=.6;
    _cityLabel.font=[UIFont systemFontOfSize:13];
    _cityLabel.alpha=.6;
    //赋值
    _titleLabel.text=@"特钢公司800热轧带钢精整设备等物品拍卖公告";
    _baoMingLabel.text=@"报名开始  2016/11/10";
    _jieZhiLabel.text=@"报名截止  2016/11/20";
    _cityLabel.text=@"所在地区  河北石家庄市";
    _baomingImage.image=[UIImage imageNamed:@"gonggao_time"];//24  26
    _jiezhiImage.image=[UIImage imageNamed:@"gonggao_stop"];//22 22
    _dwImage.image=[UIImage imageNamed:@"gonggao_dingwei"];//22  26
    [_lijiBaoMiang setBackgroundImage:[UIImage imageNamed:@"gonggao_bm"] forState:0];//130 48
    [self zuoBiaoFrame];
}
-(void)zuoBiaoFrame{
    int g =10;
    //标题
    _titleLabel.sd_layout
    .leftSpaceToView(self.contentView,15)
    .rightSpaceToView(self.contentView,15)
    .topSpaceToView(self.contentView,15)
    .heightIs(20);
    //报名图标
    _baomingImage.sd_layout
    .leftEqualToView(_titleLabel)
    .topSpaceToView(_titleLabel,g)
    .widthIs(24/2)
    .heightIs(26/2);
    //报名开始
    _baoMingLabel.sd_layout
    .leftSpaceToView(_baomingImage,10)
    .centerYEqualToView(_baomingImage)
    .heightIs(20);
    [_baoMingLabel setSingleLineAutoResizeWithMaxWidth:ScreenWidth-200];
    //截止图标
    _jiezhiImage.sd_layout
    .leftEqualToView(_baomingImage)
    .topSpaceToView(_baomingImage,g)
    .widthIs(11)
    .heightIs(11);
    //报名截止
    _jieZhiLabel.sd_layout
    .leftEqualToView(_baoMingLabel)
    .centerYEqualToView(_jiezhiImage)
    .heightIs(20);
    [_jieZhiLabel setSingleLineAutoResizeWithMaxWidth:ScreenWidth-200];
    //地区图标
    _dwImage.sd_layout
    .leftEqualToView(_baomingImage)
    .topSpaceToView(_jiezhiImage,g)
    .widthIs(11)
    .heightIs(13);
    //所在地区
    _cityLabel.sd_layout
    .leftEqualToView(_baoMingLabel)
    .centerYEqualToView(_dwImage)
    .heightIs(20);
    [_cityLabel setSingleLineAutoResizeWithMaxWidth:ScreenWidth-200];
    
    //立即报名
    _lijiBaoMiang.sd_layout
    .rightSpaceToView(self.contentView,15)
    .bottomEqualToView(_dwImage)
    .widthIs(130/2)
    .heightIs(48/2);
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
