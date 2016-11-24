

//
//  HeadLineView.m
//  京师杏林
//
//  Created by sjt on 15/11/12.
//  Copyright © 2015年 MaNingbo. All rights reserved.
//

#import "HeadLineView.h"
//颜色

@interface HeadLineView()
{
    UIButton *currentSelected;
    UILabel *label1;
    UILabel *label2;
    UILabel *label3;
    //按钮的数据
    NSMutableArray * buttonArray;
    UIButton * _lastBtn;
}
@end
@implementation HeadLineView
-(instancetype)init
{
    if (self=[super init]) {
        
        buttonArray=[[NSMutableArray alloc]init];
    }
    return self;
}
//传入currentIndex
-(void)setCurrentIndex:(NSInteger)CurrentIndex
{
    _CurrentIndex=CurrentIndex;//改变currentIndex
    [self shuaxinJiemian:_CurrentIndex];
    if ([_delegate respondsToSelector:@selector(refreshHeadLine:)]) {
        [_delegate refreshHeadLine:_CurrentIndex];
    }
}
//刷新界面
-(void)shuaxinJiemian:(NSInteger)index;
{
    if (buttonArray.count>0) {//防止没创建前为空
        for (UIButton *labelView in buttonArray) {
            if (labelView.tag==index) {
                if (labelView.tag==0) {
                    //深绿线
                    label1.backgroundColor=[UIColor redColor];//JXColor(179, 211, 85, 1);
                }else if(labelView.tag==1){
                    label2.backgroundColor=[UIColor redColor];//JXColor(179, 211, 85, 1);
                }else{
                    label3.backgroundColor=JXColor(179, 211, 85, 1);
                }
                currentSelected=labelView;
            }else{
                if (labelView.tag==0) {
                    //绿线
                    label1.backgroundColor=JXColor(238, 238, 238, 1);
                }else if(labelView.tag==1){
                    label2.backgroundColor=JXColor(238, 238, 238, 1);
                }else{
                    label3.backgroundColor=JXColor(238, 238, 238, 1);
                }
            }
        }
    }
}
//按钮点击 传入代理
-(void)buttonClick:(UIButton*)button
{
   
    _lastBtn.selected=NO;
     button.selected=!button.selected;
    _lastBtn=button;
    NSInteger viewTag=[button tag];
    if ([button isEqual:currentSelected]) {
        return;
    }
    _CurrentIndex=viewTag;
    [self shuaxinJiemian:_CurrentIndex];
    if ([_delegate respondsToSelector:@selector(refreshHeadLine:)]) {
        [_delegate refreshHeadLine:_CurrentIndex];
    }
}

//传入顶部的title
-(void)setTitleArray:(NSArray *)titleArray
{
    _titleArray=titleArray;
    UIButton * btn=NULL;
    CGFloat width=ScreenWidth/_titleArray.count;
    for (int i=0; i<_titleArray.count; i++) {
        btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(i*width, 0, width, 48);
        btn.tag=i;
        [btn setTitle:_titleArray[i] forState:UIControlStateNormal];
        btn.titleLabel.textAlignment=NSTextAlignmentCenter;
        btn.titleLabel.font=[UIFont systemFontOfSize:15.0f];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
         [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [btn setBackgroundColor:[UIColor whiteColor]];
        //_lastBtn=btn;
        [btn setUserInteractionEnabled:YES];
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [buttonArray addObject:btn];
        [self addSubview:btn];
        if (i==0) {
            currentSelected=btn;
            btn.selected=YES;
            _lastBtn=btn;
            //深绿线
            label1=[[UILabel alloc]init];//WithFrame:CGRectMake(0, 45.5, ScreenWidth/2.5, 2.5)];
            label1.backgroundColor=[UIColor redColor];//JXColor(179, 211, 85, 1);
            //[self addSubview:label1];
            [self sd_addSubviews:@[label1]];
            label1.sd_layout
            .centerXEqualToView(btn)
            .widthIs(ScreenWidth/2.5)
            .heightIs(1)
            .topSpaceToView(self,45.5);
            //如果需要添加图片，请把注释去掉就可以了
//            [btn setTitleColor:JXColor(87, 173, 104, 1) forState:UIControlStateNormal];
//            [btn setBackgroundColor:[UIColor whiteColor]];
            //[btn setImage:[UIImage imageNamed:@"ribbon-pressed@2x.png"] forState:UIControlStateNormal];
        }else if(i == 1){
            //绿线
            label2=[[UILabel alloc]init];//WithFrame:CGRectMake(width, 45.5, ScreenWidth/2.5, 2.5)];
            label2.backgroundColor=JXColor(238, 238, 238, 1);
             [self sd_addSubviews:@[label2]];
            label2.sd_layout
            .centerXEqualToView(btn)
            .widthIs(ScreenWidth/2.5)
            .heightIs(1)
            .topSpaceToView(self,45.5);
            
//            [btn setTitleColor:JXColor(155, 155, 155, 1) forState:UIControlStateNormal];
//            [btn setBackgroundColor:[UIColor whiteColor]];
            //[btn setImage:[UIImage imageNamed:@"bag@2x.png"] forState:UIControlStateNormal];
        }else{
            
            //绿线
//            label3=[[UILabel alloc]initWithFrame:CGRectMake(width * 2, 45.5, ScreenWidth/2, 2.5)];
//            label3.backgroundColor=JXColor(238, 238, 238, 1);
//            [self addSubview:label3];
        }
    }
}
@end
