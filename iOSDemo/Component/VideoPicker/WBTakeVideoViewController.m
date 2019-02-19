//
//  WBTakeVideoViewController.m
//  WebView
//
//  Created by Javictory on 2019/1/16.
//  Copyright © 2019年 Javictory. All rights reserved.
//

#import "WBTakeVideoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "WBVideoConfig.h"
#import "WBVideoSupport.h"

#define THENEBLACK [UIColor blackColor]
#define THEMEGREEN [UIColor greenColor]
//屏幕宽
#define ScreenWidth [UIApplication sharedApplication].keyWindow.frame.size.width
//屏幕高
#define ScreenHeight [UIApplication sharedApplication].keyWindow.frame.size.height

@interface WBTakeVideoViewController () <WBControllerBarDelegate,AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate,AVCaptureFileOutputRecordingDelegate>

@property (nonatomic, strong) UIView *videoView;
@property (nonatomic, strong) UIView *holdView;
@property (nonatomic, strong) UIButton  *holdBut;
@property (nonatomic, strong) UIView *actionView;

@end

static WBTakeVideoViewController *__currentVC = nil;
@implementation WBTakeVideoViewController
{
    dispatch_queue_t _recoding_queue;
    
    AVCaptureSession *_videoSession;  // 输入输出设备之间的数据传递
    AVCaptureVideoPreviewLayer *_videoPreLayer; // 图片预览层
    AVCaptureDevice *_videoDevice; // 输入设备(麦克风,相机等)
    
    AVCaptureVideoDataOutput *_videoDataOut;
    AVCaptureAudioDataOutput *_audioDataOut;
    
    WBControllerBar *_ctrlBar;  // 控制条
    
    AVAssetWriter *_assetWriter;
    AVAssetWriterInputPixelBufferAdaptor *_assetWriterPixelBufferInput;
    AVAssetWriterInput *_assetWriterVideoInput;
    AVAssetWriterInput *_assetWriterAudioInput;
    CMTime _currentSampleTime;
    BOOL _recoding;
    
    WBFocusView *_focusView;
    UILabel *_statusInfo;
    UILabel *_cancelInfo;
    
    WBVideoModel *_currentRecord;
    BOOL _currentRecordIsCancel;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    __currentVC = self;
    
    [self setupSubView];
    
    self.view.backgroundColor = THENEBLACK;
    
    [self viewDidComplete];
    [self setupWithVideo];
    
    _savePhotoAlbum = YES;
    
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    [self.view addSubview:topView];
    
    UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
    left.frame = CGRectMake(10, 20, 40, 30);
    left.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    
    [left setTitle:@"取消" forState:UIControlStateNormal];
    [left addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:left];
}

- (void)leftAction {
    NSDictionary *dic = @{@"message": @"用户点击了取消", @"state": @"false"};
    if (self.vedioBlock) {
        self.vedioBlock(dic);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}


- (void)endAniamtion {
    [UIView animateWithDuration:0.3 animations:^{
        self.view.backgroundColor = [UIColor clearColor];
        self.actionView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, ScreenHeight);
    } completion:^(BOOL finished) {
        [self closeView];
    }];
}

- (void)closeView {
    [_videoSession stopRunning];
    [_videoPreLayer removeFromSuperlayer];
    _videoPreLayer = nil;
    [_videoView removeFromSuperview];
    _videoView = nil;
    
    _videoDevice = nil;
    _videoDataOut = nil;
    _assetWriter = nil;
    _assetWriterAudioInput = nil;
    _assetWriterVideoInput = nil;
    _assetWriterPixelBufferInput = nil;
    __currentVC = nil;
}



//添加view 控制条  放大label

- (void)setupSubView {
    
    /*self.view Config*/
    self.view.backgroundColor = [UIColor whiteColor];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }

    _actionView = [[UIView alloc] initWithFrame:self.view.frame];
    
    [self.view addSubview:_actionView];
    _actionView.clipsToBounds = YES;
    
//    CGSize videoViewSize = [WBVideoConfig videoViewDefaultSize];
    
    //   视频下部的控制条
    _videoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self.actionView addSubview:_videoView];
    
    _ctrlBar = [[WBControllerBar alloc] initWithFrame:CGRectMake(0, ScreenHeight - 130 , ScreenWidth, 130)];
    [_ctrlBar setupSubViews];
    _ctrlBar.delegate = self;
    [self.view addSubview:_ctrlBar];
    
//    _ctrlBar.frame = CGRectMake(0, CGRectGetMaxY(self.videoView.frame), ScreenWidth, ScreenHeight / 2);
//    [_ctrlBar mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.mas_equalTo(0);
//        make.height.mas_equalTo(ScreenHeight/2);
//        make.top.mas_equalTo(self.videoView.mas_bottom);
//    }];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(focusAction:)];
    tapGesture.delaysTouchesBegan = YES;
    [_videoView addGestureRecognizer:tapGesture];
    
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(zoomVideo:)];
    doubleTapGesture.numberOfTapsRequired = 2;
    doubleTapGesture.numberOfTouchesRequired = 1;
    doubleTapGesture.delaysTouchesBegan = YES;
    [_videoView addGestureRecognizer:doubleTapGesture];
    [tapGesture requireGestureRecognizerToFail:doubleTapGesture];
    
    _focusView = [[WBFocusView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    _focusView.backgroundColor = [UIColor clearColor];
    
    _statusInfo = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_videoView.frame) - 30, _videoView.frame.size.width, 20)];
    _statusInfo.textAlignment = NSTextAlignmentCenter;
    _statusInfo.font = [UIFont systemFontOfSize:14.0];
    _statusInfo.textColor = [UIColor whiteColor];
    _statusInfo.hidden = YES;
    [self.actionView addSubview:_statusInfo];
    
    _cancelInfo = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 24)];
    _cancelInfo.center = _videoView.center;
    _cancelInfo.textAlignment = NSTextAlignmentCenter;
    _cancelInfo.hidden = YES;
    [self.actionView addSubview:_cancelInfo];
    
    [_actionView sendSubviewToBack:_videoView];
}


- (void)setupWithVideo {
    _recoding_queue = dispatch_queue_create("com.wbsmallvideo.queue", DISPATCH_QUEUE_SERIAL);
    NSArray *deviceVideo = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    NSArray *deviceAudio = [AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio];
    AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:deviceVideo[0] error:nil];
    AVCaptureDeviceInput *audioInput = [AVCaptureDeviceInput deviceInputWithDevice:deviceAudio[0] error:nil];
    
    _videoDevice = deviceVideo[0];
    
    _videoDataOut = [[AVCaptureVideoDataOutput alloc] init];
    _videoDataOut.videoSettings = @{(__bridge NSString *)kCVPixelBufferPixelFormatTypeKey:@(kCVPixelFormatType_32BGRA)};
    _videoDataOut.alwaysDiscardsLateVideoFrames = YES;
    [_videoDataOut setSampleBufferDelegate:self queue:_recoding_queue];
    
    _audioDataOut = [[AVCaptureAudioDataOutput alloc] init];
    [_audioDataOut setSampleBufferDelegate:self queue:_recoding_queue];
    
    
    _videoSession = [[AVCaptureSession alloc] init];
    if ([_videoSession canSetSessionPreset:AVCaptureSessionPreset640x480]) {
        _videoSession.sessionPreset = AVCaptureSessionPreset640x480;
    }
    
    if ([_videoSession canAddInput:videoInput]) {
        [_videoSession addInput:videoInput];
    }
    if ([_videoSession canAddInput:audioInput]) {
        [_videoSession addInput:audioInput];
    }
    if ([_videoSession canAddOutput:_videoDataOut]) {
        [_videoSession addOutput:_videoDataOut];
    }
    if ([_videoSession canAddOutput:_audioDataOut]) {
        [_videoSession addOutput:_audioDataOut];
    }
    CGFloat viewWidth = CGRectGetWidth(self.videoView.frame);
    CGFloat viewHeight = CGRectGetHeight(self.videoView.frame);
    _videoPreLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_videoSession];
    _videoPreLayer.frame = CGRectMake(0, -CGRectGetMinY(_videoView.frame), viewWidth, viewHeight); //viewWidth*wbVideo_w_h
    _videoPreLayer.position = CGPointMake(viewWidth/2, CGRectGetHeight(_videoView.frame)/2);
    _videoPreLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [_videoView.layer addSublayer:_videoPreLayer];
    
    [_videoSession startRunning];
    
}



//  放大label
- (void)viewDidComplete {
    
    __block UILabel *zoomLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
    zoomLab.center = CGPointMake(self.videoView.center.x, CGRectGetMaxY(self.videoView.frame) - 50);
    zoomLab.font = [UIFont boldSystemFontOfSize:14];
    zoomLab.text = @"双击放大";
    zoomLab.textColor = [UIColor whiteColor];
    zoomLab.textAlignment = NSTextAlignmentCenter;
    [_videoView addSubview:zoomLab];
    [_videoView bringSubviewToFront:zoomLab];
    
    wbdispatch_after(1.6, ^{
        [zoomLab removeFromSuperview];
    });
}

- (void)focusInPointAtVideoView:(CGPoint)point {
    CGPoint cameraPoint= [_videoPreLayer captureDevicePointOfInterestForPoint:point];
    _focusView.center = point;
    [_videoView addSubview:_focusView];
    [_videoView bringSubviewToFront:_focusView];
    [_focusView focusing];
    
    NSError *error = nil;
    if ([_videoDevice lockForConfiguration:&error]) {
        if ([_videoDevice isFocusPointOfInterestSupported]) {
            _videoDevice.focusPointOfInterest = cameraPoint;
        }
        if ([_videoDevice isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
            _videoDevice.focusMode = AVCaptureFocusModeAutoFocus;
        }
        if ([_videoDevice isExposureModeSupported:AVCaptureExposureModeAutoExpose]) {
            _videoDevice.exposureMode = AVCaptureExposureModeAutoExpose;
        }
        if ([_videoDevice isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) {
            _videoDevice.whiteBalanceMode = AVCaptureWhiteBalanceModeAutoWhiteBalance;
        }
        [_videoDevice unlockForConfiguration];
    }
    if (error) {
        NSLog(@"聚焦失败:%@",error);
    }
    wbdispatch_after(1.0, ^{
        [_focusView removeFromSuperview];
    });
}


#pragma mark - Actions --
- (void)focusAction:(UITapGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:_videoView];
    [self focusInPointAtVideoView:point];
}

- (void)zoomVideo:(UITapGestureRecognizer *)gesture {
    NSError *error = nil;
    if ([_videoDevice lockForConfiguration:&error]) {
        CGFloat zoom = _videoDevice.videoZoomFactor == 2.0?1.0:2.0;
        _videoDevice.videoZoomFactor = zoom;
        [_videoDevice unlockForConfiguration];
    }
}

#pragma mark - controllerBarDelegate

- (void)ctrollVideoDidStart:(WBControllerBar *)controllerBar {
    
    _currentRecord = [WBVideoUtil createNewVideo];
    _currentRecordIsCancel = NO;
    
    NSURL *outURL = [NSURL fileURLWithPath:_currentRecord.videoAbsolutePath];
    [self createWriter:outURL];
    
    _statusInfo.textColor = THEMEGREEN;
    _statusInfo.text = @"↑上移取消";
    _statusInfo.hidden = NO;
    wbdispatch_after(0.5, ^{
        _statusInfo.hidden = YES;
    });
    
    _recoding = YES;
    NSLog(@"视频开始录制");
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(leftItemAction)];
    self.navigationController.navigationItem.leftBarButtonItem = leftItem;
    
}
- (void)leftItemAction {
    NSDictionary *dic = @{@"message": @"用户点击了取消", @"state": @"false"};
    if (self.vedioBlock) {
        self.vedioBlock(dic);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)ctrollVideoDidEnd:(WBControllerBar *)controllerBar {
    _recoding = NO;
    [self saveVideo:^(NSURL *outFileURL) {
        if (_delegate) {
//            [_delegate videoViewController:self didRecordVideo:_currentRecord];
            [self endAniamtion];
        }
    }];
    
    NSURL *outputFileURL = [NSURL fileURLWithPath:self->_currentRecord.videoAbsolutePath];
    NSLog(@"%@", outputFileURL);
    
    NSDictionary *dic = @{@"uri": outputFileURL, @"state": @"true"};
    if (self.vedioBlock) {
        self.vedioBlock(dic);
    }
    [self dismissViewControllerAnimated:YES completion:^{
       
    }];
    NSLog(@"视频录制结束");
}

- (void)ctrollVideoDidCancel:(WBControllerBar *)controllerBar reason:(WBRecordCancelReason)reason{
    _currentRecordIsCancel = YES;
    _recoding = NO;
    if (reason == WBRecordCancelReasonTimeShort) {
        [WBVideoConfig showHinInfo:@"录制时间过短" inView:_videoView frame:CGRectMake(0,CGRectGetHeight(_videoView.frame)/3*2,CGRectGetWidth(_videoView.frame),20) timeLong:1.0];
    }
    NSLog(@"当前视频录制取消");
    NSDictionary *dic = @{@"message": @"录制时间过短", @"state": @"false"};
    if (self.vedioBlock) {
        self.vedioBlock(dic);
    }
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)ctrollVideoWillCancel:(WBControllerBar *)controllerBar {
    if (!_cancelInfo.hidden) {
        return;
    }
    _cancelInfo.text = @"松手取消";
    _cancelInfo.hidden = NO;
    wbdispatch_after(0.5, ^{
        _cancelInfo.hidden = YES;
    });
}

- (void)ctrollVideoDidRecordSEC:(WBControllerBar *)controllerBar {
    //    _topSlideView.isRecoding = YES;
    //    NSLog(@"视频录又过了 1 秒");
}

- (void)ctrollVideoDidClose:(WBControllerBar *)controllerBar {
    //    NSLog(@"录制界面关闭");
    if (_delegate && [_delegate respondsToSelector:@selector(videoViewControllerDidCancel:)]) {
        [_delegate videoViewControllerDidCancel:self];
    }
    [self endAniamtion];
}


//  创建录像对象(视频,音频)
- (void)createWriter:(NSURL *)assetUrl {
    NSError *error = nil;
    _assetWriter = [AVAssetWriter assetWriterWithURL:assetUrl fileType:AVFileTypeQuickTimeMovie error:&error];
    
    int videoWidth = [WBVideoConfig defualtVideoSize].width;
    int videoHeight = [WBVideoConfig defualtVideoSize].height;
    
    
    NSDictionary *outputSettings = @{
                                     AVVideoCodecKey : AVVideoCodecH264,
                                     AVVideoWidthKey : @(videoHeight),
                                     AVVideoHeightKey : @(videoWidth),
                                     AVVideoScalingModeKey:AVVideoScalingModeResizeAspectFill,
                                     //                          AVVideoCompressionPropertiesKey:codecSettings
                                     };
    _assetWriterVideoInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:outputSettings];
    _assetWriterVideoInput.expectsMediaDataInRealTime = YES; // 设置数据为实时输入
    _assetWriterVideoInput.transform = CGAffineTransformMakeRotation(M_PI / 2.0);
    
    
    NSDictionary *audioOutputSettings = @{
                                          AVFormatIDKey:@(kAudioFormatMPEG4AAC),
                                          AVEncoderBitRateKey:@(64000),
                                          AVSampleRateKey:@(44100),
                                          AVNumberOfChannelsKey:@(1),
                                          };
    
    _assetWriterAudioInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeAudio outputSettings:audioOutputSettings];
    _assetWriterAudioInput.expectsMediaDataInRealTime = YES;
    
    
    NSDictionary *SPBADictionary = @{
                                     (__bridge NSString *)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_32BGRA),
                                     (__bridge NSString *)kCVPixelBufferWidthKey : @(videoWidth),
                                     (__bridge NSString *)kCVPixelBufferHeightKey  : @(videoHeight),
                                     (__bridge NSString *)kCVPixelFormatOpenGLESCompatibility : ((__bridge NSNumber *)kCFBooleanTrue)
                                     };
    _assetWriterPixelBufferInput = [AVAssetWriterInputPixelBufferAdaptor assetWriterInputPixelBufferAdaptorWithAssetWriterInput:_assetWriterVideoInput sourcePixelBufferAttributes:SPBADictionary];
    if ([_assetWriter canAddInput:_assetWriterVideoInput]) {
        [_assetWriter addInput:_assetWriterVideoInput];
    }else {
        NSLog(@"不能添加视频writer的input \(assetWriterVideoInput)");
    }
    if ([_assetWriter canAddInput:_assetWriterAudioInput]) {
        [_assetWriter addInput:_assetWriterAudioInput];
    }else {
        NSLog(@"不能添加视频writer的input \(assetWriterVideoInput)");
    }
    
    if(error)
    {
        NSLog(@"error = %@", [error localizedDescription]);
    }
    
    NSLog(@"_assetWriter = %ld",(long)_assetWriter.status);
    
}




- (void)saveVideo:(void(^)(NSURL *outFileURL))complier {
    
    if (_recoding) return;
    
    if (!_recoding_queue){
        complier(nil);
        return;
    };
    
    
    dispatch_async(_recoding_queue, ^{
        NSURL *outputFileURL = [NSURL fileURLWithPath:self->_currentRecord.videoAbsolutePath];
        
        
        [self->_assetWriter finishWritingWithCompletionHandler:^{
            
            if (self->_currentRecordIsCancel) return ;
            
            //  保存
//            [WBVideoUtil saveThumImageWithVideoURL:outputFileURL second:1];
            
            if (complier) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    complier(outputFileURL);
                });
            }
            if (self->_savePhotoAlbum) {
                BOOL ios8Later = [[[UIDevice currentDevice] systemVersion] floatValue] >= 8;
                if (ios8Later) {
                    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                        [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:outputFileURL];
                    } completionHandler:^(BOOL success, NSError * _Nullable error) {
                        if (!error && success) {
                            NSLog(@"保存相册成功!");
                            [self.takeDelegate takeVideoDelegateAction:self->_currentRecord.videoAbsolutePath];
                        }
                        else {
                            NSLog(@"保存相册失败! :%@",error);
                        }
                    }];
                    
                }
                else {
                    [[[ALAssetsLibrary alloc] init] writeVideoAtPathToSavedPhotosAlbum:outputFileURL completionBlock:^(NSURL *assetURL, NSError *error) {
                        if (!error) {
                            [self.takeDelegate takeVideoDelegateAction:self->_currentRecord.videoAbsolutePath];
                            NSLog(@"保存相册成功!");
                        }
                        else {
                            NSLog(@"保存相册失败!");
                        }
                    }];
                }
                
            }
        }];
    });
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    
    if (!_recoding) return;
    
    @autoreleasepool {
        _currentSampleTime = CMSampleBufferGetOutputPresentationTimeStamp(sampleBuffer);
        if (_assetWriter.status != AVAssetWriterStatusWriting) {
            [_assetWriter startWriting];
            [_assetWriter startSessionAtSourceTime:_currentSampleTime];
        }
        if (captureOutput == _videoDataOut) {
            if (_assetWriterPixelBufferInput.assetWriterInput.isReadyForMoreMediaData) {
                CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
                BOOL success = [_assetWriterPixelBufferInput appendPixelBuffer:pixelBuffer withPresentationTime:_currentSampleTime];
                if (!success) {
                    NSLog(@"Pixel Buffer没有append成功");
                }
            }
        }
        if (captureOutput == _audioDataOut) {
            [_assetWriterAudioInput appendSampleBuffer:sampleBuffer];
        }
    }
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didDropSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error {
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:outputFileURL]) {
        [library writeVideoAtPathToSavedPhotosAlbum:outputFileURL completionBlock:^(NSURL *assetURL, NSError *error){
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    // erre
                }else
                {
                    // success
                }
            });
        }];
    }
    NSLog(@"recordEnd");
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
