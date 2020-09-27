local PipelineBuild(os='linux', arch='amd64') = {
  kind: 'pipeline',
  name: os + '-' + arch,
  platform: {
    os: os,
    arch: arch,
  },
  steps: [
    {
      name: 'build',
      image: 'thegeeklab/cc-arm',
      environment: {
        NODE_VERSION: '${DRONE_TAG##v}',
        COMPILER_CC: 'arm-rpi-linux-gnueabihf-gcc -march=armv7-a -static-libstdc++',
        COMPILER_CXX: 'arm-rpi-linux-gnueabihf-g++ -march=armv7-a -static-libstdc++',
      },
      commands: [
        '/bin/bash ./build.sh',
      ],
    },
    {
      name: 'checksum',
      image: 'alpine',
      commands: [
        'apk add --no-cache coreutils',
        'sha256sum -b dist/* > sha256sum.txt',
      ],
    },
    {
      name: 'gpg-sign',
      image: 'plugins/gpgsign:1',
      pull: 'always',
      settings: {
        key: { from_secret: 'gpgsign_key' },
        passphrase: { from_secret: 'gpgsign_passphrase' },
        detach_sign: true,
        files: ['dist/*'],
      },
      when: {
        ref: ['refs/tags/**'],
      },
    },
    {
      name: 'publish-github',
      image: 'plugins/github-release',
      settings: {
        api_key: { from_secret: 'github_token' },
        files: ['dist/*', 'sha256sum.txt'],
        overwrite: true,
        note: 'NOTE.md',
        title: '${DRONE_TAG}',
      },
      when: {
        ref: ['refs/tags/**'],
      },
    },
  ],
  trigger: {
    ref: ['refs/heads/master', 'refs/tags/**', 'refs/pull/**'],
  },
};

local PipelineNotifications(depends_on=[]) = {
  kind: 'pipeline',
  name: 'notification',
  platform: {
    os: 'linux',
    arch: 'amd64',
  },
  steps: [
    {
      name: 'matrix',
      image: 'plugins/matrix',
      settings: {
        homeserver: { from_secret: 'matrix_homeserver' },
        roomid: { from_secret: 'matrix_roomid' },
        template: 'Status: **{{ build.status }}**<br/> Build: [{{ repo.Owner }}/{{ repo.Name }}]({{ build.link }}) ({{ build.branch }}) by {{ build.author }}<br/> Message: {{ build.message }}',
        username: { from_secret: 'matrix_username' },
        password: { from_secret: 'matrix_password' },
      },
      when: {
        status: ['success', 'failure'],
      },
    },
  ],
  trigger: {
    ref: ['refs/heads/master', 'refs/tags/**'],
    status: ['success', 'failure'],
  },
  depends_on: depends_on,
};

[
  PipelineBuild(os='linux', arch='amd64'),
  PipelineNotifications(depends_on=[
    'linux-amd64',
  ]),
]
