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

#pragma mark init, dealloc, memory management

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    self.view = webView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"about" ofType:@"html"];
    NSURL *htmlURL = [NSURL fileURLWithPath:htmlPath];
    NSData *htmlData = [NSData dataWithContentsOfURL:htmlURL];
    [webView loadData:htmlData MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:htmlURL];
}

- (void)dealloc
{
    [webView release];
    [super dealloc];
}

@end
