function is-freebsd --description "Check if running on FreeBSD"
    test (uname) = FreeBSD
end
