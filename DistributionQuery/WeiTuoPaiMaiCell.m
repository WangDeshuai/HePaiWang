//
//  WeiTuoPaiMaiCell.m
//  DistributionQuery
//
//  Created by Macx on 16/11/23.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "WeiTuoPaiMaiCell.h"
@interface WeiTuoPaiMaiCell()

@end
@implementation WeiTuoPaiMaiCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+(instancetype)cellWithTableView:(UITableView*)tableView CellID:(NSString*)cellID{
    WeiTuoPaiMaiCell * cell =[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell=[[WeiTuoPaiMaiCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
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
    _codeBtn=[UIButton new];
    _textfield=[UITextField new];
    [self.contentView sd_addSubviews:@[_nameLabel,_codeBtn,_textfield]];
   //属性
    _nameLabel.font=[UIFont systemFontOfSize:16];
    _nameLabel.alpha=.8;
    _textfield.font=[UIFont systemFontOfSize:16];
    _textfield.alpha=.8;
    _codeBtn.hidden=YES;
    _codeBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    _codeBtn.sd_cornerRadius=@(5);
    //赋值
   _codeBtn.backgroundColor=[UIColor colorWithRed:242/255.0 green:142/255.0 blue:146/255.0 alpha:1];
    [_codeBtn setTitle:@"获取验证码" forState:0];
//    _nameLabel.backgroundColor=[UIColor redColor];
   // _textfield.backgroundColor=[UIColor yellowColor];
    //坐标
    //nameLabel
    _nameLabel.sd_layout
    .leftSpaceToView(self.contentView,15)
    .centerYEqualToView(self.contentView)
    .widthIs(90)
    .heightIs(20);
    //textField
    _textfield.sd_layout
    .leftSpaceToView(_nameLabel,0)
    .rightSpaceToView(self.contentView,15)
    .centerYEqualToView(_nameLabel)
    .heightIs(20);
    //按钮
    _codeBtn.sd_layout
    .rightSpaceToView(self.contentView,15)
    .centerYEqualToView(_nameLabel)
    .widthIs(90)
    .heightIs(30);
    
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
