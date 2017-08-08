//
//  ScanCodeCell.m
//  DistributionQuery
//
//  Created by Macx on 17/3/10.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "ScanCodeCell.h"
#import "TZImagePickerController.h"
#import "UIView+Layout.h"
#import "TZTestCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
@interface ScanCodeCell()<TZImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

{
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    BOOL _isSelectOriginalPhoto;
    
    CGFloat _itemWH;
    CGFloat _margin;
}
@end

@implementation ScanCodeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+(instancetype)cellWithTableView:(UITableView*)tableView CellID:(NSString*)cellID{
    ScanCodeCell * cell =[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell=[[ScanCodeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
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
    _leftLabel=[UILabel new];
    _textview=[UITextField new];
    _bgScrollview=[UIScrollView new];
    [self.contentView sd_addSubviews:@[_leftLabel,_textview,_bgScrollview]];
    
    _leftLabel.alpha=.7;
    _textview.alpha=.6;
    if (ScreenWidth==320) {
        _leftLabel.font=[UIFont systemFontOfSize:13];
        _textview.font=[UIFont systemFontOfSize:13];
    }else{
         _leftLabel.font=[UIFont systemFontOfSize:15];
         _textview.font=[UIFont systemFontOfSize:15];
    }
    
    
    _leftLabel.sd_layout
    .leftSpaceToView(self.contentView,15)
    .topSpaceToView(self.contentView,13)
    .widthIs(80)
    .heightIs(20);
    
    _textview.sd_layout
    .leftSpaceToView(_leftLabel,10)
    .rightSpaceToView(self.contentView,15)
    .topSpaceToView(self.contentView,5)
    .bottomSpaceToView(self.contentView,5);
    
//    _textview.layer.borderWidth=.5;
//    _textview.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _textview.textAlignment=2;
    
    _bgScrollview.hidden=YES;
//    _bgScrollview.backgroundColor=[UIColor yellowColor];
    _bgScrollview.sd_layout
    .leftSpaceToView(self.contentView,15)
    .topSpaceToView(_leftLabel,10)
    .rightSpaceToView(self.contentView,15)
    .bottomSpaceToView(self.contentView,13);
    
     [self configCollectionView];
//    _leftLabel.backgroundColor=[UIColor yellowColor];
//    _textview.backgroundColor=[UIColor magentaColor];
    //通知1清空照片数组等等
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lianjieClink:) name:@"dismiss" object:nil];
    
}
-(void)lianjieClink:(NSNotification*)notification{
    [_selectedPhotos removeAllObjects];
    [_selectedAssets removeAllObjects];
    [_collectionView reloadData];
}
- (void)configCollectionView {
    // 如不需要长按排序效果，将LxGridViewFlowLayout类改成UICollectionViewFlowLayout即可
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    if (ScreenWidth==320) {
        _margin = 25;
        _itemWH= (ScreenWidth-25*4)/3;
    }else{
        _margin = 4;
        _itemWH = (self.tz_width - 2 * _margin - 4) / 3 - _margin;
    }
   
    
    
   
    layout.itemSize = CGSizeMake(_itemWH, _itemWH);
    layout.minimumInteritemSpacing = _margin;
    layout.minimumLineSpacing = _margin;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 409) collectionViewLayout:layout];
    _collectionView.hidden=YES;
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.contentInset = UIEdgeInsetsMake(4, 25, 4, 25);
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.contentView sd_addSubviews:@[_collectionView]];
    _collectionView.sd_layout
    .leftSpaceToView(self.contentView,0)
    .rightSpaceToView(self.contentView,0)
    .topSpaceToView(_leftLabel,5)
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
        cell.asset = _selectedAssets[indexPath.row];
        cell.deleteBtn.hidden = NO;
    }
    //
    cell.deleteBtn.tag = indexPath.row;
    [cell.deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete"] forState:0];
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==1) {
        [LCProgressHUD showMessage:@"最多选择1张"];
        return;
    }
    
    
    if (indexPath.row == _selectedPhotos.count) {
        [self pushImagePickerController];
    }
}

- (void)deleteBtnClik:(UIButton *)sender {
    [_selectedPhotos removeObjectAtIndex:sender.tag];
    [_selectedAssets removeObjectAtIndex:sender.tag];
    
    [_collectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
        [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [_collectionView reloadData];
    }];
}
- (void)pushImagePickerController {
    
    //最大选择的张数，每行展示的张数 NO
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:6 columnNumber:4  delegate:self pushPhotoPickerVc:YES];
    
    imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    imagePickerVc.selectedAssets = _selectedAssets; // 目前已经选中的图片数组
    imagePickerVc.naviTitleColor=[UIColor whiteColor];
    imagePickerVc.naviBgColor=[UIColor redColor];
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        NSLog(@"输出图片%@",photos);
        NSMutableArray * array=[NSMutableArray new];;
        [array removeAllObjects];
        [array addObjectsFromArray:photos];
        self.photoArrImageBlock(array);
    }];
    
    [_deleteTe presentViewController:imagePickerVc animated:YES completion:nil];
}



#pragma mark - TZImagePickerControllerDelegate
/// 用户点击了取消
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    NSLog(@"用户点击了取消");
}
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    _isSelectOriginalPhoto = isSelectOriginalPhoto;
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
