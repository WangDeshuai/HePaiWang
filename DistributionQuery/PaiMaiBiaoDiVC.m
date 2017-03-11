//
//  PaiMaiBiaoDiVC.m
//  DistributionQuery
//
//  Created by Macx on 16/11/21.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "PaiMaiBiaoDiVC.h"
#import "PaiMaiBiaoDiCell.h"
#import "PaiMaiBiaoDiXiangQingVC.h"
#import "LeftMyAdressCell.h"
#import "RightMyAddressCell.h"
#import "ShengCityModel.h"
#import "PaiMaiBiaoDiModel.h"
@interface PaiMaiBiaoDiVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)UIButton * lastBtn;
@property(nonatomic,strong)UIButton * bgview;
@property(nonatomic,assign)NSInteger btntag;//用来区分左右按钮
@property(nonatomic,strong)UITableView*leftTabelView;
@property(nonatomic,strong)UITableView*rightTabelView;
@property(nonatomic,strong)UIButton * button1;
@property(nonatomic,strong)UIButton * button2;
@property(nonatomic,strong)UIButton * button3;
@property(nonatomic,strong)NSMutableArray * shengArr;
@property(nonatomic,strong)NSMutableArray * cityArr;
@property(nonatomic,strong)NSMutableArray * biaoDiArr;//标的分类
@property(nonatomic,strong)NSMutableArray * paiMaiStypeArr;//拍卖状态
@property(nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic, strong) MJRefreshComponent *myRefreshView;
@property(nonatomic,assign)int AAA;
@property(nonatomic,copy)NSString * biaoDiFenLeiText;//记录分类
@property(nonatomic,copy)NSString * citycode;//记录城市
@property(nonatomic,copy)NSString * shengcode;//记录城市
@property(nonatomic,copy)NSString * paiMaiStyleText;//拍卖状态
@property(nonatomic,copy)NSString * shengName;
@end

@implementation PaiMaiBiaoDiVC


-(void)viewWillAppear:(BOOL)animated{
    if (_searStr==nil || [_searStr isEqualToString:@""]) {
        
    }else{
       // [self getInterDataPage:1 Search:_searStr BiaoDiFenLeiStyle:@"" shengCode:@"" CityCode:@"" PaiMaiStyle:@""];
        self.textHomeField.text=_searStr;
    }
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   // self.title=@"拍卖标的";
    UIButton * logoBtn2 =[UIButton buttonWithType:UIButtonTypeCustom];
    logoBtn2.frame=CGRectMake(0, 0, 76/2, 44/2);
    [logoBtn2 setImage:[UIImage imageNamed:@"liebiao_phone"] forState:0];
    UIBarButtonItem *leftBtn2 =[[UIBarButtonItem alloc]initWithCustomView:logoBtn2];
     self.navigationItem.rightBarButtonItems=@[leftBtn2];
    
    self.textHomeField.hidden=NO;
    self.textHomeField.delegate=self;
//    UIButton * searchBtn =[UIButton buttonWithType:UIButtonTypeCustom];
//    searchBtn.frame=CGRectMake(0, -10, 489/2, 65/2);
//    [searchBtn setBackgroundImage:[UIImage imageNamed:@"search-1"] forState:0];//489   65
//    [searchBtn setTitle:@"搜索标的物" forState:0];
//    [searchBtn setTitleColor:[UIColor lightGrayColor] forState:0];
//    searchBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
//    searchBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 30, 0, 0);
//    searchBtn.titleLabel.font=[UIFont systemFontOfSize:13];
//    UIBarButtonItem *leftBtn3 =[[UIBarButtonItem alloc]initWithCustomView:searchBtn];
  
    [self CreatTableView];
    [self CreatButton];//发布信息
    NSMutableArray* titleArr =[[NSMutableArray alloc]initWithObjects:@"标的分类",@"所在地区",@"拍卖状态", nil];
    _bgview=[[UIButton alloc]init];
    _bgview.frame=CGRectMake(0, 0, ScreenWidth, ScreenHeight-64);
    _bgview.backgroundColor=[UIColor blackColor];
    [_bgview addTarget:self action:@selector(bgViewBtn) forControlEvents:UIControlEventTouchUpInside];
    _bgview.alpha=.5;
    _shengArr=[NSMutableArray new];
    _cityArr=[NSMutableArray new];
    _dataArray=[NSMutableArray new];
    _biaoDiArr=[NSMutableArray new];
    _paiMaiStypeArr=[NSMutableArray new];
    [self CreatBtnTitle:titleArr];
    [self shuChu];
}
#pragma mark --灰色按钮点击取消
-(void)bgViewBtn{
    [self dissmiss];
    _button1.selected=NO;
    _button2.selected=NO;
    _button3.selected=NO;
}
#pragma mark --创建下拉的Button
-(void)CreatBtnTitle:(NSMutableArray*)arr{
    CGFloat k =(ScreenWidth)/arr.count;///3-20;
    CGFloat g =45;
    
    for (int i = 0; i<arr.count; i++) {
        UIButton *  menuBtn  =[UIButton buttonWithType:UIButtonTypeCustom];
        [self.view sd_addSubviews:@[menuBtn]];
        menuBtn.sd_layout
        .leftSpaceToView(self.view,k*i)
        .topSpaceToView(self.view,0)
        .widthIs(k)
        .heightIs(g);
        menuBtn.backgroundColor=[UIColor whiteColor];
        [menuBtn setTitleColor:[UIColor blackColor] forState:0];
        menuBtn.titleLabel.font=[UIFont systemFontOfSize:15];
        menuBtn.tag=i;
        [menuBtn setImage:[UIImage imageNamed:@"xia123"] forState:UIControlStateNormal];
        [menuBtn addTarget:self action:@selector(butTitleClink:) forControlEvents:UIControlEventTouchUpInside];
        [menuBtn setTitle:arr[i] forState:0];
        [menuBtn setImage:[UIImage imageNamed:@"shang123"] forState:UIControlStateSelected];
        [menuBtn setImageEdgeInsets:UIEdgeInsetsMake(0,k-20, 0, 0)];
        [menuBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
        [menuBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        
    }
    
    
}
#pragma mark --topbutton点击状态
-(void)butTitleClink:(UIButton*)btn{
    btn.selected=!btn.selected;
    _btntag=btn.tag;
    if (btn.tag==0) {
        //点击的是第一个
        if (btn.selected==YES) {
             [self huoQuBiaoDiStype];//调用数据获取标的分类
            [self xianShiBtn];
            _button2.selected=NO;
            _button3.selected=NO;
             [self CreatRightTableView:ScreenWidth Xzhou:0 Gzhou:220];
        }else{
            [self dissmiss];
        }
        
        _button1=btn;
        
    }else if (btn.tag==1){
        //第二个按钮(所在地区)
        if (btn.selected==YES) {
            [self huoQuShengFen];//调用数据获取省份
             [self xianShiBtn];
            _button1.selected=NO;
            _button3.selected=NO;
            [self CreatLeftTableVeiw];
        }else{
            [self dissmiss];
        }
        _button2=btn;
    }else{
        //第三个按钮
        if (btn.selected==YES) {
            [self paiMaiStyle];
            [self xianShiBtn];
            _button2.selected=NO;
            _button1.selected=NO;
             [self CreatRightTableView:ScreenWidth Xzhou:0 Gzhou:220];
        }else{
            [self dissmiss];
        }
        _button3=btn;
    }
}

#pragma mark --获取所有省份
-(void)huoQuShengFen{
     [_shengArr removeAllObjects];
    [Engine huoQuAllShengFensuccess:^(NSDictionary *dic) {
        NSString * item1 =[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
        if ([item1 isEqualToString:@"1"]) {
            NSArray * arr =[dic objectForKey:@"content"];
            for (NSDictionary * dicc in arr)
            {
                ShengCityModel * model =[[ShengCityModel alloc]initWithShengDic:dicc];
                [_shengArr addObject:model];
            }
            
            [_leftTabelView reloadData];
        }else{
            [LCProgressHUD showMessage:[dic objectForKey:@"msg"]];
        }

    } error:^(NSError *error) {
        
    }];
}
#pragma mark --获取标的分类
-(void)huoQuBiaoDiStype{
    //_cityArr是右边表的数组
    [_cityArr removeAllObjects];
    [Engine biaoDiStypesuccess:^(NSDictionary *dic) {
        NSString * code =[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            NSArray * arr =[dic objectForKey:@"content"];
            for (NSDictionary * dicc in arr) {
                ShengCityModel * md =[[ShengCityModel alloc]initWithBiaoDiDic:dicc];
                [_cityArr addObject:md];
            }
            [_rightTabelView reloadData];
        }else{
            [LCProgressHUD showMessage:[dic objectForKey:@"msg"]];
        }
    } error:^(NSError *error) {
        
    }];
}

#pragma mark --获取拍卖状态
-(void)paiMaiStyle{
     [_cityArr removeAllObjects];
    //[_cityArr addObject:@"不限"];
     [_cityArr addObject:@"正在进行"];
     [_cityArr addObject:@"即将开始"];
     [_cityArr addObject:@"5天内"];
     [_cityArr addObject:@"10天内"];
     [_cityArr addObject:@"15天内"];
     [_cityArr addObject:@"已结束"];
     [_rightTabelView reloadData];

}

#pragma mark --获取网络数据
-(void)getInterDataPage:(int)page Search:(NSString*)sear BiaoDiFenLeiStyle:(NSString*)fenlei shengCode:(NSString*)shengcode CityCode:(NSString*)citycode PaiMaiStyle:(NSString*)style{
//  BiaoDiStyle 标的的分类 Staus拍卖状态
    [LCProgressHUD showMessage:@"请稍后..."];
    [Engine firstPaiMaiBiaoDiViewSearchStr:sear BiaoDiStyle:fenlei ProvCode:shengcode CityCode:citycode Staus:style PageSize:@"10" PageIndex:[NSString stringWithFormat:@"%d",page] success:^(NSDictionary *dic) {
        NSString * code =[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            [LCProgressHUD hide];
            NSArray * contentAr =[dic objectForKey:@"content"];
            NSMutableArray * array2 =[NSMutableArray new];
            for (NSDictionary * dicc in contentAr) {
                PaiMaiBiaoDiModel * model =[[PaiMaiBiaoDiModel alloc]initWithBiaoDiDic:dicc];
                [array2 addObject:model];
            }
            if (self.myRefreshView ==_tableView.header) {
                _dataArray=array2;
                _tableView.footer.hidden=_dataArray.count==0?YES:NO;
            }else if (self.myRefreshView == _tableView.footer){
                [_dataArray addObjectsFromArray:array2];
            }
            [_tableView reloadData];
            [_myRefreshView  endRefreshing];
            
        }else{
            [LCProgressHUD showMessage:[dic objectForKey:@"msg"]];
        }
    } error:^(NSError *error) {
         [LCProgressHUD hide];
    }];
}




#pragma mark --创建发布信息按钮
-(void)CreatButton{
    UIButton * fabu =[UIButton buttonWithType:UIButtonTypeCustom];
    fabu.backgroundColor=[UIColor whiteColor];
    _lastBtn=fabu;
    fabu.frame=CGRectMake(0, ScreenHeight-55-64, ScreenWidth, 55);
    [fabu setImage:[UIImage imageNamed:@"liebiaonav_bottom "] forState:0];
    [self.view addSubview:fabu];
   
}
#pragma mark --创建左边表格
-(void)CreatLeftTableVeiw{
    
    _leftTabelView=[[UITableView alloc]initWithFrame:CGRectMake(0, 51, ScreenWidth/2.5, ScreenHeight/1.5) style:UITableViewStylePlain];
    _leftTabelView.dataSource=self;
    _leftTabelView.delegate=self;
    _leftTabelView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_leftTabelView];
    
}
#pragma mark --创建第二个表格
-(void)CreatRightTableView:(CGFloat)kuan Xzhou:(CGFloat)x Gzhou:(CGFloat)g{
    [_rightTabelView removeFromSuperview];
    _rightTabelView=nil;
    if (_rightTabelView==nil) {
        _rightTabelView=[[UITableView alloc]initWithFrame:CGRectMake(x, 51,kuan, g) style:UITableViewStylePlain];
        _rightTabelView.backgroundColor=BG_COLOR;
        _rightTabelView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _rightTabelView.dataSource=self;
        _rightTabelView.delegate=self;
        [self.view addSubview:_rightTabelView];
    }
    
}


#pragma mark --创建主表格
-(void)CreatTableView{
    if (!_tableView) {
     _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,55, ScreenWidth, ScreenHeight-64-55) style:UITableViewStylePlain];
    }
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.backgroundColor=BG_COLOR;
    _tableView.tableFooterView=[UIView new];
    [self.view addSubview:_tableView];
    __weak typeof (self) weakSelf =self;
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.myRefreshView = weakSelf.tableView.header;
        _AAA=1;
        /*
         NSLog(@"拍卖%@",[ToolClass isString:_biaoDiFenLeiText]);
         NSLog(@"省%@",[ToolClass isString:_shengcode]);
         NSLog(@"市%@",[ToolClass isString:_citycode]);
         NSLog(@"状态%@",[ToolClass isString:_paiMaiStyleText]);
         */
         [self getInterDataPage:_AAA Search:[ToolClass isString:_searStr] BiaoDiFenLeiStyle:[ToolClass isString:_biaoDiFenLeiText] shengCode:[ToolClass isString:_shengcode] CityCode:[ToolClass isString:_citycode] PaiMaiStyle:[ToolClass isString:_paiMaiStyleText]];
    }];
    
    [_tableView.header beginRefreshing];
    //..上拉刷新
    _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.myRefreshView = weakSelf.tableView.footer;
        _AAA=_AAA+1;
        [self getInterDataPage:_AAA Search:@"" BiaoDiFenLeiStyle:[ToolClass isString:_biaoDiFenLeiText] shengCode:[ToolClass isString:_shengcode] CityCode:[ToolClass isString:_citycode] PaiMaiStyle:[ToolClass isString:_paiMaiStyleText]];
    }];
    
    _tableView.footer.hidden = YES;
   
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==_leftTabelView) {
        return _shengArr.count+1;
    }else if (tableView==_rightTabelView){
        return _cityArr.count+1;
    }else{
        return _dataArray.count;
   
    }
  }
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView==_leftTabelView) {
        LeftMyAdressCell * cell1 =[LeftMyAdressCell cellWithTableView:tableView];
        cell1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (_btntag==0) {
           //标的的分类
        }else if (_btntag==1){
            //所在地区
            if (indexPath.row==0) {
                cell1.name=@"不限";
            }else{
                ShengCityModel * md =_shengArr[indexPath.row-1];
                cell1.name=md.shengName;
 
            }
            
        }else if (_btntag==2){
            //拍卖状态
        }
        
        
        return cell1;
    }else if (tableView==_rightTabelView){
        RightMyAddressCell * cell2 =[RightMyAddressCell cellWithTableView:tableView];
        if (_btntag==0) {
            //标的的分类
            if (indexPath.row==0) {
                cell2.name=@"不限";
            }else{
                ShengCityModel * md =_cityArr[indexPath.row-1];
                cell2.name=md.biaoDiName;
            }
            
        }else if (_btntag==1){
            //所在地区
            if (indexPath.row==0) {
                cell2.name=@"不限";
            }else{
                ShengCityModel * md =_cityArr[indexPath.row-1];
                cell2.name=md.cityName;
            }
            
        }else if (_btntag==2){
            //拍卖状态
            if (indexPath.row==0) {
                cell2.name=@"不限";
            }else{
                 cell2.name=_cityArr[indexPath.row-1];
            }
           
        }
        return cell2;
    }else{
        NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld", (long)[indexPath section], (long)[indexPath row]];
        
        PaiMaiBiaoDiCell * cell =[PaiMaiBiaoDiCell cellWithTableView:tableView CellID:CellIdentifier];
        PaiMaiBiaoDiModel * md =_dataArray[indexPath.row];
        cell.twoModel=md;
        return cell;
    }
    
    
   

    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==_leftTabelView) {
        [self CreatRightTableView:ScreenWidth-ScreenWidth/2.5 Xzhou:ScreenWidth/2.5 Gzhou:ScreenHeight/1.5];
        if (_btntag==0) {
            //标的分类
        }else if (_btntag==1){
            //地区
            if (indexPath.row==0) {
                //点击左边的不限
                 [_cityArr removeAllObjects];
                _shengcode=@"";
                _shengName=@"所在地区";
            }else{
                ShengCityModel * mdd =_shengArr[indexPath.row-1];
                _shengcode=mdd.shengCode;
                _shengName=mdd.shengName;
                [self getCityWithShengCode:mdd];
            }
           
        }else{
            //拍卖状态
        }
        
    }else if (tableView==_rightTabelView){
        if (_btntag==0) {
            //标的分类
            if (indexPath.row==0) {
                _button1.selected=NO;
                [_button1 setTitle:@"标的分类" forState:0];
                _button1.titleLabel.font=[UIFont systemFontOfSize:14];
                _biaoDiFenLeiText=@"";

            }else{
                ShengCityModel * mdd =_cityArr[indexPath.row-1];
                _button1.selected=NO;
                [_button1 setTitle:mdd.biaoDiName forState:0];
                _button1.titleLabel.font=[UIFont systemFontOfSize:14];
                _biaoDiFenLeiText=mdd.biaoDiCode;
            }
            [_dataArray removeAllObjects];
            [_tableView reloadData];
            [self getInterDataPage:_AAA Search:@"" BiaoDiFenLeiStyle:[ToolClass isString:_biaoDiFenLeiText] shengCode:[ToolClass isString:_shengcode] CityCode:[ToolClass isString:_citycode] PaiMaiStyle:[ToolClass isString:_paiMaiStyleText]];
            [self shuChu];
        }else if (_btntag==1){
            //地区
            if (indexPath.row==0) {
                _button2.selected=NO;
                [_button2 setTitle:_shengName forState:0];
                _button2.titleLabel.font=[UIFont systemFontOfSize:14];
                _citycode=@"";
            }else{
                ShengCityModel * mdd =_cityArr[indexPath.row-1];
                _button2.selected=NO;
                [_button2 setTitle:mdd.cityName forState:0];
                _button2.titleLabel.font=[UIFont systemFontOfSize:14];
                _citycode=mdd.cityCode;
                _shengcode=mdd.cityShengCode;
            }
            [_dataArray removeAllObjects];
            [_tableView reloadData];
            [self getInterDataPage:_AAA Search:@"" BiaoDiFenLeiStyle:[ToolClass isString:_biaoDiFenLeiText] shengCode:[ToolClass isString:_shengcode] CityCode:[ToolClass isString:_citycode] PaiMaiStyle:[ToolClass isString:_paiMaiStyleText]];
           [self shuChu];
        }else{
            //拍卖状态
            if (indexPath.row==0) {
                _button3.selected=NO;
                [_button3 setTitle:@"拍卖状态" forState:0];
                _button3.titleLabel.font=[UIFont systemFontOfSize:14];
                _paiMaiStyleText=@"";
            }else{
                NSString * str =_cityArr[indexPath.row-1];
                _button3.selected=NO;
                [_button3 setTitle:str forState:0];
                _button3.titleLabel.font=[UIFont systemFontOfSize:14];
                _paiMaiStyleText=[self nsdicStyle:str];

            }
            [_dataArray removeAllObjects];
            [_tableView reloadData];
            [self getInterDataPage:_AAA Search:@"" BiaoDiFenLeiStyle:[ToolClass isString:_biaoDiFenLeiText] shengCode:[ToolClass isString:_shengcode] CityCode:[ToolClass isString:_citycode] PaiMaiStyle:[ToolClass isString:_paiMaiStyleText]];
           [self shuChu];
        }
        
         [self dissmiss];
    }else{
        PaiMaiBiaoDiXiangQingVC * vc =[PaiMaiBiaoDiXiangQingVC new];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
   
}

#pragma mark --根据省获取城市
-(void)getCityWithShengCode:(ShengCityModel*)mdd{
     [_cityArr removeAllObjects];
    [Engine huoQuWithShengGetCityShengCode:mdd.shengCode success:^(NSDictionary *dic) {
        NSString * code =[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            NSArray * contentArr =[dic objectForKey:@"content"];
            for (NSDictionary * dicc in contentArr) {
                ShengCityModel * md =[[ShengCityModel alloc]initWithCityDic:dicc];
                [_cityArr addObject:md];
            }
            [_rightTabelView reloadData];
        }else{
            [LCProgressHUD showMessage:[dic objectForKey:@"msg"]];
        }
    } error:^(NSError *error) {
        
    }];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_tableView) {
        return 120;
    }else{
        return 44;
    }
    
   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)shuChu{
    
    NSLog(@"拍卖%@",[ToolClass isString:_biaoDiFenLeiText]);
    NSLog(@"省%@",[ToolClass isString:_shengcode]);
    NSLog(@"市%@",[ToolClass isString:_citycode]);
    NSLog(@"状态%@",[ToolClass isString:_paiMaiStyleText]);
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)dissmiss{
    _tableView.scrollEnabled=YES;
     _lastBtn.hidden=NO;
    [_bgview removeFromSuperview];
    [_leftTabelView removeFromSuperview];
    [_rightTabelView removeFromSuperview];
}
-(void)xianShiBtn{
    _tableView.scrollEnabled=NO;
    [_tableView setContentOffset:CGPointZero animated:NO];
    [_tableView addSubview:_bgview];
    _lastBtn.hidden=YES;
    [_rightTabelView removeFromSuperview];
    [_leftTabelView removeFromSuperview];
}
-(NSString*)nsdicStyle:(NSString*)str{
    NSMutableDictionary * dicc =[NSMutableDictionary new];
     [dicc setObject:@"1" forKey:@"正在进行"];
     [dicc setObject:@"2" forKey:@"即将开始"];
     [dicc setObject:@"3" forKey:@"5天内"];
     [dicc setObject:@"4" forKey:@"10天内"];
     [dicc setObject:@"5" forKey:@"15天内"];
     [dicc setObject:@"6" forKey:@"已结束"];
    
    NSString * strID =[dicc objectForKey:str];
    return strID;
}
#pragma mark --点击了搜索事件
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];//关闭键盘
    NSLog(@"点击了搜索十几号");
     [self getInterDataPage:_AAA Search:textField.text BiaoDiFenLeiStyle:@"" shengCode:@"" CityCode:@"" PaiMaiStyle:@""];
    //[self getMainTableViewDataPage:_AAA Search:textField.text LeiXing:@"" proCode:@"" CityCode:@"" TimeStr:@""];
    
    return YES;
}
@end
