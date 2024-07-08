hostname = "submarine"

do_install:append() {
    cat > ${D}${sysconfdir}/motd <<EOF
Welcome to the submarine!
EOF
}
