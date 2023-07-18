#include "utils/clog.h"

int main(int argc, char* argv[])
{
    LOG(DBUG, "hello, world");

    print_addr1();
    print_addr2();

    return 0;
}
