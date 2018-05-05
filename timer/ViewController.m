//
//  ViewController.m
//  timer
//
//  Created by jaemoon on 4/18/18.
//  Copyright © 2018 jaemoon. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"



@interface ViewController ()
{
 
    AVAudioPlayer *player;
    NSMutableArray *minutes;
    NSMutableArray *seconds;
    
    CAShapeLayer *circle;
    CAShapeLayer *circleTwo;
    
    CABasicAnimation *pathAnim;
    CABasicAnimation *pathAnimTwo;
    
    UIImageView *secondView;
    UIImageView *thirdView;
    
    
}
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UILabel *minuteslabel;
@property (weak, nonatomic) IBOutlet UILabel *Secondslabel;
@property (weak, nonatomic) IBOutlet UIButton *startbutton;





@end



@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
  
    minutes = [[NSMutableArray alloc] init];
    seconds = [[NSMutableArray alloc] init];
    for (int i=0; i<= 59; i++){
        NSString *number = [NSString stringWithFormat:@"%d", i];

        [minutes addObject:number];
        [seconds addObject:number];
    }
    [minutes addObject:[NSString stringWithFormat: @"%d", 60]];

    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    
    //    -----------------music-------------
    NSString *path = [[NSBundle mainBundle] pathForResource:@"audio" ofType:@"mp3"];
    NSURL *url = [NSURL URLWithString:path];
    player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:NULL];
    player.numberOfLoops = -1;
   
    
    // ---------------------imageview ---------------
    UIImageView *backg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    UIImage *imgBgImage = [UIImage imageNamed:@"image.jpg"];
    GPUImagePicture *photo = [[GPUImagePicture alloc]initWithImage:imgBgImage];
    GPUImageiOSBlurFilter *blurFilter = [[GPUImageiOSBlurFilter alloc] init];
    CGFloat a = 1;
    [blurFilter setBlurRadiusInPixels:a];
    [photo addTarget: blurFilter];
    [photo processImage];
    [blurFilter useNextFrameForImageCapture];
    UIImage *output = [blurFilter imageFromCurrentFramebuffer];
    
    [backg setImage:output];
    [self.view addSubview:backg];
    [self.view sendSubviewToBack:backg];
    //----second image view
    
    
    secondView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    [secondView setImage:imgBgImage];
    [self.view addSubview:secondView];
    [self.view insertSubview:secondView atIndex:1];
    
    //------third image view
    
    thirdView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
    thirdView.alpha = 0.4;
    [thirdView setImage:imgBgImage];
    [self.view addSubview:thirdView];
    [self.view insertSubview:thirdView atIndex:2];
    
    
    
    // -----------------------circle--------------
    
    circle = [CAShapeLayer layer];
    
    CGFloat radius = 100;
    [circle setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.view.center.x - 50, self.view.center.y - 100 , radius, radius)]CGPath]];
    UIBezierPath *newPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.view.center.x - 75, self.view.center.y - 125,  3*radius/2, 3*radius/2)];
    pathAnim = [CABasicAnimation animationWithKeyPath:@"path"];
    
    pathAnim.fromValue = (id)circle.path;
    pathAnim.toValue = (id)newPath.CGPath;
    pathAnim.duration = 1.75f;
    pathAnim.repeatCount = HUGE_VALF;
    
    [circle addAnimation:pathAnim forKey:@"animateradius"];
    secondView.layer.mask = circle;
    //    ---------circletwo----------
    
    circleTwo = [CAShapeLayer layer];
    CGFloat radiusTwo = 120;
    [circleTwo setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.view.center.x - 60, self.view.center.y - 110, radiusTwo, radiusTwo)]CGPath]];
    UIBezierPath *newPathTwo = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.view.center.x - 85, self.view.center.y-135, 3*radius/2 + 20, 3*radius/2 + 20)];
    pathAnimTwo = [CABasicAnimation animationWithKeyPath:@"path"];
    
    pathAnimTwo.fromValue = (id)circleTwo.path;
    pathAnimTwo.toValue = (id)newPathTwo.CGPath;
    pathAnimTwo.duration = 1.75f;
    pathAnimTwo.repeatCount = HUGE_VALF;
    
    [circleTwo addAnimation:pathAnimTwo forKey:@"animateradius"];
    thirdView.layer.mask = circleTwo;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationEnteredBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationEnteredForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
}




- (void)applicationEnteredBackground:(NSNotification *)notification {
    [self.view.layer removeAllAnimations];
    [player pause];
}

- (void)applicationEnteredForeground:(NSNotification *)notification {
    [circle addAnimation:pathAnim forKey:@"animateradius"];
    [circleTwo addAnimation:pathAnimTwo forKey:@"animateradius"];
    [player play];
}






- (void)Counter {
    if (secValue == 0) {
        if (minuteValue == 0){
            player.currentTime = 0;
            [player pause];
            
            [self.startbutton setTitle:@"Start" forState:UIControlStateNormal];
            [actualTimer invalidate];

        }
        else {
            minuteValue -= 1;
            secValue += 59;
        }
        
    }
    else{
        secValue -= 1;
    }
    
    self.minuteslabel.text = [NSString stringWithFormat:@"%i",minuteValue];
    self.Secondslabel.text = [NSString stringWithFormat:@"%i", secValue];
    
}




- (IBAction)startbuttonClicked:(id)sender {
    [actualTimer invalidate];
    actualTimer = nil;
    if ([self.startbutton.titleLabel.text isEqual:@"Start"]){
        [player play];
        [self.startbutton setTitle:@"Stop" forState:UIControlStateNormal];
        minuteValue = [self.minuteslabel.text intValue];
        secValue = [self.Secondslabel.text intValue];
        actualTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(Counter) userInfo:nil repeats:YES];

    }
    else {
        [player pause];
        [self.startbutton setTitle:@"Start" forState:UIControlStateNormal];
    }
 
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0){
        return [minutes count];
    }
    else {
        return [seconds count];
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    switch (component) {
        case 0:
            return [minutes objectAtIndex:row];
            break;
        case 1:
            return [seconds objectAtIndex:row];
            break;
    }
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0){
        self.minuteslabel.text = minutes[row];
    }
    else {
        self.Secondslabel.text = seconds[row];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
