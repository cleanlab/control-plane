load("deploy/tilt/posthog-reverse-proxy/Tiltfile", "deploy_posthog_reverse_proxy")

should_deploy_all = os.getenv("DEPLOY_ALL", "true").lower() == "true"
should_deploy_posthog_reverse_proxy = os.getenv("DEPLOY_POSTHOG_REVERSE_PROXY", "false").lower() == "true"

def deploy_services():
    if should_deploy_all or should_deploy_posthog_reverse_proxy:
        deploy_posthog_reverse_proxy()


deploy_services()
