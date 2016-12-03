//
//  PaiMaiZiXunVC.m
//  DistributionQuery
//
//  Created by Macx on 16/12/1.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "PaiMaiZiXunVC.h"
#import "PaiMaiZiXunXiangQingVC.h"
@interface PaiMaiZiXunVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSMutableArray * dataArray;
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSMutableArray * titleArray;
@end

@implementation PaiMaiZiXunVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"拍卖资讯";
    [self CreatData];
    [self CreatTableView];
}

-(void)CreatData
{
    _titleArray=[[NSMutableArray alloc]initWithObjects:@"拍卖时应如何理性应价",@"拍卖时应如何理性认识",@"拍卖会的拍卖规则", nil];
    _dataArray=[[NSMutableArray alloc]initWithObjects:
                @"10月25日，工程师国际认证专家前来认证10月25日，工程师国际认证专家前来认证10月25日，工程师国际认证专家前来认证10月25日，工程师国际认证专家前来认证",
                @"10月25日，工程师国际认证专家前来认证10月25日，工程师国际认证专家前来认证10月25日，工程师国际认证专家前来认证10月25日，工程师国际认证专家前来认证",
                @"10月25日，工程师国际认证专家前来认证10月25日，工程师国际认证专家前来认证10月25日，工程师国际认证专家前来认证10月25日，工程师国际认证专家前来认证", nil];
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
    //标题
    UILabel * titleLabel =(UILabel*)[cell viewWithTag:1];
    titleLabel.alpha=.8;
    titleLabel.font=[UIFont systemFontOfSize:16];
    titleLabel.text=_titleArray[indexPath.row];
    titleLabel.sd_layout
    .leftSpaceToView(cell,15)
    .topSpaceToView(cell,15)
    .rightSpaceToView(cell,15)
    .heightIs(20);
    
    //内容
    UILabel * contentLabel =(UILabel*)[cell viewWithTag:2];
    contentLabel.text=_dataArray[indexPath.row];
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
    timeLabel.text=@"2016-12-2";
    timeLabel.sd_layout
    .rightSpaceToView(cell,15)
    .topSpaceToView(contentLabel,5)
    .heightIs(20);
    [timeLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PaiMaiZiXunXiangQingVC* vc =[PaiMaiZiXunXiangQingVC new];
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
