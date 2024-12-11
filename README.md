# docling-base-image

Based dockerfile for Unstructured library

```
GIT_SHA=$(git rev-parse --short HEAD)
docker buildx build --platform linux/amd64,linux/arm64 -t ghcr.io/aurelio-labs/docling-base:latest -t ghcr.io/aurelio-labs/docling-base:sha-${GIT_SHA} -f Dockerfile --push .
```

If push fails, check if you are login in:

```
echo $GH_TOKEN | docker login ghcr.io -u <GITHUB_USER> --password-stdin
```
