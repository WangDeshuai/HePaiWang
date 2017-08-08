//
//  MyBiaoDiWeiTuoViC.m
//  DistributionQuery
//
//  Created by Macx on 17/3/4.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "MyBiaoDiWeiTuoViC.h"
#import "MyWeiTuoTableViewCell.h"
#import "MyWeiTuoBiaoDiModel.h"
#import "MyWeiTuoXiangQingVC.h"
#import "WeiTuoPaiMaiVC.h"
@interface MyBiaoDiWeiTuoViC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)UIButton * lastBtn;
@property(nonatomic,strong)NSMutableArray * dataArray;
@property(nonatomic,assign)int AAA;
@property (nonatomic, strong) MJRefreshComponent *myRefreshView;
@end

@implementation MyBiaoDiWeiTuoViC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dataArray=[NSMutableArray new];
     [self CreatTableView];
   // NSLog(@"输出tagg=%lu",_tagg);
}

#pragma mark --获取主表内容
-(void)huoQuDataPage:(int)page{
    //[LCProgressHUD showMessage:@"请稍后..."];
    [Engine myCenterWeiTuoPage:[NSString stringWithFormat:@"%d",page] Status:[NSString stringWithFormat:@"%lu",(long)_tagg] success:^(NSDictionary *dic) {
        
        NSString * code =[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            NSArray * contentArr =[dic objectForKey:@"content"];
            NSMutableArray * array2 =[NSMutableArray new];
            for (NSDictionary * dicc in contentArr) {
                MyWeiTuoBiaoDiModel * md =[[MyWeiTuoBiaoDiModel alloc]initWithMyWeiTuoDic:dicc];
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
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 45, ScreenWidth, ScreenHeight-45) style:UITableViewStylePlain];
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
        [self huoQuDataPage:_AAA];
    }];
    
    [_tableView.header beginRefreshing];
    //..上拉刷新
    _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.myRefreshView = weakSelf.tableView.footer;
        _AAA=_AAA+1;
         [self huoQuDataPage:_AAA];
    }];
    
    _tableView.footer.hidden = YES;
    
    
    
    

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld", (long)[indexPath section], (long)[indexPath row]];

    MyWeiTuoTableViewCell * cell =[MyWeiTuoTableViewCell cellWithTableView:tableView CellID:CellIdentifier];
    cell.md=_dataArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyWeiTuoBiaoDiModel * md =_dataArray[indexPath.row];
    
    [self baiDiID:md.biaoDiID];

   
}
-(void)baiDiID:(NSString*)bdid{
    [LCProgressHUD showLoading:@"请稍后..."];
    [Engine myWeiTuoXiangQingBiaoDiID:bdid success:^(NSDictionary *dic) {
        NSString * code =[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            NSDictionary * contentDic =[dic objectForKey:@"content"];
            MyWeiTuoBiaoDiModel * md =[[MyWeiTuoBiaoDiModel alloc]initWithBiaoDiXiangQingDic:contentDic];
            WeiTuoPaiMaiVC * vc =[WeiTuoPaiMaiVC new];
            vc.tagg=1;
            vc.model=md;
             [self.navigationController pushViewController:vc animated:YES];
            [LCProgressHUD hide];
        }else{
            [LCProgressHUD showMessage:[dic objectForKey:@"msg"]];
        }
    } error:^(NSError *error) {
        
    }];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
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
