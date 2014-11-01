//
//  ViewController.m
//  brasatech3
//
//  Created by Deborah Barbosa Alves on 11/1/14.
//  Copyright (c) 2014 Deborah. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://deborahhh.com/brasatech/api.php"]];
    NSData* data = [NSURLConnection sendSynchronousRequest:request
                                          returningResponse:nil
                                                     error:nil];
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSArray *d = (NSArray *) json;
    
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:scroll];
    
    self.data = [[NSMutableDictionary alloc] init];
    
    int i = 0;
    
    for (id obj in d) {
        NSDictionary *dic = (NSDictionary *) obj;
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10.0, 60*i+30.0, self.view.frame.size.width - 20.0, 50.0)];
        [btn setTitle:dic[@"title"] forState:UIControlStateNormal];
        [self.data setObject:dic forKey:[NSNumber numberWithInt:(int) [dic[@"tid"] integerValue]]];
        btn.tag = [dic[@"tid"] integerValue];
        [btn addTarget:self action:@selector(pressedBtn:) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundColor:[UIColor grayColor]];
        btn.titleLabel.textColor = [UIColor whiteColor];
        [scroll addSubview:btn];
        i++;
    }
    
}

- (IBAction)pressedBtn:(id)sender {
    UIButton *btn = (UIButton *) sender;
    NSDictionary *dd = [self.data objectForKey:[NSNumber numberWithInt:(int) btn.tag]];
    NSArray *ans = (NSArray *) [dd objectForKey:@"answers"];
    NSLog(@"ANSSSS %@", ans);
//    NSArray *ans = [self.answers objectForKey:[NSNumber numberWithInt:(int) btn.tag]];
    TestsViewController *vc = [[TestsViewController alloc] initWithAnswers:ans questions:(int) [dd[@"questions"] integerValue] alternatives:(int) [dd[@"alternatives"] integerValue]];
    NSLog(@"QUESSS = %d, alternnn %d", (int) [dd[@"questions"] integerValue], (int) [dd[@"alternatives"] integerValue]);
    [self presentViewController:vc animated:YES completion:^{}];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
