//
//  MovieCell.h
//  flixter
//
//  Created by Olivia Jorasch on 6/27/18.
//  Copyright © 2018 FBU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;

@end
