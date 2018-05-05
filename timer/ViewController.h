//
//  ViewController.h
//  timer
//
//  Created by jaemoon on 4/18/18.
//  Copyright © 2018 jaemoon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <GPUImage.h>

@interface ViewController :  UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>{
//    int countInt;
    NSTimer *actualTimer;
    int minuteValue;
    int secValue;
    

  
}

@end

