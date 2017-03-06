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
@interface MessageVC ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSMutableArray * dataArray;
@property(nonatomic,strong)NSDictionary * messageDic;//缓存或者从网络请求到的数据
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
    [self huoQuMessageData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"个人信息";
    [self dataArr];
    [self CreatTableView];
    [self huoQuMessageData];
}
-(void)dataArr{
    NSArray * arr1 =@[@"头像"];
    NSArray * arr2 =@[@"账户"];
    NSArray * arr3 =@[@"用户名",@"真实姓名"];
    NSArray * arr4 =@[@"手机号",@"邮箱",@"邮编"];
    NSArray * arr5 =@[@"账户类型"];
    NSArray * arr6 =@[@"地址",@"街道"];
    NSArray * arr7 =@[@"退出"];
    _dataArray=[[NSMutableArray alloc]initWithObjects:arr1,arr2,arr3,arr4,arr5,arr6,arr7, nil];
}

#pragma mark --获取个人信息
-(void)huoQuMessageData{
//    [Engine myMessagesuccess:^(NSDictionary *dic) {
//        NSString * code =[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
//        if ([code isEqualToString:@"1"]) {
//            
//        }else
//        {
//            [LCProgressHUD showMessage:[dic objectForKey:@"msg"]];
//        }
//    } error:^(NSError *error) {
//        
//    }];
    
    NSDictionary * messageDic= [ToolClass duquPlistWenJianPlistName:@"baseInfo"];
    _messageDic=messageDic;
}



#pragma mark --创建标示图
-(void)CreatTableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
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
-(void)uitableViewCell:(MessageCell*)cell indexpath:(NSIndexPath*)indexPath{
    cell.textfield.textAlignment=2;
     cell.textfield.enabled=NO;
    
    if (indexPath.section==0) {
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        if (_image1) {
            cell.headImage.image=_image1;
        }else{
            [cell.headImage setImageWithURL:[NSURL URLWithString:[_messageDic objectForKey:@"head_img"]] placeholderImage:[UIImage imageNamed:@"headImage"]];
        }
        cell.textfield.hidden=YES;
    }else if (indexPath.section==1){
        //账户，不可更改。
        cell.textfield.text=[_messageDic objectForKey:@"account"];
    }else if (indexPath.section==2){
        if (indexPath.row==0) {
            //用户名
            cell.textfield.placeholder=@"未填写";
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            cell.textfield.text=[self stringHouMianText:_nameText InternetText:[_messageDic objectForKey:@"user_name"]];
        }else{
            //真实姓名(不可更改)
            if ([[_messageDic objectForKey:@"real_name"] isEqualToString:@""]) {
                cell.textfield.text=@"未认证";
            }else{
                cell.textfield.text=[_messageDic objectForKey:@"real_name"];
            }
            
        }
    }else if (indexPath.section==3){
        if (indexPath.row==0) {
            //手机号
            cell.textfield.placeholder=@"未填写";
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            cell.textfield.text=[self stringHouMianText:_phoneText InternetText:[_messageDic objectForKey:@"connect_tel"]];
        }else if (indexPath.row==1){
            //邮箱
            cell.textfield.placeholder=@"未填写";
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            cell.textfield.text=[self stringHouMianText:_emailText InternetText:[_messageDic objectForKey:@"mailbox"]];
        }else{
            //邮编
            cell.textfield.placeholder=@"未填写";
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            cell.textfield.text=[self stringHouMianText:_youBianText InternetText:[_messageDic objectForKey:@"postcode"]];
        }
    }else if (indexPath.section==4){
            //账户类型（不可更改）
        cell.textfield.text=[ToolClass myStype:[_messageDic objectForKey:@"authentication_type"]];
    }else if (indexPath.section==5){
        if (indexPath.row==0) {
            //地址
            cell.textfield.enabled=NO;
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            NSString * str =[NSString stringWithFormat:@"%@-%@-%@",[_messageDic objectForKey:@"provname"],[_messageDic objectForKey:@"cityname"],[_messageDic objectForKey:@"districtname"]];
            cell.textfield.text=[self stringHouMianText:_diquText InternetText:str];
        }else{
            //街道
            cell.textfield.placeholder=@"未填写";
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            cell.textfield.text=[self stringHouMianText:_jieDaoText InternetText:[_messageDic objectForKey:@"detailed_addr"]];
        }
    }else{
        //退出
         cell.textfield.hidden=YES;
    }
    
    
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        [self headImageClick];
    }else if (indexPath.section==1){
        //账户
    }else if (indexPath.section==2){
        if (indexPath.row==0) {
            //用户名
            XiuGaiMessageVC * xiugai =[XiuGaiMessageVC new];
            xiugai.indexrow=0;
            xiugai.nameBlock=^(NSString*name){
                _nameText=name;
                [_tableView reloadData];
            };
            [self.navigationController pushViewController:xiugai animated:YES];
        }else{
            //真实姓名
        }
    }else if (indexPath.section==3){
        if (indexPath.row==0) {
            //手机号
            XiuGaiMessageVC * xiugai =[XiuGaiMessageVC new];
            xiugai.indexrow=1;
            xiugai.nameBlock=^(NSString*name){
                _phoneText=name;
                [_tableView reloadData];
            };
            [self.navigationController pushViewController:xiugai animated:YES];
        }else  if (indexPath.row==1){
            //邮箱
            XiuGaiMessageVC * xiugai =[XiuGaiMessageVC new];
            xiugai.indexrow=2;
            xiugai.nameBlock=^(NSString*name){
                _emailText=name;
                [_tableView reloadData];
            };
            [self.navigationController pushViewController:xiugai animated:YES];
        }else{
            //邮编
            XiuGaiMessageVC * xiugai =[XiuGaiMessageVC new];
            xiugai.indexrow=3;
            xiugai.nameBlock=^(NSString*name){
                _youBianText=name;
                [_tableView reloadData];
            };
            [self.navigationController pushViewController:xiugai animated:YES];
        }
        
    }else if (indexPath.section==4){
        //账户类型
    }else if (indexPath.section==5){
        if (indexPath.row==0) {
            //地址
            XiuGaiMessageVC * xiugai =[XiuGaiMessageVC new];
            xiugai.indexrow=5;
            xiugai.nameBlock=^(NSString*name){
                _diquText=name;
                [_tableView reloadData];
            };
            [self.navigationController pushViewController:xiugai animated:YES];
        }else  if (indexPath.row==1){
            //街道
            XiuGaiMessageVC * xiugai =[XiuGaiMessageVC new];
            xiugai.indexrow=4;
            xiugai.nameBlock=^(NSString*name){
                _jieDaoText=name;
                [_tableView reloadData];
            };
            [self.navigationController pushViewController:xiugai animated:YES];
        }
    }else if (indexPath.section==6){
        
        UIAlertController * alertView =[UIAlertController alertControllerWithTitle:@"" message:@"是否确认退出" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action1 =[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //1.清楚token
            [NSUSE_DEFO removeObjectForKey:@"token"];
            [NSUSE_DEFO synchronize];
            //2.清楚plist文件
            [ToolClass deleagtePlistName:@"baseInfo"];
            [ToolClass deleagtePlistName:@"shiMingInfo"];
            [self.navigationController popViewControllerAnimated:YES];
        }];
        UIAlertAction * action2 =[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertView addAction:action2];
        [alertView addAction:action1];
        [self presentViewController:alertView animated:YES completion:nil];
        
       
    }
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
