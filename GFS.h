////  GFS.h //  Testovanie //  Created by Michal Cisarik on 8/1/13.  //
////  Copyright (c) 2013 Michal Cisarik. All rights reserved.        //

#import <Foundation/Foundation.h>
#import "MersenneTwister.h"

// ================== // ERRORS AND EXCEPTIONS // ================== //
@interface NotEnoughTerminalsInRepairingArray : NSException
@end

@interface UnexpectedBehavior : NSException
@end

// ====================== // CONSTANTS // ========================== //
//
// This values should be experimentally tested and optimal values should be determined according to stats
//
#define MAXWIDTH 6
#define MAXDEPTH 9
#define MAXSIZE 32
#define MAXCONSTANTS 32

// ========================= // TYPES // =========================== //
typedef double (^func2)(double,double);
typedef double (^func1)(double);
typedef double (^func0)(void);

typedef double (^input2D)(double);
typedef double (^input3D)(double,double);


// ====================== // PROTOCOLS // ========================== //
@protocol GFS2args <NSObject>
-(double) eval:(double)parameter1 and:(double)parameter2;
@end

@protocol GFS1args <NSObject>
-(double) eval:(double)a;
@end

@protocol GFS0args <NSObject>
-(double) eval;
@end

@protocol GFSvariable <NSObject>
@end

@protocol GFSconstant <NSObject>
@end

@protocol GFSreinforced <NSObject>
@end


// ======================== // INTERFACES // ======================= //
@interface Configuration : NSObject <NSCoding> {
    NSMutableDictionary *all;
}
@property (readwrite) NSMutableDictionary *all;
-(id)init;
@end


@interface GFSelement : NSObject {
    NSString *name;
}
@property (retain) NSString* name;
@end

@interface GFSvar : GFSelement <GFSvariable>{
    double* variable;
}
-(id)initWith:(double *)n name:(NSString *)s;
-(double)value;
@end

@interface GFSconst : GFSelement <GFSconstant>{
    double constant;
}
-(id)initWith:(double)n;
-(double)value;
@end

@interface GFS1 : GFSelement <GFS1args>{
    func1 function;
}
-(double) eval:(double)parameter1;
@end

@interface GFS2 : GFSelement <GFS2args>{
    func2 function;
}
-(double) eval:(double)parameter1 and:(double)parameter2;
@end

@interface GFS0 : GFSelement <GFS0args>{
    func0 function;
}
-(double) eval;
@end

@interface FS : NSObject {
    
}
+(NSDictionary*) mask:(uint64)b;
@end


@interface Calculation : NSObject{
@public
    int* array;
    int* last;
    int* len;
    int* repairing;
    int* lastrepairing;
    int* lastbigger;
    int  i;
    int  depth;
    int  last_static;
    int  len_static;
    int  lastrepairing_static;
    int  lastbigger_static;
}
-(id)initWithArray:(int*)a andRepairing:(int*)b;
-(void)nullCalculation;
@end

@interface IN : NSObject {
    
    NSMutableArray *xs;
    NSMutableArray *ys;
    NSMutableArray *zs;
    double min;
    double max;
    uint count;
}

@property (nonatomic, copy) NSMutableArray *xs;
@property (nonatomic, copy) NSMutableArray *ys;
@property (nonatomic, copy) NSMutableArray *zs;

@property (nonatomic) double min;
@property (nonatomic) double max;
@property (nonatomic) uint count;

-(id)initWithXs:(NSMutableArray *)x Ys:(NSMutableArray *)y Zs:(NSMutableArray *)z min:(double)i max:(double)mx andCount:(uint)c;

+(NSMutableArray*) ekvidistantDoublesCount:(int)count min:(double)m max:(double)mx;
@end

@interface GFS : NSObject {
    NSMutableArray* elements;
    uint64 bin;
    int functions;
    int constants;
    int reinforcementStartingIndex;
    int size;
    int xpos;
    int terminalsStartingIndex;
    int bit1;
    int bit2;
    int bit3;
    int bit4;
    int bit5;
    int bit6;
    int bit7;
    int bit8;
    int bit9;
    int bit10;
    int bit11;
    int bit12;
    int bit13;
    int bit14;
    int bit15;
    int bit16;
    int bit17;
    int bit18;
    int bit19;
    int bit20;
    int bit21;
    int bit22;
    int bit23;
    int bit24;
    int bit25;
    int bit26;
    int bit27;
    int bit28;
    int bit29;
    int bit30;
    int bit31;
    int bit32;
    
}
@property int functions;
@property int constants;
@property int size;
@property int reinforcementStartingIndex;
@property int xpos;
@property BOOL variableNameInsteadOfValue;
@property int terminalsStartingIndex;
@property uint64 bin;

@property (retain) NSMutableArray* elements;

-(id)initWithInput:(IN*)i andConfiguration:(Configuration *)cfg;

-(void)reinforceWith:(NSString *)s;

-(id)initWithFunctionSet:(uint64)fsb constants:(double*)consts andSeed:(uint32)seed;

-(NSString *)toStringRecursive:(int[])array at:(int) i last:(int*)last max:

(int*)len repairing:(int [])repairing lastrepairing:(int*)lastrepairing lastbigger:(int*)lastbigger;

-(double)evaluateRepairingRecursive:(int[])array at:(int) i last:(int*)last max:(int*)len repairing:(int [])repairing lastrepairing:(int*)lastrepairing lastbigger:(int*)lastbigger depth:(int*)depth;

-(double)evaluateRecursive:(int[])array at:(int) i last:(int*)last max:(int*)len repairing:(int [])repairing lastrepairing:(int*)lastrepairing lastbigger:(int*)lastbigger depth:(int*)depth;

-(void)setValueOf:(NSString*)var value:(double)val;

-(int)repairA:(int[])_a withB:(int[])_b;

-(double)errorA:(int[])_a withB:(int[])_b;

-(double)errorA:(int[])_a withB:(int[])_b andC:(double[])_c;

-(NSString *)stringA:(int[])_a withB:(int[])_b;

-(NSString *)describeA:(int[])_a withB:(int[])_b;

-(int)implantReinsOf:(int[])a len:(int)len;

-(void)null;

-(NSString *)description;

@end

@interface GFSrein : GFSelement <GFSreinforced> {
    int endmarker;
    NSString *tex;
}
//@property (strong) GFS* gfs;
@property int endmarker;
@property NSString *tex;

-(double)eval;
-(id)initWithArray:(int [])n andGFS:(GFS *)gfs repairing:(int[])rep;
-(id)initWithString:(NSString *)s andGFS:(GFS*)g;
-(int*)getArray;
-(int)getEnd;
@end

@interface OUT : NSObject {
    GFS *gfs;
    IN *in;
    Configuration *configuration;
    NSMutableDictionary *calculations;
    
}
@property (readwrite,retain) GFS* gfs;
@property (readwrite,retain) IN* in;
@property (readwrite,retain) Configuration *configuration;
@property (readwrite) NSMutableDictionary *calculations;

- (id)initWithInput:(IN*)i configuration:(Configuration*) con andGFS:(GFS*)gs;
-(id)initWithConfiguration:(NSDictionary*) conf andGFS:(GFS*)gfs;
-(BOOL)insertFitness:(double)i string:(NSString*)s ofMethod:(NSString*)m;
-(NSString*)description;
-(NSString*)bestDescription;
@end

