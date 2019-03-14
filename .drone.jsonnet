local PipelineBuild(os='linux', arch='amd64') = {
  kind: "pipeline",
  name: "build",
  platform: {
    os: os,
    arch: arch,
  },
  steps: [
    {
      name: "build",
      image: "centos:7",
      pull: "always",
      environment: {
        NODE_VERSION: "${DRONE_TAG##v}"
      },
      commands: [
        "/bin/bash ./build.sh"
      ],
    },
    {
      name: "publish-github",
      image: "plugins/github-release",
      pull: "always",
      settings: {
        api_key: { "from_secret": "github_token"},
        files: ["dist/*"],
      },
    },
  ],
  trigger: {
    event: [ "tag" ],
  },
};

local PipelineNotifications(depends_on=[]) = {
  kind: "pipeline",
  name: "notifications",
  platform: {
    os: "linux",
    arch: "amd64",
  },
  steps: [
    {
      image: "plugins/matrix",
      name: "matrix",
      settings: {
        homeserver: "https://matrix.rknet.org",
        roomid: "MtidqQXWWAtQcByBhH:rknet.org",
        template: "Status: **{{ build.status }}**<br/> Build: [{{ repo.Owner }}/{{ repo.Name }}]({{ build.link }}) ({{ build.branch }}) by {{ build.author }}<br/> Message: {{ build.message }}",
        username: { "from_secret": "matrix_username" },
        password: { "from_secret": "matrix_password" },
      },
      when: {
        status: [ "success", "failure" ],
      },
    },
  ],
  depends_on: depends_on
};

[
  PipelineBuild(os='linux', arch='amd64')
]
