# ImageMagick AWS Lambda Layer
Build and publish an AWS Lambda Layer which provides ImageMagick.

## Requirements
- Docker
- Linux
- Node

## Release
A layer called `image-magick-aws-lambda-layer` will be published with [Serverless Framewok](https://www.serverless.com/).

```sh
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
