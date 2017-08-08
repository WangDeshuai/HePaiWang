//
//  PaiMaiGongGaoVC.m
//  DistributionQuery
//
//  Created by Macx on 16/11/23.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "PaiMaiGongGaoVC.h"
#import "PaiMaiGongGaoCell.h"
#import "PaiMaiGongGaoXiangQingVC.h"
#import "LeftMyAdressCell.h"
#import "RightMyAddressCell.h"
#import "ShengCityModel.h"
#import "PaiMaiGongGaoModel.h"
#import "ScanCodeVC.h"
@interface PaiMaiGongGaoVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property(nonatomic,strong)UITableView *tableView;
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
@property(nonatomic,copy)NSString * biaoDiFenLeiText;//记录分类
@property(nonatomic,copy)NSString * citycode;//记录城市
@property(nonatomic,copy)NSString * shengcode;//记录城市
@property(nonatomic,copy)NSString * paiMaiStyleText;//拍卖状态
@property(nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic, strong) MJRefreshComponent *myRefreshView;
@property(nonatomic,assign)int AAA;
@property(nonatomic,copy)NSString * shengName;
@end

@implementation PaiMaiGongGaoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _dataArray=[NSMutableArray new];
    [self CreatTopButton];
    [self CreatTabelView];
    if (_tagg==2) {
        //个人中心我参加的拍卖会
        self.title=@"我参加的拍卖会";
    }else{
        //首页进入
        UIButton * logoBtn2 =[UIButton buttonWithType:UIButtonTypeCustom];
        logoBtn2.frame=CGRectMake(0, 0, 76/2, 50);
        [logoBtn2 addTarget:self action:@selector(logoBtnClink) forControlEvents:UIControlEventTouchUpInside];
        [logoBtn2 setImage:[UIImage imageNamed:@"liebiao_phone"] forState:0];
        UIBarButtonItem *leftBtn2 =[[UIBarButtonItem alloc]initWithCustomView:logoBtn2];
         self.navigationItem.rightBarButtonItems=@[leftBtn2];
        
        self.textHomeField.hidden=NO;
        self.textHomeField.delegate=self;
        [self CreatButton];
    }
}

-(void)logoBtnClink{
    //查看联系方式
    UIAlertController * actionview=[UIAlertController alertControllerWithTitle:PHONE message:@"是否进行拨打" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action =[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [ToolClass tellPhone:PHONE];
    }];
    UIAlertAction * action2 =[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [actionview addAction:action];
    [actionview addAction:action2];
    [self presentViewController:actionview animated:YES completion:nil];
}
#pragma mark --top3button
-(void)CreatTopButton{
    NSMutableArray* titleArr =[[NSMutableArray alloc]initWithObjects:@"所标的物",@"所属地区",@"时间不限", nil];
    _bgview=[[UIButton alloc]init];
    _bgview.frame=CGRectMake(0, 0, ScreenWidth, ScreenHeight-64);
    _bgview.backgroundColor=[UIColor blackColor];
    [_bgview addTarget:self action:@selector(bgViewBtn) forControlEvents:UIControlEventTouchUpInside];
    _bgview.alpha=.5;
    _shengArr=[NSMutableArray new];
    _cityArr=[NSMutableArray new];
    [self CreatBtnTitle:titleArr];
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
    [_cityArr addObject:@"1天内"];
    [_cityArr addObject:@"3天内"];
    [_cityArr addObject:@"5天内"];
    [_cityArr addObject:@"7天内"];
    [_cityArr addObject:@"15天内"];
    [_rightTabelView reloadData];
    
}

#pragma mark --1获取主表内容从首页进入
-(void)getMainTableViewDataPage:(int)page Search:(NSString*)sear LeiXing:(NSString*)lx proCode:(NSString*)shengCode CityCode:(NSString*)code TimeStr:(NSString*)timeStr{
   // [LCProgressHUD showLoading:@"请稍后..."];
    [Engine upDataPaiMaiPublicViewSearchStr:sear BiaoDiLeiXing:lx ProvCode:shengCode CityCode:code BeginTime:timeStr Page:[NSString stringWithFormat:@"%d",page] PageSize:@"10" success:^(NSDictionary *dic) {
        //
        NSString * code =[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            NSArray * contentArr =[dic objectForKey:@"content"];
            NSMutableArray * array2 =[NSMutableArray new];
            [LCProgressHUD hide];
            for (NSDictionary * dicc in contentArr) {
                PaiMaiGongGaoModel * md =[[PaiMaiGongGaoModel alloc]initWithPaiMaiPublicDic:dicc];
                [array2 addObject:md];
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
        
    }];
}
#pragma mark --获取主表内容 从个人中心进入的
-(void)myCenterComeInDataPage:(int)page LeiXing:(NSString*)lex ShengCode:(NSString*)scode CityCode:(NSString*)ccode TimeStr:(NSString*)timestr{
   
    /*
     
     "user_id":22,				//用户id
     "auction_id":12,				//参加的拍卖会id
     "auction_name":"拍卖会1",			//拍卖会名称
     "auction_add_time":"2017-02-22 19:26:10",		//拍卖会添加时间(报名开始时间)
     "auction_begin_time":"2017-03-23 19:24:00",           //拍卖会开始时间(报名截止时间)
     "provname":"浙江省",				//所在省份名称
     "cityname":"温州市"

     */
    
    
    [Engine myCenterMyCanJiaPaiMaiHuiBiaoDiType:lex Page:[NSString stringWithFormat:@"%d",page] ShengCode:scode CityCode:ccode BeginTime:timestr  success:^(NSDictionary *dic) {
        //
        NSString * code =[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            [LCProgressHUD hide];
            NSArray * contentArr =[dic objectForKey:@"content"];
            NSMutableArray * array2 =[NSMutableArray new];
            for (NSDictionary * dicc in contentArr) {
                PaiMaiGongGaoModel * md =[[PaiMaiGongGaoModel alloc]initWithPaiMaiPublicDic:dicc];
                [array2 addObject:md];
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
        
    }];
}


#pragma mark --创建按钮
-(void)CreatButton{
    UIButton * fabu =[UIButton buttonWithType:UIButtonTypeCustom];
    fabu.backgroundColor=[UIColor whiteColor];
     _lastBtn=fabu;
    [fabu addTarget:self action:@selector(fabuClink) forControlEvents:UIControlEventTouchUpInside];
    fabu.frame=CGRectMake(0, ScreenHeight-55-64, ScreenWidth, 55);
    [fabu setImage:[UIImage imageNamed:@"liebiaonav_bottom "] forState:0];
    [self.view addSubview:fabu];
    
}
-(void)fabuClink{
    ScanCodeVC * vc =[ScanCodeVC new];
    vc.tagg=1;
    [self.navigationController pushViewController:vc animated:YES];
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


#pragma mark --调用数据
-(void)dataInterStr{
    if (_tagg==2) {
        //从个人中心进入
        [self myCenterComeInDataPage:_AAA LeiXing:[ToolClass isString:_biaoDiFenLeiText] ShengCode:[ToolClass isString:_shengcode] CityCode:[ToolClass isString:_citycode] TimeStr:[ToolClass isString:_paiMaiStyleText]];
    }else{
        [self getMainTableViewDataPage:_AAA Search:self.textHomeField.text LeiXing:[ToolClass isString:_biaoDiFenLeiText] proCode:[ToolClass isString:_shengcode] CityCode:[ToolClass isString:_citycode] TimeStr:[ToolClass isString:_paiMaiStyleText]];
    }

}

#pragma mark --创建主表
-(void)CreatTabelView{

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
        [self dataInterStr];
    }];
    
    [_tableView.header beginRefreshing];
    //..上拉刷新
    _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.myRefreshView = weakSelf.tableView.footer;
        _AAA=_AAA+1;
        [self dataInterStr];
        
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
    NSString * cellID =[NSString stringWithFormat:@"%lu%lu",indexPath.section,indexPath.row];
    
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
        PaiMaiGongGaoCell * cell =[PaiMaiGongGaoCell cellWithTableView:tableView CellID:cellID];
        if (_tagg==2) {
            //从个人中心进入(我参加的拍卖会)
            [cell.lijiBaoMiang setBackgroundImage:[UIImage imageNamed:@"cj_bm"] forState:0];
        }
        cell.model=_dataArray[indexPath.row];
        cell.lijiBaoMiang.tag=indexPath.row;
        [cell.lijiBaoMiang addTarget:self action:@selector(buttonClink:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
 
    }
    
    
}
#pragma mark --立即报名按钮
-(void)buttonClink:(UIButton*)btn{
    PaiMaiGongGaoModel * md =_dataArray[btn.tag];
    PaiMaiGongGaoXiangQingVC * vc =[PaiMaiGongGaoXiangQingVC new];
    //        vc.messageID=md.messageID;
    vc.paiMaiHuiID=md.paiMaiHuiID;//拍卖会ID
    vc.baioDiID=@"";//拍卖会里面没有标的ID，所有给后台传空字符串
    [self.navigationController pushViewController:vc animated:YES];
    
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
                _shengName=@"所属地区";
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
              
                [_button1 setTitle:@"所标的物" forState:0];
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
            _AAA=1;
             [self dataInterStr];
//             [self getMainTableViewDataPage:_AAA LeiXing:[ToolClass isString:_biaoDiFenLeiText] proCode:[ToolClass isString:_shengcode] CityCode:[ToolClass isString:_citycode] TimeStr:[ToolClass isString:_paiMaiStyleText]];
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
            _AAA=1;
             [self dataInterStr];
//             [self getMainTableViewDataPage:_AAA LeiXing:[ToolClass isString:_biaoDiFenLeiText] proCode:[ToolClass isString:_shengcode] CityCode:[ToolClass isString:_citycode] TimeStr:[ToolClass isString:_paiMaiStyleText]];;
            [self shuChu];
        }else{
            //拍卖状态
            if (indexPath.row==0) {
                _button3.selected=NO;
                [_button3 setTitle:@"时间不限" forState:0];
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
            _AAA=1;
             [self dataInterStr];
//             [self getMainTableViewDataPage:_AAA LeiXing:[ToolClass isString:_biaoDiFenLeiText] proCode:[ToolClass isString:_shengcode] CityCode:[ToolClass isString:_citycode] TimeStr:[ToolClass isString:_paiMaiStyleText]];
            [self shuChu];
        }
        
        [self dissmiss];
    }else{
        PaiMaiGongGaoModel * md =_dataArray[indexPath.row];
        PaiMaiGongGaoXiangQingVC * vc =[PaiMaiGongGaoXiangQingVC new];
//        vc.messageID=md.messageID;
        vc.paiMaiHuiID=md.paiMaiHuiID;//拍卖会ID
        vc.baioDiID=@"";//拍卖会里面没有标的ID，所有给后台传空字符串
        vc.datasoure=md.dataSource;
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



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==_tableView) {
        return 110;
    }else{
        return 44;
    }
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

-(void)shuChu{
    
    NSLog(@"拍卖%@",[ToolClass isString:_biaoDiFenLeiText]);
    NSLog(@"省%@",[ToolClass isString:_shengcode]);
    NSLog(@"市%@",[ToolClass isString:_citycode]);
    NSLog(@"状态%@",[ToolClass isString:_paiMaiStyleText]);
}
#pragma mark --灰色按钮点击取消
-(void)bgViewBtn{
    [self dissmiss];
    _button1.selected=NO;
    _button2.selected=NO;
    _button3.selected=NO;
}
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
    [dicc setObject:@"1" forKey:@"1天内"];
    [dicc setObject:@"2" forKey:@"3天内"];
    [dicc setObject:@"3" forKey:@"5天内"];
    [dicc setObject:@"4" forKey:@"7天内"];
    [dicc setObject:@"5" forKey:@"15天内"];
    
    NSString * strID =[dicc objectForKey:str];
    return strID;
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.navigationController.view endEditing:YES];
}
#pragma mark --点击了搜索事件
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];//关闭键盘
    NSLog(@"点击了搜索十几号");
    [_dataArray removeAllObjects];
    [_tableView reloadData];
    _AAA=1;
    [self getMainTableViewDataPage:_AAA Search:textField.text LeiXing:@"" proCode:@"" CityCode:@"" TimeStr:@""];
    
    return YES;
}
@end
