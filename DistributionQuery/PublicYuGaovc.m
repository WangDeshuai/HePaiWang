//
//  PublicYuGaovc.m
//  DistributionQuery
//
//  Created by Macx on 16/11/29.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "PublicYuGaovc.h"

@interface PublicYuGaovc ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSMutableArray * dataArray;
@property(nonatomic,strong)UIView * view2;
@end

@implementation PublicYuGaovc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"发布预告";
    [self dataArr];
    [self CreatTableView];
    [self CreatImage];
    [self commentBtn];
}
-(void)dataArr{
    NSArray * arr1 =@[@"预告标题"];
    NSArray * arr2=@[@"资产处理人",@"预告内容"];
    _dataArray=[[NSMutableArray alloc]initWithObjects:arr1,arr2, nil];
}
-(void)CreatTableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 90+44*2) style:UITableViewStylePlain];
    }
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.scrollEnabled=NO;
   // _tableView.backgroundColor=[UIColor redColor];
    _tableView.tableFooterView=[UIView new];
    [self.view addSubview:_tableView];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray[section] count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        UITextField * textLabel =[UITextField new];
        textLabel.tag=1;
        [cell sd_addSubviews:@[textLabel]];
    }
   
    
    UITextField * nameLabel =(UITextField*)[cell viewWithTag:1];
    nameLabel.alpha=.6;
    nameLabel.font=[UIFont systemFontOfSize:15];
    nameLabel.sd_layout
    .rightSpaceToView(cell,15)
    .leftSpaceToView(cell,90)
    .centerYEqualToView(cell)
    .heightIs(30);
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.textLabel.text=_dataArray[indexPath.section][indexPath.row];
    cell.textLabel.font=[UIFont systemFontOfSize:15];
    cell.alpha=.7;
    
    if (indexPath.section==0) {
        //标题预告
    }
   else if (indexPath.section==1) {
       if (indexPath.row==0) {
           //资产处理人
            nameLabel.textAlignment=2;
       }
       else if (indexPath.row==1) {
           //预告内容
           nameLabel.enabled=NO;
           cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    return cell;
}

#pragma mark --创建预告图片
-(void)CreatImage{
    _view2=[UIView new];
    _view2.backgroundColor=[UIColor whiteColor];
    [self.view sd_addSubviews:@[_view2]];
    _view2.sd_layout
    .leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .topSpaceToView(_tableView,5)
    .heightIs(140);
    //label
    UILabel * nameLabel =[UILabel new];
    nameLabel.text=@"预告图片";
    nameLabel.textColor=[UIColor blackColor];
    nameLabel.font=[UIFont systemFontOfSize:16];
    nameLabel.alpha=.8;
    [_view2 sd_addSubviews:@[nameLabel]];
    nameLabel.sd_layout
    .leftSpaceToView(_view2,15)
    .topSpaceToView(_view2,15)
    .heightIs(20);
    [nameLabel setSingleLineAutoResizeWithMaxWidth:120];
    //button
    UIButton * imageBtn =[UIButton buttonWithType:UIButtonTypeCustom];
   // imageBtn.backgroundColor=[UIColor redColor];
    [imageBtn setBackgroundImage:[UIImage imageNamed:@"rz_pic"] forState:0];
    [_view2 sd_addSubviews:@[imageBtn]];
    imageBtn.sd_layout
    .leftSpaceToView(nameLabel,15)
    .topSpaceToView(nameLabel,0)
    .widthIs(162/2)
    .heightIs(122/2);

    
    
}

#pragma mark --创建提交按钮
-(void)commentBtn{
    
    UIButton * imageBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    imageBtn.backgroundColor=BG_COLOR;
    [imageBtn setImage:[UIImage imageNamed:@"fbyg_bt"] forState:0];
    [self.view sd_addSubviews:@[imageBtn]];
    imageBtn.sd_layout
    .leftSpaceToView(self.view,10)
    .rightSpaceToView(self.view,10)
    .topSpaceToView(_view2,30)
    .heightIs(45);
    
}











-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
    return 80;
   }else{
    return 44;
    }
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
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end
