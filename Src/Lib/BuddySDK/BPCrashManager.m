//
//  BPCrashManager.m
//  BuddySDK
//
//  Created by Erik.Kerber on 3/11/14.
//
//

#import "BPCrashManager.h"
#include <sys/sysctl.h>

@interface BPCrashManager()

@property (weak, nonatomic) id<BPRestProvider> restProvider;

@end

@implementation BPCrashManager {
    //BOOL _crashReportActivated;
    BOOL _isSetup;
    BOOL _didCrashInLastSession;
    PLCrashReporter *_plCrashReporter;
    NSUncaughtExceptionHandler *_exceptionHandler;
}

- (instancetype)initWithRestProvider:(id<BPRestProvider>)restProvider
{
    self = [super init];
    if (self) {
        _restProvider = restProvider;
    }
    return self;
}

- (void)registerObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(triggerDelayedProcessing)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(triggerDelayedProcessing)
//                                                 name:BWQuincyNetworkBecomeReachable
//                                               object:nil];
}

- (void)unregisterObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:BWQuincyNetworkBecomeReachable object:nil];
}


/**
 *	 Main startup sequence initializing PLCrashReporter if it wasn't disabled
 */
- (void)startManager {
    
    [self registerObservers];
    
    if (!_isSetup) {
        static dispatch_once_t plcrPredicate;
        dispatch_once(&plcrPredicate, ^{
            /* Configure our reporter */
            
            PLCrashReporterSignalHandlerType signalHandlerType = PLCrashReporterSignalHandlerTypeBSD;

            PLCrashReporterConfig *config = [[PLCrashReporterConfig alloc] initWithSignalHandlerType: signalHandlerType
                                                                               symbolicationStrategy: PLCrashReporterSymbolicationStrategyAll];
            _plCrashReporter = [[PLCrashReporter alloc] initWithConfiguration: config];
            
            // Check if we previously crashed
            if ([_plCrashReporter hasPendingCrashReport]) {
                _didCrashInLastSession = YES;
                [self handleCrashReport];
            }
            
            // The actual signal and mach handlers are only registered when invoking `enableCrashReporterAndReturnError`
            // So it is safe enough to only disable the following part when a debugger is attached no matter which
            // signal handler type is set
            // We only check for this if we are not in the App Store environment
            
            BOOL debuggerIsAttached = NO;
            if ([self isDebuggerAttached]) {
                debuggerIsAttached = YES;
                NSLog(@"[Quincy] WARNING: Detecting crashes is NOT enabled due to running the app with a debugger attached.");
            }
            
            
            if (!debuggerIsAttached) {

            
                NSUncaughtExceptionHandler *initialHandler = NSGetUncaughtExceptionHandler();
                
                // PLCrashReporter may only be initialized once. So make sure the developer
                // can't break this
                NSError *error = NULL;
                
                // Enable the Crash Reporter
                if (![_plCrashReporter enableCrashReporterAndReturnError: &error])
                    NSLog(@"WARNING: Could not enable crash reporter: %@", [error localizedDescription]);
                
                // get the new current top level error handler, which should now be the one from PLCrashReporter
                NSUncaughtExceptionHandler *currentHandler = NSGetUncaughtExceptionHandler();
                
                // do we have a new top level error handler? then we were successful
                if (currentHandler && currentHandler != initialHandler) {
                    _exceptionHandler = currentHandler;
                    
                    NSLog(@"INFO: Exception handler successfully initialized.");
                } else {
                    // this should never happen, theoretically only if NSSetUncaugtExceptionHandler() has some internal issues
                    NSLog(@"[Quincy] ERROR: Exception handler could not be set. Make sure there is no other exception handler set up!");
                }
            }
            _isSetup = YES;
        });
    }
    
    [self triggerDelayedProcessing];
}

#pragma mark - Crash Report Processing

- (void)triggerDelayedProcessing {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(invokeDelayedProcessing) object:nil];
    [self performSelector:@selector(invokeDelayedProcessing) withObject:nil afterDelay:0.5];
}


- (void)sendCrashReports:(PLCrashReport *)crashReport
{
    NSDictionary *parameters = @{@"methodName": @"",
                                 @"stack": @"",
                                 @"metadata": @"",
                                 @"location": @""};
    
    [self.restProvider POST:@"devices/current/crashreports" parameters:nil callback:^(id json, NSError *error) {
        
    }];
}


/**
 *	 Process new crash reports provided by PLCrashReporter
 *
 * Parse the new crash report and gather additional meta data from the app which will be stored along the crash report
 */
- (void) handleCrashReport {
    NSError *error = NULL;
	
    if (!_plCrashReporter) return;
    
        
    // Try loading the crash report
    NSData *crashData = [[NSData alloc] initWithData:[_plCrashReporter loadPendingCrashReportDataAndReturnError: &error]];
    
    NSString *cacheFilename = [NSString stringWithFormat: @"%.0f", [NSDate timeIntervalSinceReferenceDate]];
    
    if (crashData == nil) {
        NSLog(@"ERROR: Could not load crash report: %@", error);
    } else {
        // get the startup timestamp from the crash report, and the file timestamp to calculate the timeinterval when the crash happened after startup
        PLCrashReport *report = [[PLCrashReport alloc] initWithData:crashData error:&error];
        
        if (report == nil) {
            NSLog(@"WARNING: Could not parse crash report");
        } else {
            
            //[crashData writeToFile:[_crashesDir stringByAppendingPathComponent: cacheFilename] atomically:YES];
            

//            NSData *plist = [NSPropertyListSerialization dataFromPropertyList:(id)metaDict
//                                                                       format:NSPropertyListBinaryFormat_v1_0
//                                                             errorDescription:&errorString];
            
            [self sendCrashReports:report];
        }
    }

    
    [_plCrashReporter purgePendingCrashReport];
}


/**
 * Check if the debugger is attached
 *
 * Taken from https://github.com/plausiblelabs/plcrashreporter/blob/2dd862ce049e6f43feb355308dfc710f3af54c4d/Source/Crash%20Demo/main.m#L96
 *
 * @return `YES` if the debugger is attached to the current process, `NO` otherwise
 */
- (BOOL)isDebuggerAttached {
    static BOOL debuggerIsAttached = NO;
    
    static dispatch_once_t debuggerPredicate;
    dispatch_once(&debuggerPredicate, ^{
        struct kinfo_proc info;
        size_t info_size = sizeof(info);
        int name[4];
        
        name[0] = CTL_KERN;
        name[1] = KERN_PROC;
        name[2] = KERN_PROC_PID;
        name[3] = getpid();
        
        if (sysctl(name, 4, &info, &info_size, NULL, 0) == -1) {
            NSLog(@"[HockeySDK] ERROR: Checking for a running debugger via sysctl() failed: %s", strerror(errno));
            debuggerIsAttached = false;
        }
        
        if (!debuggerIsAttached && (info.kp_proc.p_flag & P_TRACED) != 0)
            debuggerIsAttached = true;
    });
    
    return debuggerIsAttached;
}

@end
