#ifndef LOG_H
#define LOG_H
#include <iostream>
#include <string>

template<typename... Type>
std::string concate_strs(Type... strs);
template<typename... Type>
std::string concate_strs(Type... strs)
{
    std::string concate = "";
    (concate += std::string(strs), ...); // only C++17 support fold expanding expression
    return concate;
}


enum class LOG_COLOR
{
    FORE_ORG = 0,
    FORE_BLK = 30,
    FORE_RED = 31,
    FORE_GRN = 32,
    FORE_YLW = 33,
    FORE_BLE = 34,
    FORE_PRP = 35,
    FORE_CYN = 36,
    FORE_WHE = 37,

    BACK_ORG = 0,
    BACK_BLK = 40,
    BACK_RED = 41,
    BACK_GRN = 42,
    BACK_YLW = 43,
    BACK_BLE = 44,
    BACK_PRP = 45,
    BACK_CYN = 46,
    BACK_WHE = 47,
};

std::string color_str(std::string str, LOG_COLOR fore_code, LOG_COLOR back_code);
#define BLE(STR) color_str(STR, LOG_COLOR::FORE_BLE, LOG_COLOR::BACK_ORG)
#define GRN(STR) color_str(STR, LOG_COLOR::FORE_GRN, LOG_COLOR::BACK_ORG)
#define YLW(STR) color_str(STR, LOG_COLOR::FORE_YLW, LOG_COLOR::BACK_ORG)
#define RED(STR) color_str(STR, LOG_COLOR::FORE_RED, LOG_COLOR::BACK_ORG)
#define PRP(STR) color_str(STR, LOG_COLOR::FORE_PRP, LOG_COLOR::BACK_ORG)

enum class LOG_LVL
{
    DBUG = 4,
    INFO = 3,
    WARN = 2,
    ERRO = 1,
    FATL = 0,
};

template<typename... Type>
void print_varlen_msgs(std::string file, int line, LOG_LVL level, Type... msgs);
template<typename... Type>
void print_varlen_msgs(std::string file, int line, LOG_LVL level, Type... msgs) {
    std::string prefix = "[NONE]";
    switch (level)
    {
    case LOG_LVL::DBUG:
        prefix = BLE("[DBUG]");
        break;
    
    case LOG_LVL::INFO:
        prefix = GRN("[INFO]");
        break;
    
    case LOG_LVL::WARN:
        prefix = YLW("[WARN]");
        break;

    case LOG_LVL::ERRO:
        prefix = RED("[ERRO]");
        break;
    
    case LOG_LVL::FATL:
        prefix = PRP("[FATL]");
        break;
    
    default:
        break;
    }
    std::cout << prefix << ' ';
    ((std::cout << msgs << ' '), ...) << std::endl;
    std::cout << "    " << file << ' ' << line << std::endl;
}
template<> // in case that LOG doesn't receive any strings.
void print_varlen_msgs(std::string file, int line, LOG_LVL level)
{
    print_varlen_msgs(file, line, level, "");
}

#define LOG(LEVEL, ...) print_varlen_msgs(__FILE__, __LINE__, LEVEL, ## __VA_ARGS__)

#endif // log.h