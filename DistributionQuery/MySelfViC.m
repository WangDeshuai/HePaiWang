//
//  MySelfViC.m
//  DistributionQuery
//
//  Created by Macx on 17/3/4.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "MySelfViC.h"
#import "XiuGaiVC.h"
#import "ShiMingRenZhengCell.h"
@interface MySelfViC ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSMutableArray * nameArray;
@property(nonatomic,strong)UIButton * lastBtn;
@property(nonatomic,copy)NSString * nameText;
@property(nonatomic,copy)NSString * phoneText;
@property(nonatomic,strong)NSMutableDictionary * messageDic;

@end

@implementation MySelfViC


-(void)viewWillAppear:(BOOL)animated{
//    [self huoQuData];
//    NSMutableDictionary * messageDic =[ToolClass duquPlistWenJianPlistName:@"shiMingInfo"];
//     _messageDic=messageDic;
//    if (messageDic==nil) {
//        NSLog(@"走哪了");
//        [self huoQuData];
//    }else{
//        NSLog(@"不知道");
//        [self huoQuData];
//          _messageDic=messageDic;
//    }
  
}
//-(void)huoQuData{
//    NSLog(@"获取了实名认证的信息了");
//    [Engine getShiMingMessagesuccess:^(NSDictionary *dic) {
//        NSString * code =[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
//        if ([code isEqualToString:@"1"]) {
//            if ([dic objectForKey:@"content"]==[NSNull null]) {
//                [LCProgressHUD showMessage:@"首次请您认证填写"];
//            }else{
//                NSDictionary * dicc =[dic objectForKey:@"content"];
//                NSMutableDictionary * dicAr = [ToolClass isDictionary:dicc];
//                _messageDic=dicAr;
//                [ToolClass savePlist:dicAr name:@"shiMingInfo"];
//                NSString * type =[NSString stringWithFormat:@"%@",[dicAr objectForKey:@"authentication_type"]];
//                if ([type isEqualToString:@"1"]) {
//                    //个人
//                    //把真实姓名和 账户类型添加进去
//                    [self saveMyMessageZhenName:[dicAr objectForKey:@"personal_name"] ZhangHuStyle:type];
//                }else{
//                    //企业
//                    [self saveMyMessageZhenName:[dicAr objectForKey:@"enterprise_name"] ZhangHuStyle:type];
//                }
//  
//            }
//            
//            
//        }
//    } error:^(NSError *error) {
//        
//    }];
//}
//#pragma mark --存进个人信息中
//-(void)saveMyMessageZhenName:(NSString*)name ZhangHuStyle:(NSString*)style{
//    NSMutableDictionary * dic =[ToolClass duquPlistWenJianPlistName:@"baseInfo"];
//    [dic setObject:name forKey:@"real_name"];
//    [dic setObject:style forKey:@"authentication_type"];
//    
//    [ToolClass savePlist:dic name:@"baseInfo"];
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self huoQuData];
    [self CreatData];
    [self CreatTabelView];
    [self addFooterButton];
}
#pragma mark --获取实名认证信息
-(void)huoQuData{
    [LCProgressHUD showMessage:@"请稍后..."];
    [Engine getShiMingMessagesuccess:^(NSDictionary *dic) {
        NSString * code =[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
           
            NSDictionary * dicc=[dic objectForKey:@"content"];
            if (dicc.count==0) {
                [LCProgressHUD showMessage:@"首次请填写认证信息"];
                return ;
            }
            NSMutableDictionary * dicAr = [ToolClass isDictionary:dicc];
            _messageDic=dicAr;
            [ToolClass savePlist:dicAr name:@"实名认证"];
            [_tableView reloadData];
            [LCProgressHUD hide];
        }else{
            [LCProgressHUD showMessage:[dic objectForKey:@"msg"]];
        }
    } error:^(NSError *error) {
        
    }];
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
    button.layer.cornerRadius = 5.0;
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
#pragma mark --提交
-(void)buttonClink{
    //姓名
    ShiMingRenZhengCell * cell1 =[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
  //手机号
    ShiMingRenZhengCell * cell2 =[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
//    NSLog(@"输出%@",cell1.textfield.text);
//    NSLog(@"输出%@",cell2.textfield.text);
   NSMutableArray * arr =[NSMutableArray new];
    NSMutableDictionary * dicc1 =[NSMutableDictionary new];
    [dicc1 setObject:cell1.textfield.text forKey:@"fieldValue"];
    [dicc1 setObject:@"personal_name" forKey:@"fieldName"];
    
    NSMutableDictionary * dicc2 =[NSMutableDictionary new];
    [dicc2 setObject:cell2.textfield.text forKey:@"fieldValue"];
    [dicc2 setObject:@"personal_connect_tel" forKey:@"fieldName"];
    
    NSMutableDictionary * dicc3 =[NSMutableDictionary new];
    [dicc3 setObject:@"1" forKey:@"fieldValue"];//_tagg 1.个人 2.企业
    [dicc3 setObject:@"authentication_type" forKey:@"fieldName"];
    [arr addObject:dicc1];
    [arr addObject:dicc2];
    [arr addObject:dicc3];
//    NSLog(@"输出json==%@",[ToolClass getJsonStringFromObject:arr]);
    [LCProgressHUD showMessage:@"正在提交..."];
    [Engine xiuGaiShiMingRenZhengMessageJsonStr:[ToolClass getJsonStringFromObject:arr] success:^(NSDictionary *dic) {
         [LCProgressHUD showMessage:[dic objectForKey:@"msg"]];
         NSString * code =[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } error:^(NSError *error) {
        
    }];
}
#pragma mark --创建数据源
-(void)CreatData{
    NSArray * arr1 =@[@"* 姓   名",@"* 手机号"];
    NSArray * arr2 =@[@"* 身份证图片"];
    _nameArray=[[NSMutableArray alloc]initWithObjects:arr1,arr2, nil];
}

#pragma mark --创建表格
-(void)CreatTabelView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 44, ScreenWidth, ScreenHeight-64-44) style:UITableViewStylePlain];
    }
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.tableFooterView=[UIView new];
    _tableView.backgroundColor=BG_COLOR;
    _tableView.keyboardDismissMode=UIScrollViewKeyboardDismissModeOnDrag;
    [self.view sd_addSubviews:@[_tableView]];

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _nameArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_nameArray[section] count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ShiMingRenZhengCell * cell =[ShiMingRenZhengCell cellWithTableView:tableView IndexPath:indexPath];
    
    cell.namelabel.text=_nameArray[indexPath.section][indexPath.row];
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            cell.textfield.delegate=self;
            cell.textfield.tag=1;
            //姓名
            if (_messageDic==nil) {
                cell.textfield.placeholder=@"请输入姓名";
            }else{
                cell.textfield.text=[self stringHouMianText:_nameText InternetText:[_messageDic objectForKey:@"personal_name"]];
            }
            
        }else if (indexPath.row==1){
            //手机号regist_tel
            cell.textfield.delegate=self;
            cell.textfield.tag=2;
            if (_messageDic==nil) {
                cell.textfield.text=[NSUSE_DEFO objectForKey:@"phone"];
            }else{
                cell.textfield.text=[self stringHouMianText:_phoneText InternetText:[_messageDic objectForKey:@"personal_connect_tel"]];
                
            }
            
        }
    }else if(indexPath.section==1){
        //图片
        cell.textfield.hidden=YES;
        cell.bgScrollView.hidden=NO;
        cell.bgScrollView.contentSize=CGSizeMake(ScreenWidth+200, 0);
        [self CreatButtonImage:cell.bgScrollView TableViewCell:cell];
    }
    
//        UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:@"Cell"];
//        if (!cell) {
//            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
//            UILabel * nameLabel =[UILabel new];
//            nameLabel.tag=1;
//            UILabel * dataLabel =[UILabel new];
//            dataLabel.tag=2;
//            UIScrollView * bgScroview =[UIScrollView new];
//            bgScroview.bounces=NO;
//            bgScroview.tag=3;
//            bgScroview.hidden=YES;
//            [cell sd_addSubviews:@[nameLabel,dataLabel,bgScroview]];
//             [self CreatButtonImage:bgScroview TableViewCell:cell];
//        }
//    cell.selectionStyle=UITableViewCellSelectionStyleNone;
//   
//        UILabel * nameLabel =[cell viewWithTag:1];
//        UILabel * dataLabel =[cell viewWithTag:2];
//        dataLabel.font=[UIFont systemFontOfSize:15];
//        dataLabel.alpha=.6;
//        dataLabel.textAlignment=2;
//        UIScrollView * bgScroview=[cell viewWithTag:3];
//        nameLabel.font=[UIFont systemFontOfSize:15];
//        nameLabel.alpha=.6;
//        nameLabel.text=_nameArray[indexPath.section][indexPath.row];
//        nameLabel.sd_layout
//        .leftSpaceToView(cell,15)
//        .topSpaceToView(cell,11)
//        .heightIs(20);
//        [nameLabel setSingleLineAutoResizeWithMaxWidth:120];
//    
//     dataLabel.sd_layout
//     .rightSpaceToView(cell,30)
//     .leftSpaceToView(nameLabel,10)
//     .centerYEqualToView(cell)
//     .heightIs(20);
//    
//    if (indexPath.section==0) {
//         cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
//        if (indexPath.row==0) {
//            //姓名
//            if (_messageDic) {
//               dataLabel.text=[self stringHouMianText:_nameText InternetText:[_messageDic objectForKey:@"personal_name"]];
//            }
//            
//        }else{
//            //手机号
//            
//            if (_messageDic) {
//                 dataLabel.text=[self stringHouMianText:_phoneText InternetText:[_messageDic objectForKey:@"personal_connect_tel"]];
//            }
//           //_phoneText;
//        }
//    }
//     else if (indexPath.section==1) {
//         dataLabel.hidden=YES;
//        bgScroview.hidden=NO;
//        bgScroview.sd_layout
//        .leftSpaceToView(cell,0)
//        .topSpaceToView(nameLabel,10)
//        .bottomSpaceToView(cell,0)
//        .rightSpaceToView(cell,0);
//        if (ScreenWidth<375) {
//            bgScroview.contentSize=CGSizeMake(375, 0);
//        }
//        
//    }
//    
    
    
    return cell;
}
#pragma mark --创建3个button
-(void)CreatButtonImage:(UIScrollView*)bgview TableViewCell:(UITableViewCell*)cell{
    NSArray * arr=@[@"fabu_pic11",@"fabu_pic22",@"fabu_pic33"];
    NSArray * seleArr =@[@"",@"",@""];
    if (_messageDic) {
          seleArr =@[[_messageDic objectForKey:@"personal_id_card_frontImg"],[_messageDic objectForKey:@"personal_id_card_backImg"],[_messageDic objectForKey:@"personal_id_card_inhandImg"]];
    }
   
    for (int i =0; i<arr.count; i++) {
        UIButton * btn =[UIButton buttonWithType:UIButtonTypeCustom];
         [btn setBackgroundImageForState:0 withURL:[NSURL URLWithString:seleArr[i]] placeholderImage:[UIImage imageNamed:arr[i]]];
        [bgview sd_addSubviews:@[btn]];
        btn.tag=i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.sd_layout
        .leftSpaceToView(bgview,15+(6+111)*i)
        .topSpaceToView(bgview,15)
        .widthIs(222/2)
        .heightIs(208/2);
    }
}

-(void)btnClick:(UIButton*)btn{
    _lastBtn=btn;
    [self xuanzeImageBtn];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return 50;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * bgView =[UIView new];
     bgView.backgroundColor=BG_COLOR;
    NSArray * image1=@[@"rz_lb",@"rz_lb1"];
    UIImageView * imageview =[[UIImageView alloc]init];
    imageview.image=[UIImage imageNamed:image1[section]];
    [bgView sd_addSubviews:@[imageview]];
    imageview.sd_layout
    .leftSpaceToView(bgView,0)
    .centerYEqualToView(bgView)
    .rightSpaceToView(bgView,0)
    .heightIs(40);
    
    
    
    return bgView;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section==0) {
//        XiuGaiVC * vc =[XiuGaiVC new];
//        vc.indexrow=indexPath.row;
//        vc.tagg=@"1";
//        vc.messageBlock=^(NSString*name){
//            if (indexPath.row==0) {
//                _nameText=name;
//            }else{
//                _phoneText=name;
//            }
//            [_tableView reloadData];
//        };
//        [self.navigationController pushViewController:vc animated:YES];
//    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1) {
        return 180;
    }else{
        return 44;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
    imagePicker.view.tag=_lastBtn.tag;
    imagePicker.delegate = self;
    imagePicker.sourceType=UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    imagePicker.allowsEditing=YES;
    imagePicker.navigationController.navigationBar.barTintColor = [UIColor redColor];
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    NSLog(@"输出%lu",picker.view.tag);
//    if (picker.view.tag==0) {
//        _image1=image;
//    }else if (picker.view.tag==1){
//         _image2=image;
//    }else{
//         _image3=image;
//    }
    [self upDataFuWuQiWithAddress:image];
    [_lastBtn setBackgroundImage:image forState:0];
    [self dismissViewControllerAnimated:YES completion:nil];
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

-(void)upDataImage:(NSString*)url{
    NSLog(@">>>_lastTag=%lu",_lastBtn.tag);
    NSArray * arrKey=@[@"personal_id_card_frontImg",@"personal_id_card_backImg",@"personal_id_card_inhandImg"];
    NSDictionary * dicc =@{@"fieldName":arrKey[_lastBtn.tag],@"fieldValue":url};;
    NSArray * arr =@[dicc];
    [LCProgressHUD showMessage:@"正在上传"];
    [Engine xiuGaiShiMingRenZhengMessageJsonStr:[ToolClass getJsonStringFromObject:arr] success:^(NSDictionary *dic) {
        [LCProgressHUD showMessage:[dic objectForKey:@"msg"]];
        NSString * code =[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            NSDictionary * dicc =[dic objectForKey:@"content"];
            NSMutableDictionary * dicAr = [ToolClass isDictionary:dicc];
            [ToolClass savePlist:dicAr name:@"shiMingInfo"];
        }
        
    } error:^(NSError *error) {
        
    }];
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

-(NSString*)stringValue:(NSString*)str1 Sting:(NSString*)str2{
    if (str1 && ![str1 isEqualToString:@""]) {
        return str1;
    }else{
        return str2;
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag==1) {
        _nameText=textField.text;
    }else if (textField.tag==2){
        _phoneText=textField.text;
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

@end
