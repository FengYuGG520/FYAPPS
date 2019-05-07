//
//  FYGCD.h
//  FYAPP
//
//  Created by 夜枫宇 on 2014/8/22.
//  Copyright © 2014年 fengyu. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  无参数无返回值的代码块
 */
typedef void (^FYBlock)(void);

typedef dispatch_queue_t fy_gcd_queue;
typedef dispatch_group_t fy_gcd_group;

typedef enum {
    FY_Queue_Main = 0,  // 在主队列     (串行)(在主线程里需要加入异步队列, 主线程空闲调用)
    FY_Queue_Serial,    // 串行队列
    FY_Queue_Global,    // 全局队列     (并行)(日常开发中, 建议用)
    FY_Queue_Concurrent // 并行队列     (开发第三方框架的时候, 建议用)
} FY_Queue;

typedef enum {
    FY_Task_Sync = 0,   // 同步任务
    FY_Task_Async,      // 异步任务
    FY_Task_Barrier,    // 障碍任务
    FY_Task_Once,       // 一次任务
} FY_Task;

@interface FYGCD : NSObject

/**
 获得主队列
 
 @return 主队列
 */
+ (fy_gcd_queue)fy_mainQueue;

/**
 异步调用主线程来做的任务
 
 @param block 代码块
 */
+ (void)fy_gcdMainAsync:(FYBlock)block;

/**
 返回一个 fy_gcd_queue 队列
 
 @param FY_Queue_Enum 队列枚举
 @return fy_gcd_queue 队列
 */
+ (fy_gcd_queue)fy_gcdQueue:(FY_Queue)FY_Queue_Enum;

/**
 执行 GCD, 参数1: 队列 参数2: 代码块 参数3: 执行任务类型 (同步, 异步, 障碍, 一次)
 
 @param queue 队列
 @param block 代码块
 @param task 执行任务类型 (同步, 异步, 障碍, 一次)
 */
+ (void)fy_gcdQueue:(fy_gcd_queue)queue task:(FY_Task)task block:(FYBlock)block;

/**
 执行 GCD 延迟任务, 参数1: 队列 参数2: 代码块 参数3: 在这行代码后延迟多久加入到队列
 
 @param queue 队列
 @param block 代码块
 @param time 在这行代码后延迟多久加入到队列
 */
+ (void)fy_gcdQueue:(fy_gcd_queue)queue afterTime:(double)time block:(FYBlock)block;

/**
 返回一个 fy_gcd_group 调度组
 
 @return fy_gcd_group 调度组
 */
+ (fy_gcd_group)fy_gcdGroup;

/**
 将 GCD 异步任务队列, 添加到调度组
 
 @param queue 异步任务队列
 @param block 代码块
 @param group 调度组
 */
+ (void)fy_gcdAddQueue:(fy_gcd_queue)queue toGroup:(fy_gcd_group)group block:(FYBlock)block;

/**
 调度组中的所有异步任务执行结束之后, 在这里得到统一的通知, 参数1: 指哪个组执行完毕后调用这个通知 参数2: 当参数1组里所有任务执行完毕后, 在参数2队列里执行参数3的任务
 
 @param group 指哪个组执行完毕后调用这个通知
 @param queue 在这个队列里
 @param block 代码块
 */
+ (void)fy_gcdNotiGroup:(fy_gcd_group)group queue:(fy_gcd_queue)queue block:(FYBlock)block;

@end
