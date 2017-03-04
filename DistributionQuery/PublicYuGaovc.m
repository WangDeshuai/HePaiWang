//
//  PublicYuGaovc.m
//  DistributionQuery
//
//  Created by Macx on 16/11/29.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "PublicYuGaovc.h"

@interface PublicYuGaovc ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSMutableArray * dataArray;
@property(nonatomic,strong)UIView * view2;
@property(nonatomic,strong) UIButton * imageBtn;
@property(nonatomic,strong)UIImage * image1;
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
        
        UITextView * textview =[UITextView new];
        textview.tag=2;
        [cell sd_addSubviews:@[textview]];
        UILabel * titleLabel =[UILabel new];
        titleLabel.tag=3;
        [cell sd_addSubviews:@[titleLabel]];
    }
    UILabel * titleLabel =[cell viewWithTag:3];
    titleLabel.alpha=.7;
    titleLabel.text=_dataArray[indexPath.section][indexPath.row];
    titleLabel.font=[UIFont systemFontOfSize:15];
    titleLabel.sd_layout
    .leftSpaceToView(cell,15)
    .centerYEqualToView(cell)
    .heightIs(20);
    [titleLabel setSingleLineAutoResizeWithMaxWidth:100];
    
    UITextField * nameLabel =(UITextField*)[cell viewWithTag:1];
    nameLabel.alpha=.6;
    nameLabel.font=[UIFont systemFontOfSize:15];
    nameLabel.sd_layout
    .rightSpaceToView(cell,15)
    .leftSpaceToView(titleLabel,10)
    .centerYEqualToView(cell)
    .heightIs(30);
    nameLabel.backgroundColor=[UIColor redColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;

    
    UITextView * textview =[cell viewWithTag:2];
    textview.backgroundColor=[UIColor yellowColor];
    textview.font=[UIFont systemFontOfSize:15];
    textview.alpha=.6;
    textview.sd_layout
    .leftSpaceToView(titleLabel,10)
    .rightSpaceToView(cell,15)
    .topSpaceToView(cell,5)
    .bottomSpaceToView(cell,5);
    
   
    
    
    if (indexPath.section==0) {
        //标题预告
        nameLabel.hidden=YES;
        titleLabel.sd_layout
        .leftSpaceToView(cell,15)
        .topSpaceToView(cell,13)
        .heightIs(20);
        [titleLabel setSingleLineAutoResizeWithMaxWidth:100];
    }
   else if (indexPath.section==1) {
       textview.hidden=YES;
        nameLabel.textAlignment=2;
       if (indexPath.row==0) {
           //资产处理人
           nameLabel.placeholder=@"未填写处理人";
       }
       else if (indexPath.row==1) {
           //预告内容
           nameLabel.placeholder=@"未填写预告内容";

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
    _imageBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [_imageBtn setBackgroundImage:[UIImage imageNamed:@"rz_pic"] forState:0];
    [_imageBtn addTarget:self action:@selector(xuanzeImageBtn) forControlEvents:UIControlEventTouchUpInside];
    [_view2 sd_addSubviews:@[_imageBtn]];
    _imageBtn.sd_layout
    .leftSpaceToView(nameLabel,15)
    .topSpaceToView(nameLabel,0)
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
    [imageBtn setImage:[UIImage imageNamed:@"fbyg_bt"] forState:0];
    [imageBtn addTarget:self action:@selector(commentBtnn) forControlEvents:UIControlEventTouchUpInside];
    [self.view sd_addSubviews:@[imageBtn]];
    imageBtn.sd_layout
    .leftSpaceToView(self.view,10)
    .rightSpaceToView(self.view,10)
    .topSpaceToView(_view2,30)
    .heightIs(45);
    
}
-(void)commentBtnn{
    NSLog(@"4>>>%@",_image1);
    UITableViewCell * cell0 =[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UITextView * textview =[cell0 viewWithTag:2];
    NSLog(@"1>>>%@",textview.text);
    
    UITableViewCell * cell1 =[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    UITextField * textfield =[cell1 viewWithTag:1];
     NSLog(@"2>>>%@",textfield.text);
    
    UITableViewCell * cell2 =[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    UITextField * textfield2 =[cell2 viewWithTag:1];
    NSLog(@"3>>>%@",textfield2.text);
    
    [Engine pubulicYuGaoTitle:[ToolClass isString:[NSString stringWithFormat:@"%@",textview.text]] People:[ToolClass isString:[NSString stringWithFormat:@"%@",textfield.text]] Content:[ToolClass isString:[NSString stringWithFormat:@"%@",textfield2.text]] Pic:_image1 success:^(NSDictionary *dic) {
        NSString * code =[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
        [LCProgressHUD showMessage:[dic objectForKey:@"msg"]];
        if ([code isEqualToString:@"1"]) {
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
    
    [_imageBtn setBackgroundImage:image forState:0];
    _image1=image;
    //虚化背景图片
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
