//
//  CKAlertView.m
//  FrameworkStruct
//
//  Created by 蒋旭蛟 on 2018/5/9.
//  Copyright © 2018年 蒋雪姣. All rights reserved.
//

#import "CKAlertView.h"
#import "OCHeader.h"

@interface CKAlertView ()
{
    
}
@end

///静态变量，记录已经创建的CKAlertView对象
static NSMapTable *identifierKeyMap;

@implementation CKAlertView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//工厂方法，创建弹窗
+(CKAlertView *)alertViewWithTitle:(nullable NSString *)title message:(nullable NSString *)message identifierKey:(NSString *)key cancelTitle:(nullable NSString *)cancelTitle cancelBlock:(void (^ __nullable)(UIAlertAction *action))cancel confirmTitle:(nullable NSString *)confirmTitle confirmBlock:(void (^ __nullable)(UIAlertAction *action))confirm inViewController:(UIViewController *)vc;
{
    if (!identifierKeyMap)      //如果没有那么创建
    {
        identifierKeyMap = [NSMapTable  mapTableWithKeyOptions:NSPointerFunctionsCopyIn valueOptions:NSMapTableWeakMemory];
    }
    if ([identifierKeyMap objectForKey:key])      //如果有值那么不创建
    {
        return nil;
    }

    CKAlertView *alertView = [CKAlertView alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertView setIdentifier:key];
    //改变字体大小和颜色
    if (title)
    {
        NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:title];
        [attrTitle addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:17] range:NSMakeRange(0, title.length)];
        [alertView setValue:attrTitle forKey:@"attributedTitle"];
    }
    if (message)
    {
        NSMutableAttributedString *attrMessage = [[NSMutableAttributedString alloc] initWithString:message];
        [attrMessage addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, message.length)];
        [alertView setValue:attrMessage forKey:@"attributedMessage"];
    }
    if (cancelTitle)     //如果cancel回调有值，那么创建取消按钮
    {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleDefault handler:cancel];
        [cancelAction setValue:UIColor.cAccent forKey:@"titleTextColor"];
        [alertView addAction:cancelAction];
    }
    if (confirmTitle)        //如果confirm回调有值，那么创建确定按钮
    {
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:confirmTitle style:UIAlertActionStyleDefault handler:confirm];
        [confirmAction setValue:UIColor.cAccent forKey:@"titleTextColor"];
        [alertView addAction:confirmAction];
    }
    //设置自身到字典中
    WS
    [identifierKeyMap setObject:weakSelf forKey:key];
    if (vc)
    {
        [vc presentViewController:alertView animated:YES completion:nil];
    }
    return alertView;
}

//工厂方法，创建弹窗，文字对齐
+(CKAlertView *)alertViewWithTitle:(nullable NSString *)title message:(nullable NSString *)message messageAlign:(NSTextAlignment)align identifierKey:(NSString *)key cancelTitle:(nullable NSString *)cancelTitle cancelBlock:(void (^ __nullable)(UIAlertAction *action))cancel confirmTitle:(nullable NSString *)confirmTitle confirmBlock:(void (^ __nullable)(UIAlertAction *action))confirm inViewController:(UIViewController *)vc
{
    CKAlertView *alertView = [CKAlertView alertViewWithTitle:title message:message identifierKey:key cancelTitle:cancelTitle cancelBlock:cancel confirmTitle:confirmTitle confirmBlock:confirm inViewController:vc];
    UIView *subView1 = alertView.view.subviews[0];
    UIView *subView2 = subView1.subviews[0];
    UIView *subView3 = subView2.subviews[0];
    UIView *subView4 = subView3.subviews[0];
    UIView *subView5 = subView4.subviews[0];
//    UILabel *title = subView5.subviews[0];
    UILabel *messageLabel = nil;
    if (IOS_VERSION >= 12.0)
    {
        messageLabel = subView5.subviews[2];
    }
    else
    {
        messageLabel = subView5.subviews[1];
    }
    messageLabel.textAlignment = align;
    return alertView;
}

//消失掉所有的弹框
+(void)dismissAllAlertCompletion:(void(^)(void))completion
{
    NSEnumerator *keys = [identifierKeyMap keyEnumerator];
    for (NSString *key in keys)
    {
        CKAlertView *alertView = (CKAlertView *)[identifierKeyMap objectForKey:key];
        [alertView.presentingViewController dismissViewControllerAnimated:NO completion:nil];
    }
    if (completion)
    {
        completion();
    }
}

//设置identifier
-(void)setIdentifier:(NSString *)identifier
{
    _identifierKey = identifier;
}


-(void)dealloc
{
    NSLog(@"CKAlertView dealloc");
}


@end
