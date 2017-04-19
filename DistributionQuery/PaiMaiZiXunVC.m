//
//  PaiMaiZiXunVC.m
//  DistributionQuery
//
//  Created by Macx on 16/12/1.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "PaiMaiZiXunVC.h"
#import "PaiMaiZiXunXiangQingVC.h"
#import "PaiMaiZiXunModel.h"
@interface PaiMaiZiXunVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSMutableArray * dataArray;
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSMutableArray * titleArray;
@property (nonatomic, strong) MJRefreshComponent *myRefreshView;
@property(nonatomic,assign)int AAA;
@end

@implementation PaiMaiZiXunVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"拍卖资讯";
      _dataArray=[NSMutableArray new];
    [self CreatTableView];
}

//-(void)CreatData
//{
//    _titleArray=[[NSMutableArray alloc]initWithObjects:@"拍卖时应如何理性应价",@"拍卖时应如何理性认识",@"拍卖会的拍卖规则", nil];
//    _dataArray=[[NSMutableArray alloc]initWithObjects:
//                @"10月25日，工程师国际认证专家前来认证10月25日，工程师国际认证专家前来认证10月25日，工程师国际认证专家前来认证10月25日，工程师国际认证专家前来认证",
//                @"10月25日，工程师国际认证专家前来认证10月25日，工程师国际认证专家前来认证10月25日，工程师国际认证专家前来认证10月25日，工程师国际认证专家前来认证",
//                @"10月25日，工程师国际认证专家前来认证10月25日，工程师国际认证专家前来认证10月25日，工程师国际认证专家前来认证10月25日，工程师国际认证专家前来认证", nil];
//}


-(void)paiMaiZiXunPage:(NSString*)page{
    [Engine paiMaiZiXunListViewPage:page success:^(NSDictionary *dic) {
        NSString * code =[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            NSArray * array =[dic objectForKey:@"content"];
            NSMutableArray * array2 =[NSMutableArray new];

            for (NSDictionary * dicc in array) {
                 PaiMaiZiXunModel * model =[[PaiMaiZiXunModel alloc]initWithPaiMaiZiXunDic:dicc];
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
            
            
           
        }
    } error:^(NSError *error) {
           [_myRefreshView  endRefreshing];
    }];
}




-(void)CreatTableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];
    }
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.tableFooterView=[UIView new];
    _tableView.backgroundColor=BG_COLOR;
    [self.view addSubview:_tableView];
    
    __weak typeof (self) weakSelf =self;
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.myRefreshView = weakSelf.tableView.header;
        _AAA=1;
        [self paiMaiZiXunPage:[NSString stringWithFormat:@"%d",_AAA]];
        
    }];
    
    [_tableView.header beginRefreshing];
    //..上拉刷新
    _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.myRefreshView = weakSelf.tableView.footer;
        _AAA=_AAA+1;
        [self paiMaiZiXunPage:[NSString stringWithFormat:@"%d",_AAA]];
    }];
    
    _tableView.footer.hidden = YES;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        UILabel * titleLabel =[UILabel new];
        UILabel * contentLabel =[UILabel new];
        UILabel * timeLabel =[UILabel new];
        titleLabel.tag=1;
        contentLabel.tag=2;
        timeLabel.tag=3;
        [cell sd_addSubviews:@[titleLabel,contentLabel,timeLabel]];
    }
    PaiMaiZiXunModel * md =_dataArray[indexPath.row];
    //标题
    UILabel * titleLabel =(UILabel*)[cell viewWithTag:1];
    titleLabel.alpha=.8;
    titleLabel.font=[UIFont systemFontOfSize:16];
    titleLabel.text=md.titlelabel;
    titleLabel.sd_layout
    .leftSpaceToView(cell,15)
    .topSpaceToView(cell,15)
    .rightSpaceToView(cell,15)
    .heightIs(20);
    
    //内容
    UILabel * contentLabel =(UILabel*)[cell viewWithTag:2];
//    contentLabel.text=md.content;;
    contentLabel.attributedText=[ToolClass HTML:md.content];
    contentLabel.attributedText=[ToolClass hangJianJuStr:contentLabel.text JuLi:8];
    contentLabel.alpha=.6;
    contentLabel.numberOfLines=2;
    contentLabel.font=[UIFont systemFontOfSize:15];
    
    contentLabel.sd_layout
    .leftEqualToView(titleLabel)
    .topSpaceToView(titleLabel,10)
    .rightSpaceToView(cell,15)
    .heightIs(60);
    
    
    //时间
    UILabel * timeLabel =(UILabel*)[cell viewWithTag:3];
    timeLabel.alpha=.5;
    timeLabel.font=[UIFont systemFontOfSize:14];
    timeLabel.text=md.fabuTime;
    timeLabel.sd_layout
    .rightSpaceToView(cell,15)
    .topSpaceToView(contentLabel,5)
    .heightIs(20);
    [timeLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PaiMaiZiXunModel*md =_dataArray[indexPath.row];
    PaiMaiZiXunXiangQingVC* vc =[PaiMaiZiXunXiangQingVC new];
    vc.zixunID=md.zixunID;
    [self.navigationController pushViewController:vc animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 130;
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
