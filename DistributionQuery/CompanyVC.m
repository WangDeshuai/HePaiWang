//
//  CompanyVC.m
//  DistributionQuery
//
//  Created by Macx on 17/3/4.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "CompanyVC.h"
#import "XiuGaiVC.h"
@interface CompanyVC ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)UIButton * lastBtn;
@property(nonatomic,strong)NSMutableArray * nameArray;
@property(nonatomic,copy)NSString * qiYeNameText;
@property(nonatomic,copy)NSString * peopleText;
@property(nonatomic,copy)NSString *peopleCardText;
@property(nonatomic,copy)NSString * daiLiNameText;
@property(nonatomic,copy)NSString * phoneText;
@property(nonatomic,strong)NSMutableDictionary * messageDic;
@end

@implementation CompanyVC
-(void)viewWillAppear:(BOOL)animated{
    NSMutableDictionary * messageDic =[ToolClass duquPlistWenJianPlistName:@"shiMingInfo"];
    _messageDic=messageDic;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self CreatData];
    [self CreatTabelView];
}
#pragma mark --创建数据源
-(void)CreatData{
    NSArray * arr1 =@[@"企业名称",@"法人名称",@"法人身份证号",@"代理人姓名",@"手机号"];
    NSArray * arr2 =@[@"身份证图片"];
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
    UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        UILabel * nameLabel =[UILabel new];
        nameLabel.tag=1;
        UILabel * dataLabel =[UILabel new];
        dataLabel.tag=2;
        UIScrollView * bgScroview =[UIScrollView new];
        bgScroview.bounces=NO;
        bgScroview.tag=3;
        bgScroview.hidden=YES;
        [cell sd_addSubviews:@[nameLabel,dataLabel,bgScroview]];
        [self CreatButtonImage:bgScroview TableViewCell:cell];
    }
     cell.selectionStyle=UITableViewCellSelectionStyleNone;
    UILabel * nameLabel =[cell viewWithTag:1];
    UILabel * dataLabel =[cell viewWithTag:2];
    dataLabel.font=[UIFont systemFontOfSize:15];
    dataLabel.alpha=.6;
    dataLabel.textAlignment=2;
    UIScrollView * bgScroview=[cell viewWithTag:3];
    nameLabel.font=[UIFont systemFontOfSize:15];
    nameLabel.alpha=.6;
    nameLabel.text=_nameArray[indexPath.section][indexPath.row];
    nameLabel.sd_layout
    .leftSpaceToView(cell,15)
    .topSpaceToView(cell,11)
    .heightIs(20);
    [nameLabel setSingleLineAutoResizeWithMaxWidth:120];
    
    dataLabel.sd_layout
    .rightSpaceToView(cell,30)
    .leftSpaceToView(nameLabel,10)
    .centerYEqualToView(cell)
    .heightIs(20);
    if (indexPath.section==0) {
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.row==0) {
            //企业名称
            if (_messageDic) {
                dataLabel.text=[self stringHouMianText:_qiYeNameText InternetText:[_messageDic objectForKey:@"enterprise_name"]];
            }
            
        }else if (indexPath.row==1){
            //法人名称
            if (_messageDic) {
                 dataLabel.text=[self stringHouMianText:_peopleText InternetText:[_messageDic objectForKey:@"enterprise_legal_person_name"]];
            }
            
        }else if (indexPath.row==2){
            //法人身份证号
            if (_messageDic) {
                dataLabel.text=[self stringHouMianText:_peopleCardText InternetText:[_messageDic objectForKey:@"enterprise_legal_person_id_card"]];
            }
            
        }else if (indexPath.row==3){
            //代理人姓名
            if (_messageDic) {
                 dataLabel.text=[self stringHouMianText:_daiLiNameText InternetText:[_messageDic objectForKey:@"enterprise_agent_name"]];
            }
           
        }else if (indexPath.row==4){
            //手机号
            if (_messageDic) {
               dataLabel.text=[self stringHouMianText:_phoneText InternetText:[_messageDic objectForKey:@"enterprise_connect_tel"]];
            }
            
        }
    }
    else if (indexPath.section==1) {
        bgScroview.hidden=NO;
        bgScroview.sd_layout
        .leftSpaceToView(cell,0)
        .topSpaceToView(nameLabel,10)
        .bottomSpaceToView(cell,0)
        .rightSpaceToView(cell,0);
        if (ScreenWidth<356) {
            bgScroview.contentSize=CGSizeMake(356, 0);
        }
        
    }
    return cell;
}
#pragma mark --创建3个button
-(void)CreatButtonImage:(UIScrollView*)bgview TableViewCell:(UITableViewCell*)cell{
    NSArray * arr=@[@"fabu_pic",@"fabu_pic5",@"fabu_pic6",@"fabu_pic7"];
    
    NSArray * seleArr=@[@"",@"",@"",@""];
    if (_messageDic) {
         seleArr =@[[_messageDic objectForKey:@"enterprise_license_img"],[_messageDic objectForKey:@"enterprise_legal_id_card_frontImg"],[_messageDic objectForKey:@"enterprise_legal_id_card_backImg"],[_messageDic objectForKey:@"enterprise_agent_id_card_inhandImg"]];
    }
    
    for (int i =0; i<arr.count; i++) {
        UIButton * btn =[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImageForState:0 withURL:[NSURL URLWithString:seleArr[i]] placeholderImage:[UIImage imageNamed:arr[i]]];
        btn.tag=i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgview sd_addSubviews:@[btn]];
        btn.sd_layout
        .leftSpaceToView(bgview,15+(10+77)*i)
        .topSpaceToView(bgview,15)
        .widthIs(154/2)
        .heightIs(208/2);
    }
}
-(void)btnClick:(UIButton*)btn{
    _lastBtn=btn;
    [self headImageClick];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        XiuGaiVC * vc =[XiuGaiVC new];
        vc.indexrow=indexPath.row;
        vc.tagg=@"2";
        vc.messageBlock=^(NSString*name){
            if (indexPath.row==0) {
                _qiYeNameText=name;
            }else if(indexPath.row==1){
                _peopleText=name;
            }else if (indexPath.row==2){
                _peopleCardText=name;
            }else if (indexPath.row==3){
                _daiLiNameText=name;
            }else{
                _phoneText=name;
            }
            [_tableView reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}





-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 50;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * bgView =[UIView new];
    bgView.backgroundColor=BG_COLOR;
    NSArray * image1=@[@"rz_tishii",@"rz_lb1"];
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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1) {
        return 180;
    }else{
        return 44;
    }
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
    NSArray * arrKey=@[@"enterprise_license_img",@"enterprise_legal_id_card_frontImg",@"enterprise_legal_id_card_backImg",@"enterprise_agent_id_card_inhandImg"];
    NSDictionary * dicc =@{@"fieldName":arrKey[_lastBtn.tag],@"fieldValue":url};;
    NSArray * arr =@[dicc];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
