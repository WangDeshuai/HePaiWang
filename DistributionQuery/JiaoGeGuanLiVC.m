//
//  JiaoGeGuanLiVC.m
//  DistributionQuery
//
//  Created by Macx on 16/12/1.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "JiaoGeGuanLiVC.h"
#import "BuyBiaoDiModel.h"
#import "QueRenChengJiaoVC.h"
@interface JiaoGeGuanLiVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSMutableArray * nameArr;
@property(nonatomic,strong)BuyBiaoDiModel * md;
@end

@implementation JiaoGeGuanLiVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"交割管理";
//    self.view.backgroundColor=[UIColor redColor];
    [self shujuYuan];
    [self CreatTabelView];
    if (_tagg==2) {
        [self jiaoGeJieXiData];
    }else{
        [self jiaoGeJieXiData];
        [self CreatTwoBtn];
    }
    
   
}
-(void)shujuYuan{
    NSArray * arr1 =@[@"标的编号",@"标的名称",@"所 在 地"];
    NSArray * arr2 =@[@"还需缴纳尾款"];
    NSArray * arr3=@[@"目前标的状态",@"委托人联系方式",@"交货地址"];
    NSArray * arr4=@[@"合拍标的交割服务专员",@"联系电话"];
    _nameArr=[[NSMutableArray alloc]initWithObjects:arr1,arr2,arr3,arr4, nil];
}


#pragma mark --创建按钮
-(void)CreatTwoBtn{
    NSArray * btnArr =@[@"查看拍卖成交确认书",@"确认收货"];
    int k =(ScreenWidth-60)/2;
    for (int i =0; i<btnArr.count; i++) {
        UIButton * btn =[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:btnArr[i] forState:0];
        btn.backgroundColor=[UIColor redColor];
        btn.sd_cornerRadius=@(5);
        btn.titleLabel.font=[UIFont systemFontOfSize:15];
        btn.tag=i;
        [btn addTarget:self action:@selector(btnClink:) forControlEvents:UIControlEventTouchUpInside];
        [self.view sd_addSubviews:@[btn]];
        btn.sd_layout
        .leftSpaceToView(self.view,20+(k+20)*i)
        .bottomSpaceToView(self.view,10)
        .widthIs(k)
        .heightIs(40);
    }
}

#pragma mark --点击状态
-(void)btnClink:(UIButton*)btn{
    if (btn.tag==0) {
        //查看拍卖成交确认书
        QueRenChengJiaoVC * vc =[QueRenChengJiaoVC new];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        //确认收货
    }
}
//已买到的--交割管理
-(void)jiaoGeJieXiData{
    [Engine jiaoGeGuanLiBiaoDiID:@"10" success:^(NSDictionary *dic) {
        NSString * code =[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            NSDictionary * contentDic =[dic objectForKey:@"content"];
            
            BuyBiaoDiModel * md =[[BuyBiaoDiModel alloc]initWithJiaoGeGuanLiDic:contentDic];
            _md=md;
            
        }else{
            [LCProgressHUD showMessage:[dic objectForKey:@"msg"]];
        }
        [_tableView reloadData];
    } error:^(NSError *error) {
        
    }];
}

//我的委托  交割管理
-(void)myweituoJiaoGeData{
    [Engine myWeiTuoJiaoGeGuanLiID:@"10" success:^(NSDictionary *dic) {
        NSString * code =[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            NSDictionary * contentDic =[dic objectForKey:@"content"];
            
            BuyBiaoDiModel * md =[[BuyBiaoDiModel alloc]initWithJiaoGeGuanLiDic:contentDic];
            _md=md;
            
        }else{
            [LCProgressHUD showMessage:[dic objectForKey:@"msg"]];
        }
        [_tableView reloadData];
    } error:^(NSError *error) {
        
    }];
}




#pragma mark --创建表
-(void)CreatTabelView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-50) style:UITableViewStylePlain];
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
            contentLaebl.text=_md.jgBianHao;
            
        }else if (indexPath.row==1){
            //标的名称
            contentLaebl.text=_md.jgName;
        }else{
            //所在地
            contentLaebl.text=_md.jgAddress;
        }
    }else if (indexPath.section==1){
        //还需缴纳尾款
        contentLaebl.text=_md.jgWeiKuan;
    }else if (indexPath.section==2){
        if (indexPath.row==0) {
            //目前标的状态
             contentLaebl.text=_md.jgZhuTai;
        }else if (indexPath.row==1){
            //委托人联系方式
            contentLaebl.text=_md.jgWeiTuoStyle;
        }else{
            //交货地址
            contentLaebl.text=_md.jgJiaoHuoDiZhi;
        }
    }else{
        if (indexPath.row==0) {
            //合拍标的交割服务专员
            contentLaebl.text=_md.jgHePaiBiaoDi;
        }else{
            //联系电话
            contentLaebl.text=_md.jgPhone;
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
