//
//  FYGCD.m
//  FYAPP
//
//  Created by 夜枫宇 on 2014/8/22.
//  Copyright © 2014年 fengyu. All rights reserved.
//

#import "FYGCD.h"

@implementation FYGCD

+ (fy_gcd_queue)fy_mainQueue {
    return [FYGCD fy_gcdQueue:FY_Queue_Main];
}

+ (void)fy_gcdMainAsync:(FYBlock)block {
    [FYGCD fy_gcdQueue:[FYGCD fy_mainQueue] task:FY_Task_Async block:block];
}

+ (fy_gcd_queue)fy_gcdQueue:(FY_Queue)FY_Queue_Enum {
    return FY_Queue_Enum == FY_Queue_Main ? dispatch_get_main_queue() : FY_Queue_Enum == FY_Queue_Serial ? dispatch_queue_create(NULL, DISPATCH_QUEUE_SERIAL) : FY_Queue_Enum == FY_Queue_Global ? dispatch_get_global_queue(0, 0) : dispatch_queue_create(NULL, DISPATCH_QUEUE_CONCURRENT);// global 的第一个参数是优先级
}

+ (void)fy_gcdQueue:(fy_gcd_queue)queue task:(FY_Task)task block:(FYBlock)block {
    if (task == FY_Task_Once) {
        static dispatch_once_t onceDispatch;
        dispatch_once(&onceDispatch, block);
    } else task == FY_Task_Sync ? dispatch_sync(queue, block) : task == FY_Task_Async ? dispatch_async(queue, block) : dispatch_barrier_sync(queue, block);
}

+ (void)fy_gcdQueue:(fy_gcd_queue)queue afterTime:(double)time block:(FYBlock)block {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), queue, block);
}

+ (fy_gcd_group)fy_gcdGroup {
    return dispatch_group_create();
}

+ (void)fy_gcdAddQueue:(fy_gcd_queue)queue toGroup:(fy_gcd_group)group block:(FYBlock)block {
    dispatch_group_async(group, queue, block);
}

+ (void)fy_gcdNotiGroup:(fy_gcd_group)group queue:(fy_gcd_queue)queue block:(FYBlock)block {
    dispatch_group_notify(group, queue, block);
}

@end
