
#import "RGApplication.h"
#import "RemoteControlEvents.h"

@implementation RGApplication

extern NSString* RGRemoteControlPlayButtonTapped;
extern NSString* RGRemoteControlPauseButtonTapped;
extern NSString* RGRemoteControlStopButtonTapped;

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    switch (event.subtype)
    {
        case UIEventSubtypeRemoteControlPlay:
            [self postNotificationWithName:RGRemoteControlPlayButtonTapped];
            break;
        case UIEventSubtypeRemoteControlPause:
            [self postNotificationWithName:RGRemoteControlPauseButtonTapped];
            break;
        case UIEventSubtypeRemoteControlStop:
            [self postNotificationWithName:RGRemoteControlStopButtonTapped];
            break;
        case UIEventSubtypeRemoteControlNextTrack:
        case UIEventSubtypeRemoteControlPreviousTrack:
        default:
            break;
    }
}

- (void)postNotificationWithName:(NSString *)name
{
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil];
}

@end
