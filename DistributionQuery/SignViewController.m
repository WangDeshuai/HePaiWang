//
//  SignViewController.m
//  SignTest
//
//  Created by  on 16/8/23.
//  Copyright © 2016年 shixiaodan. All rights reserved.
//

#import "SignViewController.h"

@interface SignViewController ()
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

@implementation SignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"开始签名";
    UIButton * saveButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    saveButton.frame=CGRectMake(100, 20, 50, 50);
    [saveButton addTarget:self action:@selector(saveButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftBtn2 =[[UIBarButtonItem alloc]initWithCustomView:saveButton];
    self.navigationItem.rightBarButtonItems=@[leftBtn2];
    
    
    
    
    
    
    
    
    self.imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 300)];
    self.imageView.layer.borderWidth = 1.0;
    self.imageView.layer.borderColor =[[UIColor colorWithRed:0x33/255.0 green:0x33/255.0 blue:0x33/255.0 alpha:1] CGColor];
    [self.view addSubview:self.imageView];
    
    self.view.backgroundColor=[UIColor whiteColor];
}
//-(void)buttonClick
//{
//    [self dismissViewControllerAnimated:YES completion:^{
//        
//    }];
//}
-(void)saveButtonClick
{
    [self showImage:self.imageView.image];
    [self.navigationController popViewControllerAnimated:YES];
}
//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    //新建贝塞斯曲线
//    self.bezier = [UIBezierPath bezierPath];
//    
//    //获取触摸的点
//    UITouch *myTouche = [touches anyObject];
//    CGPoint point = [myTouche locationInView:self.imageView];
//    
//    //把刚触摸的点设置为bezier的起点
//    [self.bezier moveToPoint:point];
//    
//    //把每条线存入字典中
//    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] initWithCapacity:3];
//    [tempDic setObject:[UIColor blackColor] forKey:@"color"];
//    [tempDic setObject:[NSNumber numberWithFloat:5] forKey:@"lineWidth"];
//    [tempDic setObject:self.bezier forKey:@"line"];
//    
//    //把线加入数组中
//    [self.allLine addObject:tempDic];
//    
//}
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
    //检测代理有没有实现代理方法
    if([self.delegate respondsToSelector:@selector(showImage:)]){
        [self.delegate showImage:image];
    }else{
        NSLog(@"代理没有实现changeStatus:方法");
    }
}
@end
