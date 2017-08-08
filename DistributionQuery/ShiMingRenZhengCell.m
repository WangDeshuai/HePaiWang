//
//  ShiMingRenZhengCell.m
//  DistributionQuery
//
//  Created by Macx on 17/6/2.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "ShiMingRenZhengCell.h"

@interface ShiMingRenZhengCell ()

@end

@implementation ShiMingRenZhengCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+(instancetype)cellWithTableView:(UITableView*)tableView IndexPath:(NSIndexPath *)indexPath{
    NSString * cellID =[NSString stringWithFormat:@"%lu%lu",(long)indexPath.section,(long)indexPath.row];
    ShiMingRenZhengCell * cell =[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell=[[ShiMingRenZhengCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self CreatStar];
    }
    return self;
}
-(void)CreatStar{
    _namelabel=[UILabel new];
    _namelabel.alpha=.7;
    _namelabel.font=[UIFont systemFontOfSize:15];
    [self.contentView sd_addSubviews:@[_namelabel]];
    _namelabel.sd_layout
    .leftSpaceToView(self.contentView,15)
    .topSpaceToView(self.contentView,15)
    .heightIs(20);
    [_namelabel setSingleLineAutoResizeWithMaxWidth:200];
    
    
    _textfield=[UITextField new];
    _textfield.font=[UIFont systemFontOfSize:15];
    _textfield.textAlignment=2;
    [self.contentView sd_addSubviews:@[_textfield]];
    _textfield.sd_layout
    .rightSpaceToView(self.contentView,15)
    .centerYEqualToView(_namelabel)
    .widthIs(150)
    .heightIs(30);
   
    _bgScrollView=[UIScrollView new];
    _bgScrollView.hidden=YES;
//    _bgScrollView.backgroundColor=[UIColor redColor];
    [self.contentView sd_addSubviews:@[_bgScrollView]];
    _bgScrollView.sd_layout
    .leftSpaceToView(self.contentView,0)
    .rightSpaceToView(self.contentView,0)
    .topSpaceToView(_namelabel,15)
    .bottomSpaceToView(self.contentView,0);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
