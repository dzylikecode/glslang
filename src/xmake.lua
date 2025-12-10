add_rules("plugin.compile_commands.autoupdate",{outputdir =".vscode"})
set_policy("package.requires_lock", true)
add_requires("glslang", {configs = {shared = true, static = false}})


target("dll")
    set_kind("binary")
    add_files("src/*.cpp")
    add_packages("glslang")

    after_install(function (target)
        local glslang_pkg = target:pkg("glslang")
        if not glslang_pkg then
            print("Warning: glslang package not found")
            return
        end
        local installdir = os.getenv("XMAKE_INSTALL_DIR") or "dist"
        os.cp(glslang_pkg:installdir(), path.join(installdir, "glslang"))
    end)
