# meditation-app
Front-end centric iOS meditation app implemented in Objective - C

This app plays a guided meditation audio file for the amount of time designated in the pickerview. 
Heatbeat like animation is implemented using CALayer, CaBasicAnimation and blurred imageview is implemented through GPUImage library's blur filter. 


<p align="center">
  <img src="https://github.com/moonjae/meditation-app/blob/master/app.gif" width= "200">
</p>
* Please bear in mind that this is just a GIF image that consists of three frames. The animation is smoother when run on the actual app 

## How It Works 

### Animation
You can notice that it has three imageViews
1. clear plain imageView  ``` secondView ```
2. blurred imageView ``` backg ```
3. blurred imageView with opacity of 0.4  ``` thirdView ```

* (1) ``` circle ``` CALayer (smaller circle) is used as a mask layer of ``` secondView ``` which makes the circle filled with clear image with blurry background 

* (2) ``` circleTwo ``` CALayer (bigger circle) is used as a mask layer of ```thirdView ``` which makes the circle to show an inner layer of (1) with blurry background with opacity of 0.4

### Stopping and Resuming Animations 

Because the animations are implemented in viewDidLoad, the animations stop functioning when the enters the foreground after being run on the background. This problem can be solved by stopping animations when the app enters the background and resuming the animations when the app enters the foreground. I used notifications so that certain functions get executed when notifications that the app entered background or the foreground are received. 


```
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationEnteredBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
```
* When notificadtion is delivered, applicationEnteredBackground function gets executed

```
- (void)applicationEnteredBackground:(NSNotification *)notification {
    [self.view.layer removeAllAnimations];
    [player pause];
}
```
* This function serves to stop the audio file and animations so that they can be resumed when the app enters the foreground again 

## Built With 

* Xcode 

## Authors

* **Jae Hyun Moon** 

