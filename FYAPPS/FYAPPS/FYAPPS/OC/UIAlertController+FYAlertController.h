//
//  UIAlertController+FYAlertController.h
//  FYAPP
//
//  Created by 夜枫宇 on 2014/8/22.
//  Copyright © 2014年 fengyu. All rights reserved.
//

/**
 *  使用操作提示窗步骤:
 *      1. 类方法创建并设置标题, 描叙内容, 提示窗位置
 *      2. 设置用模态弹出, 并设置弹出本窗口的对象
 *         可设弹出后对应事件 (默认弹出是带动画效果的)
 *      3. 添加操作项, 设置操作文本 文本样式 每个操作执行的事件
 */

#import <UIKit/UIKit.h>

// MARK: 定义 FYAlert 就是本窗口
#define FYAlert UIAlertController

typedef enum {
    FY_Alert_Bottom = 0,    // 在下面弹出
    FY_Alert_Center,        // 在中间弹出
} FY_Alert;

typedef enum {
    FY_TextStyle_Default = 0,   // 普通字
    FY_TextStyle_Thick,         // 粗体字
    FY_TextStyle_Red,           // 红色字
} FY_TextStyle;

@interface UIAlertController (FYAlertController)

/**
 类方法创建操作提示窗 参数1: 提示窗标题 参数2: 标题描叙内容 参数3: 提示窗位置
 
 @param title 提示窗标题
 @param describe 标题描叙内容
 @param location 提示窗位置
 @return 操作提示窗
 */
+ (instancetype)fy_alertTitle:(NSString *)title describe:(NSString *)describe location:(FY_Alert)location;

/**
 利用模态弹出本窗口 参数1: 弹出本窗口的对象 参数2: 弹出后做什么
 
 @param target 弹出本窗口的对象
 @param completion 弹出后做什么
 */
- (void)fy_modalTarget:(id)target completion:(void (^)(void))completion;

/**
 添加提示窗操作 参数1: 操作文本 参数2: 文本样式 参数3: 每个操作执行的事件
 
 @param title 操作文本
 @param textStyle 文本样式
 @param actionBlock 每个操作执行的事件
 */
- (void)fy_addTitle:(NSString *)title textStyle:(FY_TextStyle)textStyle actionBlock:(void (^)(UIAlertAction *action))actionBlock;

@end
