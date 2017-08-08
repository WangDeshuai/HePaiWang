//
//  ChengJiaoAnLiVC.m
//  DistributionQuery
//
//  Created by Macx on 16/12/2.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "ChengJiaoAnLiVC.h"
#import "PaiMaiBiaoDiCell.h"
#import "ChengJiaoAnLiModel.h"
#import "PaiMaiBiaoDiXiangQingVC.h"
@interface ChengJiaoAnLiVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * tableView;
@property (nonatomic, strong) MJRefreshComponent *myRefreshView;
@property(nonatomic,assign)int AAA;
@property(nonatomic,strong)NSMutableArray * dataArray;
@end

@implementation ChengJiaoAnLiVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"成交案例";
    _dataArray=[NSMutableArray new];
    [self CreatTableView];
}
#pragma mark --获取网络数据成交案例
-(void)getDataPage:(NSString*)page{
    [Engine firstChengJiaoAnLiPageindex:page success:^(NSDictionary *dic) {
        
        NSString * code =[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            NSArray * contentArr= [dic objectForKey:@"content"];
            NSMutableArray * array2 =[NSMutableArray new];
            for (NSDictionary * dicc in contentArr) {
                ChengJiaoAnLiModel * md =[[ChengJiaoAnLiModel alloc]initWithChengJiaoAnliDic:dicc];
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
           
            
            
            
        }
        
    } error:^(NSError *error) {
        
    }];
}


#pragma mark --创建表格
-(void)CreatTableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];
    }
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.tableFooterView=[UIView new];
    _tableView.backgroundColor=BG_COLOR;
    [self.view sd_addSubviews:@[_tableView]];
    
    __weak typeof (self) weakSelf =self;
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.myRefreshView = weakSelf.tableView.header;
        _AAA=1;
        [self getDataPage:[NSString stringWithFormat:@"%d",_AAA]];
        
    }];
    
    [_tableView.header beginRefreshing];
    //..上拉刷新
    _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.myRefreshView = weakSelf.tableView.footer;
        _AAA=_AAA+1;
        [self getDataPage:[NSString stringWithFormat:@"%d",_AAA]];
    }];
    
    _tableView.footer.hidden = YES;
    



}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld", (long)[indexPath section], (long)[indexPath row]];
    
    PaiMaiBiaoDiCell * cell =[PaiMaiBiaoDiCell cellWithTableView:tableView CellID:CellIdentifier];
    cell.qipaiLabel.text=@"成交价格";
    cell.model=_dataArray[indexPath.row];
    cell.chengJiaoImage.hidden=NO;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChengJiaoAnLiModel * md=_dataArray[indexPath.row];
    PaiMaiBiaoDiXiangQingVC * vc =[PaiMaiBiaoDiXiangQingVC new];
    vc.paiMaiID=md.paiMaiHuiID;
    vc.biaoDiID=md.biaoDiID;
    vc.dataScore=md.dataSoure;
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
