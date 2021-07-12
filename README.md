# Docker Monarc
This is the build for a monarc docker container.

## Database

This container does not provide databases for the service.
Please make sure that you provide it with two distinct databases "monarc_cli" and "monarc_common" and an appropriate user.
Please set up the proper credentials in ./rundocker.sh

Also note that in case of a fresh install, you should initialize the databases with the provided ./initdb.sh script. (Todo : dockerize, provide db docker)
