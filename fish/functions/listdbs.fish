function listdbs -d "Lists all available postgres databases"
    psql -U postgres -c 'select datname from pg_database where datistemplate = false' | tail -n +4
end
