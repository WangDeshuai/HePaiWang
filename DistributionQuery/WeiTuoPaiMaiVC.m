//
//  WeiTuoPaiMaiVC.m
//  DistributionQuery
//
//  Created by Macx on 16/11/17.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "WeiTuoPaiMaiVC.h"
#import "WeiTuoPaiMaiCell.h"
@interface WeiTuoPaiMaiVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSMutableArray * dataArray;
@end

@implementation WeiTuoPaiMaiVC
-(void)viewWillAppear:(BOOL)animated{
      [self CreatDataArr];
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.backHomeBtn.hidden=YES;
    [self CreatTabelView];
  
    [self CreatButton];
}
#pragma mark --创建提交按钮
-(void)CreatButton{
    UIButton * tijaoBtn =[UIButton new];
    tijaoBtn.backgroundColor=[UIColor redColor];
    [tijaoBtn setTitle:@"确认提交" forState:0];
    tijaoBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    [self.view sd_addSubviews:@[tijaoBtn]];
    tijaoBtn.sd_layout
    .leftSpaceToView(self.view,20)
    .rightSpaceToView(self.view,20)
    .bottomSpaceToView(self.view,100)
    .heightIs(45);
}
#pragma mark --数据源
-(void)CreatDataArr{
    if ([ToolClass isLogin]) {
        NSArray * arr1 =@[@"联系人",@"手机号"];
        NSArray * arr2 =@[@"标的名称",@"标的描述",@"标的瑕癖",@"标的所在地"];
        NSArray * arr3 =@[@"标的保留价",@"标的评估价"];
        _dataArray=[[NSMutableArray alloc]initWithObjects:arr1,arr2,arr3, nil];
    }else{
        NSArray * arr1 =@[@"联系人",@"手机号",@"验证码"];
        NSArray * arr2 =@[@"标的名称",@"标的描述",@"标的瑕癖",@"标的所在地"];
        _dataArray=[[NSMutableArray alloc]initWithObjects:arr1,arr2, nil];
    }
    [_tableView reloadData];
}
#pragma mark --创建表
-(void)CreatTabelView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];
    }
    _tableView.scrollEnabled=NO;
    _tableView.backgroundColor=BG_COLOR;
    _tableView.tableFooterView=[UIView new];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    [self.view addSubview:_tableView];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_dataArray[section] count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * cellID =[NSString stringWithFormat:@"%lu%lu",(long)indexPath.section,(long)indexPath.row];
     WeiTuoPaiMaiCell * cell =[WeiTuoPaiMaiCell cellWithTableView:tableView CellID:cellID];
    cell.nameLabel.text=_dataArray[indexPath.section][indexPath.row];
    if (indexPath.section==0) {
        //第0区
        if (indexPath.row==0) {
            cell.textfield.placeholder=@"例如张三";
        }else if (indexPath.row==1){
            cell.textfield.placeholder=@"请您填写准确的手机号码";
        }else{
            cell.textfield.placeholder=@"请填写验证码";
            cell.codeBtn.hidden=NO;
            [cell sd_addSubviews:@[cell.textfield]];
            cell.textfield.sd_layout
            .rightSpaceToView(cell,110);

        }
    }else if (indexPath.section==1){
        //第1区
        if (indexPath.row==0) {
             cell.textfield.placeholder=@"请填写标的名称";
        }else if (indexPath.row==1){
            cell.textfield.enabled=NO;
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }else if (indexPath.row==2){
            cell.textfield.enabled=NO;
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }else{
            cell.textfield.enabled=NO;
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
    }else{
        //第三区
         cell.textfield.enabled=NO;
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
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
