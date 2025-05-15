return {
    cmd = {
        "clangd",
        "-j=3",
        "--header-insertion=iwyu",
        "--completion-style=detailed",
        "--cross-file-rename",
    },
    single_file_support = false,
    init_options = {
        usePlaceholders = true,
        completeUnimported = true,
        clangdFileStatus = true,
    },
}
