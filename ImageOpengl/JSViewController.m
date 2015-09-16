//
//  JSViewController.m
//  ImageOpengl
//
//  Created by Lightning on 15/9/16.
//  Copyright (c) 2015年 Lightning. All rights reserved.
//

#import "JSViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "ViewController.h"

@interface JSViewController ()
@property (nonatomic, weak) UIWebView *webview;

@end

@implementation JSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIWebView *webView =[[UIWebView alloc]initWithFrame:CGRectMake(0, 310, self.view.bounds.size.width, 300)];
    self.webview = webView;
    self.webview.backgroundColor=[UIColor lightGrayColor];
    NSString *htmlPath=[[NSBundle mainBundle] resourcePath];
    htmlPath=[htmlPath stringByAppendingPathComponent:@"index.html"];
    NSURL *localURL=[[NSURL alloc]initFileURLWithPath:htmlPath];
    [self.webview loadRequest:[NSURLRequest requestWithURL:localURL]];
    [self.view addSubview:self.webview];
    
    JSContext *context = [self.webview valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[@"log"] = ^() {
        
        NSLog(@"+++++++Begin Log+++++++");
        NSArray *args = [JSContext currentArguments];
        NSString *urlString = @"opengltest://?2";
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlString]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        }
        
        for (JSValue *jsVal in args) {
            NSLog(@"%@", jsVal);
        }
        
        JSValue *this = [JSContext currentThis];
        NSLog(@"this: %@",this);
        NSLog(@"-------End Log-------");
        
    };
}





@end
