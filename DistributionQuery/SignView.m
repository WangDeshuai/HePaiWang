//
//  SignView.m
//  DistributionQuery
//
//  Created by Macx on 17/4/18.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "SignView.h"
@interface SignView()
@property(nonatomic,assign)CGPoint lastPoint;
@property(nonatomic,assign)BOOL isSwiping;
@property(nonatomic,assign)CGFloat red;
@property(nonatomic,assign)CGFloat green;
@property(nonatomic,assign)CGFloat blue;
@property(nonatomic,strong)NSMutableArray * xPoints;
@property(nonatomic,strong)NSMutableArray * yPoints;

@property(nonatomic,strong)UIImageView * imageView;
@property(nonatomic, strong) UIBezierPath *bezier;
//存储Undo出来的线条
@property(nonatomic, strong) NSMutableArray *cancleArray;
@end


@implementation SignView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIView * headView =[UIView new];
        headView.backgroundColor=BG_COLOR;
        [self sd_addSubviews:@[headView]];
        headView.sd_layout
        .leftSpaceToView(self,0)
        .rightSpaceToView(self,0)
        .topSpaceToView(self,0)
        .heightIs(45);
//        //确认
        UIButton * sureBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        sureBtn.sd_cornerRadius=@(3);
        sureBtn.backgroundColor=[UIColor redColor];
        [sureBtn setTitle:@"确认签字" forState:0];
        [sureBtn addTarget:self action:@selector(queRenBtn:) forControlEvents:UIControlEventTouchUpInside];
        sureBtn.tag=1;
        sureBtn.titleLabel.font=[UIFont systemFontOfSize:15];
        [headView sd_addSubviews:@[sureBtn]];
        sureBtn.sd_layout
        .widthIs(70)
        .rightSpaceToView(headView,10)
        .centerYEqualToView(headView)
        .heightIs(35);
       
        
        
        
        
        //取消
        UIButton * backBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.sd_cornerRadius=@(3);
        backBtn.backgroundColor=[UIColor lightGrayColor];
        [backBtn setTitle:@"取消" forState:0];
        [backBtn addTarget:self action:@selector(queRenBtn:) forControlEvents:UIControlEventTouchUpInside];
        backBtn.tag=0;
        backBtn.titleLabel.font=[UIFont systemFontOfSize:15];
        [headView sd_addSubviews:@[backBtn]];
        backBtn.sd_layout
        .widthIs(70)
        .leftSpaceToView(headView,10)
        .centerYEqualToView(headView)
        .heightIs(35);
        
        
        
        //中间label
        UILabel * titlabel =[UILabel new];
        titlabel.text=@"请在下方签字";
        titlabel.textAlignment=1;
        titlabel.textColor=[UIColor blackColor];
        [headView sd_addSubviews:@[titlabel]];
        titlabel.sd_layout
        .leftSpaceToView(backBtn,10)
        .rightSpaceToView(sureBtn,10)
        .centerYEqualToView(headView)
        .heightIs(35);
//        
        
        self.imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 45, ScreenWidth, 300)];
        self.imageView.backgroundColor=[UIColor whiteColor];
        self.imageView.layer.borderWidth = 1.0;
        self.imageView.layer.borderColor =[[UIColor colorWithRed:0x33/255.0 green:0x33/255.0 blue:0x33/255.0 alpha:1] CGColor];
        [self addSubview:self.imageView];
       // [self sd_addSubviews:@[self.imageView]];
//        self.imageView.sd_layout
//        .leftSpaceToView(self,0)
//        .rightSpaceToView(self,0)
//        .bottomSpaceToView(self,0)
//        .topSpaceToView(headView,0);
        self.backgroundColor=[UIColor whiteColor];
    }
    return self;
}


-(void)queRenBtn:(UIButton*)button{
    
    if (button.tag==0) {
        //清空
        [_xPoints removeAllObjects];
        [_yPoints removeAllObjects];
        [_cancleArray removeAllObjects];
        self.imageView.image=nil;
    }else{
//        NSLog(@"btn>>>%@",self.imageView.image);
    }
    
    
    if ([_delegate respondsToSelector:@selector(buttonClinkTwo: Image:)]) {
        [_delegate buttonClinkTwo:button Image:self.imageView.image];
    }

}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.isSwiping    = false;
    UITouch * touch = touches.anyObject;
    self.lastPoint = [touch locationInView:self.imageView];
    [self.xPoints addObject:[NSNumber numberWithFloat:self.lastPoint.x]];
    [self.yPoints addObject:[NSNumber numberWithFloat:self.lastPoint.y]];
}
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.isSwiping = true;
    UITouch * touch = touches.anyObject;
    CGPoint currentPoint = [touch locationInView:self.imageView];
    UIGraphicsBeginImageContext(self.imageView.frame.size);
    [self.imageView.image drawInRect:(CGRectMake(0, 0, self.imageView.frame.size.width, self.imageView.frame.size.height))];
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), self.lastPoint.x, self.lastPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(),kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 3.0);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(),0.0, 0.0, 0.0, 1.0);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.lastPoint = currentPoint;
    [self.xPoints addObject:[NSNumber numberWithFloat:self.lastPoint.x]];
    [self.yPoints addObject:[NSNumber numberWithFloat:self.lastPoint.y]];
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if(!self.isSwiping) {
        // This is a single touch, draw a point
        UIGraphicsBeginImageContext(self.imageView.frame.size);
        [self.imageView.image drawInRect:(CGRectMake(0, 0, self.imageView.frame.size.width, self.imageView.frame.size.height))];
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 3.0);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 0.0, 0.0, 1.0);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), self.lastPoint.x, self.lastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), self.lastPoint.x, self.lastPoint.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
}
#pragma mark getter && setter
-(NSMutableArray*)xPoints
{
    if (!_xPoints) {
        _xPoints=[[NSMutableArray alloc]initWithCapacity:0];
    }
    return _xPoints;
}
-(NSMutableArray*)yPoints
{
    if (!_yPoints) {
        _yPoints=[[NSMutableArray alloc]initWithCapacity:0];
    }
    return _yPoints;
}
#pragma mark delegate
- (void)showImage:(UIImage *)image
{
   
    
    NSLog(@"走没走代理image");
    //检测代理有没有实现代理方法
    if([self.delegate respondsToSelector:@selector(showImage:)]){
        [self.delegate showImage:image];
    }else{
        NSLog(@"代理没有实现changeStatus:方法");
    }
}


@end
