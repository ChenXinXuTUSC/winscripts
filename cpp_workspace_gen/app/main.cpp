#include "dummy/dummy.h"
#include "utils/log.h"
#include "mathnipet.h"

int main(void)
{
    print_msg("Hello, world!");
    LOG(LOG_LVL::DBUG, GRN("Hello"), YLW(","), RED("world!"));
    LOG(LOG_LVL::INFO);
    LOG(LOG_LVL::WARN, "1 + 1", "=", add(1, 1));
    LOG(LOG_LVL::ERRO, "1 - 1", "=", sub(1, 1));
    LOG(LOG_LVL::FATL, "log test complete...");
    return 0;
}

