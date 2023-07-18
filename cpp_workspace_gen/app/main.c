#include "clog.h"

int main(int argc, char** argv)
{
    LOG(DBUG, "%d %s", 1024, GRN("hello, world"));
    return 0;
}
