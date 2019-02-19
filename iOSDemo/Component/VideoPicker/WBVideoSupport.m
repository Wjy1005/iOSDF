//
//  WBVideoSupport.m
//  WebView
//
//  Created by Javictory on 2019/1/16.
//  Copyright © 2019年 Javictory. All rights reserved.
//

#import "WBVideoSupport.h"
#import "WBVideoConfig.h"

#define THEMEGREEN [UIColor greenColor]
//屏幕宽
#define ScreenWidth [UIApplication sharedApplication].keyWindow.frame.size.width
//屏幕高
#define ScreenHeight [UIApplication sharedApplication].keyWindow.frame.size.height

#pragma mark - Custom View --

@implementation WBRecordBtn {
    UITapGestureRecognizer *_tapGesture;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupRoundButton];
        self.layer.cornerRadius = 40.0f;
        self.layer.masksToBounds = YES;
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setupRoundButton {
    self.backgroundColor = [UIColor clearColor];
    
    CGFloat width = self.frame.size.width;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:width/2];
    
    CAShapeLayer *trackLayer = [CAShapeLayer layer];
    trackLayer.frame = self.bounds;
    trackLayer.strokeColor = THEMEGREEN.CGColor;
    trackLayer.fillColor = [UIColor clearColor].CGColor;
    trackLayer.opacity = 1.0;
    trackLayer.lineCap = kCALineCapRound;
    trackLayer.lineWidth = 2.0;
    trackLayer.path = path.CGPath;
    [self.layer addSublayer:trackLayer];
    
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.string = @"按住拍";
    textLayer.frame = CGRectMake(0, 0, 120, 30);
    textLayer.position = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    UIFont *font = [UIFont boldSystemFontOfSize:22];
    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
    textLayer.font = fontRef;
    textLayer.fontSize = font.pointSize;
    CGFontRelease(fontRef);
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    textLayer.foregroundColor = THEMEGREEN.CGColor;
    textLayer.alignmentMode = kCAAlignmentCenter;
    textLayer.wrapped = YES;
    [trackLayer addSublayer:textLayer];
    CAGradientLayer *gradLayer = [CAGradientLayer layer];
    gradLayer.frame = self.bounds;
    [self.layer addSublayer:gradLayer];
    gradLayer.mask = trackLayer;
}
@end

@implementation WBFocusView {
    CGFloat _width;
    CGFloat _height;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _width = CGRectGetWidth(frame);
        _height = _width;
    }
    return self;
}

- (void)focusing {
    [UIView animateWithDuration:0.5 animations:^{
        
        self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.8, 0.8);
    } completion:^(BOOL finished) {
        self.transform = CGAffineTransformIdentity;
    }];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, THEMEGREEN.CGColor);
    CGContextSetLineWidth(context, 1.0);
    
    CGFloat len = 4;
    
    CGContextMoveToPoint(context, 0.0, 0.0);
    CGContextAddRect(context, self.bounds);
    
    CGContextMoveToPoint(context, 0, _height/2);
    CGContextAddLineToPoint(context, len, _height/2);
    CGContextMoveToPoint(context, _width/2, _height);
    CGContextAddLineToPoint(context, _width/2, _height - len);
    CGContextMoveToPoint(context, _width, _height/2);
    CGContextAddLineToPoint(context, _width - len, _height/2);
    CGContextMoveToPoint(context, _width/2, 0);
    CGContextAddLineToPoint(context, _width/2, len);
    CGContextDrawPath(context, kCGPathStroke);
}
@end

//------  分割线  ------

@implementation WBControllerBar {
    WBRecordBtn *_startBtn;
    UILongPressGestureRecognizer *_longPress;
    UIView *_progressLine;
    BOOL _touchIsInside;
    BOOL _recording;
    NSTimer *_timer;
    NSTimeInterval _surplusTime;
    BOOL _videoDidEnd;
}

- (void)setupSubViews {
    [self layoutIfNeeded];
    
    _startBtn = [[WBRecordBtn alloc] initWithFrame:CGRectMake((ScreenWidth - 80) / 2 , 10, 100, 100)];
    
    _startBtn.text = @"按住拍";
    _startBtn.textAlignment = NSTextAlignmentCenter;
    _startBtn.textColor = [UIColor whiteColor];
    
    CAShapeLayer *solidLine =  [CAShapeLayer layer];
    CGMutablePathRef solidPath =  CGPathCreateMutable();
    solidLine.lineWidth = 2.0f ;
    solidLine.strokeColor = THEMEGREEN.CGColor;
    solidLine.fillColor = [UIColor clearColor].CGColor;
    CGPathAddEllipseInRect(solidPath, nil, CGRectMake(1.5,  1.5, 95, 95));
    solidLine.path = solidPath;
    CGPathRelease(solidPath);
    [_startBtn.layer addSublayer:solidLine];
    
    [self addSubview:_startBtn];
//    _startBtn.center = self.center;
    
//    [_startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(self.mas_centerX);
//        make.centerY.mas_equalTo(self.mas_centerY);
//        make.height.width.mas_equalTo(135);
//    }];
    
    _longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longpressAction:)];
    _longPress.minimumPressDuration = 0.01;
    _longPress.delegate = self;
    [self addGestureRecognizer:_longPress];
    
    _progressLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 4)];
    _progressLine.backgroundColor = THEMEGREEN;
    _progressLine.hidden = YES;
    [self addSubview:_progressLine];
    _surplusTime = wbRecordTime;
}

- (void)startRecordSet {
    _startBtn.alpha = 1.0;
    
    _progressLine.frame = CGRectMake(0, 0, self.bounds.size.width, 2);
    _progressLine.backgroundColor = THEMEGREEN;
    _progressLine.hidden = NO;
    
    _surplusTime = wbRecordTime;
    _recording = YES;
    
    _videoDidEnd = NO;
    
    if (_timer == nil) {
        _timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(recordTimerAction) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    }
    [_timer fire];
    
    [UIView animateWithDuration:0.4 animations:^{
        _startBtn.alpha = 0.0;
        _startBtn.transform = CGAffineTransformScale(CGAffineTransformIdentity, 2.0, 2.0);
    } completion:^(BOOL finished) {
        if (finished) {
            _startBtn.transform = CGAffineTransformIdentity;
        }
    }];
}

- (void)endRecordSet {
    _progressLine.hidden = YES;
    [_timer invalidate];
    _timer = nil;
    _recording = NO;
    _startBtn.alpha = 1;
}

//pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == _longPress) {
        if (_surplusTime <= 0) return  NO;
        
        CGPoint point = [gestureRecognizer locationInView:self];
        CGPoint startBtnCent = _startBtn.center;
        
        CGFloat dx = point.x - startBtnCent.x;
        CGFloat dy = point.y - startBtnCent.y;
        
        CGFloat startWidth = _startBtn.bounds.size.width;
        if ((dx * dx) + (dy * dy) < (startWidth * startWidth)) {
            return YES;
        }
        return NO;
    }
    return YES;
}

//pragma mark - Actions --
- (void)longpressAction:(UILongPressGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:self];
    _touchIsInside = point.y >= 0;
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            [self videoStartAction];
        }
            break;
        case UIGestureRecognizerStateChanged: {
            if (!_touchIsInside) {
                _progressLine.backgroundColor = THEMEGREEN;
                if (_delegate && [_delegate respondsToSelector:@selector(ctrollVideoWillCancel:)]) {
                    [_delegate ctrollVideoWillCancel:self];
                }
            }
            else {
                _progressLine.backgroundColor = THEMEGREEN;
            }
        }
            break;
        case UIGestureRecognizerStateEnded: {
            [self endRecordSet];
            if (!_touchIsInside || wbRecordTime - _surplusTime <= 1) {
                WBRecordCancelReason reason = WBRecordCancelReasonTimeShort;
                if (!_touchIsInside) {
                    reason = WBRecordCancelReasonDefault;
                }
                [self videoCancelAction:reason];
            }
            else {
                [self videoEndAction];
            }
        }
            break;
        case UIGestureRecognizerStateCancelled:
            break;
        default:
            break;
            
    }
}

- (void)videoStartAction {
    [self startRecordSet];
    if (_delegate && [_delegate respondsToSelector:@selector(ctrollVideoDidStart:)]) {
        [_delegate ctrollVideoDidStart:self];
    }
}

- (void)videoCancelAction:(WBRecordCancelReason)reason {
    if (_delegate && [_delegate respondsToSelector:@selector(ctrollVideoDidCancel:reason:)]) {
        [_delegate ctrollVideoDidCancel:self reason:reason];
    }
}

- (void)videoEndAction {
    
    if (_videoDidEnd) return;
    
    _videoDidEnd = YES;
    if (_delegate && [_delegate respondsToSelector:@selector(ctrollVideoDidEnd:)]) {
        [_delegate ctrollVideoDidEnd:self];
    }
}

- (void)videoListAction {
    if (_delegate && [_delegate respondsToSelector:@selector(ctrollVideoOpenVideoList:)]) {
        [_delegate ctrollVideoOpenVideoList:self];
    }
}

- (void)videoCloseAction {
    if (_delegate && [_delegate respondsToSelector:@selector(ctrollVideoDidClose:)]) {
        [_delegate ctrollVideoDidClose:self];
    }
}

- (void)recordTimerAction {
    CGFloat reduceLen = self.bounds.size.width/wbRecordTime;
    CGFloat oldLineLen = _progressLine.frame.size.width;
    CGRect oldFrame = _progressLine.frame;
    
    [UIView animateWithDuration:1.0 delay: 0.0 options: UIViewAnimationOptionCurveLinear animations:^{
        _progressLine.frame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y, oldLineLen - reduceLen, oldFrame.size.height);
        _progressLine.center = CGPointMake(self.bounds.size.width/2, _progressLine.bounds.size.height/2);
    } completion:^(BOOL finished) {
        _surplusTime --;
        if (_recording) {
            if (_delegate && [_delegate respondsToSelector:@selector(ctrollVideoDidRecordSEC:)]) {
                [_delegate ctrollVideoDidRecordSEC:self];
            }
        }
        if (_surplusTime <= 0.0) {
            [self endRecordSet];
            [self videoEndAction];
        }
    }];
}

@end

