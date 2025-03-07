function sign_in -d "Signs in with curl and saves cookie"
    # get csrf token
    # TODO: Rename?
    set csrf_token (command curl -s localhost:3000/users/sign_in | rg "csrf-token" | sed -En 's/.*content="(.*)".*/\1/p')
    # sign in with credentials and csrf token
    # TODO: De-hardcode cookie path
    # TODO: Return error code when missing env vars
    # TODO: Use 1Password CLI to securely fetch credentials instead of using env vars
    echo "Signing in..."
    command curl -s -o /dev/null -X POST http://localhost:3000/users/sign_in \
        -F "user[login]=$KIPU_CAS_USER_LOGIN" \
        -F "user[password]=$KIPU_CAS_USER_PASSWORD" \
        -F "authenticity_token=$csrf_token" \
        -c $KIPU_CAS_COOKIE_PATH
    if test $status -eq 0
        echo "Signed in"
    else
        echo "Unable to sign in"
        exit 1
    end
end
