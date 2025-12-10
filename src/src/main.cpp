#include "glslang/Include/glslang_c_interface.h"
#include <iostream>

int main() {
    glslang_version_s version;
    glslang_get_version(&version);
    std::cout << "glslang version: " << version.major << "." << version.minor << "." << version.patch << std::endl;
    std::cout << version.flavor << std::endl;
    return 0;
}