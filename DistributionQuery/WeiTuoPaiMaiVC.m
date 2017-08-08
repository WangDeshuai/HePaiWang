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
#import "WeiTuoHeTongImageVC.h"//委托合同
@interface WeiTuoPaiMaiVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSMutableArray * dataArray;
@property(nonatomic,copy)NSString * miaoShuText;//描述
@property(nonatomic,copy)NSString * xiaCiText;//瑕疵
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
@property(nonatomic,copy)NSString * baoLiuPrice;
@property(nonatomic,copy)NSString * pingGuPrice;
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
    self.title=@"委托拍卖";
    if (_tagg==1) {
         self.backHomeBtn.hidden=NO;
    }else{
         self.backHomeBtn.hidden=YES;
    }
    _imageArray=[NSMutableArray new];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardUpOrDown:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [self CreatTabelView];
    [self addFooterButton];
   
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





#pragma mark --提交数据
-(void)tijiaoBtn{
    //联系人
    WeiTuoPaiMaiCell * cell0 =[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    //手机号
    WeiTuoPaiMaiCell * cell1 =[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    //验证码
    WeiTuoPaiMaiCell * cell2 =[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    //标的名称
    WeiTuoPaiMaiCell * cell3 =[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    //标的描述
    WeiTuoPaiMaiCell * cell4 =[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    //标的瑕疵
    WeiTuoPaiMaiCell * cell5 =[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
    //标的所在地
//    WeiTuoPaiMaiCell * cell6 =[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    //标的保留价
    WeiTuoPaiMaiCell * cell7 =[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    //标的评估价
    WeiTuoPaiMaiCell * cell8 =[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:2]];
    
    ;
    if ([ToolClass isLogin]==NO) {
        NSLog(@"联系人>>>>%@",[self stringHouMianText:_xmName InternetText:cell0.textfield.text]);
        NSLog(@"手机号>>>>%@",[self stringHouMianText:_phoneName InternetText:cell1.textfield.text]);
        NSLog(@"验证码>>>>%@",[self stringHouMianText:_yanZhengCode InternetText:cell2.textfield.text]);
        NSLog(@"标的名称>>>>%@",[self stringHouMianText:_biaoDiName InternetText:cell3.textfield.text]);
        NSLog(@"图片个数%lu",_photoArray.count);
        [LCProgressHUD showLoading:@"请稍后正在提交..."];
        [Engine loginIsNoPublicPeople:[self stringHouMianText:_xmName InternetText:cell0.textfield.text] Phone:[self stringHouMianText:_phoneName InternetText:cell1.textfield.text] PhoneCode:[self stringHouMianText:_yanZhengCode InternetText:cell2.textfield.text] BiaoDiName:[self stringHouMianText:_biaoDiName InternetText:cell3.textfield.text] BiaoDiMiaoShu:@"" XiaCiName:@"" ShengCode:@"" CityCode:@"" XianCode:@"" ImageArray:_photoArray success:^(NSDictionary *dic) {
            NSString * code =[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
            if ([code isEqualToString:@"1"]) {
                [self dissMissData];
                NSDictionary * contentDic =[dic objectForKey:@"content"];
                 [LCProgressHUD hide];
                UIAlertController * actionview=[UIAlertController alertControllerWithTitle:@"温馨提示" message:[dic objectForKey:@"msg"] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * action1 =[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSString * pswWord =[ToolClass isString:[NSString stringWithFormat:@"%@",[contentDic objectForKey:@"initial_password"]]];
                    NSString * username =[ToolClass isString:[NSString stringWithFormat:@"%@",[contentDic objectForKey:@"regist_tel"]]];
                    [self userLogin:username Psw:pswWord];
                }];
                UIAlertAction * action2 =[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [actionview addAction:action1];
                [actionview addAction:action2];

                [self presentViewController:actionview animated:YES completion:nil];
            }else{
                [LCProgressHUD showMessage:[dic objectForKey:@"msg"]];
            }
        } error:^(NSError *error) {
            
        }];
        
        
        
    }else{
        
        NSLog(@"联系人>>>>%@",[self stringHouMianText:[self stringHouMianText:_xmName InternetText:cell0.textfield.text] InternetText:_model.xqlianxiren]);
        NSLog(@"手机号>>>>%@",[self stringHouMianText:[self stringHouMianText:_phoneName InternetText:cell1.textfield.text] InternetText:_model.xqphone]);
        NSLog(@"标的名称>>>>%@",[self stringHouMianText:[self stringHouMianText:_biaoDiName InternetText:cell3.textfield.text] InternetText:_model.xqbiaoDiName]);
        NSLog(@"标的描述>>>%@",[self stringHouMianText:[self stringHouMianText:_miaoShuText InternetText:cell4.textfield.text] InternetText:_model.xqbiaoDiMiaoShu]);
        NSLog(@"标的瑕疵>>>%@",[self stringHouMianText:[self stringHouMianText:_xiaCiText InternetText:cell5.textfield.text] InternetText:_model.xqxiaCi]);
        NSLog(@"省code=%@citycode=%@ixancode=%@",[self stringHouMianText:_shengCodeText InternetText:_model.xqShengCode],[self stringHouMianText:_cityCodeText InternetText:_model.xqCityCode],[self stringHouMianText:_xianCodeText InternetText:_model.xqXianCode]);
        NSLog(@"保留价>>>%@",[self stringHouMianText:[self stringHouMianText:_baoLiuPrice InternetText:cell7.textfield.text] InternetText:_model.xqBaoLiuJia]);
        NSLog(@"评估价>>>%@",[self stringHouMianText:[self stringHouMianText:_pingGuPrice InternetText:cell8.textfield.text] InternetText:_model.xqPingGuJia]);
        NSMutableArray * arrayImage=[NSMutableArray new];
        NSString * str =[NSUSE_DEFO objectForKey:@"手动"];
        if (_photoArray.count==0) {
            if (str) {
                NSLog(@"1图片个数%lu",_photoArray.count);
                arrayImage=_photoArray;
            }else{
                NSLog(@"2图片个数>>%lu",_model.xqImage.count);
                for (NSString * urlStr in _model.xqImage) {
                     UIImage *image1 = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]]];
                    [arrayImage addObject:image1];
                }
            }
        }else{
            NSLog(@"3图片个数%lu",_photoArray.count);
            arrayImage=_photoArray;
        }
        //修改
        if (_model) {
            [self xiuGaiCanShuLianXiRen:[self stringHouMianText:[self stringHouMianText:_xmName InternetText:cell0.textfield.text] InternetText:_model.xqlianxiren] Phone:[self stringHouMianText:[self stringHouMianText:_phoneName InternetText:cell1.textfield.text] InternetText:_model.xqphone] BiaoDiName:[self stringHouMianText:[self stringHouMianText:_biaoDiName InternetText:cell3.textfield.text] InternetText:_model.xqbiaoDiName] MiaoShu:[self stringHouMianText:[self stringHouMianText:_miaoShuText InternetText:cell4.textfield.text] InternetText:_model.xqbiaoDiMiaoShu] XiaCi:[self stringHouMianText:[self stringHouMianText:_xiaCiText InternetText:cell5.textfield.text] InternetText:_model.xqxiaCi] ShengCode:[self stringHouMianText:_shengCodeText InternetText:_model.xqShengCode] ShiCode:[self stringHouMianText:_cityCodeText InternetText:_model.xqCityCode] XianCode:[self stringHouMianText:_xianCodeText InternetText:_model.xqXianCode] PingGuJia:[self stringHouMianText:[self stringHouMianText:_pingGuPrice InternetText:cell8.textfield.text] InternetText:_model.xqPingGuJia] BaoLiu:[self stringHouMianText:[self stringHouMianText:_baoLiuPrice InternetText:cell7.textfield.text] InternetText:_model.xqBaoLiuJia] ImageArray:arrayImage];
        }else{
            // [self dissMissData];_xmName
            [Engine loginIsYesPublicPeopleName:[self stringHouMianText:[self stringHouMianText:cell0.textfield.text InternetText:_xmName] InternetText:_model.xqlianxiren] PhoneNum:[self stringHouMianText:[self stringHouMianText:_phoneName InternetText:cell1.textfield.text] InternetText:_model.xqphone] BiaoDiName:[self stringHouMianText:[self stringHouMianText:_biaoDiName InternetText:cell3.textfield.text] InternetText:_model.xqbiaoDiName] MiaoShu:[self stringHouMianText:[self stringHouMianText:_miaoShuText InternetText:cell4.textfield.text] InternetText:_model.xqbiaoDiMiaoShu] XiaCi:[self stringHouMianText:[self stringHouMianText:_xiaCiText InternetText:cell5.textfield.text] InternetText:_model.xqxiaCi] ShengCode:[self stringHouMianText:_shengCodeText InternetText:_model.xqShengCode] CityCode:[self stringHouMianText:_cityCodeText InternetText:_model.xqCityCode] XianCode:[self stringHouMianText:_xianCodeText InternetText:_model.xqXianCode] BaoLiuPrice:[self stringHouMianText:[self stringHouMianText:_baoLiuPrice InternetText:cell7.textfield.text] InternetText:_model.xqBaoLiuJia] PingGuPrice:[self stringHouMianText:[self stringHouMianText:_pingGuPrice InternetText:cell8.textfield.text] InternetText:_model.xqPingGuJia] imageArr:arrayImage success:^(NSDictionary *dic) {
                [LCProgressHUD showMessage:[dic objectForKey:@"msg"]];
                    NSString * code =[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
                    if ([code isEqualToString:@"1"]) {
                        [self dissMissData];
                    }else{
                    }
            } error:^(NSError *error) {
                
            }];
        }
        
        

        
    }
    
    
    
    
    
    
}

-(void)userLogin:(NSString*)username Psw:(NSString*)mima{
    
    [Engine ziDongLoginPhone:username success:^(NSDictionary *dic) {
        [LCProgressHUD showMessage:[dic objectForKey:@"msg"]];
        NSString * code =[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            NSDictionary * dicc =[dic objectForKey:@"content"];
            NSMutableDictionary * dicAr = [ToolClass isDictionary:dicc];
            NSLog(@"输出%@",dicAr);
            //1.把返回的字段内容缓存为plist文件
            [ToolClass savePlist:dicAr name:@"baseInfo"];
            //2.把idd当做token存起来，用以判断是否登录
            NSString * idd =[NSString stringWithFormat:@"%@",[dicc objectForKey:@"id"]];
            [NSUSE_DEFO setObject:idd forKey:@"token"];
            //3.把注册手机号存起来
            [NSUSE_DEFO setObject:[ToolClass isString:[NSString stringWithFormat:@"%@",[dicAr objectForKey:@"regist_tel"]]] forKey:@"phone"];
            //4.把联系人存起来
            [NSUSE_DEFO setObject:[ToolClass isString:[NSString stringWithFormat:@"%@",[dicAr objectForKey:@"liaisons_name"]]] forKey:@"people"];
            [NSUSE_DEFO synchronize];
            self.tabBarController.selectedIndex=3;
        }
    } error:^(NSError *error) {
        
    }];
    
    
    
    
    
    
   
}

#pragma mark --修改
-(void)xiuGaiCanShuLianXiRen:(NSString*)people Phone:(NSString*)dianhua BiaoDiName:(NSString*)bd MiaoShu:(NSString*)ms XiaCi:(NSString*)xc ShengCode:(NSString*)scode ShiCode:(NSString*)ccode XianCode:(NSString*)xcode PingGuJia:(NSString*)pgj BaoLiu:(NSString*)blj ImageArray:(NSMutableArray*)array{
//    for (UIImage * image in array) {
//        NSLog(@">>>%@",image);
//    }
    [LCProgressHUD showMessage:@"请稍后..."];
    [Engine XiuGaiBiaoDiXiangQingBiaoDiID:_model.xqBiaoDiID LianXiRen:people Phone:dianhua BiaoDiName:bd MiaoShu:ms XiaCi:xc ShengCode:scode ShiCode:ccode XianCode:xcode BaoLiuJia:blj PingGuJia:pgj ImageArray:array success:^(NSDictionary *dic) {
        NSString * code =[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
          [LCProgressHUD showMessage:[dic objectForKey:@"msg"]];
        if ([code isEqualToString:@"1"]) {
            [self.navigationController popViewControllerAnimated:YES];
            [NSUSE_DEFO removeObjectForKey:@"手动"];
            [NSUSE_DEFO synchronize];
        }else{
          
        }
    } error:^(NSError *error) {
        
    }];
}


#pragma mark --textFieldDelete
- (void)textFieldDidEndEditing:(UITextField *)textField{
        if (textField.tag==10) {
            //姓名
            if (textField.text==nil) {
                _xmName=[NSUSE_DEFO objectForKey:@"people"];
            }else{
                _xmName=textField.text;
            }
            
        }else if (textField.tag==11){
            //手机号
            if (textField.text==nil) {
                _phoneName=[NSUSE_DEFO objectForKey:@"phone"];
            }else{
               _phoneName=textField.text;
            }
            
        }else if (textField.tag==12){
            //标的名称
            _biaoDiName=textField.text;;
        }else if (textField.tag==13){
            //验证码
            _yanZhengCode=textField.text;
        }else if (textField.tag==14){
            //保留价
            _baoLiuPrice=textField.text;
        }else if (textField.tag==15){
            //评估价
            _pingGuPrice=textField.text;
        }
}

#pragma mark --数据源
-(void)CreatDataArr{
    if ([ToolClass isLogin]) {
        NSArray * arr1 =@[@"* 联   系   人",@"* 手   机   号"];
        NSArray * arr2 =@[@"* 标 的 名 称",@"标 的 描 述",@"标 的 瑕 癖",@"标的所在地"];
        NSArray * arr3 =@[@"标的保留价",@"标的评估价"];
        NSArray * arr4 =@[@"标的图片"];
        _dataArray=[[NSMutableArray alloc]initWithObjects:arr1,arr2,arr3,arr4, nil];
    }else{
        NSArray * arr1 =@[@"*联   系   人",@"*手   机   号",@"*验   证   码"];
        NSArray * arr2 =@[@"*标 的 名 称"];
        NSArray * arr3 =@[@"标的图片"];
        _dataArray=[[NSMutableArray alloc]initWithObjects:arr1,arr2,arr3, nil];
    }
    [_tableView reloadData];
}
#pragma mark --提交按钮
-(void)addFooterButton
{
    
    UIView * footView =[UIView new];
    footView.backgroundColor=BG_COLOR;
    footView.frame=CGRectMake(0, 10, ScreenWidth, 100);
    if (_model==nil) {
        // 1.初始化Button
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        //    //2.设置文字和文字颜色
        [button setTitle:@"提交" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //    //3.设置圆角幅度
        button.layer.cornerRadius = 10.0;
        //
        [button addTarget:self action:@selector(tijiaoBtn) forControlEvents:UIControlEventTouchUpInside];
        //    //4.设置frame
        button.frame =CGRectMake(30, 30, ScreenWidth-60, 40);;
        //
        //    //5.设置背景色
        button.backgroundColor = [UIColor redColor];
        
        [footView addSubview:button];
        self.tableView.tableFooterView = footView;
    }else{
        //修改
        NSArray * nameArr =@[@"委托合同",@"确认提交"];
        for (int i =0; i<nameArr.count; i++) {
            UIButton * btn =[UIButton buttonWithType:UIButtonTypeCustom];
            btn.sd_cornerRadius=@(5);
            [btn setTitle:nameArr[i] forState:0];
            btn.backgroundColor=[UIColor redColor];
            btn.titleLabel.font=[UIFont systemFontOfSize:15];
            btn.tag=i;
            [btn addTarget:self action:@selector(xiuGaiBtn:) forControlEvents:UIControlEventTouchUpInside];
            [footView sd_addSubviews:@[btn]];
            btn.sd_layout
            .leftSpaceToView(footView,25+(25+(ScreenWidth-75)/2)*i)
            .topSpaceToView(footView,30)
            .widthIs((ScreenWidth-75)/2)
            .heightIs(35);
            self.tableView.tableFooterView = footView;
        }
    }
   
}
#pragma mark --修改按钮点击状态
-(void)xiuGaiBtn:(UIButton*)btn{
    if (btn.tag==0) {
        WeiTuoHeTongImageVC * vc =[WeiTuoHeTongImageVC new];
        vc.biaoDiID=_model.xqBiaoDiID;
        vc.tagg=1;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self tijiaoBtn];
    }
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
            if (_model==nil) {
//                cell.textfield.placeholder=@"例如张三";
                cell.textfield.text=nil;
                cell.textfield.text=[NSUSE_DEFO objectForKey:@"people"];
            }else{
                cell.textfield.text=[self stringHouMianText:_xmName InternetText:_model.xqlianxiren];
            }
            
            cell.textfield.tag=10;
        }else if (indexPath.row==1){
            if (_model==nil) {
//                 cell.textfield.placeholder=@"请您填写准确的手机号码";
                cell.textfield.text=nil;
                cell.textfield.text=[NSUSE_DEFO objectForKey:@"phone"];
            }else{
                NSString * str =[self stringHouMianText:_phoneName InternetText:_model.xqphone];
               
                cell.textfield.text=[self stringHouMianText:_phoneName InternetText:_model.xqphone];//_model.xqphone;
            }
           
            cell.textfield.tag=11;
            cell.textfield.keyboardType=UIKeyboardTypeNumberPad;
        }
    }else if (indexPath.section==1){
        //第1区
        if (indexPath.row==0) {
            if (_model==nil) {
                cell.textfield.placeholder=@"请填写标的名称";
            }else{
                cell.textfield.text=[self stringHouMianText:_biaoDiName InternetText:_model.xqbiaoDiName];//_model.xqbiaoDiName;
            }
            
            cell.textfield.tag=12;
        }else if (indexPath.row==1){
            cell.textfield.enabled=NO;
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            if (_model==nil) {
                if (_miaoShuText==nil) {
                    cell.textfield.text=nil;
                    cell.textfield.placeholder=@"请填写您的描述";
                }else{
                    cell.textfield.text=_miaoShuText;
                }
            }else{//flattenHTML
                cell.textfield.text=[self stringHouMianText:_miaoShuText InternetText:[ToolClass flattenHTML:_model.xqbiaoDiMiaoShu]];
            }
            
            
        }else if (indexPath.row==2){
            cell.textfield.enabled=NO;
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            if (_model==nil) {
                if (_xiaCiText==nil) {
                     cell.textfield.text=nil;
                    cell.textfield.placeholder=@"请填写您的瑕疵";
                }else{
                    cell.textfield.text=_xiaCiText;
                }

            }else{
                cell.textfield.text=[self stringHouMianText:_xiaCiText InternetText:_model.xqxiaCi];//_model.xqxiaCi;
            }
        }else{
            cell.textfield.enabled=NO;
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            if (_model==nil) {
                if (_diQuText==nil) {
                     cell.textfield.text=nil;
                    cell.textfield.placeholder=@"请选择您具体的地区";
                }else{
                    cell.textfield.text=_diQuText;
                }
            }else{
                cell.textfield.text=[self stringHouMianText:_diQuText InternetText:[NSString stringWithFormat:@"%@-%@-%@",_model.xqShengName,_model.xqCityName,_model.xqXianName]];//[NSString stringWithFormat:@"%@-%@-%@",_model.xqShengName,_model.xqCityName,_model.xqXianName];
            }
            
           
        }
    }else if (indexPath.section==2){
        //保留价格
        if (indexPath.row==0) {
            cell.textfield.hidden=NO;
            if (_model==nil) {
                cell.textfield.placeholder=@"请输入保留价";
            }else{
                cell.textfield.text=_model.xqBaoLiuJia;
            }
            cell.textfield.tag=14;
        }else{
            if (_model==nil) {
                cell.textfield.placeholder=@"请输入评估价";
            }else{
                cell.textfield.text=_model.xqPingGuJia;
            }
            cell.textfield.tag=15;
        }
         cell.textfield.keyboardType=UIKeyboardTypeNumberPad;
    }else{
        //标的图片
        cell.textfield.hidden=YES;
        cell.bgScrollview.hidden=NO;
        cell.deleteTe=self;
        cell.collectionView.hidden=NO;
        if (_model) {
            cell.photoArray=_model.xqImage;
        }
        cell.photoArrImageBlock=^(NSMutableArray*array){
            _photoArray=array;
        };
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
            
        }
    }else if (indexPath.section==1){
        //第1区
        if (indexPath.row==0) {
            cell.textfield.placeholder=@"请填写标的名称";
            cell.textfield.tag=12;
        }

    }else{
        //标的图片
        cell.textfield.hidden=YES;
        cell.bgScrollview.hidden=NO;
        cell.deleteTe=self;
        cell.collectionView.hidden=NO;
        cell.photoArrImageBlock=^(NSMutableArray*array){
            _photoArray=array;
        };


    }
}




#pragma mark --获取验证码
-(void)buttonCode:(UIButton*)sender{
    //标的评估价
    WeiTuoPaiMaiCell * cell4 =[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    [LCProgressHUD showLoading:@"获取验证码..."];
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
                        [sender setTitle:[NSString stringWithFormat:@"重新发送(%@)",strTime] forState:UIControlStateNormal];
                        sender.titleLabel.font=[UIFont systemFontOfSize:13];
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

#pragma mark --表的点击
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
            if (_miaoShuText==nil) {
                vc.neiRong=[ToolClass HTML:_model.xqbiaoDiMiaoShu];
            }else{
                vc.contentText=_miaoShuText;
            }
            //vc.contentText=[self stringHouMianText:_miaoShuText InternetText:_model.xqbiaoDiMiaoShu];;
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row==2){
            //标的瑕疵
            WeiTuoXiuGaiVC * vc =[WeiTuoXiuGaiVC new];
             vc.indexrow=1;
            vc.nameBlock=^(NSString*name,NSString*shengcode,NSString*citycode,NSString*xiancode){
                _xiaCiText=name;
                [_tableView reloadData];
            };
            vc.contentText=[self stringHouMianText:_xiaCiText InternetText:_model.xqxiaCi];//_xiaCiText;
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
        return 176;
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
#pragma mark --清空数据
-(void)dissMissData{
    [_tableView setContentOffset:CGPointZero animated:NO];
    //联系人
    WeiTuoPaiMaiCell * cell0 =[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    //手机号
    WeiTuoPaiMaiCell * cell1 =[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    //验证码
    WeiTuoPaiMaiCell * cell2 =[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    //标的名称
    WeiTuoPaiMaiCell * cell3 =[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    //标的描述
    WeiTuoPaiMaiCell * cell4 =[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    //标的瑕疵
    WeiTuoPaiMaiCell * cell5 =[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    //标的所在地
        WeiTuoPaiMaiCell * cell6 =[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    //标的保留价
    WeiTuoPaiMaiCell * cell7 =[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    //标的评估价
    WeiTuoPaiMaiCell * cell8 =[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:2]];
    
    cell0.textfield.text=nil;
    cell1.textfield.text=nil;
    cell2.textfield.text=nil;
    cell3.textfield.text=nil;
    cell4.textfield.text=nil;
    cell5.textfield.text=nil;
    cell6.textfield.text=nil;
    cell7.textfield.text=nil;
    cell8.textfield.text=nil;
    
    _xmName=nil;
    _phoneName=nil;
    _yanZhengCode=nil;
    _biaoDiName=nil;
    _miaoShuText=nil;
    _xiaCiText=nil;
    _diQuText=nil;
    _shengCodeText=nil;
    _cityCodeText=nil;
    _xiaCiText=nil;
    _baoLiuPrice=nil;
    _pingGuPrice=nil;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissWeiTuo" object:nil userInfo:nil];
    [_tableView reloadData];
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
