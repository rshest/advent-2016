#include <iostream>
#include <string>
#include <vector>
#include <algorithm>

typedef std::vector<std::string> string_list;

struct keypad {
    int startx, starty;
    std::vector<std::string> cells;
};

const keypad KEYPAD1 = 
{2, 2, {
".....",
".123.",
".456.",
".789.",
"....."}};


const keypad KEYPAD2 =
{1, 3, {
".......",
"...1...",
"..234..",
".56789.",
"..ABC..",
"...D...",
"......."}};


std::string compute_code(const keypad& kp, const string_list& path) {
    std::string res;
    int x = kp.startx, y = kp.starty;
    for (const auto& p: path) {
        for (char c: p) {
            switch (c) {
            case 'R': x = kp.cells[y][x + 1] == '.' ? x : x + 1; break;
            case 'D': y = kp.cells[y + 1][x] == '.' ? y : y + 1; break;
            case 'L': x = kp.cells[y][x - 1] == '.' ? x : x - 1; break;
            case 'U': y = kp.cells[y - 1][x] == '.' ? y : y - 1; break;
            default: { std::cerr << "Unrecognized instruction, code " << (int)c; exit(1); }
            }
        }
        res += kp.cells[y][x];
    }
    return res;
}

int main() {
    string_list path;
    std::string str;
    while (std::getline(std::cin, str)) {
        path.push_back(str);
    }
    std::cout << "Code 1: " << compute_code(KEYPAD1, path) << std::endl;
    std::cout << "Code 2: " << compute_code(KEYPAD2, path) << std::endl;
    return 0;
}

