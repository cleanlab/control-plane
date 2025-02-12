def load_env_as_secrets(secret_ref_name, env_file_path):
    local_resource(
        'create-dotenv-secret-{}'.format(secret_ref_name),
        cmd='kubectl create secret generic {} --from-env-file={} -o yaml --dry-run=client | kubectl apply -f -'.format(secret_ref_name, env_file_path),
        deps=[env_file_path]
    )
