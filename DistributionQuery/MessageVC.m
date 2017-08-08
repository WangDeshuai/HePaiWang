//
//  MessageVC.m
//  DistributionQuery
//
//  Created by Macx on 16/11/29.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "MessageVC.h"
#import "MessageCell.h"
#import "XiuGaiMessageVC.h"
@interface MessageVC ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSMutableArray * dataArray;
@property(nonatomic,strong)NSDictionary * messageDic;//缓存或者从网络请求到的数据
@property(nonatomic,copy)NSString * accountText;//账户类型
@property(nonatomic,copy)NSString * nameText;//用户名
@property(nonatomic,copy)NSString * phoneText;//手机号
@property(nonatomic,copy)NSString * emailText;//邮箱
@property(nonatomic,copy)NSString * diquText;//地区
@property(nonatomic,copy)NSString * youBianText;//邮编
@property(nonatomic,copy)NSString * jieDaoText;//街道
@property(nonatomic,strong)UIImage * image1;
@end

@implementation MessageVC
-(void)viewWillAppear:(BOOL)animated
{
    //[self huoQuMessageData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"个人信息";
    [self dataArr];
    [self huoQuMessageData];
    [self CreatTableView];
    [self addFooterButton];
   
}



-(void)addFooterButton
{
    
    UIView * footView =[UIView new];
    footView.backgroundColor=BG_COLOR;
    footView.frame=CGRectMake(0, 10, ScreenWidth, 100);
    
    // 1.初始化Button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    //    //2.设置文字和文字颜色
    [button setTitle:@"提交" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    //3.设置圆角幅度
    button.layer.cornerRadius = 10.0;
    //
    [button addTarget:self action:@selector(buttonClink) forControlEvents:UIControlEventTouchUpInside];
    //    //4.设置frame
    button.frame =CGRectMake(30, 30, ScreenWidth-60, 40);;
    //
    //    //5.设置背景色
    button.backgroundColor = [UIColor redColor];
    
    [footView addSubview:button];
    self.tableView.tableFooterView = footView;
}
#pragma mark --提交按钮
-(void)buttonClink{
    //账户
    MessageCell * cell1 =[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    //用户名
     MessageCell * cell2 =[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    //手机号
     MessageCell * cell3 =[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
    //邮箱
     MessageCell * cell4 =[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:3]];
    //邮编
     MessageCell * cell5 =[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:3]];
    //详细地址
     MessageCell * cell6 =[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:5]];
    NSLog(@"账户>>>>%@",[self stringHouMianText:_accountText InternetText:[ToolClass isString:cell1.textfield.text]]);
    NSLog(@"用户名>>>>%@",[self stringHouMianText:_nameText InternetText:[ToolClass isString:cell2.textfield.text]]);
    NSLog(@"手机号>>>>%@",[self stringHouMianText:_phoneText InternetText:[ToolClass isString:cell3.textfield.text]]);
    NSLog(@"邮箱>>>>%@",[self stringHouMianText:_emailText InternetText:[ToolClass isString:cell4.textfield.text]]);
    NSLog(@"邮编>>>>%@",[self stringHouMianText:_youBianText InternetText:[ToolClass isString:cell5.textfield.text]]);
    NSLog(@"街道>>>>%@",[self stringHouMianText:_jieDaoText InternetText:[ToolClass isString:cell6.textfield.text]]);
    //账户
    NSMutableDictionary * dicc1 =[NSMutableDictionary new];
    [dicc1 setObject:[self stringHouMianText:_accountText InternetText:[ToolClass isString:cell1.textfield.text]] forKey:@"fieldValue"];
    [dicc1 setObject:@"account" forKey:@"fieldName"];
    //用户名
    NSMutableDictionary * dicc2 =[NSMutableDictionary new];
    [dicc2 setObject:[self stringHouMianText:_nameText InternetText:[ToolClass isString:cell2.textfield.text]] forKey:@"fieldValue"];
    [dicc2 setObject:@"user_name" forKey:@"fieldName"];
    //手机号
    NSMutableDictionary * dicc3 =[NSMutableDictionary new];
    [dicc3 setObject:[self stringHouMianText:_phoneText InternetText:[ToolClass isString:cell3.textfield.text]] forKey:@"fieldValue"];
    [dicc3 setObject:@"regist_tel" forKey:@"fieldName"];
    //邮箱
    NSMutableDictionary * dicc4 =[NSMutableDictionary new];
    [dicc4 setObject:[self stringHouMianText:_emailText InternetText:[ToolClass isString:cell4.textfield.text]] forKey:@"fieldValue"];
    [dicc4 setObject:@"mailbox" forKey:@"fieldName"];
    //邮编
    NSMutableDictionary * dicc5 =[NSMutableDictionary new];
    [dicc5 setObject:[self stringHouMianText:_youBianText InternetText:[ToolClass isString:cell5.textfield.text]] forKey:@"fieldValue"];
    [dicc5 setObject:@"postcode" forKey:@"fieldName"];
    //街道
    NSMutableDictionary * dicc6 =[NSMutableDictionary new];
    [dicc6 setObject:[self stringHouMianText:_jieDaoText InternetText:[ToolClass isString:cell6.textfield.text]] forKey:@"fieldValue"];
    [dicc6 setObject:@"detailed_addr" forKey:@"fieldName"];
    NSArray * arr =@[dicc1,dicc2,dicc3,dicc4,dicc5,dicc6];
    [LCProgressHUD showLoading:@"请稍后..."];
    [Engine modificationMyMessageKeyDicStr:[ToolClass getJsonStringFromObject:arr] success:^(NSDictionary *dic) {
        [LCProgressHUD showMessage:[dic objectForKey:@"msg"]];
        NSString * code =[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            NSDictionary * dicc =[dic objectForKey:@"content"];
            NSDictionary * dicAr =[ToolClass isDictionary:dicc];
            [ToolClass savePlist:dicAr name:@"baseInfo"];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    } error:^(NSError *error) {
        
    }];
    
}
-(void)dataArr{
    NSArray * arr1 =@[@"头        像"];
    NSArray * arr2 =@[@"账        户"];
    NSArray * arr3 =@[@"用  户  名",@"真实姓名"];
    NSArray * arr4 =@[@"手  机  号",@"邮        箱",@"邮        编"];
    NSArray * arr5 =@[@"账户类型"];
    NSArray * arr6 =@[@"地        址",@"街        道"];
   
    _dataArray=[[NSMutableArray alloc]initWithObjects:arr1,arr2,arr3,arr4,arr5,arr6, nil];
    
}

#pragma mark --获取个人信息
-(void)huoQuMessageData{
    [Engine myMessagesuccess:^(NSDictionary *dic) {
        NSString * code =[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            NSString * code =[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
            if ([code isEqualToString:@"1"]) {
                NSDictionary * dicc=[dic objectForKey:@"content"];
                NSMutableDictionary * dicDic=[ToolClass isDictionary:dicc];
//                [ToolClass savePlist:dicDic name:@"baseInfo"];
//                NSDictionary * messageDic= [ToolClass duquPlistWenJianPlistName:@"baseInfo"];
                
                 _messageDic=dicDic;
                
            }
            [_tableView reloadData];
        }else
        {
            [LCProgressHUD showMessage:[dic objectForKey:@"msg"]];
        }
    } error:^(NSError *error) {
        
    }];
   //
//    NSDictionary * messageDic= [ToolClass duquPlistWenJianPlistName:@"baseInfo"];
//    _messageDic=messageDic;
}



#pragma mark --创建标示图
-(void)CreatTableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];
    }
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.backgroundColor=BG_COLOR;
    _tableView.tableFooterView=[UIView new];
    _tableView.keyboardDismissMode=UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:_tableView];
   

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArray[section] count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld", (long)[indexPath section], (long)[indexPath row]];
    
    MessageCell * cell =[MessageCell cellWithTableView:tableView CellID:CellIdentifier];
    cell.nameLabel.text=_dataArray[indexPath.section][indexPath.row];
    [self uitableViewCell:cell indexpath:indexPath];
    
    return cell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            return 80;
        }
    }
    return 44;
}
#pragma mark --cell内部
-(void)uitableViewCell:(MessageCell*)cell indexpath:(NSIndexPath*)indexPath{
    cell.textfield.textAlignment=2;
   
    if (indexPath.section==0) {
        //头像
        cell.headImage.hidden=NO;
        cell.textfield.hidden=YES;
        if (_image1) {
            cell.headImage.image=_image1;
        }else{
            [cell.headImage setImageWithURL:[NSURL URLWithString:[_messageDic objectForKey:@"head_img"]] placeholderImage:[UIImage imageNamed:@"headImage"]];
        }

        
        
    }else if (indexPath.section==1){
        //账户
        cell.textfield.text=[self stringHouMianText:_accountText InternetText:[ToolClass isString:[_messageDic objectForKey:@"account"]]];
        cell.textfield.delegate=self;
        cell.textfield.tag=1;
    }else if (indexPath.section==2){
        if (indexPath.row==0) {
            //用户名
            cell.textfield.delegate=self;
            cell.textfield.tag=2;
            if ([[ToolClass isString:[_messageDic objectForKey:@"user_name"]] isEqualToString:@""]) {
                cell.textfield.placeholder=@"请填写用户名";
            }else{
               cell.textfield.text=[self stringHouMianText:_nameText InternetText:[ToolClass isString:[_messageDic objectForKey:@"user_name"]]];
            }
            
            
        }else if (indexPath.row==1){
            //真实姓名
            cell.textfield.enabled=NO;
            cell.textfield.text=[ToolClass isString:[_messageDic objectForKey:@"real_name"]];
        }
    }else if (indexPath.section==3){
        if (indexPath.row==0) {
            //手机号
            cell.textfield.delegate=self;
            cell.textfield.tag=3;
            cell.textfield.text=[self stringHouMianText:_phoneText InternetText:[ToolClass isString:[_messageDic objectForKey:@"regist_tel"]]];
        }else if (indexPath.row==1){
            //邮箱
            cell.textfield.delegate=self;
            cell.textfield.tag=4;
            if ([[_messageDic objectForKey:@"mailbox"] isEqualToString:@""]) {
                cell.textfield.placeholder=@"请输入邮箱";
            }else{
                 cell.textfield.text=[self stringHouMianText:_emailText InternetText:[ToolClass isString:[_messageDic objectForKey:@"mailbox"]]];
            }
        }else if (indexPath.row==2){
            //邮编
            cell.textfield.delegate=self;
            cell.textfield.tag=5;
            if ([[_messageDic objectForKey:@"postcode"] isEqualToString:@""]) {
                cell.textfield.placeholder=@"请输入邮编";
            }else{
                cell.textfield.text=[self stringHouMianText:_youBianText InternetText:[ToolClass isString:[_messageDic objectForKey:@"postcode"]]];
            }
        }
    }else if (indexPath.section==4){
        //账户类型qiYeRenZhengStye
        cell.textfield.enabled=NO;
        cell.textfield.text=[self qiYeRenZhengStye:[ToolClass isString:[_messageDic objectForKey:@"authentication_type"]]];
        
    }else if (indexPath.section==5){
        if (indexPath.row==0) {
            //地址
            NSString * str =[NSString stringWithFormat:@"%@-%@-%@",[ToolClass isString:[_messageDic objectForKey:@"provname"]],[ToolClass isString:[_messageDic objectForKey:@"cityname"]],[ToolClass isString:[_messageDic objectForKey:@"districtname"]]];
            
           cell.textfield.text = [self stringHouMianText:_diquText InternetText:[self stringValue2:str Sting:@"未选择"]];
            
            cell.textfield.enabled=NO;
        }else if (indexPath.row==1){
            //街道
            cell.textfield.delegate=self;
            cell.textfield.tag=6;
            if ([[_messageDic objectForKey:@"detailed_addr"] isEqualToString:@""]) {
                cell.textfield.placeholder=@"请输入街道地址";
            }else{
                cell.textfield.text=[self stringHouMianText:_jieDaoText InternetText:[ToolClass isString:[_messageDic objectForKey:@"detailed_addr"]]];
            }
        }
    }
    
    
//    if (indexPath.section==0) {
//        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
//        if (_image1) {
//            cell.headImage.image=_image1;
//        }else{
//            if (_messageDic) {
//                [cell.headImage setImageWithURL:[NSURL URLWithString:[_messageDic objectForKey:@"head_img"]] placeholderImage:[UIImage imageNamed:@"headImage"]];
//            }
//            
//        }
//        cell.textfield.hidden=YES;
//    }else if (indexPath.section==1){
//        //账户，不可更改。
//        if (_messageDic) {
//            cell.textfield.text=[_messageDic objectForKey:@"account"];
//            [cell sd_addSubviews:@[cell.textfield]];
//            cell.textfield.sd_layout.rightSpaceToView(cell,30);
//        }
//        
//    }else if (indexPath.section==2){
//        if (indexPath.row==0) {
//            //用户名
//            if (_messageDic) {
//                cell.textfield.placeholder=@"未填写";
//                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
//                cell.textfield.text=[self stringHouMianText:_nameText InternetText:[_messageDic objectForKey:@"user_name"]];
//            }
//            
//        }else{
//            //真实姓名(不可更改)
//            if (_messageDic) {
//                if ([[_messageDic objectForKey:@"real_name"] isEqualToString:@""]) {
//                    cell.textfield.text=@"未认证";
//                }else{
//                    cell.textfield.text=[_messageDic objectForKey:@"real_name"];
//                    [cell sd_addSubviews:@[cell.textfield]];
//                    cell.textfield.sd_layout.rightSpaceToView(cell,30);
//                }
//            }
//            
//            
//        }
//    }else if (indexPath.section==3){
//        if (indexPath.row==0) {
//            //手机号
//            if (_messageDic) {
//                
//                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
//                //cell.textfield.text=[self stringHouMianText:_phoneText InternetText:[_messageDic objectForKey:@"regist_tel"]];
//                cell.textfield.text=[self stringHouMianText:_nameText InternetText:[self stringValue:[_messageDic objectForKey:@"regist_tel"] Sting:@"未填写"]];
//                
//                
//            }
//            
//        }else if (indexPath.row==1){
//            //邮箱
//            if (_messageDic) {
//                cell.textfield.placeholder=@"未填写";
//                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
//                cell.textfield.text=[self stringHouMianText:_emailText InternetText:[_messageDic objectForKey:@"mailbox"]];
//            }
//            
//        }else{
//            //邮编
//            if (_messageDic) {
//                cell.textfield.placeholder=@"未填写";
//                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
//                cell.textfield.text=[self stringHouMianText:_youBianText InternetText:[_messageDic objectForKey:@"postcode"]];
//            }
//            
//        }
//    }else if (indexPath.section==4){
//            //账户类型（不可更改）
//        if (_messageDic) {
//            cell.textfield.text=[ToolClass myStype:[_messageDic objectForKey:@"authentication_type"]];
//            [cell sd_addSubviews:@[cell.textfield]];
//            cell.textfield.sd_layout.rightSpaceToView(cell,30);
//        }
//       
//    }else if (indexPath.section==5){
//        if (indexPath.row==0) {
//            //地址
//            if (_messageDic) {
//                cell.textfield.enabled=NO;
//                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
//                NSString * str =[NSString stringWithFormat:@"%@-%@-%@",[_messageDic objectForKey:@"provname"],[_messageDic objectForKey:@"cityname"],[_messageDic objectForKey:@"districtname"]];
//                cell.textfield.text=[self stringHouMianText:_diquText InternetText:str];
//            }
//            
//        }else{
//            //街道
//            if (_messageDic) {
//                cell.textfield.placeholder=@"未填写";
//                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
//                cell.textfield.text=[self stringHouMianText:_jieDaoText InternetText:[_messageDic objectForKey:@"detailed_addr"]];
//            }
//            
//        }
//    }else{
//        //退出
//         cell.textfield.hidden=YES;
//        cell.nameLabel.textAlignment=1;
//        cell.nameLabel.alpha=.8;
//        cell.nameLabel.font=[UIFont systemFontOfSize:17 weight:1];
//        cell.nameLabel.textColor=[UIColor redColor];
//        cell.nameLabel.sd_layout.widthIs(ScreenWidth-30);
//    }
//    
    
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==0) {
        [self xuanzeImageBtn];
    }else if (indexPath.section==5) {
        if (indexPath.row==0) {
            //地址
            XiuGaiMessageVC * xiugai =[XiuGaiMessageVC new];
            xiugai.indexrow=5;
            xiugai.nameBlock=^(NSString*name){
            _diquText=name;
            [_tableView reloadData];
            };
        [self.navigationController pushViewController:xiugai animated:YES];
        }
    }
    
//    if (indexPath.section==0) {
//        [self headImageClick];
//    }else if (indexPath.section==1){
//        //账户
//    }else if (indexPath.section==2){
//        if (indexPath.row==0) {
//            //用户名
//            XiuGaiMessageVC * xiugai =[XiuGaiMessageVC new];
//            xiugai.indexrow=0;
//            xiugai.nameBlock=^(NSString*name){
//                _nameText=name;
//                [_tableView reloadData];
//            };
//            [self.navigationController pushViewController:xiugai animated:YES];
//        }else{
//            //真实姓名
//        }
//    }else if (indexPath.section==3){
//        if (indexPath.row==0) {
//            //手机号
//            XiuGaiMessageVC * xiugai =[XiuGaiMessageVC new];
//            xiugai.indexrow=1;
//            xiugai.nameBlock=^(NSString*name){
//                _phoneText=name;
//                [_tableView reloadData];
//            };
//            [self.navigationController pushViewController:xiugai animated:YES];
//        }else  if (indexPath.row==1){
//            //邮箱
//            XiuGaiMessageVC * xiugai =[XiuGaiMessageVC new];
//            xiugai.indexrow=2;
//            xiugai.nameBlock=^(NSString*name){
//                _emailText=name;
//                [_tableView reloadData];
//            };
//            [self.navigationController pushViewController:xiugai animated:YES];
//        }else{
//            //邮编
//            XiuGaiMessageVC * xiugai =[XiuGaiMessageVC new];
//            xiugai.indexrow=3;
//            xiugai.nameBlock=^(NSString*name){
//                _youBianText=name;
//                [_tableView reloadData];
//            };
//            [self.navigationController pushViewController:xiugai animated:YES];
//        }
//        
//    }else if (indexPath.section==4){
//        //账户类型
//    }else if (indexPath.section==5){
//        if (indexPath.row==0) {
//            //地址
//            XiuGaiMessageVC * xiugai =[XiuGaiMessageVC new];
//            xiugai.indexrow=5;
//            xiugai.nameBlock=^(NSString*name){
//                _diquText=name;
//                [_tableView reloadData];
//            };
//            [self.navigationController pushViewController:xiugai animated:YES];
//        }else  if (indexPath.row==1){
//            //街道
//            XiuGaiMessageVC * xiugai =[XiuGaiMessageVC new];
//            xiugai.indexrow=4;
//            xiugai.nameBlock=^(NSString*name){
//                _jieDaoText=name;
//                [_tableView reloadData];
//            };
//            [self.navigationController pushViewController:xiugai animated:YES];
//        }
//    }else if (indexPath.section==6){
//        
//        UIAlertController * alertView =[UIAlertController alertControllerWithTitle:@"" message:@"是否确认退出" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction * action1 =[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//            //1.清楚token
//            [NSUSE_DEFO removeObjectForKey:@"token"];
//            [NSUSE_DEFO synchronize];
//            //2.清楚plist文件
//            [ToolClass deleagtePlistName:@"baseInfo"];
//            [ToolClass deleagtePlistName:@"shiMingInfo"];
//            [self.navigationController popViewControllerAnimated:YES];
//        }];
//        UIAlertAction * action2 =[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            
//        }];
//        [alertView addAction:action2];
//        [alertView addAction:action1];
//        [self presentViewController:alertView animated:YES completion:nil];
//        
//       
//    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
////text1是从后面界面传过来的，text2是从上个界面过来的_model
//-(NSString *)stringHouMianText:(NSString*)text1 InternetText:(NSString*)text2{
//    
//    NSString * str;
//    if (text1) {
//        str=text1;
//    }else{
//        str=text2;
//    }
//    
//    return str;
//}

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
-(NSString *)stringValue2:(NSString*)text1 Sting:(NSString*)text2{
    
    NSString * str;
    if ([text1 isEqualToString:@"--"]) {
        str=text2;
    }else{
        str=text1;
    }
    
    return str;
}
-(NSString*)stringValue:(NSString*)str1 Sting:(NSString*)str2{
    if (str1 && ![str1 isEqualToString:@""]) {
        return str1;
    }else{
        return str2;
    }
}

-(NSString*)qiYeRenZhengStye:(NSString*)qiye{
    NSMutableDictionary * dicc =[NSMutableDictionary new];
    [dicc setObject:@"未认证" forKey:@"0"];
    [dicc setObject:@"个人" forKey:@"1"];
    [dicc setObject:@"企业" forKey:@"2"];
    
    return [dicc objectForKey:qiye];
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag==1) {
        //账户
        _accountText=textField.text;
    }else if (textField.tag==2){
        //用户名
        _nameText=textField.text;
    }else if (textField.tag==3){
        //手机号
        _phoneText=textField.text;
    }else if (textField.tag==4){
        //邮箱
        _emailText=textField.text;
    }else if (textField.tag==5){
        //邮编
        _youBianText=textField.text;
    }else if (textField.tag==6){
        //街道
        _jieDaoText=textField.text;
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
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
    _image1=image;
    [self upDataFuWuQiWithAddress:image];
    [self dismissViewControllerAnimated:YES completion:nil];
     [_tableView reloadData];
}
#pragma mark --上传图片到服务器获取地址
-(void)upDataFuWuQiWithAddress:(UIImage*)image{
    [LCProgressHUD showMessage:@"请稍后..."];
    [Engine upDataBaseWithImageBaseImage:image success:^(NSDictionary *dic) {
        NSString * code =[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            NSString * contentUrl =[dic objectForKey:@"content"];
            [self upDataImage:contentUrl];
        }
        
    } error:^(NSError *error) {
        
    }];
}
#pragma mark --上传服务器
-(void)upDataImage:(NSString*)url{
   
    NSDictionary * dicc =@{@"fieldName":@"head_img",@"fieldValue":url};
    NSArray * arr =@[dicc];
    NSLog(@"输出格式%@",[ToolClass getJsonStringFromObject:arr]);
    [Engine modificationMyMessageKeyDicStr:[ToolClass getJsonStringFromObject:arr] success:^(NSDictionary *dic) {
        [LCProgressHUD showMessage:[dic objectForKey:@"msg"]];
        NSString * code =[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            NSDictionary * dicc =[dic objectForKey:@"content"];
            NSMutableDictionary * dicAr = [ToolClass isDictionary:dicc];
            [ToolClass savePlist:dicAr name:@"baseInfo"];
        }
    } error:^(NSError *error) {
        
    }];
}

@end
