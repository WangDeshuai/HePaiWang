//
//  ShiMingRenZhengVC.m
//  DistributionQuery
//
//  Created by Macx on 16/11/30.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "ShiMingRenZhengVC.h"

@interface ShiMingRenZhengVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UIButton * lastBtn;
@property(nonatomic,strong)UIImageView * imageview;
@property(nonatomic,strong)NSMutableArray * nameArray;
@property(nonatomic,strong)NSMutableArray * nameArray2;
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)UIImageView * imageview2;
@property(nonatomic,strong)UIView * view1;
@end

@implementation ShiMingRenZhengVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _nameArray=[[NSMutableArray alloc]initWithObjects:@"姓名",@"手机号", nil];
    _nameArray2=[[NSMutableArray alloc]initWithObjects:@"企业名称",@"法人名称",@"法人身份证号",@"代理人姓名",@"手机号", nil];
    [self CreatTopBtn];//最上面2个按钮
    [self CreatImagePeople];//图片1
    [self CreatTabelView];//创建表
    [self CreatImageTwo];//图片2
    [self CreatView1];//上传图片
}
#pragma mark --创建顶部按钮
-(void)CreatTopBtn{
    NSArray * nameAr =@[@"个人",@"企业"];
    
    
    int d =ScreenWidth/nameAr.count;
    for (int i=0; i<nameAr.count; i++) {
        UIButton * btn =[UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor=[UIColor whiteColor];
        [btn setTitle:nameAr[i] forState:0];
        btn.tag=i;
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
    [self imageTwo];
    if (button.tag==0) {
        [self CreatTabelView];
    }else{
        [self CreatTabelView];
    }
    
    
}

#pragma mark --图片
-(void)CreatImagePeople
{
    _imageview=[[UIImageView alloc]init];
    _imageview.image=[UIImage imageNamed:@"rz_lb"];
    [self.view sd_addSubviews:@[_imageview]];
    _imageview.sd_layout
    .leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .topSpaceToView(_lastBtn,5)
    .heightIs(40);
   
    
}
#pragma mark --创建表格
-(void)CreatTabelView{
    NSLog(@"tagg=%lu",_lastBtn.tag);
    [_tableView removeFromSuperview];
    [_tableView reloadData];
    if (!_tableView) {
        _tableView=[[UITableView alloc]init];
    }
    _tableView.scrollEnabled=NO;
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view sd_addSubviews:@[_tableView]];
    int d ;
    if (_lastBtn.tag==1) {
        d=(int)_nameArray2.count;
    }else{
        d=(int)_nameArray.count;
    }
    _tableView.sd_layout
    .leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .topSpaceToView(_imageview,5)
    .heightIs(d*44);
    //
}
#pragma mark --创建第2个图片
-(void)CreatImageTwo
{
   _imageview2 =[[UIImageView alloc]init];
    [self imageTwo];
}
-(void)imageTwo{
    if (_lastBtn.tag==1) {
       _imageview2.image=[UIImage imageNamed:@"rz_tishii"];
    }else{
        _imageview2.image=[UIImage imageNamed:@"rz_lb1"];
    }
   
    [self.view sd_addSubviews:@[_imageview2]];
    _imageview2.sd_layout
    .topSpaceToView(_tableView,5)
    .leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .heightIs(40);
}


#pragma mark --创建view1
-(void)CreatView1{
    _view1=[UIView new];
    _view1.backgroundColor=[UIColor whiteColor];
    [self.view sd_addSubviews:@[_view1]];
    _view1.sd_layout
    .leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .topSpaceToView(_imageview2,5)
    .heightIs(100);
    
    UILabel * nameLabel =[UILabel new];
    nameLabel.text=@"身份证图片";
    nameLabel.font=[UIFont systemFontOfSize:15];
    nameLabel.alpha=.6;
    [_view1 sd_addSubviews:@[nameLabel]];
    nameLabel.sd_layout
    .leftSpaceToView(_view1,15)
    .topSpaceToView(_view1,15)
    .heightIs(20);
    [nameLabel setSingleLineAutoResizeWithMaxWidth:120];
    //上传按钮
    UIButton * imageBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [imageBtn setBackgroundImage:[UIImage imageNamed:@"rz_pic"] forState:0];
    [_view1 sd_addSubviews:@[imageBtn]];
    imageBtn.sd_layout
    .leftSpaceToView(nameLabel,10)
    .topSpaceToView(_view1,20)
    .widthIs(162/2)
    .heightIs(122/2);
    
    
    
}











-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_lastBtn.tag==1) {
        return _nameArray2.count;
    }else{
        return _nameArray.count;
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.textLabel.font=[UIFont systemFontOfSize:15];
    cell.textLabel.alpha=.6;
    if (_lastBtn.tag==1) {
        NSLog(@"11111111");
      cell.textLabel.text=_nameArray2[indexPath.row];
    }else{
          NSLog(@"000000");
      cell.textLabel.text=_nameArray[indexPath.row];
    }
    
    return cell;
    
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
