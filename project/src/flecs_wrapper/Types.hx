package flecs_wrapper;

#if (cpp && !scriptable && !macro)
typedef Float32 = cpp.Float32;
typedef Float64 = cpp.Float64;

typedef Int8   = cpp.Int8;
typedef UInt8  = cpp.UInt8;
typedef Int16  = cpp.Int16;
typedef UInt16 = cpp.UInt16;
typedef Int32  = cpp.Int32;
typedef UInt32 = cpp.UInt32;
typedef Int64  = cpp.Int64;
typedef UInt64 = cpp.UInt64;
#else
typedef Float32 = Float;
typedef Float64 = Float;

typedef Int8   = Int;
typedef UInt8  = Int;
typedef Int16  = Int;
typedef UInt16 = Int;
typedef Int32  = Int;
typedef UInt32 = Int;
typedef Int64  = Int;
typedef UInt64 = Int;
#end
