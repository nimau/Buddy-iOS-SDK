//
//  BPPictureCollection.h
//  BuddySDK
//
//  Created by Erik Kerber on 11/22/13.
//
//

#import "BuddyCollection.h"
#import "BPPicture.h"

@interface BPPictureCollection : BuddyCollection

- (void)addPicture:(UIImage *)picture
   describePicture:(DescribePicture)describePicture
        callback:(BuddyObjectCallback)callback;

- (void)getPictures:(BuddyCollectionCallback)callback;

- (void)searchPictures:(DescribePicture)describePicture callback:(BuddyCollectionCallback)callback;

- (void)getPicture:(NSString *)pictureId callback:(BuddyObjectCallback)callback;

@end
