//
//  XiuGaiMessageVC.m
//  DistributionQuery
//
//  Created by Macx on 17/3/2.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "XiuGaiMessageVC.h"
#import "LeftMyAdressCell.h"
#import "RightMyAddressCell.h"
#import "CenterableViewCell.h"
#import "ShengCityModel.h"
@interface XiuGaiMessageVC ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate>
@property(nonatomic,strong)UITextField * textfield;
@property(nonatomic,strong)NSMutableArray * keyArray;
@property(nonatomic,strong)UITableView * leftTableView;
@property(nonatomic,strong)UITableView * centerTableView;
@property(nonatomic,strong)UITableView * rightTableView;
@property(nonatomic,strong)NSMutableArray * leftArr;
@property(nonatomic,strong)NSMutableArray * centerArr;
@property(nonatomic,strong)NSMutableArray * rightArr;
@property(nonatomic,copy)NSString * shengText;
@property(nonatomic,copy)NSString * cityText;

@end

@implementation XiuGaiMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"修改个人信息";
    //用户名、联系电话、邮箱、右边、详细地址
    _keyArray=[[NSMutableArray alloc]initWithObjects:@"user_name",@"connect_tel",@"mailbox",@"postcode",@"detailed_addr", nil];
     _leftArr=[NSMutableArray new];
    _centerArr=[NSMutableArray new];
    _rightArr=[NSMutableArray new];
   
    if (_indexrow==5) {
        [self huoQuAllSheng];
        [self CreatLeftTableView];
    }else{
         [self CreatRigthBtn];
       [self CreatTextField];
    }
   
    
}
#pragma mark --创建textField
-(void)CreatTextField{
    _textfield=[[UITextField alloc]init];
    _textfield.placeholder=@"未填写";
    _textfield.backgroundColor=[UIColor whiteColor];
    _textfield.sd_cornerRadius=@(5);
    _textfield.font=[UIFont systemFontOfSize:15];
    [self.view sd_addSubviews:@[_textfield]];
    _textfield.sd_layout
    .leftSpaceToView(self.view,5)
    .rightSpaceToView(self.view,5)
    .topSpaceToView(self.view,20)
    .heightIs(35);
}
#pragma mark --创建右按钮
-(void)CreatRigthBtn{
    UIButton *fabu=[UIButton buttonWithType:UIButtonTypeCustom];
    [fabu setTitle:@"保存" forState:0];
    fabu.titleLabel.font=[UIFont systemFontOfSize:15];
    [fabu setTitleColor:[UIColor whiteColor] forState:0];
    fabu.frame=CGRectMake(0,0, 70, 20);
    [fabu addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightBtn =[[UIBarButtonItem alloc]initWithCustomView:fabu];
    self.navigationItem.rightBarButtonItem=rightBtn;
}
-(void)save{
    NSMutableArray * arr =[NSMutableArray new];
    NSMutableDictionary * dicc =[NSMutableDictionary new];
    [dicc setObject:_textfield.text forKey:@"fieldValue"];
    [dicc setObject:_keyArray[_indexrow] forKey:@"fieldName"];
    [arr addObject:dicc];
    NSLog(@"输出%@",[ToolClass getJsonStringFromObject:arr]);
    [Engine modificationMyMessageKeyDicStr:[ToolClass getJsonStringFromObject:arr] success:^(NSDictionary *dic) {
        [LCProgressHUD showMessage:[dic objectForKey:@"msg"]];
        NSString * code =[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            NSDictionary * dicc =[dic objectForKey:@"content"];
            NSMutableDictionary * dicAr = [ToolClass isDictionary:dicc];
            [ToolClass savePlist:dicAr name:@"baseInfo"];
            self.nameBlock(_textfield.text);
            [self.navigationController popViewControllerAnimated:YES];
        }
    } error:^(NSError *error) {
        
    }];
}

#pragma mark --左边创建表
-(void)CreatLeftTableView{
    
    _leftTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth/3, ScreenHeight-64) style:UITableViewStylePlain];
    _leftTableView.dataSource=self;
    _leftTableView.delegate=self;
    _leftTableView.tableFooterView=[UIView new];
    _leftTableView.backgroundColor=BG_COLOR;
    [self.view addSubview:_leftTableView];
    
}
#pragma mark --创建中间表格
-(void)CreatCenterTableView{
    [_centerTableView removeFromSuperview];
    _centerTableView=[[UITableView alloc]initWithFrame:CGRectMake(ScreenWidth/3, 0, ScreenWidth/3, ScreenHeight-64) style:UITableViewStylePlain];
    _centerTableView.dataSource=self;
    _centerTableView.delegate=self;
    _centerTableView.tableFooterView=[UIView new];
    _centerTableView.backgroundColor=BG_COLOR;

    [self.view addSubview:_centerTableView];
    
}
#pragma mark --创建右边表格
-(void)CreatRightTableView{
    
    [_rightTableView removeFromSuperview];
    _rightTableView=[[UITableView alloc]initWithFrame:CGRectMake(ScreenWidth/3*2, 0, ScreenWidth/3, ScreenHeight-64) style:UITableViewStylePlain];
    _rightTableView.dataSource=self;
    _rightTableView.delegate=self;
    _rightTableView.tableFooterView=[UIView new];
    _rightTableView.backgroundColor=BG_COLOR;
    [self.view addSubview:_rightTableView];
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==_leftTableView) {
        return _leftArr.count;
    }else if (tableView==_centerTableView){
        return _centerArr.count;
    }else{
        return _rightArr.count;
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_leftTableView) {
        LeftMyAdressCell * cell1 =[LeftMyAdressCell cellWithTableView:tableView];
        cell1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        ShengCityModel * md =_leftArr[indexPath.row];
        cell1.name=md.shengName;
        return cell1;
    }else if (tableView==_centerTableView){
        CenterableViewCell * cell2 =[CenterableViewCell cellWithTableView:tableView];
        cell2.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        ShengCityModel * md =_centerArr[indexPath.row];
        cell2.name=md.cityName;
        return cell2;
    }else{
        RightMyAddressCell * cell3 =[RightMyAddressCell cellWithTableView:tableView];
        cell3.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        ShengCityModel * md =_rightArr[indexPath.row];
        cell3.name=md.xianName;
        return cell3;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_leftTableView) {
        [_rightTableView removeFromSuperview];
         ShengCityModel * md =_leftArr[indexPath.row];
        _shengText=md.shengName;
        [self getCityWithShengCode:md];//调取数据
        [self CreatCenterTableView];
    }else if (tableView==_centerTableView){
        ShengCityModel * md =_centerArr[indexPath.row];
        [self getXianWithCityCode:md];
        _cityText=md.cityName;
        [self CreatRightTableView];
    }else{
        ShengCityModel * md =_rightArr[indexPath.row];
        NSMutableArray * arr =[NSMutableArray new];
        NSMutableDictionary * dic1 =[NSMutableDictionary new];
        [dic1 setObject:md.xianShengCode forKey:@"fieldValue"];
        [dic1 setObject:@"provcode" forKey:@"fieldName"];
        NSMutableDictionary * dic2 =[NSMutableDictionary new];
        [dic2 setObject:md.xianCityCode forKey:@"fieldValue"];
        [dic2 setObject:@"citycode" forKey:@"fieldName"];
        NSMutableDictionary * dic3 =[NSMutableDictionary new];
        [dic3 setObject:md.xianCode forKey:@"fieldValue"];
        [dic3 setObject:@"districtcode" forKey:@"fieldName"];
        [arr addObject:dic1];
        [arr addObject:dic2];
        [arr addObject:dic3];
        NSLog(@"输出%@",[ToolClass getJsonStringFromObject:arr]);
        NSString * str =[NSString stringWithFormat:@"%@-%@-%@",_shengText,_cityText,md.xianName];
        [Engine modificationMyMessageKeyDicStr:[ToolClass getJsonStringFromObject:arr] success:^(NSDictionary *dic) {
            [LCProgressHUD showMessage:[dic objectForKey:@"msg"]];
            NSString * code =[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
            if ([code isEqualToString:@"1"]) {
                NSDictionary * dicc =[dic objectForKey:@"content"];
                NSMutableDictionary * dicAr = [ToolClass isDictionary:dicc];
                [ToolClass savePlist:dicAr name:@"baseInfo"];
                self.nameBlock(str);
                [self.navigationController popViewControllerAnimated:YES];
            }
        } error:^(NSError *error) {
            
        }];
    }
}
#pragma mark --获取全国省份
-(void)huoQuAllSheng{
    [_leftArr removeAllObjects];
    [Engine huoQuAllShengFensuccess:^(NSDictionary *dic) {
        NSString * item1 =[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
        if ([item1 isEqualToString:@"1"]) {
            NSArray * arr =[dic objectForKey:@"content"];
            for (NSDictionary * dicc in arr)
            {
                ShengCityModel * model =[[ShengCityModel alloc]initWithShengDic:dicc];
                [_leftArr addObject:model];
            }
            
            [_leftTableView reloadData];
        }else{
            [LCProgressHUD showMessage:[dic objectForKey:@"msg"]];
        }

    } error:^(NSError *error) {
        
    }];
}
#pragma mark --根据省获取城市
-(void)getCityWithShengCode:(ShengCityModel*)mdd{
    [_centerArr removeAllObjects];
    [Engine huoQuWithShengGetCityShengCode:mdd.shengCode success:^(NSDictionary *dic) {
        NSString * code =[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            NSArray * contentArr =[dic objectForKey:@"content"];
            for (NSDictionary * dicc in contentArr) {
                ShengCityModel * md =[[ShengCityModel alloc]initWithCityDic:dicc];
                [_centerArr addObject:md];
            }
            [_centerTableView reloadData];
        }else{
            [LCProgressHUD showMessage:[dic objectForKey:@"msg"]];
        }
    } error:^(NSError *error) {
        
    }];
}

#pragma mark --根据市获取县
-(void)getXianWithCityCode:(ShengCityModel*)mdd{
    [_rightArr removeAllObjects];
    [Engine huoQuXianWithCityCode:mdd.cityCode success:^(NSDictionary *dic) {
        NSString * code =[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            NSArray * contentArr =[dic objectForKey:@"content"];
            for (NSDictionary * dicc in contentArr) {
                ShengCityModel * md =[[ShengCityModel alloc]initWithXianDic:dicc];
                [_rightArr addObject:md];
            }
            [_rightTableView reloadData];
        }else{
            [LCProgressHUD showMessage:[dic objectForKey:@"msg"]];
        }

    } error:^(NSError *error) {
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
