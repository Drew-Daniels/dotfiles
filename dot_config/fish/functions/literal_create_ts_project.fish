function create_ts_project -d "Scaffolds a new TS project"
    # TODO: Allow specification of package manager to use: npm, yarn, pnpm
    # TODO: Allow specification of runtime manager: mise, nvm, asdf

    if ! count $argv >/dev/null
        echo "Must specify a project name/directory"
        return 2
    end

    set -l project_name $argv[1]

    # Create new project directory
    mkdir -p $project_name
    cd $project_name

    # Create .mise.toml
    mise use node@22.17.1

    # Initialize NPM project
    npm init git@github.com:Drew-Daniels/default-tsconfig.git

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
        tsx \
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
    cat < < json >"tsconfig.json"
    {
      "compilerOptions": {
        "declaration": true,
        "module": "Node16",
        "outDir": "dist",
        "rootDir": "src",
        "strict": true,
        "target": "es2022",
        "moduleResolution": "node16"
      },
      "include": ["./src/**/*"],
    }
    json

    # Create eslint.config.js
    cat < < javascript >"eslint.config.js"
    import js from '@eslint/js'
    import globals from globals
    import tseslint from typescript-eslint
    import cspellESLintPluginRecommended from '@cspell/eslint-plugin/recommended'
    import eslintConfigPrettier from eslint-config-prettier/flat
    import { defineConfig, globalIgnores } from eslint/config
    export default defineConfig([
      {
        files: ['**/*.{js,mjs,cjs,ts,mts,cts}'],
        plugins: { js },
        extends: ['js/recommended'],
        languageOptions: { globals: globals.node },
        linterOptions: {
          reportUnusedDisableDirectives: 'off',
        },
      },
      // @ts-expect-error https://github.com/typescript-eslint/typescript-eslint/issues/10899
      tseslint.configs.recommended,
      cspellESLintPluginRecommended,
      eslintConfigPrettier,
      globalIgnores(['./dist', './bin']),
    ])
    javascript

    # Create cspell.config.js
    cat < < javascript >"cspell.config.js"
    // @ts-check

    import { defineConfig } from cspell

    export default defineConfig({
      /* eslint-disable */
      words: [],
      /* eslint-enable */
    })
    javascript

    # TODO: Create cucumber.js file
    cat < < javascript >"cucumber.js"
    import tsx
    /**
    * Per issue linked below, we can use `tsx` instead of `ts-node` (to avoid installing another dependency)
    * However, we need to prefix call to cucumber-js with NODE_OPTIONS='--import tsx' in our test script
    * @see {@link https://github.com/cucumber/cucumber-js/blob/main/docs/configuration.md}
    * @see {@link https://github.com/cucumber/cucumber-js/issues/2339#issuecomment-2662258192}
    * @type {import("@cucumber/cucumber").IConfiguration}
    *
    */
    export default {
      paths: [ './test/features/**/*.feature' ],
      import: [ './test/features/**/*.ts' ],
      // loader: ['ts-node/esm'],
      formatOptions: {
        snippetInterface: 'async-await',
      },
      format: [
        'html:reports/report.html',
        'summary',
        '@cucumber/pretty-formatter',
        'cucumber-console-formatter',
        ]
      }
    javascript

    # Initialize git repository
    git init

    # Initialize directory structure
    mkdir src
    mkdir -p test/features/step_defitions test/unit
    touch src/index.ts

    # Create README.md
    echo "# $project_name" >README.md

    # Create .gitignore
    echo dist >>.gitignore

    # Initial commit
    git add .
    git commit -m "Initial commit"

    # Create a new tmuxinator configuration file
    cat < < yaml >"~/projects/$project_name.yml"
    name: $project_name
    root: ~/projects/$project_name
    windows:
    - root:
    layout: main-horizontal
    panes:
    - editor:
    - fish
    - cls
    - nvim
    - dev:
    - fish
    - cls
    - cmd:
    - fish
    - cls
    yaml

    # # Launch new tmux session
    # mux $project_name

    chezmoi add "$HOME/.config/tmuxinator/$project_name.yml"

    return 0

end
