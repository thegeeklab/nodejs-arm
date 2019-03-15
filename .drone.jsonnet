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
      image: "xoxys/cc-arm:linux-amd64",
      pull: "always",
      environment: {
        NODE_VERSION: "${DRONE_TAG##v}",
        COMPILER_CC: "arm-rpi-linux-gnueabihf-gcc -march=armv7-a -static-libstdc++",
        COMPILER_CXX: "arm-rpi-linux-gnueabihf-g++ -march=armv7-a -static-libstdc++"
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
