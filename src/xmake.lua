add_rules("plugin.compile_commands.autoupdate",{outputdir =".vscode"})
set_policy("package.requires_lock", true)
add_requires("glslang", {system = false, configs={shared = true}})


target("dart_dll")
    set_kind("binary")
    add_files("src/*.cpp")
    add_packages("glslang")

    after_install(function (target)
        local pkg = target:pkg("glslang")
        if not pkg then
            print("Warning: glslang package not found")
            return
        end
        os.cp(pkg:installdir(), path.join(target:installdir(), "glslang"))
    end)
