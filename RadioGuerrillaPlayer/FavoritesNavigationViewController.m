
#import "FavoritesNavigationViewController.h"

@interface FavoritesNavigationViewController ()

@end

@implementation FavoritesNavigationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    if (managedObjectContext)
    {
        for (id viewController in self.viewControllers)
        {
            if ([viewController respondsToSelector:@selector(managedObjectContext)])
            {
                [viewController setManagedObjectContext:self.managedObjectContext];
            }
        }
    }
}

@end
