//
//  BuyDaoViewController.m
//  DistributionQuery
//
//  Created by Macx on 16/11/29.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "BuyDaoViewController.h"
#import "MyWeiTuoTableViewCell.h"
#import "BuyXiangQingVC.h"
#import "BuyBiaoDiModel.h"
@interface BuyDaoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSMutableArray * dataArray;
@property(nonatomic,strong)NSArray * styeArr;
@property(nonatomic,assign)int AAA;
@property (nonatomic,strong) MJRefreshComponent *myRefreshView;
@end

@implementation BuyDaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.title=@"已买到的标的";
    _dataArray=[NSMutableArray new];
    _styeArr=@[@"-1",@"1",@"0"];
    
    [self CreatTableView];
}

#pragma mark --获取网络数据
-(void)getBuyBiaoDiPage:(NSString*)page{
    //stype:-1全部 0未交割 1已交割
    [Engine myCenterMyBuyBiaoDiStype:_styeArr[_tagg] Page:page  success:^(NSDictionary *dic) {
        NSString * code =[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            NSMutableArray * array2 =[NSMutableArray new];
            NSArray * contentArr =[dic objectForKey:@"content"];
            for (NSDictionary * dicc in contentArr) {
                BuyBiaoDiModel * md =[[BuyBiaoDiModel alloc]initWithBiaoDiDic:dicc];
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



#pragma mark --创建表格
-(void)CreatTableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 45, ScreenWidth, ScreenHeight-45-64) style:UITableViewStylePlain];
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
        [self getBuyBiaoDiPage:[NSString stringWithFormat:@"%d",_AAA]];
        
    }];
    
    [_tableView.header beginRefreshing];
    //..上拉刷新
    _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.myRefreshView = weakSelf.tableView.footer;
        _AAA=_AAA+1;
        [self getBuyBiaoDiPage:[NSString stringWithFormat:@"%d",_AAA]];
    }];
    
    _tableView.footer.hidden = YES;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld", (long)[indexPath section], (long)[indexPath row]];
    
    MyWeiTuoTableViewCell * cell =[MyWeiTuoTableViewCell cellWithTableView:tableView CellID:CellIdentifier];
    BuyBiaoDiModel * md =_dataArray[indexPath.row];
    cell.model=md;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BuyBiaoDiModel * md =_dataArray[indexPath.row];
    BuyXiangQingVC * vc =[BuyXiangQingVC new];
    vc.biaoDiid=md.biaoDiId;
    [self.navigationController pushViewController:vc animated:YES];
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
