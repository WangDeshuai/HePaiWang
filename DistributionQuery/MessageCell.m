//
//  MessageCell.m
//  DistributionQuery
//
//  Created by Macx on 16/11/29.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "MessageCell.h"
@interface MessageCell()
@end
@implementation MessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+(instancetype)cellWithTableView:(UITableView*)tableView CellID:(NSString*)cellID{
    MessageCell * cell =[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell=[[MessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
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
    _headImage=[UIImageView new];
    _textfield=[UITextField new];
    [self.contentView sd_addSubviews:@[_nameLabel,_headImage,_textfield]];
    _nameLabel.font=[UIFont systemFontOfSize:15];
    _nameLabel.alpha=.5;
    _textfield.alpha=.7;
    _textfield.font=[UIFont systemFontOfSize:15];
    
    _nameLabel.sd_layout
    .leftSpaceToView(self.contentView,15)
    .centerYEqualToView(self.contentView)
    .heightIs(20);
    [_nameLabel setSingleLineAutoResizeWithMaxWidth:120];
    
//    _textfield.backgroundColor=[UIColor yellowColor];
    _textfield.sd_layout
    .rightSpaceToView(self.contentView,15)
    .centerYEqualToView(self.contentView)
    .leftSpaceToView(_nameLabel,10)
    .heightIs(20);
    _headImage.sd_cornerRadius=@(130/4);
    _headImage.sd_layout
    .rightSpaceToView(self.contentView,15)
    .centerYEqualToView(self.contentView)
    .widthIs(130/2)
    .heightIs(130/2);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
