//
//  XiaoXiTableViewCell.m
//  DistributionQuery
//
//  Created by Macx on 16/11/29.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "XiaoXiTableViewCell.h"
@interface XiaoXiTableViewCell()
@property(nonatomic,strong)UILabel * titleLabel;
@property(nonatomic,strong)UILabel * timeLabel;
@end
@implementation XiaoXiTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+(instancetype)cellWithTableView:(UITableView*)tableView CellID:(NSString*)cellID{
    XiaoXiTableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell=[[XiaoXiTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
    }
    cell.layer.cornerRadius=5;
    cell.clipsToBounds=YES;
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
    _titleLabel=[UILabel new];
    _timeLabel=[UILabel new];
    [self.contentView sd_addSubviews:@[_titleLabel,_timeLabel]];
    
    _titleLabel.alpha=.5;
    _titleLabel.font=[UIFont systemFontOfSize:16];
    _timeLabel.alpha=.5;
    _titleLabel.numberOfLines=2;
    _timeLabel.font=[UIFont systemFontOfSize:14];
    
    
    _titleLabel.text=@"您已参加稍后的拍卖会，保证金马上到账，请于2016-11-30准时参加拍卖会，您已参加您已参加稍后的拍卖会，保证金马上到账，请于2016-11-30准时参加拍卖会，您已参加";
    _titleLabel.attributedText=[ToolClass hangJianJuStr:_titleLabel.text JuLi:5];
    _timeLabel.text=@"2016-11-24 10:00";
    _titleLabel.sd_layout
    .leftSpaceToView(self.contentView,15)
    .rightSpaceToView(self.contentView,10)
    .topSpaceToView(self.contentView,15)
    .heightIs(60);
    
    _timeLabel.sd_layout
    .rightSpaceToView(self.contentView,15)
    .topSpaceToView(_titleLabel,15)
    .heightIs(20);
    [_timeLabel setSingleLineAutoResizeWithMaxWidth:ScreenWidth];
    
}
-(void)setFrame:(CGRect)frame
{
    frame.origin.y+=10;
    frame.size.height-=10;
    frame.origin.x+=10;
    frame.size.width-=20;
    [super setFrame:frame];
}
-(void)setModel:(XiaoXiModel *)model
{
    _model=model;
     _titleLabel.text=model.contentStr;
    _timeLabel.text=model.sendTime;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
