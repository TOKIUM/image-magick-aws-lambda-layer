# ImageMagick AWS Lambda Layer
Build and publish an AWS Lambda Layer which provides ImageMagick.

## Requirements
- Docker
- AWS CLI v2
- Node.js (npm)

## Release
A layer called `image-magick-aws-lambda-layer` will be published with AWS CLI.
`npm install` is not needed because the project has no npm dependencies.

Copy `.env.release.example` to `.env.release`, and set the AWS account to publish to and the AWS CLI profile.
`.env.release` is not committed.

```sh
cp .env.release.example .env.release  # only for the first time
npm run release
```

The release stops if the credentials belong to another AWS account.
The description of the layer is generated from the version of the built `identify` (`ImageMagick v<version>`), and the published layer version is printed at the end.

Publishing the layer does not change the Lambda functions by itself.
However, keihi-lambda's receipt-thumbnails uses the latest version of this layer unless a version is specified, so a published version is picked up on its next deployment.

## Usage
If you attach the layer to a lambda function, command line tools will be installed under `/opt/bin`.

```sh
/opt/bin/identify --version
```

## License
ImageMagick License. See [LICENSE](https://github.com/BearTail/image-magick-aws-lambda-layer/blob/main/LICENSE) for more details.
