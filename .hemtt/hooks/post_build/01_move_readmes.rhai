let docs_readmes = ["README.md"];
for readme in docs_readmes {
    HEMTT_VFS.join("docs").join(readme).move(HEMTT_VFS.join(readme));
}