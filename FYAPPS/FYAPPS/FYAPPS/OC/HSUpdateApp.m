#import "HSUpdateApp.h"

@implementation HSUpdateApp
+ (void)hs_updateWithAPPID:(NSString *)appid block:(void(^)(NSString *currentVersion, NSString *storeVersion, NSString *openUrl, BOOL isUpdate))block {
    //1先获取当前工程项目版本号
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = infoDic[@"CFBundleShortVersionString"];
    
    //2从网络获取appStore版本号
    NSError *error;
    NSData *response = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/cn/lookup?id=%@",appid]]] returningResponse:nil error:nil];
    if (response == nil) {
        NSLog(@"你没有连接网络哦");
        return;
    }
    NSDictionary *appInfoDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    if (error) {
        NSLog(@"hsUpdateAppError:%@",error);
        return;
    }
//    NSLog(@"%@",appInfoDic);
    NSArray *array = appInfoDic[@"results"];
    
    if (array.count < 1) {
        NSLog(@"此APPID为未上架的APP或者查询不到");
        return;
    }
    
    NSDictionary *dic = array[0];
    NSString *appStoreVersion = dic[@"version"];
    //3打印版本号
    NSLog(@"当前版本号:%@\n商店版本号:%@",currentVersion,appStoreVersion);
    
    
    //4当前版本号不等于商店版本号,就更新
    if (![currentVersion isEqualToString:appStoreVersion])
    {
        block(currentVersion, dic[@"version"], [NSString stringWithFormat:@"https://itunes.apple.com/us/app/id%@?ls=1&mt=8", appid], YES);
    } else {
        block(currentVersion, dic[@"version"], [NSString stringWithFormat:@"https://itunes.apple.com/us/app/id%@?ls=1&mt=8", appid], NO);
    }

}
@end
