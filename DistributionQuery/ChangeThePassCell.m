//
//  ChangeThePassCell.m
//  DistributionQuery
//
//  Created by Macx on 17/3/13.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "ChangeThePassCell.h"

@implementation ChangeThePassCell


+(instancetype)cellWithTableView:(UITableView*)tableView CellID:(NSString*)cellID{
    ChangeThePassCell * cell =[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell=[[ChangeThePassCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
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
    _leftImage=[UIButton new];
    _textfield=[UITextField new];
    _codeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _codeBtn.backgroundColor=JXColor(255, 150, 154, 1);
    _codeBtn.sd_cornerRadius=@(5);
    _textfield.font=[UIFont systemFontOfSize:15];
    [_codeBtn setTitle:@"获取验证码" forState:0];
    _codeBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    [self.contentView sd_addSubviews:@[_leftImage,_textfield,_codeBtn]];
    
    //26  32
    _leftImage.adjustsImageWhenHighlighted=NO;
    _leftImage.sd_layout
    .leftSpaceToView(self.contentView,15)
    .centerYEqualToView(self.contentView)
    .widthIs(26)
    .heightIs(32);
    
    
    _textfield.sd_layout
    .leftSpaceToView(_leftImage,15)
    .rightSpaceToView(self.contentView,5)
    .centerYEqualToView(self.contentView)
    .heightIs(30);
    
    _codeBtn.hidden=YES;
    _codeBtn.sd_layout
    .rightSpaceToView(self.contentView,15)
    .centerYEqualToView(self.contentView)
    .widthIs(100)
    .heightIs(30);
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
