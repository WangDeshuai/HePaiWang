//
//  ChangeThePasswordVC.m
//  DistributionQuery
//
//  Created by Macx on 17/3/13.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "ChangeThePasswordVC.h"
#import "ChangeThePassCell.h"
@interface ChangeThePasswordVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSArray * dataArray;
@property(nonatomic,strong)NSArray * imageArray;
@end

@implementation ChangeThePasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"修改密码";
    [self CreatData];
    [self CreatTabelView];
    
}

-(void)CreatData{
    self.dataArray=@[@"请输入手机号",@"请输入手机验证码",@"请输入新密码",@"请再次输入新密码"];
    self.imageArray=@[@"zhuce_mima",@"zhuce_yanzheng",@"zhuce_mima",@"zhuce_mima"];
}


#pragma mark --创建提交button
-(void)CreatButton{
    UIButton * button =[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(15, 55*4+25, ScreenWidth-30, 35);
    button.backgroundColor=[UIColor redColor];
    button.layer.cornerRadius=5;
    button.clipsToBounds=YES;
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"确定" forState:0];
    [_tableView addSubview:button];
    
}

-(void)buttonClick{
    ChangeThePassCell * cell0 =[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
     ChangeThePassCell * cell1 =[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
     ChangeThePassCell * cell2 =[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
     ChangeThePassCell * cell3 =[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    [LCProgressHUD showMessage:@"请稍后..."];
    [Engine forgetPassWordPhone:cell0.textfield.text Code:cell1.textfield.text NewPsw:cell2.textfield.text AgeinPsw:cell3.textfield.text success:^(NSDictionary *dic) {
        [LCProgressHUD showMessage:[dic objectForKey:@"msg"]];
        NSString * code =[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
        [LCProgressHUD showMessage:[dic objectForKey:@"msg"]];
        if ([code isEqualToString:@"1"]) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            
        }
    } error:^(NSError *error) {
        
    }];
    
}




#pragma mark --创建表格
-(void)CreatTabelView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];
    }
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.tableFooterView=[UIView new];
    _tableView.rowHeight=55;
    _tableView.backgroundColor=BG_COLOR;
    _tableView.keyboardDismissMode=UIScrollViewKeyboardDismissModeOnDrag;
    [self.view sd_addSubviews:@[_tableView]];
    [self CreatButton];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.imageArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld", (long)[indexPath section], (long)[indexPath row]];
    
    ChangeThePassCell * cell =[ChangeThePassCell cellWithTableView:tableView CellID:CellIdentifier];
    [cell.leftImage setImage:[UIImage imageNamed: self.imageArray[indexPath.row]] forState:0];
    cell.textfield.placeholder=_dataArray[indexPath.row];
    if (indexPath.row==0) {
        cell.codeBtn.hidden=NO;
        cell.textfield.keyboardType=UIKeyboardTypeNumberPad;
        [cell.codeBtn addTarget:self action:@selector(xiuGaiMiMa:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}


-(void)xiuGaiMiMa:(UIButton*)sender{
     ChangeThePassCell * cell0 =[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//     ChangeThePassCell * cell1 =[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
//     ChangeThePassCell * cell2 =[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
//     ChangeThePassCell * cell3 =[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    [Engine getMessageCodePhone:cell0.textfield.text success:^(NSDictionary *dic) {
        [LCProgressHUD showMessage:[dic objectForKey:@"msg"]];
        NSString * code =[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            __block int timeout=60; //倒计时时间
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
            dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
            dispatch_source_set_event_handler(_timer, ^{
                if(timeout<=0){ //倒计时结束，关闭
                    dispatch_source_cancel(_timer);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //设置界面的按钮显示 根据自己需求设置
                        [sender setTitle:@"发送验证码" forState:UIControlStateNormal];
                        sender.userInteractionEnabled = YES;
                    });
                }
                else{
                    int seconds = timeout % 60;
                    NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //设置界面的按钮显示 根据自己需求设置
                        //NSLog(@"____%@",strTime);
                        [UIView beginAnimations:nil context:nil];
                        [UIView setAnimationDuration:1];
                        [sender setTitle:[NSString stringWithFormat:@"重新发送(%@)",strTime] forState:UIControlStateNormal];
                        [UIView commitAnimations];
                        sender.userInteractionEnabled = NO;
                    });
                    timeout--;
                }
            });
            dispatch_resume(_timer);
        }
        
    } error:^(NSError *error) {
        
    }];
    
    
    
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
