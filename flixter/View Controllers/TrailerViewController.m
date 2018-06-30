//
//  TrailerViewController.m
//  flixter
//
//  Created by Olivia Jorasch on 6/29/18.
//  Copyright © 2018 FBU. All rights reserved.
//

#import "TrailerViewController.h"
#import <WebKit/WebKit.h>

@interface TrailerViewController ()

@property (weak, nonatomic) IBOutlet WKWebView *trailerView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation TrailerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self fetchTrailer];
    
    [self.activityIndicator startAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)fetchTrailer {
    NSString *movieID = [self.movie[@"id"] stringValue];
    NSString *urlString = [[@"https://api.themoviedb.org/3/movie/" stringByAppendingString:movieID] stringByAppendingString:@"/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US"];
    NSLog(@"%@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
        else {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSArray *results = dataDictionary[@"results"];
            if (results.count > 0) {
                NSString *youtubeID = dataDictionary[@"results"][0][@"key"];
                NSString *trailerString = [@"https://www.youtube.com/watch?v=" stringByAppendingString:youtubeID];
                NSURL *trailerURL = [NSURL URLWithString:trailerString];
                // Place the URL in a URL Request.
                NSURLRequest *request = [NSURLRequest requestWithURL:trailerURL
                                                         cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                     timeoutInterval:10.0];
                [self.trailerView loadRequest:request];
            } else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"No Trailer" message:@"No trailer is available for this movie :(" preferredStyle:(UIAlertControllerStyleAlert)];
                 // create an OK action
                 UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                 // handle response here.
                 }];
                 // add the OK action to the alert controller
                 [alert addAction:okAction];
                 [self presentViewController:alert animated:YES completion:^{
                 // optional code for what happens after the alert controller has finished presenting
                 }];
            }
        }
        [self.activityIndicator stopAnimating];
    }];
    [task resume];
}

- (IBAction)buttonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
