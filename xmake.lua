-- xmake macro package -a x86_64 -o ../000_packages -p mingw

set_project("001_lua")
set_version("5.3.6", {build = "%Y%m%d%H%M"})
set_xmakever("2.2.5")
set_warnings("all", "error")

set_languages("gnu99", "cxx11")
add_cxflags("-Wno-error=deprecated-declarations", "-fno-strict-aliasing")
add_cxflags("-O2", "-Wall", "-Wextra", "-fPIC")

add_defines("LUA_COMPAT_5_2=1")
set_strip("all")

if is_plat("linux") then
    add_defines("LUA_USE_LINUX=1")
    add_links("dl", "readline")
end

target("lualib-5.3.6") 
    set_kind("static")    
    add_headerfiles("lua-5.3.6/src/*.h")
    add_files("lua-5.3.6/src/lapi.c"
    	, "lua-5.3.6/src/lcode.c"
    	, "lua-5.3.6/src/lctype.c"
    	, "lua-5.3.6/src/ldebug.c"
    	, "lua-5.3.6/src/ldo.c"
    	, "lua-5.3.6/src/ldump.c"
    	, "lua-5.3.6/src/lfunc.c"
    	, "lua-5.3.6/src/lgc.c"
    	, "lua-5.3.6/src/llex.c"
    	, "lua-5.3.6/src/lmem.c"
    	, "lua-5.3.6/src/lobject.c"
    	, "lua-5.3.6/src/lopcodes.c"
    	, "lua-5.3.6/src/lparser.c"
    	, "lua-5.3.6/src/lstate.c"
    	, "lua-5.3.6/src/lstring.c"
    	, "lua-5.3.6/src/ltable.c"
    	, "lua-5.3.6/src/ltm.c"
    	, "lua-5.3.6/src/lundump.c"
    	, "lua-5.3.6/src/lvm.c"
    	, "lua-5.3.6/src/lzio.c"
    	, "lua-5.3.6/src/lauxlib.c"
    	, "lua-5.3.6/src/lbaselib.c"
    	, "lua-5.3.6/src/lbitlib.c"
    	, "lua-5.3.6/src/lcorolib.c"
    	, "lua-5.3.6/src/ldblib.c"
    	, "lua-5.3.6/src/liolib.c"
    	, "lua-5.3.6/src/lmathlib.c"
    	, "lua-5.3.6/src/loslib.c"
    	, "lua-5.3.6/src/lstrlib.c"
    	, "lua-5.3.6/src/ltablib.c"
    	, "lua-5.3.6/src/lutf8lib.c"
    	, "lua-5.3.6/src/loadlib.c"
    	, "lua-5.3.6/src/linit.c"
    	)


target("lua")  
 	add_deps("lualib-5.3.6")
    set_kind("binary")
    add_files("lua-5.3.6/src/lua.c")
	add_links("lualib-5.3.6")
	add_rules("binaryrule")

target("luac")  
 	add_deps("lualib-5.3.6")
    set_kind("binary")
    add_files("lua-5.3.6/src/luac.c")
	add_links("lualib-5.3.6")
	add_rules("binaryrule")

rule("binaryrule")
    set_extensions("", ".exe") 
 	after_package(function (target)
        local targetfile = target:targetfile() 
        local extstr = path.extension(targetfile)
        local targetdir = target:targetdir() 
        local filename = target:name() .. extstr 

        local destdir = "../000_packages/lualib-5.3.6.pkg/$(plat)/$(arch)/bin/$(mode)"
        if not os.exists(destdir) then os.mkdir(destdir) end 
        local destfile = path.join(destdir, filename) 
        if os.exists(destfile) then os.rm(destfile) end 

        print("package " .. targetfile .. " => " .. destfile) 
        os.cp(targetfile, destfile) 
    end)
