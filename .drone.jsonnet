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
      image: "xoxys/rpmbuild-centos7",
      pull: "always",
      environment: {
        NODE_VERSION: "10.15.3"
      },
      commands: [
        "/bin/bash ./build.sh"
      ],
    },
  ]
};

local PipelineNotifications = {
  kind: "pipeline",
  name: "notifications",
  platform: {
    os: "linux",
    arch: "amd64",
  },
  steps: [
    {
      image: "plugins/matrix",
      settings: {
        homeserver: "https://matrix.rknet.org",
        roomid: "MtidqQXWWAtQcByBhH:rknet.org",
        template: "Status: **{{ build.status }}**<br/> Build: [{{ repo.Owner }}/{{ repo.Name }}]({{ build.link }}) ({{ build.branch }}) by {{ build.author }}<br/> Message: {{ build.message }}",
        username: { "from_secret": "matrix_username" },
        password: { "from_secret": "matrix_password" },
      },
    },
  ],
  depends_on: [
    "deployment",
  ],
  trigger: {
    event: [ "push", "tag" ],
    status: [ "success", "failure" ],
  },
};

[
  PipelineBuild(os='linux', arch='arm')
]
