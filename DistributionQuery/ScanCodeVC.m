//
//  ScanCodeVC.m
//  DistributionQuery
//
//  Created by Macx on 16/10/8.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "ScanCodeVC.h"
#import "ScanCodeCell.h"
@interface ScanCodeVC ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSMutableArray * dataArray;
@property(nonatomic,strong)UIView * view2;
@property(nonatomic,strong) UIButton * imageBtn;
@property(nonatomic,strong)UIImage * image1;


@end

@implementation ScanCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"发布预告";
     self.backHomeBtn.hidden=YES;
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lianjieClink:) name:@"nil" object:nil];
    [self dataArr];
    [self CreatTableView];

}
#pragma mark --接收的通知1清空数据
-(void)lianjieClink:(NSNotification*)notification{
    ScanCodeCell * cell0 =[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    ScanCodeCell * cell1 =[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    
    ScanCodeCell * cell2 =[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    
    // ScanCodeCell * cell3 =[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    _image1=nil;
    
    cell0.textview.text=nil;
    cell1.textview.text=nil;
    cell2.textview.text=nil;
    [_tableView reloadData];
    
}
-(void)dataArr{
    NSArray * arr1 =@[@"预 告 标 题"];
    NSArray * arr2=@[@"资产处理人",@"预 告 内 容"];
    NSArray * arr3=@[@"预 告 图 片"];
    _dataArray=[[NSMutableArray alloc]initWithObjects:arr1,arr2,arr3, nil];
}
-(void)CreatTableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-49) style:UITableViewStylePlain];
    }
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.tableFooterView=[UIView new];
    _tableView.backgroundColor=BG_COLOR;
    _tableView.keyboardDismissMode=UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:_tableView];
    [self commentBtn];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray[section] count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld", (long)[indexPath section], (long)[indexPath row]];
    ScanCodeCell * cell =[ScanCodeCell cellWithTableView:tableView CellID:CellIdentifier];
    cell.leftLabel.text=_dataArray[indexPath.section][indexPath.row];
    if (indexPath.section==0) {
        //预告标题
    }else if (indexPath.section==1){
        if (indexPath.row==0) {
            //资产处理人
        }else{
            //预告内容
        }
    }else{
        //预告图片
        cell.textview.hidden=YES;
        cell.bgScrollview.hidden=NO;
        [self CreatBtn:cell];
    }
    return cell;
}

-(void)CreatBtn:(ScanCodeCell*)cell{
    [_imageBtn removeFromSuperview];
     UIButton *  imageBtn =[UIButton buttonWithType:UIButtonTypeCustom];
   
    if (_image1) {
        [imageBtn setBackgroundImage:_image1 forState:0];
    }else{
      [imageBtn setBackgroundImage:[UIImage imageNamed:@"rz_pic"] forState:0];
    }
    _imageBtn=imageBtn;
    [imageBtn addTarget:self action:@selector(xuanzeImageBtn) forControlEvents:UIControlEventTouchUpInside];
    [cell.bgScrollview sd_addSubviews:@[imageBtn]];
    imageBtn.sd_layout
    .leftSpaceToView(cell.bgScrollview,0)
    .topSpaceToView(cell.bgScrollview,0)
    .widthIs(162/2)
    .heightIs(122/2);
}


-(void)xuanzeImageBtn{
    UIAlertController * actionView =[UIAlertController alertControllerWithTitle:@"请选择照片来源" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * action1 =[UIAlertAction actionWithTitle:@"相机" style:0 handler:^(UIAlertAction * _Nonnull action) {
        
        // 先判断相机是否可用
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            // 把imagePicker.sourceType改为相机
            UIImagePickerController * imagePicker=[[UIImagePickerController alloc]init];
            imagePicker.delegate =self;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }else
        {
            [LCProgressHUD showMessage:@"相机不可用"];
        }
        
        
    }];
    UIAlertAction * action2 =[UIAlertAction actionWithTitle:@"相册" style:0 handler:^(UIAlertAction * _Nonnull action){
        [self headImageClick];
    }];
    UIAlertAction * action3 =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [actionView addAction:action1];
    [actionView addAction:action2];
    [actionView addAction:action3];
    [self presentViewController:actionView animated:YES completion:nil];
    
    
    
}
#pragma mark --创建提交按钮
-(void)commentBtn{
    
    UIButton * imageBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    imageBtn.backgroundColor=BG_COLOR;
   // [imageBtn setImage:[UIImage imageNamed:@"fbyg_bt"] forState:0];
    imageBtn.layer.cornerRadius=5;
    imageBtn.clipsToBounds=YES;
    imageBtn.backgroundColor=[UIColor redColor];
    [imageBtn setTitle:@"确认提交" forState:0];
    [imageBtn addTarget:self action:@selector(commentBtnn) forControlEvents:UIControlEventTouchUpInside];
    if (ScreenWidth==320) {
      imageBtn.frame=CGRectMake(15, ScreenHeight-64-49-50, ScreenWidth-30, 35);
        imageBtn.titleLabel.font=[UIFont systemFontOfSize:13];
    }else{
       imageBtn.frame=CGRectMake(10, ScreenHeight-64-49-50, ScreenWidth-20, 45);
         imageBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    }
    
   
    [_tableView addSubview:imageBtn];
//    imageBtn.sd_layout
//    .leftSpaceToView(self.view,10)
//    .rightSpaceToView(self.view,10)
//    .topSpaceToView(_view2,30)
//    .heightIs(45);
    
}
-(void)commentBtnn{
    NSLog(@"4>>>%@",_image1);
    ScanCodeCell * cell0 =[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSLog(@"1>>>%@",cell0.textview.text);
    
    ScanCodeCell * cell1 =[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    NSLog(@"2>>>%@",cell1.textview.text);
    
    ScanCodeCell * cell2 =[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    NSLog(@"3>>>%@",cell2.textview.text);
    [LCProgressHUD showMessage:@"正在发布..."];
    [Engine pubulicYuGaoTitle:[ToolClass isString:[NSString stringWithFormat:@"%@",cell0.textview.text]] People:[ToolClass isString:[NSString stringWithFormat:@"%@",cell1.textview.text]] Content:[ToolClass isString:[NSString stringWithFormat:@"%@",cell2.textview.text]] Pic:_image1 success:^(NSDictionary *dic) {
        NSString * code =[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
        [LCProgressHUD showMessage:[dic objectForKey:@"msg"]];
        if ([code isEqualToString:@"1"]) {
             [[NSNotificationCenter defaultCenter] postNotificationName:@"nil" object:nil userInfo:dic];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            
        }
    } error:^(NSError *error) {
        
    }];
}










-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 80;
    }else if (indexPath.section==2){
        return 126;
    }
    else{
        return 44;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section==2) {
        return 15;
    }
    return 5;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark --调用系统相册
-(void)headImageClick{
    UIImagePickerController * imagePicker =[UIImagePickerController new];
    
    imagePicker.delegate = self;
    imagePicker.sourceType=UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    imagePicker.allowsEditing=YES;
    imagePicker.navigationController.navigationBar.barTintColor = [UIColor redColor];
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    NSLog(@"%@",editingInfo);
    
    //[_imageBtn setBackgroundImage:image forState:0];
    _image1=image;
    //虚化背景图片
    [self dismissViewControllerAnimated:YES completion:nil];
    [_tableView reloadData];
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
