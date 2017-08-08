//
//  WeiTuoPaiMaiCell.m
//  DistributionQuery
//
//  Created by Macx on 16/11/23.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "WeiTuoPaiMaiCell.h"
#import "TZImagePickerController.h"
#import "UIView+Layout.h"
#import "TZTestCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
@interface WeiTuoPaiMaiCell()<TZImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    BOOL _isSelectOriginalPhoto;
    
    CGFloat _itemWH;
    CGFloat _margin;
}
@end
@implementation WeiTuoPaiMaiCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+(instancetype)cellWithTableView:(UITableView*)tableView CellID:(NSString*)cellID{
    WeiTuoPaiMaiCell * cell =[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell=[[WeiTuoPaiMaiCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //  self.backgroundColor=[UIColor colorWithRed:254/255.0 green:251/255.0 blue:224/255.0 alpha:1];
        [self CreatStar];
    }
    return self;
}
-(void)CreatStar{
    _nameLabel=[UILabel new];
    _textfield=[UITextField new];
    _bgScrollview=[UIScrollView new];
     _codeBtn=[UIButton new];
    [self.contentView sd_addSubviews:@[_nameLabel,_textfield,_codeBtn,_bgScrollview]];
   //属性
    
    _nameLabel.alpha=.8;
    if (ScreenWidth==320) {
         _textfield.font=[UIFont systemFontOfSize:14];
        _nameLabel.font=[UIFont systemFontOfSize:14];
    }else{
         _textfield.font=[UIFont systemFontOfSize:16];
        _nameLabel.font=[UIFont systemFontOfSize:16];
    }
    _textfield.alpha=.8;
    _codeBtn.hidden=YES;
    _codeBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    _codeBtn.sd_cornerRadius=@(5);
    //赋值
   _codeBtn.backgroundColor=[UIColor colorWithRed:242/255.0 green:142/255.0 blue:146/255.0 alpha:1];
    [_codeBtn setTitle:@"获取验证码" forState:0];
    //坐标
    //nameLabel
    _nameLabel.sd_layout
    .leftSpaceToView(self.contentView,15)
    .topSpaceToView(self.contentView,15)
    .widthIs(90)
    .heightIs(20);
    //textField
    _textfield.sd_layout
    .leftSpaceToView(_nameLabel,10)
    .rightSpaceToView(self.contentView,5)
    .centerYEqualToView(_nameLabel)
    .heightIs(30);
    //按钮
    _codeBtn.sd_layout
    .rightSpaceToView(self.contentView,15)
    .centerYEqualToView(_nameLabel)
    .widthIs(90)
    .heightIs(30);
    //滚动试图
    _bgScrollview.hidden=YES;
    _bgScrollview.sd_layout
    .leftSpaceToView(self.contentView,15)
    .topSpaceToView(_nameLabel,15)
    .bottomSpaceToView(self.contentView,15)
    .rightSpaceToView(self.contentView,15);
    [self configCollectionView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lianjieClink:) name:@"dismissWeiTuo" object:nil];

}
-(void)lianjieClink:(NSNotification*)notification{
    [_selectedPhotos removeAllObjects];
    [_selectedAssets removeAllObjects];
    [_collectionView reloadData];
}
- (void)configCollectionView {
    // 如不需要长按排序效果，将LxGridViewFlowLayout类改成UICollectionViewFlowLayout即可
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _margin = 4;
    _itemWH = (self.tz_width - 2 * _margin - 4) / 4 - _margin;
    layout.itemSize = CGSizeMake(_itemWH, _itemWH);
    layout.minimumInteritemSpacing = _margin;
    layout.minimumLineSpacing = _margin;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, self.tz_width, self.tz_height - 409) collectionViewLayout:layout];
    _collectionView.hidden=YES;
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.contentInset = UIEdgeInsetsMake(4, 4, 4, 4);
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.contentView sd_addSubviews:@[_collectionView]];
    _collectionView.sd_layout
    .leftSpaceToView(self.contentView,0)
    .rightSpaceToView(self.contentView,0)
    .topSpaceToView(_nameLabel,5)
    .bottomSpaceToView(self.contentView,0);
    [_collectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
        return _selectedPhotos.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
    
    cell.backgroundColor=[UIColor whiteColor];
    cell.videoImageView.hidden = YES;
    
    
        if (indexPath.row == _selectedPhotos.count) {
            
            cell.imageView.image = [UIImage imageNamed:@"rz_pic"];
            cell.deleteBtn.hidden = YES;
            cell.gifLable.hidden = YES;
            
        } else {
            cell.imageView.image = _selectedPhotos[indexPath.row];
            // cell.asset = _selectedAssets[indexPath.row];
            cell.deleteBtn.hidden = NO;
            cell.gifLable.hidden = YES;
        }
        //
        cell.deleteBtn.tag = indexPath.row;
        [cell.deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete"] forState:0];
        [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    
    
   
    
    
    return cell;
}

-(void)setPhotoArray:(NSArray *)photoArray
{
    _photoArray=photoArray;
    
    if (_selectedPhotos.count==0) {
        _selectedPhotos=[NSMutableArray new];
        _selectedAssets=[NSMutableArray new];
        for (NSString * strUrl in _photoArray) {
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:strUrl]]];
//            [_selectedAssets addObject:@""];
            [_selectedPhotos addObject:image];
            ALAsset * result=[[ALAsset alloc]init];
            [_selectedAssets addObject:result];
            
        }
    }
   
////    NSLog(@"输出数组个数>>%lu>>>%lu",_selectedPhotos.count,photoArray.count);
    [_collectionView reloadData];
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == _selectedPhotos.count) {
        [self pushImagePickerController];
    }
}

- (void)deleteBtnClik:(UIButton *)sender {
    [_selectedPhotos removeObjectAtIndex:sender.tag];
    [_selectedAssets removeObjectAtIndex:sender.tag];
    
    if (_selectedPhotos.count==0) {
        [NSUSE_DEFO setObject:@"手动" forKey:@"手动"];
        [NSUSE_DEFO synchronize];
    }
    self.photoArrImageBlock(_selectedPhotos);
    
    [_collectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
        [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [_collectionView reloadData];
    }];
}
- (void)pushImagePickerController {
    
    //最大选择的张数，每行展示的张数 NO
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9-_photoArray.count columnNumber:4  delegate:self pushPhotoPickerVc:YES];
    
    imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    if (_photoArray.count==0) {
         imagePickerVc.selectedAssets = _selectedAssets;
    }
    // 目前已经选中的图片数组
    imagePickerVc.naviTitleColor=[UIColor whiteColor];
    imagePickerVc.naviBgColor=[UIColor redColor];
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        NSLog(@"输出图片%@",photos);
        NSMutableArray * array=[NSMutableArray new];;
        [array removeAllObjects];
//        [array addObjectsFromArray:photos];
        [array addObjectsFromArray:_photoArray];
         NSLog(@"输出图片%lu",_selectedPhotos.count);
            self.photoArrImageBlock(_selectedPhotos);
    }];
    
    [_deleteTe presentViewController:imagePickerVc animated:YES completion:nil];
}



#pragma mark - TZImagePickerControllerDelegate
/// 用户点击了取消
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    NSLog(@"用户点击了取消");
}
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
//    NSLog(@"确认了>>>%lu",_photoArray.count);
    _selectedPhotos = [NSMutableArray new];
    _selectedAssets = [NSMutableArray new];
    _isSelectOriginalPhoto = isSelectOriginalPhoto;
   
    for (NSString * strUrl in _photoArray) {
        UIImage *image1 = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:strUrl]]];
            [_selectedPhotos addObject:image1];
        
            [_selectedAssets addObject:@""];
    }
    [_selectedPhotos addObjectsFromArray:photos];
    [_selectedAssets addObjectsFromArray:assets];
    [_collectionView reloadData];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void)refreshCollectionViewWithAddedAsset:(id)asset image:(UIImage *)image {
    [_selectedAssets addObject:asset];
    [_selectedPhotos addObject:image];
    [_collectionView reloadData];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
