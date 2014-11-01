//
//  TestsViewController.h
//  brasatech3
//
//  Created by Deborah Barbosa Alves on 11/1/14.
//  Copyright (c) 2014 Deborah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <opencv2/opencv.hpp>

@interface TestsViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>



@property (strong,nonatomic) NSArray *answers;
@property (nonatomic, assign) int questions;
@property (nonatomic, assign) int alternatives;



- (id)initWithAnswers:(NSArray *)answers questions:(int)questions alternatives:(int)alternatives;


@end