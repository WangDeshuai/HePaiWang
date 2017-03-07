//
//  XiuGaiVC.m
//  DistributionQuery
//
//  Created by Macx on 17/3/6.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "XiuGaiVC.h"

@interface XiuGaiVC ()
@property(nonatomic,strong)UITextField * textfield;
@property(nonatomic,strong)NSArray * keyArray;
@end

@implementation XiuGaiVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"修改资料";
    //姓名、手机号
    if ([_tagg isEqualToString:@"1"]) {
         _keyArray=@[@"personal_name",@"personal_connect_tel"];
    }else{
    _keyArray=@[@"enterprise_name",@"enterprise_legal_person_name",@"enterprise_legal_person_id_card",@"enterprise_agent_name",@"enterprise_connect_tel"];
    }
   
    [self CreatRigthBtn];
    [self CreatTextField];
}
#pragma mark --创建textField
-(void)CreatTextField{
    _textfield=[[UITextField alloc]init];
    _textfield.placeholder=@"未填写";
    _textfield.backgroundColor=[UIColor whiteColor];
    _textfield.sd_cornerRadius=@(5);
    _textfield.font=[UIFont systemFontOfSize:15];
    [self.view sd_addSubviews:@[_textfield]];
    _textfield.sd_layout
    .leftSpaceToView(self.view,5)
    .rightSpaceToView(self.view,5)
    .topSpaceToView(self.view,20)
    .heightIs(35);
}
#pragma mark --创建右按钮
-(void)CreatRigthBtn{
    UIButton *fabu=[UIButton buttonWithType:UIButtonTypeCustom];
    [fabu setTitle:@"保存" forState:0];
    fabu.titleLabel.font=[UIFont systemFontOfSize:15];
    [fabu setTitleColor:[UIColor whiteColor] forState:0];
    fabu.frame=CGRectMake(0,0, 70, 20);
    [fabu addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightBtn =[[UIBarButtonItem alloc]initWithCustomView:fabu];
    self.navigationItem.rightBarButtonItem=rightBtn;
}
-(void)save{
    NSMutableArray * arr =[NSMutableArray new];
    NSMutableDictionary * dicc1 =[NSMutableDictionary new];
    
    [dicc1 setObject:_textfield.text forKey:@"fieldValue"];
    [dicc1 setObject:_keyArray[_indexrow] forKey:@"fieldName"];
    NSMutableDictionary * dicc2 =[NSMutableDictionary new];
    [dicc2 setObject:_tagg forKey:@"fieldValue"];//_tagg 1.个人 2.企业
    [dicc2 setObject:@"authentication_type" forKey:@"fieldName"];
    [arr addObject:dicc1];
    [arr addObject:dicc2];
    NSLog(@"输出%@",[ToolClass getJsonStringFromObject:arr]);
    [LCProgressHUD showMessage:@"请稍后..."];
    [Engine xiuGaiShiMingRenZhengMessageJsonStr:[ToolClass getJsonStringFromObject:arr]  success:^(NSDictionary *dic) {
        [LCProgressHUD showMessage:[dic objectForKey:@"msg"]];
        NSString * code =[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            self.messageBlock(_textfield.text);
            NSDictionary * dicc =[dic objectForKey:@"content"];
            NSMutableDictionary * dicAr = [ToolClass isDictionary:dicc];
            [ToolClass savePlist:dicAr name:@"shiMingInfo"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } error:^(NSError *error) {
        [LCProgressHUD showMessage:@"20网络错误"];
    }];
    

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
