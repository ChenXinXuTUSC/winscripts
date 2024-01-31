#include "clog.h"

char log_buf[BUF_SZE];
char tmp_buf[BUF_SZE];

char* color_str(int fore_code, int back_code, const char *str)
{
    char fore_code_buf[8];
    char back_code_buf[8];

    if (fore_code == FORE_ORG)
        sprintf_s(fore_code_buf, 8, "");
    else
        sprintf_s(fore_code_buf, 8, ";%d", fore_code);
    
    if (back_code == BACK_ORG)
        sprintf_s(back_code_buf, 8, "");
    else
        sprintf_s(back_code_buf, 8, ";%d", back_code);

    sprintf_s(tmp_buf, BUF_SZE, "\033[1%s%sm%s\033[0m", fore_code_buf, back_code_buf, str);

    return tmp_buf;
}

char* log_prefix(int level)
{
    // entry point will clean log buffer and tmp buffer
    memset(log_buf, 0, BUF_SZE);
    memset(log_buf, 0, BUF_SZE);
    memset(tmp_buf, 0, BUF_SZE);

    const char* prefix = "";
    switch (level)
    {
    case DBUG:
        prefix = BLE("[DBUG] ");
        break;
    
    case INFO:
        prefix = GRN("[INFO] ");
        break;
    
    case WARN:
        prefix = YLW("[WARN] ");
        break;
    
    case ERRO:
        prefix = RED("[ERRO] ");
        break;
    
    case FATL:
        prefix = PRP("[FATL] ");
        break;
    
    default:
        break;
    }

    strcat(log_buf, tmp_buf);

    return tmp_buf;
}

char* log_suffix(const char *file, int line)
{
    sprintf_s(tmp_buf, BUF_SZE, "\n    %s %d\n", file, line);
    strcat(log_buf, tmp_buf);
    return tmp_buf;
}
