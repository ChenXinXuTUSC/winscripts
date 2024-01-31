#ifndef DUMMY_H
#define DUMMY_H

// MSVC default export behaviour is different from
// GNU, it only exports  normal  functions,  other
// type of data need to be exported explicitly
#if defined(CXX_COMPILER_ID_MSVC)
    #include <windows.h>
    #define DLLEXPORT __declspec(dllexport)
#else
    #define DLLEXPORT
#endif

extern DLLEXPORT int dumyi;

void print_msg(const char* msg);

#endif
