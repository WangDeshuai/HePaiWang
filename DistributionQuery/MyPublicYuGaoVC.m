//
//  MyPublicYuGaoVC.m
//  DistributionQuery
//
//  Created by Macx on 16/11/29.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "MyPublicYuGaoVC.h"
#import "MyPublicYuGaoCell.h"
#import "YuGaoXiangQingVC.h"
#import "MyPublicYuGaoModel.h"

@interface MyPublicYuGaoVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSMutableArray * dataArray;
@property(nonatomic,assign)NSInteger AAA;
@property (nonatomic, strong) MJRefreshComponent *myRefreshView;
@end

@implementation MyPublicYuGaoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"我发布的预告";
    [self CreatTabelView];
}

#pragma mark --获取网络数据14
-(void)huoQuMyPublicPage:(NSString*)page{
    [Engine myCenterYuGaoPageIndex:page success:^(NSDictionary *dic) {
        NSString * code =[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
        NSMutableArray * array2 =[NSMutableArray new];
        if ([code isEqualToString:@"1"]) {
            NSArray * contentArr =[dic objectForKey:@"content"];
            for (NSDictionary * dicc in contentArr) {
                MyPublicYuGaoModel * md =[[MyPublicYuGaoModel alloc]initWithMyPublicDic:dicc];
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
        }else
        {
            [LCProgressHUD showMessage:[dic objectForKey:@"msg"]];
        }
    } error:^(NSError *error) {
        
    }];
}



#pragma mark --创建表格
-(void)CreatTabelView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];
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
        [self huoQuMyPublicPage:[NSString stringWithFormat:@"%lu",_AAA]];
        
    }];
    
    [_tableView.header beginRefreshing];
    //..上拉刷新
    _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.myRefreshView = weakSelf.tableView.footer;
        _AAA=_AAA+1;
         [self huoQuMyPublicPage:[NSString stringWithFormat:@"%lu",_AAA]];
    }];
    
    _tableView.footer.hidden = YES;

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld", (long)[indexPath section], (long)[indexPath row]];
    
    MyPublicYuGaoCell * cell =[MyPublicYuGaoCell cellWithTableView:tableView CellID:CellIdentifier];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.model=_dataArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YuGaoXiangQingVC * vc =[YuGaoXiangQingVC new];
    vc.model=_dataArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 170;
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
