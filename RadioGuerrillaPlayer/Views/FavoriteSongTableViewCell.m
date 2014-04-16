
#import "FavoriteSongTableViewCell.h"

@implementation FavoriteSongTableViewCell

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = MIN(self.imageView.image.size.width, 60);
    
    self.imageView.frame = CGRectMake(self.imageView.frame.origin.x, self.imageView.frame.origin.y, width, self.imageView.frame.size.height);
    self.textLabel.frame = CGRectMake(self.imageView.frame.origin.x + 65,
                                      self.textLabel.frame.origin.y,
                                      self.textLabel.frame.size.width,
                                      self.textLabel.frame.size.height);
    self.detailTextLabel.frame = CGRectMake(self.imageView.frame.origin.x + 65,
                                            self.detailTextLabel.frame.origin.y,
                                            self.detailTextLabel.frame.size.width,
                                            self.detailTextLabel.frame.size.height);
}

@end
