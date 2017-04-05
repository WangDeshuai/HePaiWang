//
//  LiuYanZhuanQuCell.m
//  DistributionQuery
//
//  Created by Macx on 17/4/5.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "LiuYanZhuanQuCell.h"
@interface LiuYanZhuanQuCell()
@property(nonatomic,strong)UILabel * nameLabel ;
@property(nonatomic,strong)UILabel * timeLabel;
@property(nonatomic,strong)UILabel * contentLabel;
@end
@implementation LiuYanZhuanQuCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+(instancetype)cellWithTableView:(UITableView*)tableView CellID:(NSString*)cellID{
    LiuYanZhuanQuCell * cell =[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell=[[LiuYanZhuanQuCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
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
    _nameLabel=[UILabel new];
    _timeLabel=[UILabel new];
    _contentLabel=[UILabel new];
    [self.contentView sd_addSubviews:@[_nameLabel,_timeLabel,_contentLabel]];
    _nameLabel.textColor=JXColor(110, 175, 255, 1);
    _timeLabel.alpha=.6;
    _contentLabel.alpha=.8;
    
    _nameLabel.font=[UIFont systemFontOfSize:15];
    _timeLabel.font=[UIFont systemFontOfSize:15];
    _contentLabel.font=[UIFont systemFontOfSize:15];
    
    _nameLabel.sd_layout
    .leftSpaceToView(self.contentView,15)
    .topSpaceToView(self.contentView,10)
    .heightIs(20);
    [_nameLabel setSingleLineAutoResizeWithMaxWidth:120];
    
    _timeLabel.sd_layout
    .leftSpaceToView(_nameLabel,15)
    .rightSpaceToView(self.contentView,15)
    .heightIs(20)
    .topEqualToView(_nameLabel);
    
    _contentLabel.sd_layout
    .leftEqualToView(_nameLabel)
    .rightSpaceToView(self.contentView,15)
    .topSpaceToView(_timeLabel,10)
    .autoHeightRatio(0);
    
    _nameLabel.text=@"001";
    _timeLabel.text=@"2016-11-23 10:23:00";
    _contentLabel.text=@"这次竞价怎么这么低？机器不值钱了还是工厂快倒闭了";
    
//    _nameLabel.backgroundColor=[UIColor redColor];
//    _timeLabel.backgroundColor=[UIColor yellowColor];
//    _contentLabel.backgroundColor=[UIColor magentaColor];
    
    
    [self setupAutoHeightWithBottomView:_contentLabel bottomMargin:10];
    
}
-(void)setModel:(ZaiXianModel *)model
{
    _model=model;
    _nameLabel.text=model.faYanPeopleName;
    _timeLabel.text=model.faYanPeopleTime;
    _contentLabel.text=model.faYanPeopleContent;
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
