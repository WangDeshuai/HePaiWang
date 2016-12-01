//
//  JiaoGeGuanLiVC.m
//  DistributionQuery
//
//  Created by Macx on 16/12/1.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "JiaoGeGuanLiVC.h"

@interface JiaoGeGuanLiVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSMutableArray * nameArr;
@end

@implementation JiaoGeGuanLiVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"交割管理";
    [self shujuYuan];
    [self CreatTabelView];
}
-(void)shujuYuan{
    NSArray * arr1 =@[@"标的编号",@"标的名称",@"所 在 地"];
    NSArray * arr2 =@[@"还需缴纳尾款"];
    NSArray * arr3=@[@"目前标的状态",@"委托人联系方式",@"交货地址"];
    NSArray * arr4=@[@"合拍标的交割服务专员",@"联系电话"];
    _nameArr=[[NSMutableArray alloc]initWithObjects:arr1,arr2,arr3,arr4, nil];
}

#pragma mark --创建表
-(void)CreatTabelView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];
    }
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.tableFooterView=[UIView new];
    _tableView.backgroundColor=BG_COLOR;
    [self.view addSubview:_tableView];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _nameArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_nameArr[section] count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        UILabel * contentLabel =[UILabel new];
        UILabel * nameLabel =[UILabel new];
        contentLabel.tag=2;
        nameLabel.tag=1;
        [cell sd_addSubviews:@[nameLabel,contentLabel]];
    }
    UILabel * nameLabel =(UILabel *)[cell viewWithTag:1];
    nameLabel.text=_nameArr[indexPath.section][indexPath.row];
    nameLabel.font=[UIFont systemFontOfSize:15];
    nameLabel.alpha=.6;
    nameLabel.sd_layout
    .leftSpaceToView(cell,15)
    .centerYEqualToView(cell)
    .heightIs(20);
    [nameLabel setSingleLineAutoResizeWithMaxWidth:200];
   
    UILabel * contentLabel =(UILabel *)[cell viewWithTag:2];
    contentLabel.font=[UIFont systemFontOfSize:15];
    contentLabel.alpha=.8;
    contentLabel.sd_layout
    .leftSpaceToView(nameLabel,10)
    .centerYEqualToView(cell)
    .rightSpaceToView(cell,15)
    .heightIs(20);
    
    
    
    [self uitableviewCell:cell indepath:indexPath contenLabel:contentLabel];
    
    return cell;
}
-(void)uitableviewCell:(UITableViewCell*)cell indepath:(NSIndexPath*)indexPath contenLabel:(UILabel*)contentLaebl{
    
//    contentLaebl.backgroundColor=[UIColor redColor];
    contentLaebl.textAlignment=2;
    if (indexPath.section==0) {
        contentLaebl.textAlignment=0;
        if (indexPath.row==0) {
            //标的编号
            contentLaebl.text=@"254129572";
            
        }else if (indexPath.row==1){
            //标的名称
            contentLaebl.text=@"桑坦纳江铃北京现代等53辆机动车";
        }else{
            //所在地
            contentLaebl.text=@"河北省石家庄";
        }
    }else if (indexPath.section==1){
        //还需缴纳尾款
        contentLaebl.text=@"2000元";
    }else if (indexPath.section==2){
        if (indexPath.row==0) {
            //目前标的状态
             contentLaebl.text=@"成交等待交割";
        }else if (indexPath.row==1){
            //委托人联系方式
            contentLaebl.text=@"18333152969";
        }else{
            //交货地址
            contentLaebl.text=@"河北省石家庄市长安区广安大街33号";
        }
    }else{
        if (indexPath.row==0) {
            //合拍标的交割服务专员
            contentLaebl.text=@"张三";
        }else{
            //联系电话
            contentLaebl.text=@"18333152832";
        }
    }
    
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIImageView * view =[UIImageView new];
    //view.backgroundColor=[UIColor redColor];//jiaoge_bg
    view.image=[UIImage imageNamed:@"jiaoge_bg"];
    if (section==1) {
        return view;
    }else{
        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section==1) {
        return 55;
    }else{
       return 5;
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
