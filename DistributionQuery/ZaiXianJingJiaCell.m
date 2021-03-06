//
//  ZaiXianJingJiaCell.m
//  DistributionQuery
//
//  Created by Macx on 16/11/24.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "ZaiXianJingJiaCell.h"
@interface ZaiXianJingJiaCell()

@end
@implementation ZaiXianJingJiaCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+(instancetype)cellWithTableView:(UITableView*)tableView CellID:(NSString*)cellID{
    ZaiXianJingJiaCell * cell =[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell=[[ZaiXianJingJiaCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
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
    _leftLabel=[UILabel new];
    _rightLabel=[UILabel new];
    _centerLabel=[UILabel new];
    [self.contentView sd_addSubviews:@[_leftLabel,_rightLabel,_centerLabel]];
    //属性
    _leftLabel.font=[UIFont systemFontOfSize:14];
    _leftLabel.alpha=.6;
    _rightLabel.font=[UIFont systemFontOfSize:14];
    _rightLabel.alpha=.6;
    _centerLabel.font=[UIFont systemFontOfSize:14];
    _centerLabel.alpha=.6;
    
//    _leftLabel.backgroundColor=[UIColor redColor];
//    _centerLabel.backgroundColor=[UIColor yellowColor];
//    _rightLabel.backgroundColor=[UIColor magentaColor];
    
     _leftLabel.textAlignment=1;
     _centerLabel.textAlignment=0;
     _rightLabel.textAlignment=1;
    
    _centerLabel.textColor=[UIColor redColor];
   
    //坐标
    _leftLabel.sd_layout
    .leftSpaceToView(self.contentView,0)
    .topSpaceToView(self.contentView,12)
    .widthIs(ScreenWidth/3.5)
    .heightIs(20);
    
    _centerLabel.sd_layout
    .centerXEqualToView(self.contentView)
    .topEqualToView(_leftLabel)
    .heightIs(20)
    .widthIs(ScreenWidth/4);
    
    _rightLabel.sd_layout
    .rightSpaceToView(self.contentView,5)
    .topSpaceToView(self.contentView,12)
    .widthIs(ScreenWidth/3.5*1.5+10)
    .heightIs(20);
   // [_rightLabel setSingleLineAutoResizeWithMaxWidth:220];
    
    if (ScreenWidth==320) {
         _centerLabel.sd_layout
        .leftSpaceToView(_leftLabel,0)
        .topEqualToView(_leftLabel)
        .heightIs(20)
        .widthIs(ScreenWidth/4);
    }
    
    
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
