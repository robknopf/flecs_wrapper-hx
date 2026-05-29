package flecs_wrapper;

#if (cpp && !scriptable && !macro)
typedef NativePtr<T> = cpp.Pointer<T>;
#else
typedef NativePtr<T> = Dynamic;
#end
