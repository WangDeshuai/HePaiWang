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
    _textfield=[UITextField new];
    _bgScrollview=[UIScrollView new];
     _codeBtn=[UIButton new];
    [self.contentView sd_addSubviews:@[_nameLabel,_textfield,_codeBtn,_bgScrollview]];
   //属性
    
    _nameLabel.alpha=.8;
    if (ScreenWidth==320) {
         _textfield.font=[UIFont systemFontOfSize:14];
        _nameLabel.font=[UIFont systemFontOfSize:14];
    }else{
         _textfield.font=[UIFont systemFontOfSize:16];
        _nameLabel.font=[UIFont systemFontOfSize:16];
    }
   
    _textfield.alpha=.8;
    _codeBtn.hidden=YES;
    _codeBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    _codeBtn.sd_cornerRadius=@(5);
    //赋值
   _codeBtn.backgroundColor=[UIColor colorWithRed:242/255.0 green:142/255.0 blue:146/255.0 alpha:1];
    [_codeBtn setTitle:@"获取验证码" forState:0];
    //坐标
    //nameLabel
    _nameLabel.sd_layout
    .leftSpaceToView(self.contentView,15)
    .topSpaceToView(self.contentView,15)
    .widthIs(90)
    .heightIs(20);
    //textField
    _textfield.sd_layout
    .leftSpaceToView(_nameLabel,0)
    .rightSpaceToView(self.contentView,5)
    .topSpaceToView(self.contentView,15)
    .heightIs(20);
    //按钮
    _codeBtn.sd_layout
    .rightSpaceToView(self.contentView,15)
    .centerYEqualToView(_nameLabel)
    .widthIs(90)
    .heightIs(30);
    //滚动试图
    _bgScrollview.hidden=YES;
    _bgScrollview.sd_layout
    .leftSpaceToView(self.contentView,15)
    .topSpaceToView(_nameLabel,15)
    .bottomSpaceToView(self.contentView,15)
    .rightSpaceToView(self.contentView,15);
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
