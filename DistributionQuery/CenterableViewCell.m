//
//  CenterableViewCell.m
//  DistributionQuery
//
//  Created by Macx on 17/3/3.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "CenterableViewCell.h"
@interface CenterableViewCell()

@property(nonatomic,strong)UILabel * nameLabel;
@end
@implementation CenterableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+(instancetype)cellWithTableView:(UITableView*)tableView{
    static NSString * ID =@"center";
    CenterableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell =[[CenterableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    return cell;
}



-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView * bg =[[UIImageView alloc]init];
        bg.image=[UIImage imageNamed:@"bg_dropdown_leftpart"];
        self.backgroundView=bg;
        
        UIImageView * selectbg =[UIImageView new];
        selectbg.image=[UIImage imageNamed:@"bg_dropdown_left_selected"];
        self.selectedBackgroundView=selectbg;
        
        _nameLabel=[UILabel new];
        if (ScreenWidth==320) {
            _nameLabel.font=[UIFont systemFontOfSize:13];
        }else{
            _nameLabel.font=[UIFont systemFontOfSize:15];
        }
        _nameLabel.textAlignment=1;
        [self.contentView sd_addSubviews:@[_nameLabel]];
        _nameLabel.sd_layout
        .leftSpaceToView(self.contentView,0)
        .rightSpaceToView(self.contentView,0)
        .heightIs(20)
        .centerYEqualToView(self.contentView);
    }
    
    
    return self;
}
-(void)setName:(NSString *)name
{
    _name=name;
    _nameLabel.text=name;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
