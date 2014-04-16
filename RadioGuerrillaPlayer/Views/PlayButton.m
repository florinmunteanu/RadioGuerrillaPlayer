
#import "PlayButton.h"

@implementation PlayButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    int bubbleRadius = 40;
   
    UIView* playCircle = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2 * bubbleRadius, 2 * bubbleRadius)];
    playCircle.backgroundColor = [self colorFromRgb:0x66cc99];
    playCircle.layer.cornerRadius = bubbleRadius;
    playCircle.layer.masksToBounds = YES;
    playCircle.opaque = NO;
    playCircle.alpha = 0.97;
    
    // Circle icon
    UIImageView* playIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"play"]];
    CGRect playFrame = playIcon.frame;
    playFrame.origin.x = (playCircle.frame.size.width - playFrame.size.width) * 0.5;
    playFrame.origin.y = (playCircle.frame.size.height - playFrame.size.height) * 0.5;
    playIcon.frame = playFrame;
    
    [playCircle addSubview:playIcon];
    
    UIView* pauseCircle = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2 * bubbleRadius, 2 * bubbleRadius)];
    pauseCircle.backgroundColor = [self colorFromRgb:0x1ab7ea];
    pauseCircle.layer.cornerRadius = bubbleRadius;
    pauseCircle.layer.masksToBounds = YES;
    pauseCircle.opaque = NO;
    pauseCircle.alpha = 0.97;
    
    // Circle icon
    UIImageView* pauseIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pause"]];
    CGRect pauseFrame = pauseIcon.frame;
    pauseFrame.origin.x = (pauseCircle.frame.size.width - pauseFrame.size.width) * 0.5;
    pauseFrame.origin.y = (pauseCircle.frame.size.height - pauseFrame.size.height) * 0.5;
    pauseIcon.frame = pauseFrame;
    
    [playCircle addSubview:playIcon];
    [pauseCircle addSubview:pauseIcon];
    
    [self setBackgroundImage:[self imageWithView:playCircle] forState:UIControlStateNormal];
    [self setBackgroundImage:[self imageWithView:pauseCircle] forState:UIControlStateSelected];
    
    self.titleLabel.text = @"";
}

- (UIColor *)colorFromRgb:(int)rgb
{
    return [UIColor colorWithRed:((float)((rgb & 0xFF0000) >> 16))/255.0 green:((float)((rgb & 0xFF00) >> 8))/255.0 blue:((float)(rgb & 0xFF))/255.0 alpha:1.0];
}

- (UIImage *)imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
