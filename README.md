<!-- markdownlint-disable MD041 -->
<!-- markdownlint-disable MD012 -->

# deno

Repo Template for Deno


## Binary Distribution

[![Docker Image Version (tag latest semver)](https://img.shields.io/docker/v/lukechannings/deno/latest?label=Docker%20Image)](https://hub.docker.com/r/lynsei/bin/tags)
[![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/lukechannings/deno-arm64?label=ARM64%20Binary)](https://github.com/softdist/docker.client/releases/tag/main)

### Supported Platforms


> [!IMPORTANT]
>
> The following platforms are *currently* supported:

* darwin
  * amd64
  * arm64
* linux
  * amd64
  * arm64
* windows
  * amd64
  * -arm64- (unsupported)

## Index


| Command | Purpose |
| -- | -- |
| name |  Creates a thing |
| default | Does another thing |

<!-- github feature -->
<!-- markdownlint-disable MD033 -->
<details>
  <summary>Detailed Information</summary>

    ## Hide me

    Lots of details
</details>

# Logical Diagram

<!-- github feature -->
<!-- markdownlint-disable MD046 -->
```mermaid
---
title: Docker Client
---
  graph TD;
      deno_code-->release_auto_tag;
      release_auto_tag-->release_build_deno;
      release_build_deno-->release_publish_artifact;
```
