#include "glslang/Include/glslang_c_interface.h"

int main() {
    glslang_version_s version;
    glslang_get_version(&version);
    return 0;
}