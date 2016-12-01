//
//  MessageVC.m
//  DistributionQuery
//
//  Created by Macx on 16/11/29.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "MessageVC.h"
#import "MessageCell.h"
@interface MessageVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSMutableArray * dataArray;
@end

@implementation MessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"个人信息";
    [self dataArr];
    [self CreatTableView];
}
-(void)dataArr{
    NSArray * arr1 =@[@"头像"];
    NSArray * arr2 =@[@"账户"];
    NSArray * arr3 =@[@"用户名",@"真实姓名"];
    NSArray * arr4 =@[@"手机号",@"邮箱",@"邮编"];
    NSArray * arr5 =@[@"账户类型"];
    NSArray * arr6 =@[@"地址",@"街道"];
    NSArray * arr7 =@[@"退出"];
    _dataArray=[[NSMutableArray alloc]initWithObjects:arr1,arr2,arr3,arr4,arr5,arr6,arr7, nil];
}
#pragma mark --创建标示图
-(void)CreatTableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    }
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.backgroundColor=BG_COLOR;
    _tableView.tableFooterView=[UIView new];
    [self.view addSubview:_tableView];
    UITapGestureRecognizer * tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [_tableView addGestureRecognizer:tap];

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArray[section] count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld", (long)[indexPath section], (long)[indexPath row]];
    
    MessageCell * cell =[MessageCell cellWithTableView:tableView CellID:CellIdentifier];
    cell.nameLabel.text=_dataArray[indexPath.section][indexPath.row];
    [self uitableViewCell:cell indexpath:indexPath];
    
    return cell;

}
-(void)tap:(UIGestureRecognizer*)tapp{
    [_tableView endEditing:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            return 80;
        }
    }
    return 44;
}
-(void)uitableViewCell:(MessageCell*)cell indexpath:(NSIndexPath*)indexPath{
    cell.textfield.textAlignment=2;
    if (indexPath.section==0) {
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.headImage.image=[UIImage imageNamed:@"headImage"];
        cell.textfield.hidden=YES;
    }else if (indexPath.section==1){
        cell.textfield.placeholder=@"未填写";
    }else if (indexPath.section==2){
        if (indexPath.row==0) {
            //用户名
            cell.textfield.placeholder=@"未填写";
        }else{
            //真实姓名
            cell.textfield.placeholder=@"未填写";
        }
    }else if (indexPath.section==3){
        if (indexPath.row==0) {
            //手机号
            cell.textfield.placeholder=@"未填写";
        }else if (indexPath.row==1){
            //邮箱
            cell.textfield.placeholder=@"未填写";
        }else{
            //邮编
            cell.textfield.placeholder=@"未填写";
        }
    }else if (indexPath.section==4){
            //账户类型
        cell.textfield.enabled=NO;
        cell.textfield.text=@"个人";
       
        [cell sd_addSubviews:@[cell.textfield]];
        cell.textfield.sd_layout
        .rightSpaceToView(cell,25);
         cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.section==5){
        if (indexPath.row==0) {
            //地址
            cell.textfield.enabled=NO;
            cell.textfield.text=@"河北石家庄";
            [cell sd_addSubviews:@[cell.textfield]];
            cell.textfield.sd_layout
            .rightSpaceToView(cell,25);
             cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }else{
            //街道
            cell.textfield.placeholder=@"未填写";
        }
    }else{
        //退出
         cell.textfield.hidden=YES;
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

@end
