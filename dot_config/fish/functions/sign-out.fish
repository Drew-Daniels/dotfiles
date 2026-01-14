function sign-out -d "Signs out"
    echo "Signing out..."
    command curl -s -o /dev/null -X POST localhost:3000/users/sign_out
    if test $status -eq 0
        echo "Successfully signed out"
    else
        echo "An error occurred while trying to sign out"
        exit 1
    end
end
