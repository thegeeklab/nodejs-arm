local PipelineBuild(os='linux', arch='amd64') = {
  kind: "pipeline",
  name: os + "-" + arch,
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
      name: "checksum",
      image: "alpine",
      pull: "always",
      commands: [
        "apk add --no-cache coreutils",
        "sha256sum -b dist/* > sha256sum.txt"
      ],
    },
    {
      name: "gpg-sign",
      image: "plugins/gpgsign:1",
      pull: "always",
      settings: {
        key: { "from_secret": "gpgsign_key" },
        passphrase: { "from_secret": "gpgsign_passphrase" },
        detach_sign: true,
        files: [ "dist/*" ],
      },
    },
    {
      name: "publish-github",
      image: "plugins/github-release",
      pull: "always",
      settings: {
        api_key: { "from_secret": "github_token"},
        files: ["dist/*", "sha256sum.txt"],
        overwrite: true,
        note: "NOTE.md",
        title: "${DRONE_TAG}",
      },
    },
  ],
  trigger: {
    event: [ "tag" ],
  },
};

local PipelineNotifications(depends_on=[]) = {
  kind: "pipeline",
  name: "notification",
  platform: {
    os: "linux",
    arch: "amd64",
  },
  steps: [
    {
      image: "plugins/matrix",
      name: "matrix",
      pull: 'always',
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
  trigger: {
    event: [ "tag" ],
    status: [ "success", "failure" ],
  },
  depends_on: depends_on
};

[
  PipelineBuild(os='linux', arch='amd64'),
  PipelineNotifications(depends_on=[
    "linux-amd64"
  ])
]
