//
//  WeiTuoHeTongImageVC.m
//  DistributionQuery
//
//  Created by Macx on 17/6/27.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "WeiTuoHeTongImageVC.h"
#import "UIImageView+WebCache.h"
#import "SignView.h"
@interface WeiTuoHeTongImageVC ()<UIScrollViewDelegate,ImageDalegate1,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIGestureRecognizerDelegate>
@property(nonatomic,retain)UIScrollView *ScrollSonView;
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)SignView * vcvc;
//*****//
@property(nonatomic,assign)CGPoint lastPoint;
@property(nonatomic,assign)BOOL isSwiping;
@property(nonatomic,assign)CGFloat red;
@property(nonatomic,assign)CGFloat green;
@property(nonatomic,assign)CGFloat blue;
@property(nonatomic,strong)NSMutableArray * xPoints;
@property(nonatomic,strong)NSMutableArray * yPoints;
@property(nonatomic,strong)UIImageView * sineImage;
@property(nonatomic,strong)UIImage * _image;
@property(nonatomic,assign)CGRect rectt;
@end
@implementation WeiTuoHeTongImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (_tagg==1) {
        self.title=@"委托拍卖合同";
    }else{
        self.title=@"拍卖成交确认书";
    }
     [self CreatButton];
    [self CreatRightBtn];
    self.view.backgroundColor=[UIColor whiteColor];
    _ScrollSonView  = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0, ScreenWidth, ScreenHeight-55-64)];
    _ScrollSonView .delegate = self;
    _ScrollSonView.bounces = 0;
    _ScrollSonView.bouncesZoom = 0;
   
    [_ScrollSonView setBackgroundColor:[UIColor clearColor]];
    _ScrollSonView .minimumZoomScale = 1;
    _ScrollSonView .maximumZoomScale = 3;
    _ScrollSonView .showsHorizontalScrollIndicator = NO;
    _ScrollSonView .showsVerticalScrollIndicator = NO;
    [self.view addSubview:_ScrollSonView ];
     _ScrollSonView.userInteractionEnabled=YES;
//    _ScrollSonView.backgroundColor=[UIColor yellowColor];
    UIImageView *imgview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _ScrollSonView.frame.size.width, _ScrollSonView.frame.size.height)];
    _imageView=imgview;
    imgview.tag=100;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    imgview.userInteractionEnabled=YES;
    [ _ScrollSonView addSubview:imgview];
    
 
    if (ScreenWidth==320) {
           _sineImage=[[UIImageView alloc]initWithFrame:CGRectMake(80, imgview.frame.size.height-120, 80, 80)];
    }else{
           _sineImage=[[UIImageView alloc]initWithFrame:CGRectMake(80, imgview.frame.size.height-150, 80, 80)];
    }
    
    
    _sineImage.userInteractionEnabled=YES;
//    _sineImage.backgroundColor=[UIColor redColor];
    [imgview addSubview:_sineImage];
     UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGRAct:)];
//      pan.delegate = self;
    [_sineImage setUserInteractionEnabled:YES];
    [_sineImage addGestureRecognizer:panGR];
    
    if (_tagg==1) {
        [self tagg1Image];
    }else{
        [self tagg2Image];
    }
    
    [self tianJiaShouShi];
   
    
 
   
}

-(void)CreatRightBtn{
    UIButton*  backHomeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [backHomeBtn setTitle:@"确定" forState:0];
    [backHomeBtn setTitleColor:[UIColor whiteColor] forState:0];
    backHomeBtn.frame=CGRectMake(0, 0, 100, 30);
    backHomeBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    backHomeBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
    [backHomeBtn addTarget:self action:@selector(rightBtnClink) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftBtn2 =[[UIBarButtonItem alloc]initWithCustomView:backHomeBtn];
    self.navigationItem.rightBarButtonItems=@[leftBtn2];
}
-(void)rightBtnClink{
    CGSize size = CGSizeMake(self.imageView.size.width, self.imageView.size.height);
    UIGraphicsBeginImageContext(size);
    
    [self.imageView.image drawInRect:CGRectMake(0, 0, self.imageView.size.width, size.height)];
    CGRect rect =_rectt;
     [__image drawInRect:rect];
    
    UIImage *togetherImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if (_tagg==1) {
        [Engine WUYIWeiTuoQianMing:togetherImage BiaoDiID:_biaoDiID success:^(NSDictionary *dic) {
            [LCProgressHUD showMessage:[dic objectForKey:@"msg"]];
            NSString * code =[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
            if ([code isEqualToString:@"1"]) {
                  [self.navigationController popViewControllerAnimated:YES];
            }
        } error:^(NSError *error) {
            
        }];
    }else{
        [Engine WU53YiMaiDao:togetherImage BiaoDiID:_biaoDiID success:^(NSDictionary *dic) {
            [LCProgressHUD showMessage:[dic objectForKey:@"msg"]];
            NSString * code =[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
            if ([code isEqualToString:@"1"]) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        } error:^(NSError *error) {
            
        }];
    }
    

}


- (void)panGRAct: (UIPanGestureRecognizer *)rec{
    
    
    CGPoint point = [rec translationInView:_imageView];
    NSLog(@"%f,%f",point.x,point.y);
    rec.view.center = CGPointMake(rec.view.center.x + point.x, rec.view.center.y + point.y);
    [rec setTranslation:CGPointMake(0, 0) inView:_imageView];
    
    _rectt=_sineImage.frame;
}


#pragma mark --创建3个按钮
-(void)CreatButton{
    NSArray * nameArr =@[@"下载",@"确认签字",@"上传"];
    int kj =25;
    int k =(ScreenWidth-25*(nameArr.count+1))/nameArr.count;
    int g =35;
    for (int i=0; i<nameArr.count; i++) {
        UIButton * button =[UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor=[UIColor redColor];
        button.sd_cornerRadius=@(5);
        [button setTitle:nameArr[i] forState:0];
        button.titleLabel.font=[UIFont systemFontOfSize:15];
        button.tag=i;
        [button addTarget:self action:@selector(buttonClink:) forControlEvents:UIControlEventTouchUpInside];
        [self.view sd_addSubviews:@[button]];
        button.sd_layout
        .leftSpaceToView(self.view,kj+(kj+k)*i)
        .bottomSpaceToView(self.view,5)
        .widthIs(k)
        .heightIs(g);
    }
}

#pragma mark --按钮点击状态
-(void)buttonClink:(UIButton*)btn{
    if (btn.tag==0) {
        //下载
        [self loadImageFinished:self.imageView.image];
    }else if (btn.tag==1){
        //确认签字
        [self sizeQunRen];
    }else{
        //上传
        [self xuanzeImageBtn];
    }
}
#pragma mark --1.照片下载
- (void)loadImageFinished:(UIImage *)image
{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
    if (error==nil) {
        [LCProgressHUD showSuccess:@"下载成功"];
    }else{
        [LCProgressHUD showMessage:@"下载失败"];
    }
}
#pragma mark --2.确认签字
-(void)sizeQunRen{
  SignView * vc =[[SignView alloc]initWithFrame:CGRectMake(0, 700, ScreenWidth, ScreenHeight/2)];
    _vcvc=vc;
    vc.delegate=self;
    [self.view addSubview:vc];
    [self.view bringSubviewToFront:vc];
    [UIView animateWithDuration:1 animations:^{
        vc.frame=CGRectMake(0, ScreenHeight-ScreenHeight/2-64, ScreenWidth, ScreenHeight/2);
    }];

}
-(void)buttonClinkTwo:(UIButton*)btn Image:(UIImage *)image{
    if (btn.tag==0) {
        //取消
        _vcvc.frame=CGRectMake(0, ScreenHeight-ScreenHeight/2-64, ScreenWidth, ScreenHeight/2);
        [UIView animateWithDuration:1 animations:^{
            _vcvc.frame=CGRectMake(0, 700, ScreenWidth, ScreenHeight/2);
        }];
    }else{
        //确认
        // [LCProgressHUD showMessage:@"签名成功"];
        
        if (image==nil) {
            [LCProgressHUD showMessage:@"请签字后在提交!!"];
            return;
        }
        
        _vcvc.frame=CGRectMake(0, ScreenHeight-ScreenHeight/2-64, ScreenWidth, ScreenHeight/2);
        [UIView animateWithDuration:1 animations:^{
            _vcvc.frame=CGRectMake(0, 700, ScreenWidth, ScreenHeight/2);
        }];
        _sineImage.image=image;
        __image=image;
       
//        static dispatch_once_t hanwanjie;
//        dispatch_once(&hanwanjie, ^{
            UIAlertController * actionview=[UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请把签名拖到合适位置" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * action =[UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
            
            [actionview addAction:action];
            [self presentViewController:actionview animated:YES completion:nil];
            

//        });
        
        
        
        
        
    }
}



#pragma mark --3.调用系统相册
-(void)xuanzeImageBtn{
    UIAlertController * actionView =[UIAlertController alertControllerWithTitle:@"请选择照片来源" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * action1 =[UIAlertAction actionWithTitle:@"相机" style:0 handler:^(UIAlertAction * _Nonnull action) {
        
        // 先判断相机是否可用
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            // 把imagePicker.sourceType改为相机
            UIImagePickerController * imagePicker=[[UIImagePickerController alloc]init];
            imagePicker.delegate =self;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }else
        {
            [LCProgressHUD showMessage:@"相机不可用"];
        }
        
        
    }];
    UIAlertAction * action2 =[UIAlertAction actionWithTitle:@"相册" style:0 handler:^(UIAlertAction * _Nonnull action){
        [self headImageClick];
    }];
    UIAlertAction * action3 =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [actionView addAction:action1];
    [actionView addAction:action2];
    [actionView addAction:action3];
    [self presentViewController:actionView animated:YES completion:nil];
    
    
    
}




#pragma mark --调用系统相册
-(void)headImageClick{
    UIImagePickerController * imagePicker =[UIImagePickerController new];
    imagePicker.delegate = self;
    imagePicker.sourceType=UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    imagePicker.allowsEditing=YES;
    imagePicker.navigationController.navigationBar.barTintColor = [UIColor redColor];
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    //    if (picker.view.tag==0) {
    //        _image1=image;
    //    }else if (picker.view.tag==1){
    //         _image2=image;
    //    }else{
    //         _image3=image;
    //    }
   
    [self dismissViewControllerAnimated:YES completion:nil];
    [LCProgressHUD showLoading:@"请稍后..."];
    if (_tagg==1) {
        [Engine WU50WeiTuoUp:image BiaoDiID:_biaoDiID success:^(NSDictionary *dic) {
            [LCProgressHUD showMessage:[dic objectForKey:@"msg"]];
        } error:^(NSError *error) {
            
        }];
    }else{
        [Engine WU52TuoQianMing:image BiaoDiID:_biaoDiID success:^(NSDictionary *dic) {
            [LCProgressHUD showMessage:[dic objectForKey:@"msg"]];
        } error:^(NSError *error) {
            
        }];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark --委托拍卖合同(网络接口)
-(void)tagg1Image{
    [LCProgressHUD showLoading:@"正在加载..."];
    [Engine myWeiTuoHtmlBtnBiaoDiID:_biaoDiID success:^(NSDictionary *dic) {
        if ([dic objectForKey:@"content"]==[NSNull null] ||[dic objectForKey:@"content"]==nil) {
            [LCProgressHUD showMessage:@"暂无内容"];
            [self.navigationController popViewControllerAnimated:YES];
            return ;
        }
        
        NSString * code =[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            [LCProgressHUD hide];
            NSString * urlStr =[dic objectForKey:@"content"];
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:urlStr] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
            }];
            
        }else{
            [LCProgressHUD showMessage:[dic objectForKey:@"msg"]];
        }
    } error:^(NSError *error) {
        
    }];
}
#pragma mark --拍卖成交确认书(网络接口)
-(void)tagg2Image{
    [LCProgressHUD showLoading:@"正在加载..."];
    [Engine chaKanQueRenShuBiaoDiID:_biaoDiID success:^(NSDictionary *dic) {
        NSString * code =[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            [LCProgressHUD hide];
            NSString * urlStr =[dic objectForKey:@"content"];
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:urlStr] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
            }];
        }else{
            [LCProgressHUD showMessage:[dic objectForKey:@"msg"]];
        }
    } error:^(NSError *error) {
        
    }];
}

#pragma mark --添加手势
-(void)tianJiaShouShi{
    //一个手指
    UITapGestureRecognizer *singleClickDog = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singliDogTap:)];
    UITapGestureRecognizer *doubleClickTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    //两个手指
    UITapGestureRecognizer *twoFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handelTwoFingerTap:)];
    singleClickDog.numberOfTapsRequired = 1;
    singleClickDog.numberOfTouchesRequired = 1;
    doubleClickTap.numberOfTapsRequired = 2;//需要点两下
    twoFingerTap.numberOfTouchesRequired = 2;//需要两个手指touch
    [_imageView addGestureRecognizer:singleClickDog];
    [_imageView addGestureRecognizer:doubleClickTap];
    [_imageView addGestureRecognizer:twoFingerTap];
    [singleClickDog requireGestureRecognizerToFail:doubleClickTap];//如果双击了，则不响应单击事件
    [_ScrollSonView setZoomScale:1];
}



#pragma mark - ScrollView Delegate
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}
//缩放系数(倍数)
-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    //[_ScrollSonView  setZoomScale:scale ];
    [scrollView setZoomScale:scale+0.01 animated:NO];
    [scrollView setZoomScale:scale animated:NO];
}
#pragma mark - 手势点击事件处理
-(void)singliDogTap:(UITapGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.numberOfTapsRequired == 1)
    {
    }
}
//双击
-(void)handleDoubleTap:(UITapGestureRecognizer *)gestureRecognizer{
    if (gestureRecognizer.numberOfTapsRequired == 2) {
        if(_ScrollSonView.zoomScale == 1){
            //放大
            float newScale = [_ScrollSonView zoomScale] *2;
            CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
            [_ScrollSonView zoomToRect:zoomRect animated:YES];
        }else{
            //缩小
            float newScale = [_ScrollSonView zoomScale]/2;
            CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
            [_ScrollSonView zoomToRect:zoomRect animated:YES];
        }
    }
}
//2个手指
-(void)handelTwoFingerTap:(UITapGestureRecognizer *)gestureRecongnizer{
    float newScale = [_ScrollSonView zoomScale]/2;
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecongnizer locationInView:gestureRecongnizer.view]];
    [_ScrollSonView zoomToRect:zoomRect animated:YES];
}

#pragma mark - 缩放大小获取方法
-(CGRect)zoomRectForScale:(CGFloat)scale withCenter:(CGPoint)center{
    CGRect zoomRect;
    //大小
    zoomRect.size.height = [_ScrollSonView frame].size.height/scale;
    zoomRect.size.width = [_ScrollSonView frame].size.width/scale;
    //原点
    zoomRect.origin.x = center.x - zoomRect.size.width/2;
    zoomRect.origin.y = center.y - zoomRect.size.height/2;
    return zoomRect;
}


@end
