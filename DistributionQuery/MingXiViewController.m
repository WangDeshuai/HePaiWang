//
//  MingXiViewController.m
//  DistributionQuery
//
//  Created by Macx on 16/12/1.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "MingXiViewController.h"
#import "BuyBiaoDiModel.h"
@interface MingXiViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSMutableArray * nameArr;
@property(nonatomic,strong)BuyBiaoDiModel * md;
@end

@implementation MingXiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"交易明细";
    [self shujuYuan];
    [self CreatTabelView];
    if (_tagg==2) {
        [self jiaoYiMingXiDataMyweiTuo];
    }else{
        [self jiaoYiMingXiData];
    }
    
}
-(void)shujuYuan{
    NSArray * arr1 =@[@"标的编号",@"标的名称",@"所在地"];
    NSArray * arr2 =@[@"标的保证金",@"标的成交价",@"标的佣金",@"总计金额",@"还需缴纳尾款"];
    _nameArr=[[NSMutableArray alloc]initWithObjects:arr1,arr2, nil];
}


//交易明细数据请求 已买到的
-(void)jiaoYiMingXiData{
    [Engine jiaoYiMingXiBiaoDiID:_biaoDiID success:^(NSDictionary *dic) {
        NSString * code =[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            NSDictionary * contentDic =[dic objectForKey:@"content"];
            BuyBiaoDiModel * md =[[BuyBiaoDiModel alloc]initWithJiaoYiMingXiDic:contentDic];
            _md=md;
        }else{
            [LCProgressHUD showMessage:[dic objectForKey:@"msg"]];
        }
        [_tableView reloadData];
    } error:^(NSError *error) {
        [LCProgressHUD showMessage:@"后台错误或网络超时"];
    }];
}
//交易明细数据,我委托的
-(void)jiaoYiMingXiDataMyweiTuo{
    [Engine myWeiTuoJiaoYiXiangXiID:_biaoDiID success:^(NSDictionary *dic) {
        NSString * code =[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            NSDictionary * contentDic =[dic objectForKey:@"content"];
            BuyBiaoDiModel * md =[[BuyBiaoDiModel alloc]initWithJiaoYiMingXiDic:contentDic];
            _md=md;
        }else{
            [LCProgressHUD showMessage:[dic objectForKey:@"msg"]];
        }
        [_tableView reloadData];
    } error:^(NSError *error) {
         [LCProgressHUD showMessage:@"后台错误或网络超时"];
    }];
}


#pragma mark --创建表
-(void)CreatTabelView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];
    }
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.tableFooterView=[UIView new];
    _tableView.backgroundColor=BG_COLOR;
    [self.view addSubview:_tableView];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _nameArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_nameArr[section] count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        UILabel * namelabel =[UILabel new];
        namelabel.tag=10;
        [cell sd_addSubviews:@[namelabel]];
    }
    UILabel * namelabel =[cell viewWithTag:10];
    namelabel.textAlignment=2;
    namelabel.sd_layout
    .rightSpaceToView(cell,15)
    .centerYEqualToView(cell)
    .leftSpaceToView(cell,100)
    .heightIs(20);
    
    
    
    cell.textLabel.text=_nameArr[indexPath.section][indexPath.row];
    cell.textLabel.font=[UIFont systemFontOfSize:16];
    cell.textLabel.alpha=.6;
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            namelabel.text=_md.mxBianHao;
        }else if (indexPath.row==1){
            namelabel.text=_md.mxName;
        }else if (indexPath.row==2){
            namelabel.text=_md.mxAddress;
        }
    }else if (indexPath.section==1){
        if (indexPath.row==0) {
             namelabel.text=_md.mxBaoZheng;
        }else if (indexPath.row==1){
            namelabel.text=_md.mxChengJiao;
        }else if (indexPath.row==2){
            namelabel.text=_md.mxYongJin;
        }else if (indexPath.row==3){
            namelabel.text=_md.mxZonge;
        }else if (indexPath.row==4){
            namelabel.text=_md.mxWeiKuan;
        }
       
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
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
