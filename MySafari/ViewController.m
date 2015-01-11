//
//  ViewController.m
//  MySafari
//
//  Created by Don Wettasinghe on 1/9/15.
//  Copyright (c) 2015 Don Wettasinghe. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()< UIWebViewDelegate , UITextFieldDelegate, UIAlertViewDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property CGFloat lastContentOffSet;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *forwardButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.scrollView.delegate=self;
    self.forwardButton.enabled=NO;
    self.backButton.enabled=NO;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    NSString *fullURL= [NSString stringWithFormat:@"http://%@",self.urlTextField.text];
    NSURL *url=[NSURL URLWithString:fullURL];
    NSURLRequest *urlRequest=[NSURLRequest requestWithURL:url];
    
    [self.webView loadRequest:urlRequest];
    
    return YES;
}

#pragma mark UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (self.lastContentOffSet < scrollView.contentOffset.y) {
        self.urlTextField.hidden=YES;
    } else{
        self.urlTextField.hidden=NO;
    }
    
}


# pragma mark UIWebViewDelegate

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    NSString *webTitle=[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.navigationItem.title=webTitle;
    self.forwardButton.enabled=YES;
    self.backButton.enabled=YES;
    
    [self.spinner stopAnimating];
    
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    [self.spinner startAnimating];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    if (navigationType==UIWebViewNavigationTypeLinkClicked) {
        NSURL *activeURL=request.URL;
        
        self.urlTextField.text=[activeURL absoluteString];
        NSLog(@"%@", activeURL);
    }
    
    return YES;
}

# pragma mark Button Actions

- (IBAction)comingSoon:(id)sender {
    UIAlertView *message=[[UIAlertView alloc]initWithTitle:@"Coming soon!" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    
    [message show];
}

- (IBAction)onForwardButtonPressed:(id)sender {
    [self.webView goForward];
}

- (IBAction)onBackButtonPressed:(id)sender {
    [self.webView goBack];
}

- (IBAction)onStopLoadingButtonPressed:(id)sender {
    [self.webView stopLoading];
}
- (IBAction)onReloadButtonPressed:(id)sender {
    [self.webView reload];
}


@end
