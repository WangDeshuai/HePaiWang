//
//  XiaoXiViewController.m
//  DistributionQuery
//
//  Created by Macx on 16/11/29.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "XiaoXiViewController.h"
#import "XiaoXiTableViewCell.h"
@interface XiaoXiViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)UIButton * lastBtn;
@end

@implementation XiaoXiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (_tagg==1) {
      self.title=@"消息列表";
    }else{
     self.title=@"账户信息";
    }
    
    [self CreatTopBtn];
    [self CreatTableView];
}
#pragma mark --创建顶部按钮
-(void)CreatTopBtn{
    NSArray * nameAr =@[@"未读",@"已读"];
    
    
    int d =ScreenWidth/nameAr.count;
    for (int i=0; i<nameAr.count; i++) {
        UIButton * btn =[UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor=[UIColor whiteColor];
        [btn setTitle:nameAr[i] forState:0];
        [btn setTitleColor:[UIColor blackColor] forState:0];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        btn.titleLabel.alpha=.7;
        [btn addTarget:self action:@selector(btnnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font=[UIFont systemFontOfSize:16];
        if (i==0) {
            btn.selected=YES;
            _lastBtn=btn;
        }
        [self.view sd_addSubviews:@[btn]];
        btn.sd_layout
        .leftSpaceToView(self.view,(d+1)*i)
        .topSpaceToView(self.view,0)
        .widthIs(d)
        .heightIs(40);
    }
}
-(void)btnnClick:(UIButton*)button{
    _lastBtn.selected=NO;
    button.selected=!button.selected;
    _lastBtn=button;
}
#pragma mark --创建表格
-(void)CreatTableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 45, ScreenWidth, ScreenHeight-45) style:UITableViewStylePlain];
    }
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.backgroundColor=BG_COLOR;
    [self.view addSubview:_tableView];
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld", (long)[indexPath section], (long)[indexPath row]];
    
    XiaoXiTableViewCell * cell =[XiaoXiTableViewCell cellWithTableView:tableView CellID:CellIdentifier];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 125;
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
