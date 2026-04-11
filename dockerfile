docker run --rm -it \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v $(pwd)/runner-config:/etc/gitlab-runner \
  --network db-anonymizer_gitlab-network \
  gitlab/gitlab-runner:latest register