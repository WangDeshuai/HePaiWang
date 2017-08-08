//
//  ScanCodeVC.m
//  DistributionQuery
//
//  Created by Macx on 16/10/8.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "ScanCodeVC.h"
#import "ScanCodeCell.h"
@interface ScanCodeVC ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextViewDelegate>
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSMutableArray * dataArray;
@property(nonatomic,strong)UIView * view2;
@property(nonatomic,strong) UIButton * imageBtn;
@property(nonatomic,strong)NSMutableArray * image1;
@property(nonatomic,strong)UITextView * contentTextview;


@end

@implementation ScanCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"发布预告";
    
    
    if (_tagg==1) {
         self.backHomeBtn.hidden=NO;
    }else{
         self.backHomeBtn.hidden=YES;
    }
    
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lianjieClink:) name:@"nil" object:nil];
    [self dataArr];
    [self CreatTableView];
    [self addFooterButton];
}

-(void)addFooterButton
{
    
    UIView * footView =[UIView new];
    footView.backgroundColor=BG_COLOR;
    footView.frame=CGRectMake(0, 10, ScreenWidth, 100);
    
    // 1.初始化Button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    //    //2.设置文字和文字颜色
    [button setTitle:@"提交" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    //3.设置圆角幅度
    button.layer.cornerRadius = 10.0;
    //
    [button addTarget:self action:@selector(commentBtnn) forControlEvents:UIControlEventTouchUpInside];
    //    //4.设置frame
    button.frame =CGRectMake(30, 30, ScreenWidth-60, 40);;
    //
    //    //5.设置背景色
    button.backgroundColor = [UIColor redColor];
    
    [footView addSubview:button];
    self.tableView.tableFooterView = footView;
}


#pragma mark --接收的通知1清空数据
-(void)lianjieClink:(NSNotification*)notification{
    ScanCodeCell * cell0 =[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    ScanCodeCell * cell1 =[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    //ScanCodeCell * cell2 =[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    _contentTextview.text=@"请输入发布预告内容...";
    _contentTextview.textColor=[UIColor lightGrayColor];
     ScanCodeCell * cell3 =[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    _image1=nil;
    [_image1 removeAllObjects];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dismiss" object:nil userInfo:nil];
    cell0.textview.text=nil;
    cell1.textview.text=nil;
    cell3.textview.text=nil;
    [_tableView reloadData];
    
}
-(void)dataArr{
    NSArray * arr1 =@[@"*预告标题",@"*联系方式",@"*预告内容"];
    NSArray * arr2=@[@"资产处置人"];
    NSArray * arr3=@[@"预告图片"];
    _dataArray=[[NSMutableArray alloc]initWithObjects:arr1,arr2,arr3, nil];
}
-(void)CreatTableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-49) style:UITableViewStylePlain];
    }
    _tableView.delegate=self;
    _tableView.dataSource=self;
//    _tableView.tableFooterView=[UIView new];
    _tableView.backgroundColor=BG_COLOR;
    _tableView.keyboardDismissMode=UIScrollViewKeyboardDismissModeOnDrag;
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
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld", (long)[indexPath section], (long)[indexPath row]];
    ScanCodeCell * cell =[ScanCodeCell cellWithTableView:tableView CellID:CellIdentifier];
    cell.leftLabel.text=_dataArray[indexPath.section][indexPath.row];
    if (indexPath.section==0) {
       
        if (indexPath.row==0) {
            //预告标题
            cell.textview.placeholder=@"预告标题不能为空";
        }
        else if (indexPath.row==1){
            //联系方式
            cell.textview.placeholder=@"手机号不能为空";
        }else{
            //预告内容
            cell.textview.hidden=YES;
        }
    }else if (indexPath.section==1){
        if (indexPath.row==0) {
            //资产处理人
            cell.textview.placeholder=@"资产请填写资产处理人姓名";
        }
    }else{
        //预告图片
        cell.textview.hidden=YES;
        cell.collectionView.hidden=NO;
        cell.deleteTe=self;
        cell.photoArrImageBlock=^(NSMutableArray*arr){
            _image1=arr;
        };

    }
    return cell;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView * footview =[UIView new];
    footview.backgroundColor=[UIColor whiteColor];
    if (section==0) {
        
        UIView * linview =[UIView new];
        linview.backgroundColor=BG_COLOR;
        [footview sd_addSubviews:@[linview]];
        linview.sd_layout
        .leftSpaceToView(footview,0)
        .rightSpaceToView(footview,0)
        .topSpaceToView(footview,1)
        .heightIs(1);
        
        
        UITextView * textview =[UITextView new];
        textview.text=@"请输入发布预告内容...";
        textview.textColor=[UIColor lightGrayColor];
        textview.delegate=self;
        _contentTextview=textview;
        if (ScreenWidth==320) {
             textview.font=[UIFont systemFontOfSize:13];
        }else{
            textview.font=[UIFont systemFontOfSize:16];
        }
       
        textview.backgroundColor=[UIColor whiteColor];
        [footview sd_addSubviews:@[textview]];
        textview.sd_layout
        .leftSpaceToView(footview,15)
        .rightSpaceToView(footview,15)
        .topSpaceToView(footview,10)
        .bottomSpaceToView(footview,5);
        
        
        return footview;
    }else if (section==1){
        return nil;
    }else{
        return nil;
    }
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==0) {
        return 80;
    }else{
        return 0;
    }
}



-(void)textViewDidBeginEditing:(UITextView*)textView{
    if ([textView.text isEqualToString:@"请输入发布预告内容..."])
    {
        textView.text=@"";
        textView.textColor=[UIColor blackColor];
    }
}
-(void)textViewDidEndEditing:(UITextView*)textView{
    if(textView.text.length<1){
        textView.text=@"请输入发布预告内容...";
        textView.textColor=JXColor(76, 76, 76, 1);
    }
    
}
#pragma mark --提交按钮
-(void)commentBtnn{
    NSLog(@"4>>>%@",_image1);
    //预告标题
    ScanCodeCell * cell0 =[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSLog(@"1>>>%@",cell0.textview.text);
    //联系方式
    ScanCodeCell * cell1 =[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    NSLog(@"2>>>%@",cell1.textview.text);
    //预告内容
    
    NSLog(@"3>>>%@",_contentTextview.text);
    //资产处置人
     ScanCodeCell * cell3 =[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    [LCProgressHUD showLoading:@"正在发布..."];

    [Engine pubulicYuGaoTitle:[ToolClass isString:[NSString stringWithFormat:@"%@",cell0.textview.text]] People:[ToolClass isString:[NSString stringWithFormat:@"%@",cell3.textview.text]] Content:[ToolClass isString:[NSString stringWithFormat:@"%@",_contentTextview.text ]]Pic:_image1 Phone:[ToolClass isString:[NSString stringWithFormat:@"%@",cell1.textview.text]] success:^(NSDictionary *dic) {
        NSString * code =[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
       
        if ([code isEqualToString:@"1"]) {
             [[NSNotificationCenter defaultCenter] postNotificationName:@"nil" object:nil userInfo:dic];
            [self.navigationController popViewControllerAnimated:YES];
            [LCProgressHUD hide];
            UIAlertController * actionview=[UIAlertController alertControllerWithTitle:@"温馨提示" message:[dic objectForKey:@"msg"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * action =[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
           
            [actionview addAction:action];
            [self presentViewController:actionview animated:YES completion:nil];
            
        }else{
             [LCProgressHUD showMessage:[dic objectForKey:@"msg"]];
        }
    } error:^(NSError *error) {
        
    }];
}










-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 44;
    }else if (indexPath.section==2){
        return 126;
    }
    else{
        return 44;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
//    if (section==2) {
//        return 15;
//    }
    return 5;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

//#pragma mark --调用系统相册
//-(void)headImageClick{
//    UIImagePickerController * imagePicker =[UIImagePickerController new];
//    
//    imagePicker.delegate = self;
//    imagePicker.sourceType=UIImagePickerControllerSourceTypeSavedPhotosAlbum;
//    imagePicker.allowsEditing=YES;
//    imagePicker.navigationController.navigationBar.barTintColor = [UIColor redColor];
//    [self presentViewController:imagePicker animated:YES completion:nil];
//    
//}
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
//{
//    NSLog(@"%@",editingInfo);
//    
//    //[_imageBtn setBackgroundImage:image forState:0];
//    _image1=image;
//    //虚化背景图片
//    [self dismissViewControllerAnimated:YES completion:nil];
//    [_tableView reloadData];
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
