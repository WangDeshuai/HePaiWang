//
//  ScanCodeCell.m
//  DistributionQuery
//
//  Created by Macx on 17/3/10.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "ScanCodeCell.h"
@interface ScanCodeCell()



@end

@implementation ScanCodeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+(instancetype)cellWithTableView:(UITableView*)tableView CellID:(NSString*)cellID{
    ScanCodeCell * cell =[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell=[[ScanCodeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
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
    _textview=[UITextView new];
    _bgScrollview=[UIScrollView new];
    [self.contentView sd_addSubviews:@[_leftLabel,_textview,_bgScrollview]];
    
    _leftLabel.alpha=.7;
    _textview.alpha=.6;
    if (ScreenWidth==320) {
        _leftLabel.font=[UIFont systemFontOfSize:13];
        _textview.font=[UIFont systemFontOfSize:13];
    }else{
         _leftLabel.font=[UIFont systemFontOfSize:15];
         _textview.font=[UIFont systemFontOfSize:15];
    }
    
    
    _leftLabel.sd_layout
    .leftSpaceToView(self.contentView,15)
    .topSpaceToView(self.contentView,13)
    .widthIs(80)
    .heightIs(20);
    
    _textview.sd_layout
    .leftSpaceToView(_leftLabel,10)
    .rightSpaceToView(self.contentView,15)
    .topSpaceToView(self.contentView,5)
    .bottomSpaceToView(self.contentView,5);
    
    _textview.layer.borderWidth=.5;
    _textview.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
    _bgScrollview.hidden=YES;
//    _bgScrollview.backgroundColor=[UIColor yellowColor];
    _bgScrollview.sd_layout
    .leftSpaceToView(self.contentView,15)
    .topSpaceToView(_leftLabel,10)
    .rightSpaceToView(self.contentView,15)
    .bottomSpaceToView(self.contentView,13);
    
    
//    _leftLabel.backgroundColor=[UIColor yellowColor];
//    _textview.backgroundColor=[UIColor magentaColor];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
