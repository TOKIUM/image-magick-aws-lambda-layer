# ImageMagick AWS Lambda Layer
Build and publish an AWS Lambda Layer which provides ImageMagick.

## Requirements
- Docker
- Linux
- Node

## Release
A layer called `image-magick-aws-lambda-layer` will be published with [Serverless Framework](https://www.serverless.com/) v4.

Serverless Framework v4 requires Node.js 18.17 or later and a license key.
Set the license key (the same one used by keihi-lambda) as an environment variable before running the release command.

```sh
export SERVERLESS_LICENSE_KEY=...

npm install
npm run release

# release option
npm run release -- --stage dev --region ap-southeast-1
```

## Usage
If you attach the layer to a lambda function, command line tools will be installed under `/opt/bin`.

```sh
/opt/bin/identify --version
```

## License
ImageMagick License. See [LICENSE](https://github.com/BearTail/image-magick-aws-lambda-layer/blob/main/LICENSE) for more details.
