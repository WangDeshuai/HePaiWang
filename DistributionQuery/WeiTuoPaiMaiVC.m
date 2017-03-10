//
//  WeiTuoPaiMaiVC.m
//  DistributionQuery
//
//  Created by Macx on 16/11/17.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "WeiTuoPaiMaiVC.h"
#import "WeiTuoPaiMaiCell.h"
#import "WeiTuoXiuGaiVC.h"
#import "SGImagePickerController.h"//相片选择
@interface WeiTuoPaiMaiVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSMutableArray * dataArray;
@property(nonatomic,copy)NSString * miaoShuText;
@property(nonatomic,copy)NSString * xiaCiText;
@property(nonatomic,copy)NSString *shengCodeText;
@property(nonatomic,copy)NSString *cityCodeText;
@property(nonatomic,copy)NSString *xianCodeText;
@property(nonatomic,copy)NSString * diQuText;
@property(nonatomic,strong)NSMutableArray * photoArray;//存放照片的数组
@property(nonatomic,strong)UIButton * lastBtn;
//姓名 手机号 标的名称
@property(nonatomic,copy)NSString * xmName;
@property(nonatomic,copy)NSString *phoneName;
@property(nonatomic,copy)NSString *biaoDiName;
//未登录状态下的验证码
@property(nonatomic,copy)NSString * yanZhengCode;
@property(nonatomic,strong)NSMutableArray * imageArray;//存放照片的数组

@end

@implementation WeiTuoPaiMaiVC
-(void)viewWillAppear:(BOOL)animated{
      [self CreatDataArr];
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.backHomeBtn.hidden=YES;
    _photoArray=[NSMutableArray new];
    _imageArray=[NSMutableArray new];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardUpOrDown:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lianjieClink:) name:@"qingkong" object:nil];
    [self CreatTabelView];
  
   
}
- (void)keyboardUpOrDown:(NSNotification *)notifition
{
    NSDictionary * dic = notifition.userInfo;
    //用NSValue来接收，因为它是坐标（结构体）
    NSValue * value = [dic objectForKey:UIKeyboardFrameEndUserInfoKey];
    //结构体转化为对象类型
    CGRect rect = [value CGRectValue];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
  //表的坐标
    _tableView.frame = CGRectMake(0, 0, ScreenWidth, rect.origin.y);
//      [_tableView setContentInset:UIEdgeInsetsMake(0, 0, 70+30, 0)];
    [UIView commitAnimations];

}

#pragma mark --创建提交按钮
-(void)CreatButton{

//    WeiTuoPaiMaiCell * cell =[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:_dataArray.count]];
//    CGRect rect =[self.view convertRect:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height) fromView:cell];
    [self dissmiss];
    UIButton * tijaoBtn=[UIButton new];
    tijaoBtn.backgroundColor=[UIColor redColor];
    _lastBtn=tijaoBtn;
    [tijaoBtn addTarget:self action:@selector(tijiaoBtn) forControlEvents:UIControlEventTouchUpInside];
    [tijaoBtn setTitle:@"确认提交" forState:0];
    if ([ToolClass isLogin]) {
        if (ScreenWidth==320) {
            tijaoBtn.frame=CGRectMake(30, ScreenHeight, ScreenWidth-60, 35);
        }else{
            tijaoBtn.frame=CGRectMake(30, ScreenHeight-64-49-45-10, ScreenWidth-60, 45);
        }
    }else{
        if (ScreenWidth==320) {
            tijaoBtn.frame=CGRectMake(30, ScreenHeight-60, ScreenWidth-60, 35);
        }else{
            tijaoBtn.frame=CGRectMake(30, ScreenHeight-64-49-45-10, ScreenWidth-60, 45);
        }
    }
   
    
    
    tijaoBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    [_tableView addSubview:tijaoBtn];

}
-(void)dissmiss{
    [_lastBtn removeFromSuperview];
}
#pragma mark --提交数据
-(void)tijiaoBtn{
//    //联系人
//     WeiTuoPaiMaiCell * cell =[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//    //手机号
//     WeiTuoPaiMaiCell * cell1 =[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
//    //标的名称
//     WeiTuoPaiMaiCell * cell2 =[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    //标的保留价
    WeiTuoPaiMaiCell * cell3 =[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];

    //标的评估价
    WeiTuoPaiMaiCell * cell4 =[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:2]];

    NSLog(@"输出图片个数%lu",(unsigned long)_photoArray.count);
    NSLog(@"联系人%@",_xmName);
     NSLog(@"手机号%@",_phoneName);
     NSLog(@"标的名称%@",_biaoDiName);
     NSLog(@"描述%@",_miaoShuText);
     NSLog(@"瑕癖%@",_xiaCiText);
     NSLog(@"省code=%@citycode=%@ixancode=%@",_shengCodeText,_cityCodeText,_xianCodeText);
    NSLog(@"保留价%@",cell3.textfield.text);
    NSLog(@"评估价%@",cell4.textfield.text);
    
    NSLog(@"验证码%@",_yanZhengCode);
    
    
    
    if ([ToolClass isLogin]==NO) {
        //未登录
         [LCProgressHUD showMessage:@"发布中..."];
        
        [Engine loginIsNoPublicPeople:[ToolClass isString:[NSString stringWithFormat:@"%@",_xmName]] Phone:[ToolClass isString:[NSString stringWithFormat:@"%@",_phoneName]] PhoneCode:[ToolClass isString:[NSString stringWithFormat:@"%@",_yanZhengCode]] BiaoDiName:[ToolClass isString:[NSString stringWithFormat:@"%@",_biaoDiName]] BiaoDiMiaoShu:[ToolClass isString:[NSString stringWithFormat:@"%@",_miaoShuText]] XiaCiName:[ToolClass isString:[NSString stringWithFormat:@"%@",_xiaCiText]] ShengCode:[ToolClass isString:[NSString stringWithFormat:@"%@",_shengCodeText]] CityCode:[ToolClass isString:[NSString stringWithFormat:@"%@",_cityCodeText]] XianCode:[ToolClass isString:[NSString stringWithFormat:@"%@",_xianCodeText]] ImageArray:_photoArray success:^(NSDictionary *dic) {
            [LCProgressHUD showMessage:[dic objectForKey:@"msg"]];
            NSString * code =[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
            if ([code isEqualToString:@"1"]) {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"qingkong" object:nil userInfo:dic];
                
            }
        } error:^(NSError *error) {
            [LCProgressHUD showMessage:@"网络错误"];
        }];
        
        
        
        
    }else{
        [LCProgressHUD showMessage:@"发布中..."];
        [Engine loginIsYesPublicPeopleName:[ToolClass isString:[NSString stringWithFormat:@"%@",_xmName]] PhoneNum:[ToolClass isString:[NSString stringWithFormat:@"%@",_phoneName]] BiaoDiName:[ToolClass isString:[NSString stringWithFormat:@"%@",_biaoDiName]] MiaoShu:[ToolClass isString:[NSString stringWithFormat:@"%@",_miaoShuText]] XiaCi:[ToolClass isString:[NSString stringWithFormat:@"%@",_xiaCiText]] ShengCode:[ToolClass isString:[NSString stringWithFormat:@"%@",_shengCodeText]] CityCode:[ToolClass isString:[NSString stringWithFormat:@"%@",_cityCodeText]] XianCode:[ToolClass isString:[NSString stringWithFormat:@"%@",_xianCodeText]] BaoLiuPrice:[ToolClass isString:[NSString stringWithFormat:@"%@",cell3.textfield.text]] PingGuPrice:[ToolClass isString:[NSString stringWithFormat:@"%@",cell4.textfield.text]] imageArr:_photoArray success:^(NSDictionary *dic) {
            [LCProgressHUD showMessage:[dic objectForKey:@"msg"]];
            NSString * code =[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
            if ([code isEqualToString:@"1"]) {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"qingkong" object:nil userInfo:dic];
                
            }
        } error:^(NSError *error) {
             [LCProgressHUD showMessage:@"网络错误"];
        }];
        

    }
    
    
    
    
    
}
#pragma mark --接收的通知1清空数据
-(void)lianjieClink:(NSNotification*)notification{
    NSLog(@"数据要清空");
    //联系人清空
    WeiTuoPaiMaiCell * cell =[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    //手机号
    WeiTuoPaiMaiCell * cell1 =[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    //验证码
    WeiTuoPaiMaiCell * cell5 =[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    //    //标的名称
    WeiTuoPaiMaiCell * cell2 =[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    //标的保留价
    WeiTuoPaiMaiCell * cell3 =[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    
    //标的评估价
    WeiTuoPaiMaiCell * cell4 =[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:2]];

    _xmName=nil;//联系人清空
    _phoneName=nil;//手机号清空
    _biaoDiName=nil;//标的名称清空
    _yanZhengCode=nil;//验证码清空
     cell.textfield.text=nil;//
     cell1.textfield.text=nil;
     cell2.textfield.text=nil;
     cell5.textfield.text=nil;
    _miaoShuText=@"";//描述清空
    _xiaCiText=@"";//瑕疵清空
    _diQuText=@"";//地区清空
    _shengCodeText=nil;//省市县code清空
    _cityCodeText=nil;
    _xianCodeText=nil;
    cell3.textfield.text=nil;
    cell4.textfield.text=nil;
    [_photoArray removeAllObjects];
    [_tableView reloadData];
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    
        if (textField.tag==10) {
            //姓名
            _xmName=textField.text;
        }else if (textField.tag==11){
            //手机号
            _phoneName=textField.text;
        }else if (textField.tag==12){
            //标的名称
            _biaoDiName=textField.text;;
        }else if (textField.tag==13){
            //验证码
            _yanZhengCode=textField.text;
        }
    
    
    
}
#pragma mark --数据源
-(void)CreatDataArr{
    if ([ToolClass isLogin]) {
        NSArray * arr1 =@[@"联   系   人",@"手   机   号"];
        NSArray * arr2 =@[@"标 的 名 称",@"标 的 描 述",@"标 的 瑕 癖",@"标的所在地"];
        NSArray * arr3 =@[@"标的保留价",@"标的评估价"];
        NSArray * arr4 =@[@"标的图片"];
        _dataArray=[[NSMutableArray alloc]initWithObjects:arr1,arr2,arr3,arr4, nil];
    }else{
        NSArray * arr1 =@[@"联   系   人",@"手   机   号",@"验   证   码"];
        NSArray * arr2 =@[@"标 的 名 称",@"标 的 描 述",@"标 的 瑕 癖",@"标的所在地"];
         NSArray * arr3 =@[@"标的图片"];
        _dataArray=[[NSMutableArray alloc]initWithObjects:arr1,arr2,arr3, nil];
    }
    [self CreatButton];
    [_tableView reloadData];
}
#pragma mark --创建表
-(void)CreatTabelView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];
    }
    _tableView.backgroundColor=BG_COLOR;
    _tableView.tableFooterView=[UIView new];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.keyboardDismissMode=UIScrollViewKeyboardDismissModeOnDrag;
    [_tableView setContentInset:UIEdgeInsetsMake(0, 0, 70+30, 0)];
    [self.view addSubview:_tableView];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_dataArray[section] count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * cellID =[NSString stringWithFormat:@"%lu%lu",(long)indexPath.section,(long)indexPath.row];
     WeiTuoPaiMaiCell * cell =[WeiTuoPaiMaiCell cellWithTableView:tableView CellID:cellID];
    cell.nameLabel.text=_dataArray[indexPath.section][indexPath.row];
    [cell removeFromSuperview];
    cell.textfield.delegate=self;
    if ([ToolClass isLogin]) {
        //已登录
         [self cellForRow:cell IndexPath:indexPath];
    }else{
        //未登录
        [self WeicellForRow:cell IndexPath:indexPath];
    }
    
    
    
    
    return cell;
}

#pragma mark --登录状态下
-(void)cellForRow:(WeiTuoPaiMaiCell*)cell IndexPath:(NSIndexPath*)indexPath{
      cell.bgScrollview.hidden=YES;
    if (indexPath.section==0) {
        //第0区
        if (indexPath.row==0) {
            cell.textfield.placeholder=@"例如张三";
            cell.textfield.tag=10;
        }else if (indexPath.row==1){
            cell.textfield.placeholder=@"请您填写准确的手机号码";
            cell.textfield.tag=11;
            cell.textfield.keyboardType=UIKeyboardTypeNumberPad;
        }
    }else if (indexPath.section==1){
        //第1区
        if (indexPath.row==0) {
            cell.textfield.placeholder=@"请填写标的名称";
            cell.textfield.tag=12;
        }else if (indexPath.row==1){
            cell.textfield.enabled=NO;
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            if (_miaoShuText==nil) {
                cell.textfield.placeholder=@"请填写您的描述";
            }else{
                cell.textfield.text=_miaoShuText;
            }
            
        }else if (indexPath.row==2){
            cell.textfield.enabled=NO;
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            if (_xiaCiText==nil) {
                 cell.textfield.placeholder=@"请填写您的瑕疵";
            }else{
                 cell.textfield.text=_xiaCiText;
            }
           
        }else{
            cell.textfield.enabled=NO;
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            if (_diQuText==nil) {
                cell.textfield.placeholder=@"请选择您具体的地区";
            }else{
                 cell.textfield.text=_diQuText;
            }
           
        }
    }else if (indexPath.section==2){
        //保留价格
//          cell.textfield.enabled;
        if (indexPath.row==0) {
            cell.textfield.hidden=NO;
            cell.textfield.placeholder=@"请输入保留价";
        }else{
            cell.textfield.placeholder=@"请输入评估价";
        }
         cell.textfield.keyboardType=UIKeyboardTypeNumberPad;
    }else{
        //标的图片
         cell.bgScrollview.hidden=NO;
        [self CreatPhotoBtn:cell];
        // [self CreatButton];
    }
}

#pragma mark --未登录
-(void)WeicellForRow:(WeiTuoPaiMaiCell*)cell IndexPath:(NSIndexPath*)indexPath{
    cell.bgScrollview.hidden=YES;
    if (indexPath.section==0) {
        //第0区
        if (indexPath.row==0) {
            cell.textfield.placeholder=@"例如张三";
            cell.textfield.tag=10;
        }else if (indexPath.row==1){
            cell.textfield.placeholder=@"请您填写准确的手机号码";
            cell.textfield.keyboardType=UIKeyboardTypeNumberPad;
            cell.textfield.tag=11;
        }else if (indexPath.row==2){
            cell.textfield.placeholder=@"请填写验证码";
            cell.codeBtn.hidden=NO;
            cell.textfield.keyboardType=UIKeyboardTypeNumberPad;
            cell.textfield.tag=13;
            [cell.codeBtn addTarget:self action:@selector(buttonCode:) forControlEvents:UIControlEventTouchUpInside];
//            [cell sd_addSubviews:@[cell.textfield]];
//            cell.textfield.sd_layout
//            .widthIs(120);
            
        }
    }else if (indexPath.section==1){
        //第1区
        if (indexPath.row==0) {
            cell.textfield.placeholder=@"请填写标的名称";
            cell.textfield.tag=12;
        }else if (indexPath.row==1){
            cell.textfield.enabled=NO;
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            cell.textfield.text=_miaoShuText;
        }else if (indexPath.row==2){
            cell.textfield.enabled=NO;
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            cell.textfield.text=_xiaCiText;
        }else{
            cell.textfield.enabled=NO;
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            cell.textfield.text=_diQuText;
        }
    }else{
        //标的图片
        cell.textfield.hidden=YES;
         cell.bgScrollview.hidden=NO;
        [self CreatPhotoBtn:cell];
        // [self CreatButton];
    }
}
-(void)buttonCode:(UIButton*)sender{
    NSLog(@"加载了button");
    //标的评估价
    WeiTuoPaiMaiCell * cell4 =[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    [Engine getMessageCodePhone:[self stringHouMianText:cell4.textfield.text InternetText:_phoneName] success:^(NSDictionary *dic) {
        [LCProgressHUD showMessage:[dic objectForKey:@"msg"]];
        NSString * code =[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            __block int timeout=60; //倒计时时间
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
            dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
            dispatch_source_set_event_handler(_timer, ^{
                if(timeout<=0){ //倒计时结束，关闭
                    dispatch_source_cancel(_timer);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //设置界面的按钮显示 根据自己需求设置
                        [sender setTitle:@"发送验证码" forState:UIControlStateNormal];
                        sender.userInteractionEnabled = YES;
                    });
                }
                else{
                    int seconds = timeout % 60;
                    NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //设置界面的按钮显示 根据自己需求设置
                        //NSLog(@"____%@",strTime);
                        [UIView beginAnimations:nil context:nil];
                        [UIView setAnimationDuration:1];
                        [sender setTitle:[NSString stringWithFormat:@"%@秒后重新发送",strTime] forState:UIControlStateNormal];
                        [UIView commitAnimations];
                        sender.userInteractionEnabled = NO;
                    });
                    timeout--;
                }
            });
            dispatch_resume(_timer);
        }
        
    } error:^(NSError *error) {
        
    }];
}

-(void)qingKongImageView{
    for (UIButton * image in _imageArray) {
        [image removeFromSuperview];
    }
}
#pragma mark --创建相机按钮
-(void)CreatPhotoBtn:(WeiTuoPaiMaiCell*)cell{
    [self qingKongImageView];
    if (_photoArray.count==0) {
        UIButton * btn =[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageNamed:@"rz_pic"] forState:0];
        [btn addTarget:self action:@selector(btnClinkPhoto) forControlEvents:UIControlEventTouchUpInside];
        [cell.bgScrollview sd_addSubviews:@[btn]];
        btn.sd_layout
        .leftSpaceToView(cell.bgScrollview,0)
        .topSpaceToView(cell.bgScrollview,0)
        .widthIs(162/2)
        .heightIs(61);
    }else if (_photoArray.count<6){
        for (int i=0; i<_photoArray.count; i++) {
            UIButton * imageBtn =[UIButton new];
            [imageBtn setBackgroundImage:_photoArray[i] forState:0];
            //imageBtn.image=_photoArray[i];
            [cell.bgScrollview sd_addSubviews:@[imageBtn]];
            imageBtn.sd_layout
            .leftSpaceToView(cell.bgScrollview,(10+81)*i)
            .topSpaceToView(cell.bgScrollview,0)
            .heightIs(61)
            .widthIs(81);
            [_imageArray addObject:imageBtn];
            if (i==_photoArray.count-1) {
                UIButton * seletBtn =[UIButton buttonWithType:UIButtonTypeCustom];
               // seletBtn.backgroundColor=[UIColor redColor];
                [seletBtn setBackgroundImage:[UIImage imageNamed:@"rz_pic"] forState:0];
                [seletBtn addTarget:self action:@selector(btnClinkPhoto) forControlEvents:UIControlEventTouchUpInside];
                [cell.bgScrollview sd_addSubviews:@[seletBtn]];
                seletBtn.sd_layout
                .leftSpaceToView(cell.bgScrollview,(10+81)*i+91)
                .topSpaceToView(cell.bgScrollview,0)
                .widthIs(162/2)
                .heightIs(61);
                 [_imageArray addObject:seletBtn];
            }//
            cell.bgScrollview.contentSize=CGSizeMake((_photoArray.count+1)*81+_photoArray.count*10, 0);
        }
    }else if (_photoArray.count==6){
        for (int i=0; i<_photoArray.count; i++) {
            UIButton * imageBtn =[UIButton new];
            [imageBtn setBackgroundImage:_photoArray[i] forState:0];
            //imageBtn.image=_photoArray[i];
            [cell.bgScrollview sd_addSubviews:@[imageBtn]];
            imageBtn.sd_layout
            .leftSpaceToView(cell.bgScrollview,0+(10+81)*i)
            .topSpaceToView(cell.bgScrollview,0)
            .heightIs(61)
            .widthIs(81);
              [_imageArray addObject:imageBtn];
        }
        cell.bgScrollview.contentSize=CGSizeMake(_photoArray.count*81+(_photoArray.count-1)*10, 0);
    }
   
    


}
-(void)btnClinkPhoto{
    SGImagePickerController *picker = [[SGImagePickerController alloc] init];
    picker.maxCount = 6-_photoArray.count;
    [picker setDidFinishSelectThumbnails:^(NSArray * imageArr) {
        for (UIImage * image in imageArr) {
            [_photoArray addObject:image];
        }
        [_tableView reloadData];
    }];
    [self presentViewController:picker animated:YES completion:nil];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1) {
        if (indexPath.row==1) {
            //标的描述
            WeiTuoXiuGaiVC * vc =[WeiTuoXiuGaiVC new];
            vc.indexrow=0;
           
            vc.nameBlock=^(NSString*name,NSString*shengcode,NSString*citycode,NSString*xiancode){
                _miaoShuText=name;
                [_tableView reloadData];
            };
            vc.contentText=_miaoShuText;
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row==2){
            //标的瑕疵
            WeiTuoXiuGaiVC * vc =[WeiTuoXiuGaiVC new];
             vc.indexrow=1;
            vc.nameBlock=^(NSString*name,NSString*shengcode,NSString*citycode,NSString*xiancode){
                _xiaCiText=name;
                [_tableView reloadData];
            };
              vc.contentText=_xiaCiText;
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row==3){
            //标的所在地
            WeiTuoXiuGaiVC * vc =[WeiTuoXiuGaiVC new];
             vc.indexrow=2;
             vc.nameBlock=^(NSString*name,NSString*shengcode,NSString*citycode,NSString*xiancode){
                _diQuText=name;
                 _shengCodeText=shengcode;
                 _cityCodeText=citycode;
                 _xianCodeText=xiancode;
                [_tableView reloadData];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==_dataArray.count-1) {
        return 126;
    }else{
         return 50;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//text1是从后面界面传过来的，text2是从上个界面过来的_model
-(NSString *)stringHouMianText:(NSString*)text1 InternetText:(NSString*)text2{
    
    NSString * str;
    if (text1) {
        str=text1;
    }else{
        str=text2;
    }
    
    return str;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
