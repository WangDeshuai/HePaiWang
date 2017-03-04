//
//  MyPublicYuGaoCell.m
//  DistributionQuery
//
//  Created by Macx on 16/11/29.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "MyPublicYuGaoCell.h"
@interface MyPublicYuGaoCell ()
@property(nonatomic,strong)UIImageView * leftImage;//左边的图片
@property(nonatomic,strong)UILabel * titleLabel;//标题
@property(nonatomic,strong)UILabel * timeLabel;//发布时间
@property(nonatomic,strong)UIView * lineView;//灰线
@property(nonatomic,strong)UIButton * xiangQingBtn;//详情按钮
@property(nonatomic,strong)UIButton * deleteBtn;//删除按钮

@end
@implementation MyPublicYuGaoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+(instancetype)cellWithTableView:(UITableView*)tableView CellID:(NSString*)cellID{
    MyPublicYuGaoCell * cell =[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell=[[MyPublicYuGaoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
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
     leftImage;//左边的图片
     titleLabel;//标题
     timeLabel;//发布时间
     lineView;//灰线
     xiangQingBtn;//详情按钮
     deleteBtn;//删除按钮
     */
    _leftImage=[UIImageView new];
    _titleLabel=[UILabel new];
    _timeLabel=[UILabel new];
    _lineView=[UIView new];
    _xiangQingBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _deleteBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView sd_addSubviews:@[_leftImage,_titleLabel,_timeLabel]];
     [self.contentView sd_addSubviews:@[_lineView,_xiangQingBtn,_deleteBtn]];
    //属性
    
    _titleLabel.font=[UIFont systemFontOfSize:16];
    _titleLabel.alpha=.8;
    _titleLabel.numberOfLines=0;
    _timeLabel.font=[UIFont systemFontOfSize:14];
    _timeLabel.alpha=.6;
    _lineView.backgroundColor=BG_COLOR;
    //赋值
    _leftImage.image=[UIImage imageNamed:@"fbyg_pc"];
    _titleLabel.text=@"出售海泰500T注塑机";
    _timeLabel.text=@"发布时间  2016-11-28";
    [_xiangQingBtn setBackgroundImage:[UIImage imageNamed:@"fbyg_bt1"] forState:0];
    [_deleteBtn setBackgroundImage:[UIImage imageNamed:@"fbyg_bt2"] forState:0];
    
    [self zuoBiaoFrame];
}

-(void)zuoBiaoFrame{
    //左边图片
    _leftImage.sd_layout
    .leftSpaceToView(self.contentView,15)
    .topSpaceToView(self.contentView,15)
    .widthIs(206/2)
    .heightIs(156/2);
    //标题
    _titleLabel.sd_layout
    .leftSpaceToView(_leftImage,10)
    .topSpaceToView(self.contentView,15)
    .rightSpaceToView(self.contentView,15)
    .autoHeightRatio(0);
    //发布时间
    _timeLabel.sd_layout
    .leftEqualToView(_titleLabel)
    .topSpaceToView(_titleLabel,15)
    .rightSpaceToView(self.contentView,15)
    .heightIs(20);
    //会线条
    _lineView.sd_layout
    .leftSpaceToView(self.contentView,0)
    .rightSpaceToView(self.contentView,0)
    .topSpaceToView(_leftImage,15)
    .heightIs(1);
    
    
    //查看详情
    _xiangQingBtn.sd_layout
    .rightSpaceToView(self.contentView,15)
    .topSpaceToView(_lineView,15)
    .widthIs(126/2)
    .heightIs(56/2);
    //删除
    _deleteBtn.sd_layout
    .rightSpaceToView(_xiangQingBtn,10)
    .centerYEqualToView(_xiangQingBtn)
    .widthIs(126/2)
    .heightIs(56/2);
    
    
}
-(void)setModel:(MyPublicYuGaoModel *)model
{
    _model=model;
    
    [_leftImage setImageWithURL:[NSURL URLWithString:model.headImage] placeholderImage:[UIImage imageNamed:@"fbyg_pc"]];
    
    _titleLabel.text=model.titleName;
    _timeLabel.text=[NSString stringWithFormat:@"发布时间  %@",model.timeName];//@"发布时间  2016-11-28";
}
-(void)setFrame:(CGRect)frame
{
    frame.origin.y+=5;
    frame.size.height-=5;
    [super setFrame:frame];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
