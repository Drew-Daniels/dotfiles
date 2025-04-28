function create_ts_project -d "Scaffolds a new TS project"
    # TODO: Allow specification of package manager to use: npm, yarn, pnpm
    if count $argv >/dev/null
        mkdir -p $argv
        cd $argv
        npm init -y
        npm install typescript @types/node -D
        npx tsc --init --outdir "./dist"
        git init
        touch index.ts
        git add .
        git commit -m "Initial commit"
        return 0
    else
        echo "Must specify a project name/directory"
        return 1
    end
end
