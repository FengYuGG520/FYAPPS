//
//  UICollectionView+FYCollectionView.m
//  FYAPP
//
//  Created by 夜枫宇 on 2014/8/22.
//  Copyright © 2014年 fengyu. All rights reserved.
//

#import "UICollectionView+FYCollectionView.h"

@interface NSURL (FYURL)

/**
 得到 xib 名的 URL 路径
 
 @param nibName xib 名
 @return URL 路径
 */
+ (NSURL *)fy_URLNibName:(NSString *)nibName;

@end

@implementation UICollectionView (FYCollectionView)

+ (instancetype)fy_collectionLayout:(UICollectionViewLayout *)layout {
    return [[self alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
}

- (void)fy_collectionTarget:(id)target {
    self.delegate = target;
    self.dataSource = target;
}

- (id)fy_collectionItemID:(NSString *)itemID indexPath:(NSIndexPath *)indexPath {
    return [self dequeueReusableCellWithReuseIdentifier:itemID forIndexPath:indexPath];
}

- (void)fy_collectionHeaderID:(NSString *)headerID headerName:(NSString *)headerName {
    [self fy_collectionSupplementaryID:headerID kind:UICollectionElementKindSectionHeader supplementaryName:headerName];
}

- (void)fy_collectionFooterID:(NSString *)footerID footerName:(NSString *)footerName {
    [self fy_collectionSupplementaryID:footerID kind:UICollectionElementKindSectionFooter supplementaryName:footerName];
}

- (void)fy_collectionSupplementaryID:(NSString *)supplementaryID kind:(NSString *)kind supplementaryName:(NSString *)supplementaryName {
    if ([NSURL fy_URLNibName:supplementaryName])
        [self registerNib:[UINib nibWithNibName:supplementaryName bundle:nil] forSupplementaryViewOfKind:kind withReuseIdentifier:supplementaryID];
    else [self registerClass:NSClassFromString(supplementaryName) forSupplementaryViewOfKind:kind withReuseIdentifier:supplementaryID];
}

@end

@implementation NSURL (FYURL)

+ (NSURL *)fy_URLNibName:(NSString *)nibName {
    return [[NSBundle mainBundle] URLForResource:nibName withExtension:@"nib"];
}

+ (NSString *)fy_readURL:(NSURL *)url {
    // 读取 URL 路径的文件, 用字符串接收, 并返回
    return [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
}

+ (BOOL)fy_writeStr:(NSString *)string toURL:(NSURL *)url {
    // 把字符串写入一个 URL 路径里, 如果写入成功, 则返回 YES
    return [string writeToURL:url atomically:NO encoding:NSUTF8StringEncoding error:nil];
}

+ (instancetype)fy_URLGETInStr:(NSString *)str {
    return [NSURL URLWithString:[str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
}

+ (NSString *)fy_filePath:(NSString *)str {
    return [[NSBundle mainBundle] pathForResource:str ofType:nil];
}

@end
