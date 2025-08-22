function create_ts_project -d "Scaffolds a new TS project"
    # TODO: Allow specification of package manager to use: npm, yarn, pnpm
    # TODO: Add a 'build' script command to `package.json#scripts` that runs 'tsc'

    if ! count $argv >/dev/null
        echo "Must specify a project name/directory"
        return 2
    end

    # TODO: Only collect the first argument and toss the rest

    # Create new project directory
    mkdir -p $argv
    cd $argv

    # Create .mise.toml
    mise use node@22.17.1

    # Initialize NPM project
    npm init -y

    # TODO: Update 'main' to `dist/index.js`

    # TODO: Create 'test' script: `npm run test:unit && npm run test:integration`

    # TODO: Create 'test:unit' script: `node --test --experimental-test-coverage ./test/unit/**/*.ts`

    # TODO: Create 'test:integration' script: `npx cucumber-js -c cucumber.js`

    # TODO: Create 'dev' script: `tsc --watch`

    # TODO: Create 'build' script: `tsc --build`

    # Install Dev Dependencies
    npm i -D \
        @cucumber/cucumber \
        @cucumber/pretty-formatter \
        cucumber-console-formatter \
        typescript \
        @types/node \
        typescript-eslint \
        eslint \
        cspell \
        jiti \
        @eslint/js \
        @cspell/eslint-plugin \
        eslint-config-prettier \
        prettier

    # Install Runtime dependencies
    npm i dotenvx

    # Create tsconfig.json
    npx tsc --init --outdir "./dist"

    # TODO: Create eslint.config.js

    # TODO: Create cspell.config.js

    # TODO: Create cucumber.js file

    # Initialize git repository
    git init

    # Initialize directory structure
    mkdir src
    mkdir -p test/features/step_defitions test/unit
    touch src/index.ts

    # Create README.md
    echo "# ${$argv}" >README.md

    # Create .gitignore
    echo dist >>.gitignore

    # Initial commit
    git add .
    git commit -m "Initial commit"

    # Create a new tmuxinator configuration file
    # cat < < yaml >"~/projects/${argv}.yaml"
    # name: ${argv}
    # root: ~/projects/${argv}
    # windows:
    # - root:
    # layout: main-horizontal
    # panes:
    # - editor:
    # - fish
    # - cls
    # - nvim
    # - dev:
    # - fish
    # - cls
    # - cmd:
    # - fish
    # - cls
    # yaml
    #
    # # Launch new tmux session
    # mux ${argv}

    return 0

end
