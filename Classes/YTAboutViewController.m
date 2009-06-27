//
//  YTAboutViewController.m
//  YourTurn
//
//  Created by Masashi Ono on 09/06/20.
//  Copyright (c) 2009, Masashi Ono
//  All rights reserved.
//

#import "YTAboutViewController.h"


@implementation YTAboutViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"about" ofType:@"html"];
    NSURL *htmlURL = [NSURL fileURLWithPath:htmlPath];
    NSData *htmlData = [NSData dataWithContentsOfURL:htmlURL];
    LOG(@"AboutViewController path=%@ url=%@", htmlPath, [htmlURL absoluteURL]);
    UIWebView *webView = (UIWebView *)self.view;
    [webView loadData:htmlData MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:htmlURL];
}

- (void)dealloc
{
    [super dealloc];
}

@end
