//
//  common.h
//  Movie App
//
//  Created by Dmitry Beloborodov on 04/02/15.
//  Copyright (c) 2015 Mobile Solutions. All rights reserved.
//

#ifndef Movie_App_common_h
#define Movie_App_common_h

#ifdef DEBUG
#	define DLog(fmt, ...)               NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#	define DLog(...)
#endif

#define WeakObject(o)                   __typeof__(o) __weak
#define WeakSelf                        WeakObject(self)


#endif
