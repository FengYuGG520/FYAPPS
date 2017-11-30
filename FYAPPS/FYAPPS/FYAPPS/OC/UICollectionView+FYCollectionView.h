//
//  UICollectionView+FYCollectionView.h
//  FYAPP
//
//  Created by 夜枫宇 on 2014/8/22.
//  Copyright © 2014年 fengyu. All rights reserved.
//

// 1. 创建 UICollectionViewFlowLayout
// 2. 创建 UICollectionView 并设置 layout
// 3. 注册标识
// 4. 设置代理, 遵守协议, 布局并记录
// 5. 数据源拿到 item
// => 注册组头组尾 注册标识->代理方法->设置大小以及是否悬停 (layout里设置)

#import <UIKit/UIKit.h>

@interface UICollectionView (FYCollectionView)

/**
 初始化并设置布局
 
 @param layout 布局
 @return collectionView
 */
+ (instancetype)fy_collectionLayout:(UICollectionViewLayout *)layout;

/**
 设置代理, 以及数据源对象
 
 @param target 代理, 以及数据源对象
 */
- (void)fy_collectionTarget:(id)target;

/**
 在 collectionView 的数据源方法里面, 拿到 item
 
 @param itemID itemID
 @param indexPath indexPath
 @return (UICollectionViewCell *)
 */
- (id)fy_collectionItemID:(NSString *)itemID indexPath:(NSIndexPath *)indexPath;

///**
// 禁用 item 的预读功能
// */
//- (void)fy_collectionPrefetchNO;

/**
 根据类名或 xib 名, 注册 组头
 
 @param headerID headerID
 @param headerName headerName
 */
- (void)fy_collectionHeaderID:(NSString *)headerID headerName:(NSString *)headerName;

/**
 根据类名或 xib 名, 注册 组尾
 
 @param footerID footerID
 @param footerName footerName
 */
- (void)fy_collectionFooterID:(NSString *)footerID footerName:(NSString *)footerName;

@end
