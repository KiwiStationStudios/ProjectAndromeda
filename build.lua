return {
    name = "Project Andromeda!",
    developer = "KiwiStationStudios",
    output = "./export",
    version = "0.0.1",
    love = "11.5",
    ignore = {
        "export", 
        "boot.cmd", 
        ".gitignore", 
        ".gitattribute", 
        ".commitid", 
        "icon_old.png", 
        "docs", 
        ".VSCodeCounter",
        "project",
        "gjassets",
        "README.md",
        "icon.png"
    },
    icon = "icon.png",
    
    identifier = "com.kiwistationstudios.projectandromeda", 
    libs = { 
        windows = {
            "bin/win/https.dll",
            "bin/win/discord-rpc.dll"
        },
        macos = {
            "bin/macos/https.so",
            "bin/macos/libdiscord-rpc.dylib"
        },
        linux = {
            "bin/linux/https.so",
            "bin/linux/libdiscord-rpc.so"
        },
        all = {"LICENSE.md"}
    },
    platforms = {"windows", "linux"} 
}