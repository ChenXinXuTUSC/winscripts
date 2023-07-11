#include "dummy/dummy.h"
#include "log.h"


int main(void)
{
    print_msg("Hello, world!");
    LOG(LOG_LVL::DBUG, GRN("Hello"), YLW(","), RED("world!"));
    LOG(LOG_LVL::DBUG);
    return 0;
}

