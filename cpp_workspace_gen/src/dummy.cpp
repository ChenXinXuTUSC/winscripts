#include "dummy/dummy.h"
#include "log.h"
#include <iostream>

void print_msg(const char *msg)
{
    using namespace std;
    cout << "msg - " << msg << endl;
    LOG(LOG_LVL::DBUG, msg);
    LOG(LOG_LVL::DBUG);
}
