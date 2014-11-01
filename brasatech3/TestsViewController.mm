//
//  TestsViewController.m
//  brasatech3
//
//  Created by Deborah Barbosa Alves on 11/1/14.
//  Copyright (c) 2014 Deborah. All rights reserved.
//

#import "TestsViewController.h"

@interface TestsViewController ()

@end

@implementation TestsViewController


- (id)initWithAnswers:(NSArray *)answers questions:(int)questions alternatives:(int)alternatives {
    NSLog(@"answers %@",answers);
    self = [super init];
    if (self) {
        self.answers = answers;
        self.alternatives = alternatives;
        self.questions = questions;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *pic = [[UIButton alloc] initWithFrame:CGRectMake(10, 100, self.view.frame.size.width - 20.0, 50)];
    [pic setTitle:@"Choose image and Calculate" forState:UIControlStateNormal];
    [pic addTarget:self action:@selector(calculate:) forControlEvents:UIControlEventTouchUpInside];
    [pic setBackgroundColor:[UIColor colorWithRed:0/255 green:0/255 blue:255/255 alpha:0.2]];
    pic.titleLabel.textColor = [UIColor whiteColor];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:pic];
    
    UIButton *back = [[UIButton alloc] initWithFrame:CGRectMake(10.0, 40.0, 70.0, 40.0)];
    [back setTitle:@"Back" forState:UIControlStateNormal];
    [back setBackgroundColor:[UIColor lightGrayColor]];
    back.titleLabel.textColor = [UIColor blackColor];
    [back addTarget:self action:@selector(dismissvc:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
}

- (IBAction)dismissvc:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)calculate:(id)sender {
    
    std::vector<bool> results = [self readAnswerSheet:[UIImage imageNamed:@"IMG_3991.JPG"]];
    
    NSMutableString *output = [[NSMutableString alloc] initWithString:@""];
    for (int i = 0; i < results.size(); i++) {
        NSString *res = (results.at(i)) ? @"correct" : @"wrong";
        [output appendString:[NSString stringWithFormat:@"Q%d - %@\n",i+1,res]];
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 160, self.view.frame.size.width - 20, self.view.frame.size.height - 160 - 10)];
    label.text = output;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.numberOfLines = 0;
    [self.view addSubview:label];
    
}


- (std::vector<bool>)readAnswerSheet:(UIImage *)sheet {
    // THRESHOLDS
    
    
    using namespace cv;
    
    // converts image to cvMat
    Mat img = [self cvMatFromUIImage:sheet];
    

    
    // make black and white
    cvtColor(img, img, CV_RGB2GRAY);
    
    // make binary
    bitwise_not(img, img);
    cv::threshold(img, img, 100, 255, CV_THRESH_BINARY);
    
    // dilate/erode
    cv::dilate(img, img, cv::Mat(),cv::Point(-1,-1),10);
    cv::erode(img, img, cv::Mat(),cv::Point(-1,-1),30);
    
    
    Mat img2;
    img.convertTo(img2, CV_8U);
    
    vector<vector<cv::Point> > contours;
    vector<Vec4i> hierarchy;
    findContours(img2, contours, hierarchy, CV_RETR_TREE, CV_CHAIN_APPROX_SIMPLE, cv::Point(0, 0));
    NSLog(@"%lu",contours.size());
    
    
    // convert img back to rgb
    cvtColor(img, img, CV_GRAY2BGR);
    
    vector<point> pts;
    for (int i = 0; i < contours.size(); i++) {
        vector<cv::Point> c = contours.at(i);
        float x=0, y=0;
        for (int j = 0; j < c.size(); j++) {
            x += c.at(j).x;
            y += c.at(j).y;
        }
        x /= c.size();
        y /= c.size();
        
        point pt;
        pt.x = x; pt.y = y;
        pts.push_back(pt);
        circle(img,cv::Point(x,y),50,Scalar(255,0,0),25);
    }

    vector<int> correct;
    for (id n in self.answers) {
        correct.push_back((int) [n integerValue]);
    }
    
    vector<bool> answers = readAnswers(pts, correct, 100.0, self.questions, self.alternatives);
    
//    UIImageView *answerView = [[UIImageView alloc] initWithImage:[self UIImageFromCVMat:img]];
//    answerView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//    answerView.contentMode = UIViewContentModeScaleAspectFit;
//    [self.view addSubview:answerView];
    
    
    return answers;
    
}

/*
 * asfasfgasdgfsd
 */

typedef struct point
{
    double x;
    double y;
    int check;
    
} point;

bool ord_Inc_byX(point A, point B)
{
    if (A.x < B.x)
    {
        return true;
    }
    
    return false;
}

bool ord_Dec_byX(point A, point B)
{
    if (A.x > B.x)
    {
        return true;
    }
    
    return false;
}

bool ord_Inc_byY(point A, point B)
{
    if (A.y < B.y)
    {
        return true;
    }
    
    return false;
}

bool ord_Dec_byY(point A, point B)
{
    if (A.y > B.y)
    {
        return true;
    }
    
    return false;
}

// calculate distance from point K to line MN
double dist(point K, point M, point N)
{
    // define points
    double x_0 = K.x;
    double y_0 = K.y;
    double x_1 = M.x;
    double y_1 = M.y;
    double x_2 = N.x;
    double y_2 = N.y;
    
    double answer = 0;
    
    double numerador = 0;
    double denominador = 0;
    
    numerador = fabs((y_1 - y_2)*x_0 + (x_2 - x_1)*y_0 + x_1*y_2 - y_1*x_2);
    
    denominador = sqrt((y_1 - y_2)*(y_1 - y_2) + (x_2 - x_1)*(x_2 - x_1));
    
    answer = numerador/denominador;
    
    return answer;
}

std::vector<bool> readAnswers(std::vector<point> pts, std::vector<int> correct_answer, double threshold, int quest, int qty_alt)
{
    
    // define left and right points of answer sheet
    point left[quest + 2];
    point right[quest + 2];
    
    // define top and bottom points of answer sheet
    point top[qty_alt + 2];
    point bottom[qty_alt + 2];
    
    // define answer points
    point answers[quest + 2];
    
    // define vector result
    std::vector<bool> result;
    
    for (int i = 0; i < pts.size(); i++)
    {
        (pts.at(i)).check = 0;
    }
    
    // find the left points
    // sort points increasingly according to x-coordinate
    sort(pts.begin(), pts.end(), ord_Inc_byX);
    
    //printf("Left:\n");
    for (int i = 0; i < quest; i++)
    {
        left[i].x = (pts.at(i)).x;
        left[i].y = (pts.at(i)).y;
        
        //printf("ponto (%lf, %lf)\n", left[i].x, left[i].y);
        
        // check this point
        (pts.at(i)).check = 1;
    }
    //printf("\n");
    
    std::sort(&left[0], &left[quest], ord_Inc_byY);
    
    // find the right points
    // sort points decreasingly according to x-coordinate
    sort(pts.begin(), pts.end(), ord_Dec_byX);
    
    //printf("Right:\n");
    for (int i = 0; i < quest; i++)
    {
        right[i].x = (pts.at(i)).x;
        right[i].y = (pts.at(i)).y;
        
        //printf("ponto (%lf, %lf)\n", right[i].x, right[i].y);
        
        // check this point
        (pts.at(i)).check = 1;
    }
    //printf("\n");
    std::sort(&right[0], &right[quest], ord_Inc_byY);
    
    // find the bottom points
    // sort points decreasingly according to y-coordinate
    sort(pts.begin(), pts.end(), ord_Dec_byY);
    
    //printf("Bottom:\n");
    for (int i = 0; i < qty_alt; i++)
    {
        bottom[i].x = (pts.at(i)).x;
        bottom[i].y = (pts.at(i)).y;
        
        //printf("bottom[%d] = (%lf, %lf)\n", i, bottom[i].x, bottom[i].y);
        
        // check this point
        (pts.at(i)).check = 1;
    }
    //printf("\n");
    std::sort(&bottom[0], &bottom[qty_alt], ord_Inc_byX);
    
    // find the top points
    // sort points increasingly according to y-coordinate
    sort(pts.begin(), pts.end(), ord_Inc_byY);
    
    //printf("Top:\n");
    for (int i = 0; i < qty_alt; i++)
    {
        top[i].x = (pts.at(i)).x;
        top[i].y = (pts.at(i)).y;
        
        //printf("top[%d] = (%lf, %lf)\n", i, top[i].x, top[i].y);
        
        // check this point
        (pts.at(i)).check = 1;
    }
    //printf("\n");
    std::sort(&top[0], &top[qty_alt], ord_Inc_byX);
    
    int resp = 0;
    
    //printf("Answers:\n");
    // find answer points
    for (int i = 0; i < pts.size(); i++)
    {
        // check if it has not been checked before
        if ((pts.at(i)).check == 0)
        {
            // if it has not been checked, it is an answer point
            answers[resp].x = (pts.at(i)).x;
            answers[resp].y = (pts.at(i)).y;
            //printf("ponto (%lf, %lf)\n", answers[resp].x, answers[resp].y);
            
            resp++;
        }
        
    }
    NSLog(@"%d",resp);
    //printf("\n");
    
    // lets check if these bitches are correct answers
    
    // define current answer being checked
    int current_answer = 0;
    
    for (int i = 0; i < quest; i++)
    {
        result.push_back(false);
        
        NSLog(@"vert dist = %f, (%f,%f), (%f,%f), (%f,%f)", dist(answers[current_answer], left[i], right[i]), answers[current_answer].x, answers[current_answer].y, left[i].x, left[i].y, right[i].x, right[i].y);
        // check if current answer corresponds to current question
        if (dist(answers[current_answer], left[i], right[i]) <= threshold)
        {
            NSLog(@"horiz dist = %f", dist(answers[current_answer], top[correct_answer.at(i)], bottom[correct_answer.at(i)]));
            // check if this is the right answer
            if (dist(answers[current_answer], top[correct_answer.at(i)], bottom[correct_answer.at(i)]) <= threshold)
            {
                result.at(i) = true;
            }
            
            // update current_answer being checked
            current_answer++;
        }
    }
    
    return result;
}

/*
 * OPENCV FUNCTIONS
 */

- (cv::Mat)cvMatFromUIImage:(UIImage *)image
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
    cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels (color channels + alpha)
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to  data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    
    return cvMat;
}

-(UIImage *)UIImageFromCVMat:(cv::Mat)cvMat
{
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize()*cvMat.total()];
    CGColorSpaceRef colorSpace;
    
    if (cvMat.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    // Creating CGImage from cv::Mat
    CGImageRef imageRef = CGImageCreate(cvMat.cols,                                 //width
                                        cvMat.rows,                                 //height
                                        8,                                          //bits per component
                                        8 * cvMat.elemSize(),                       //bits per pixel
                                        cvMat.step[0],                            //bytesPerRow
                                        colorSpace,                                 //colorspace
                                        kCGImageAlphaNone|kCGBitmapByteOrderDefault,// bitmap info
                                        provider,                                   //CGDataProviderRef
                                        NULL,                                       //decode
                                        false,                                      //should interpolate
                                        kCGRenderingIntentDefault                   //intent
                                        );
    
    
    // Getting UIImage from CGImage
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return finalImage;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
