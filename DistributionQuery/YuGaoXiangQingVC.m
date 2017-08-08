//
//  YuGaoXiangQingVC.m
//  DistributionQuery
//
//  Created by Macx on 16/12/1.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "YuGaoXiangQingVC.h"
#import "YuGaoXiangQingCell.h"
#import "MyPublicYuGaoModel.h"
#import "XiuGaiYGVC.h"

@interface YuGaoXiangQingVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSMutableArray * dataArray;
@property(nonatomic,strong)MyPublicYuGaoModel * md;
@property(nonatomic,strong)NSMutableArray * arraynew;
@property(nonatomic,strong)NSMutableArray * arrayold;
@end

@implementation YuGaoXiangQingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"发布预告详情";
//    [self CreatView1];
//     [self CreatView2];
//     [self CreatView3];
    [self CreatData];
    [self XiangQing];
    [self CreatTabelView];
    [self CreatRightBtn];
}

-(void)XiangQing{
    [Engine myPublicYuGaoID:_idd success:^(NSDictionary *dic) {
        NSString * code =[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            NSDictionary * dicContent =[dic objectForKey:@"content"];
            MyPublicYuGaoModel * md =[[MyPublicYuGaoModel alloc]initWithMyPublicDic:dicContent];
            _md=md;
            [_tableView reloadData];
        }else{
            [LCProgressHUD showMessage:[dic objectForKey:@"msg"]];
        }
    } error:^(NSError *error) {
        
    }];
}

-(void)CreatRightBtn{
    UIButton*  backHomeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [backHomeBtn setTitle:@"提交" forState:0];
    [backHomeBtn setTitleColor:[UIColor whiteColor] forState:0];
    backHomeBtn.frame=CGRectMake(0, 0, 100, 30);
    backHomeBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    backHomeBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
    [backHomeBtn addTarget:self action:@selector(rightBtnClink) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftBtn2 =[[UIBarButtonItem alloc]initWithCustomView:backHomeBtn];
    self.navigationItem.rightBarButtonItems=@[leftBtn2];
}
-(void)rightBtnClink{
    
    //预告标题
    YuGaoXiangQingCell * cell0 =[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSLog(@"1>>>%@",cell0.textview.text);
    //联系方式
    YuGaoXiangQingCell * cell1 =[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    NSLog(@"2>>>%@",cell1.textview.text);
    //预告内容
    
  
    //资产处置人
    YuGaoXiangQingCell * cell3 =[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    
    NSLog(@">>>>>%@>>>%@>>>>>%@",cell0.textview.text,cell1.textview.text,cell3.textview.text);
    
    
    
      NSLog(@"旧的>>>%lu",_arrayold.count);
    NSLog(@">>>>新的%lu",_arraynew.count);
    [LCProgressHUD showLoading:@"正在修改..."];
    [Engine xiuGaiYiFaBuID:_idd Title:[ToolClass isString:[NSString stringWithFormat:@"%@",cell0.textview.text]] Phone:[ToolClass isString:[NSString stringWithFormat:@"%@",cell1.textview.text]] Peolpe:[ToolClass isString:[NSString stringWithFormat:@"%@",cell3.textview.text]] oldArr:_arrayold NewArr:_arraynew success:^(NSDictionary *dic) {
        NSString * code =[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
        [LCProgressHUD showMessage:[dic objectForKey:@"msg"]];
        if ([code isEqualToString:@"1"]) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            
        }
    } error:^(NSError *error) {
        
    }];
}
-(void)CreatData{
    NSArray * arr1 =@[@"*预告标题",@"*联系方式",@"*预告内容"];
    NSArray * arr2=@[@"资产处置人"];
    NSArray * arr3=@[@"预告图片(长按可以删除)",@""];
    _dataArray=[[NSMutableArray alloc]initWithObjects:arr1,arr2,arr3, nil];
}
#pragma mark --创建表格
-(void)CreatTabelView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];
    }
    _tableView.tableFooterView=[UIView new];
    _tableView.backgroundColor=BG_COLOR;
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.keyboardDismissMode=UIScrollViewKeyboardDismissModeOnDrag;
    
    [self.view sd_addSubviews:@[_tableView]];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray[section] count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YuGaoXiangQingCell * cell =[YuGaoXiangQingCell cellWithTableView:tableView IndexPath:indexPath];
    cell.leftLabel.text=_dataArray[indexPath.section][indexPath.row];
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            //预告标题
            cell.textview.text=_md.titleName;
        }else if (indexPath.row==1){
            //联系方式
            cell.textview.text=_md.phone;
        }else if (indexPath.row==2){
            //预告内容
            cell.textview.text=_md.yuGaoContent;
             cell.textview.enabled=NO;
        }
    }else if (indexPath.section==1){
        //资产处置人
        cell.textview.text=_md.yuGaoPeople;
    }else{
        cell.textview.enabled=NO;
        if(indexPath.row==0){
            //照片数组
            cell.picContainerView.hidden=NO;
            cell.imageArr=_md.imageArr;
             _arrayold=_md.imageArr;
            cell.picContainerView.tapBlock=^(NSInteger tag){
                UIAlertController * actionview=[UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否确认删除" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * action =[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    [_md.imageArr removeObjectAtIndex:tag];
                    _arrayold=_md.imageArr;
                    [_tableView reloadData];
                    
                }];
                UIAlertAction * action2 =[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:nil];
                [actionview addAction:action];
                [actionview addAction:action2];
                [self presentViewController:actionview animated:YES completion:nil];
            };
        }else if (indexPath.row==1){
            cell.collectionView.hidden=NO;
            cell.deleteTe=self;
            cell.photoArrImageBlock=^(NSMutableArray*arr){
               // _image1=arr;
                
                NSInteger new1 =arr.count;
                NSInteger old1 =[_arrayold count];
                NSLog(@">>>%lu>>>%lu>>>%lu>>>%lu",new1,old1,arr.count,_arrayold.count);
                if ( new1+old1 >6) {
                    UIAlertController * actionview=[UIAlertController alertControllerWithTitle:@"温馨提示" message:@"图片总共限制6张，请删除多余的图片，否则不能上传" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction * action =[UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    }];
                    
                    [actionview addAction:action];
                    [self presentViewController:actionview animated:YES completion:nil];
                }else{
                    _arraynew=arr;
                }
                
                
//
//                NSLog(@">>>%lu>>>%lu",,);
            };
        }
        
        
        
     
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        if (indexPath.row==2) {
            //预告内容
            XiuGaiYGVC * vc=[XiuGaiYGVC new];
            vc.strContent=_md.yuGaoContent;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}







-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==2) {
        return    [_tableView cellHeightForIndexPath:indexPath model:_md.imageArr keyPath:@"imageArr" cellClass:[YuGaoXiangQingCell class] contentViewWidth:[ToolClass  cellContentViewWith]]+20;
;
    }else{
      return 50;
    }
   
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
//-(void)CreatView1{
//    _view1=[UIView new];
//    _view1.backgroundColor=[UIColor whiteColor];
//    [self.view sd_addSubviews:@[_view1]];
//    _view1.sd_layout
//    .leftSpaceToView(self.view,0)
//    .rightSpaceToView(self.view,0)
//    .topSpaceToView(self.view,5);
//    //label
//    UILabel * namelabel =[UILabel new];
//    namelabel.text=@"预告标题";
//    namelabel.font=[UIFont systemFontOfSize:16];
//    [_view1 sd_addSubviews:@[namelabel]];
//    namelabel.sd_layout
//    .leftSpaceToView(_view1,15)
//    .topSpaceToView(_view1,15)
//    .heightIs(20);
//    [namelabel setSingleLineAutoResizeWithMaxWidth:120];
//    //contenLabel
//    UILabel * contentLabel =[UILabel new];
//    contentLabel.text=_model.titleName;//@"瓷砖贴膜机 自动磨边机等机器设备一批拍卖公告";
//    
//    contentLabel.numberOfLines=0;
//    contentLabel.alpha=.6;
//    contentLabel.font=[UIFont systemFontOfSize:16];
//    [_view1 sd_addSubviews:@[contentLabel]];
//    contentLabel.sd_layout
//    .leftSpaceToView(namelabel,10)
//    .topEqualToView(namelabel)
//    .rightSpaceToView(_view1,15)
//    .autoHeightRatio(0);
//    
//    [_view1 setupAutoHeightWithBottomView:contentLabel bottomMargin:15];
//    
//    
//}
//
//-(void)CreatView2{
//    _view2=[UIView new];
//    _view2.backgroundColor=[UIColor whiteColor];
//    [self.view sd_addSubviews:@[_view2]];
//    _view2.sd_layout
//    .leftSpaceToView(self.view,0)
//    .rightSpaceToView(self.view,0)
//    .topSpaceToView(_view1,5);
//    //label
//    UILabel * namelabel =[UILabel new];
//    namelabel.text=@"资产处理人";
//    namelabel.font=[UIFont systemFontOfSize:16];
//    [_view2 sd_addSubviews:@[namelabel]];
//    namelabel.sd_layout
//    .leftSpaceToView(_view2,15)
//    .topSpaceToView(_view2,15)
//    .heightIs(20);
//    [namelabel setSingleLineAutoResizeWithMaxWidth:120];
//    //name
//    UILabel * contentLabel1 =[UILabel new];
//    contentLabel1.text=_model.yuGaoPeople;//@"大头旋";
//    contentLabel1.numberOfLines=0;
//    contentLabel1.alpha=.6;
//    contentLabel1.font=[UIFont systemFontOfSize:16];
//    [_view2 sd_addSubviews:@[contentLabel1]];
//    contentLabel1.sd_layout
//    .topEqualToView(namelabel)
//    .rightSpaceToView(_view2,15)
//    .heightIs(20);
//    [contentLabel1 setSingleLineAutoResizeWithMaxWidth:220];
//    
//    //线条
//    UIView * lineView =[UIView new];
//    lineView.backgroundColor=BG_COLOR;
//    [_view2 sd_addSubviews:@[lineView]];
//    lineView.sd_layout
//    .leftSpaceToView(_view2,0)
//    .rightSpaceToView(_view2,0)
//    .topSpaceToView(namelabel,15)
//    .heightIs(1);
//
//    //label2
//    UILabel * namelabel2 =[UILabel new];
//    namelabel2.text=@"预告内容";
//    namelabel2.font=[UIFont systemFontOfSize:16];
//    [_view2 sd_addSubviews:@[namelabel2]];
//    namelabel2.sd_layout
//    .leftSpaceToView(_view2,15)
//    .topSpaceToView(lineView,15)
//    .heightIs(20);
//    [namelabel2 setSingleLineAutoResizeWithMaxWidth:120];
//    //name2
//    UILabel * contentLabel2 =[UILabel new];
//    contentLabel2.text=_model.yuGaoContent;//@"大头大头大头大头大头大头大头旋大头大头大头旋大头大头大头旋大头大头大头旋大头大头大头旋大头大头大头旋";
//    contentLabel2.numberOfLines=0;
//    contentLabel2.alpha=.6;
//    contentLabel2.font=[UIFont systemFontOfSize:16];
//    [_view2 sd_addSubviews:@[contentLabel2]];
//    contentLabel2.sd_layout
//    .topSpaceToView(lineView,15)
//    .rightSpaceToView(_view2,15)
//    .leftSpaceToView(namelabel2,15)
//    .autoHeightRatio(0);
//   
//    [_view2 setupAutoHeightWithBottomView:contentLabel2 bottomMargin:15];
//    
//    
//}
//-(void)CreatView3{
//    _view3=[UIView new];
//    _view3.backgroundColor=[UIColor whiteColor];
//    [self.view sd_addSubviews:@[_view3]];
//    _view3.sd_layout
//    .leftSpaceToView(self.view,0)
//    .rightSpaceToView(self.view,0)
//    .topSpaceToView(_view2,5);
//    //label
//    UILabel * namelabel =[UILabel new];
//    namelabel.text=@"预告图片";
//    namelabel.font=[UIFont systemFontOfSize:16];
//    [_view3 sd_addSubviews:@[namelabel]];
//    namelabel.sd_layout
//    .leftSpaceToView(_view3,15)
//    .topSpaceToView(_view3,15)
//    .heightIs(20);
//    [namelabel setSingleLineAutoResizeWithMaxWidth:120];
//    //图片
//    UIImageView * imageview =[[UIImageView alloc]init];
//   // imageview.image=[UIImage imageNamed:@"login_logo"];
//    [imageview setImageWithURL:[NSURL URLWithString:_model.yuGaoImage] placeholderImage:[UIImage imageNamed:@"login_logo"]];
//    [_view3 sd_addSubviews:@[imageview]];
//    imageview.sd_layout
//    .topSpaceToView(_view3,20)
//    .leftSpaceToView(namelabel,10)
//    .widthIs(153/2)
//    .heightIs(204/2);
//    [_view3 setupAutoHeightWithBottomView:imageview bottomMargin:15];
//}
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
