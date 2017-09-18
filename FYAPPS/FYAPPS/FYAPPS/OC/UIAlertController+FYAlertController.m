//
//  UIAlertController+FYAlertController.m
//  FYAPP
//
//  Created by 夜枫宇 on 2014/8/22.
//  Copyright © 2014年 fengyu. All rights reserved.
//

#import "UIAlertController+FYAlertController.h"

@implementation UIAlertController (FYAlertController)

+ (instancetype)fy_alertTitle:(NSString *)title describe:(NSString *)describe location:(FY_Alert)location {
    // 类方法创建一个操作提示窗, 并设置 标题 描叙内容 位置
    return [self alertControllerWithTitle:title message:describe preferredStyle:(UIAlertControllerStyle)location];
}

- (void)fy_modalTarget:(id)target completion:(void (^)(void))completion {
    // 将本窗口使用 target 模态弹出, 默认弹出带动画效果, 可以添加弹出执行事件
    [target presentViewController:self animated:YES completion:completion];
}

- (void)fy_addTitle:(NSString *)title textStyle:(FY_TextStyle)textStyle actionBlock:(void (^)(UIAlertAction *action))actionBlock {
    // 给本窗口添加操作内容, 其中包括: 1. 操作的文本 2. 文本样式 3. 操作对应的事件
    [self addAction:[UIAlertAction actionWithTitle:title style:(UIAlertActionStyle)textStyle handler:actionBlock]];
}

@end

/**
 *  MARK: UIAlertController 笔记
 *  // 参数1: 提示框标题
 *  // 参数2: 提示框消息
 *  // 参数3: 样式
 *  // UIAlertControllerStyleActionSheet  actionSheet样式, 也就是从下面出来
 *  // UIAlertControllerStyleAlert        alertView样式, 从中间出来
 *  UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"恭喜你, 中奖了!" preferredStyle:UIAlertControllerStyleActionSheet];
 *
 *  // 它的每个按钮都是一个 UIAlertAction 的对象
 *  // 参数1: 按钮标题
 *  // 参数2: 按钮的样式
 *  // 参数3: 点击这个按钮的时候做什么事
 *  // UIAlertActionStyleDefault       普通
 *  // UIAlertActionStyleCancel        加粗样式
 *  // UIAlertActionStyleDestructive   加红
 *  UIAlertAction *aa1 = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
 *      NSLog(@"点击了删除");
 *  }];
 *  UIAlertAction *aa2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
 *      NSLog(@"点击了取消");
 *  }];
 *  UIAlertAction *aa3 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
 *      NSLog(@"点击了确定");
 *  }];
 *  // 把这几个 action 加入到 UIAlertController 才有用
 *  [alertVC addAction:aa3];
 *  [alertVC addAction:aa1];
 *  [alertVC addAction:aa2];
 *  // 用模态弹出
 *  [self presentViewController:alertVC animated:YES completion:^{
 *      NSLog(@"弹出来时会调用的代码块");
 *  }];
 *
 */

/**
 *  MARK: 被禁用的操作弹窗 UIAlertView
 - (IBAction)UIAlertView:(UIButton *)sender {
     // 参数1: 提示框标题
     // 参数2: 提示框信息内容
     // 参数3: 代理对象 (作用就是在点击提示框按钮的时候会调用)
     // 参数4: 取消按钮, 会加粗 (不要认为 cancel 是取消按钮, 它只是加粗了)
     // 参数5: 其他按钮, 不加粗
     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"恭喜你, 中奖了! 请拨打 110 领奖!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", @"重试", nil];
     [alert show];
 }
 
 // 点击任何按钮都会触发这个方法
 // 参数2: 用来区分你是哪个按钮被点
 - (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
     switch (buttonIndex) {
         case 0:
             NSLog(@"点击了确定");
             break;
         case 1:
             NSLog(@"点击了取消");
             break;
         case 2:
             NSLog(@"点击了重试");
             break;
         default:
             break;
     }
 }
 
 MARK: 被禁用的操作弹窗 UIActionSheet
 - (IBAction)UIActionSheet:(UIButton *)sender {
     // 参数1: 提示框标题 (提示框信息内容)
     // 参数2: 代理对象 (作用就是在点击提示框按钮的时候会调用)
     // 参数3: 取消按钮, 会加粗 (不要认为 cancel 是取消按钮, 它只是加粗了)
     // 参数4: 重要操作的按钮 (文字变红)
     // 参数5: 其他按钮, 不加粗
     UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"提示" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:@"确定", @"收藏", nil];
     [sheet showInView:self.view];
 }
 
 // 点击任何按钮都会触发这个方法
 // 参数2: 用来区分你是哪个按钮被点
 - (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
     switch (buttonIndex) {
         case 0:
             NSLog(@"点击了删除");
             break;
         case 1:
             NSLog(@"点击了确定");
             break;
         case 2:
             NSLog(@"点击了收藏");
             break;
         case 3:
             NSLog(@"点击了取消");
             break;
     }
 }
 */
