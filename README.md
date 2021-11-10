# dataworks-ecr-ap-r-image


## Docker image for RStudio OSS and associated dependancies for AP.

This repository creates a docker image containing the OpenSource version of RStudio, with a set of R packages.
This is a repo for creating docker R images for AP in dataworks. The flow starts from a concourse pipeline and then triggers into GHA workflow to build docker images then pushes the image into a private ECR repository.
This repo contains Makefile, Dockerfile and base terraform folders and jinja2 files to fit the standard pattern.
This repo is a base to create new Docker building repos, adding the githooks submodule, making the repo ready for use.

Running aviator will create the pipeline required on the AWS-Concourse instance, in order pass a mandatory CI ran status check.  this will likely require you to login to Concourse, if you haven't already.

For more information please go to:
https://git.ucd.gpn.gov.uk/dip/datsci-model-build/wiki

## Dockerfile
The docker file builds RStudio and packages from source.
The packages to install are listed in the R_PKGS environment variable.

The running container accepts the following environment variables.

Name | Description
-----|------------
HTTP_PROXY | The internet proxy for HTTP requests.
HTTPS_PROXY | The internet proxy for HTTPS requests.
NO_PROXY | URLs that we can connect to directly rather than going via the proxy.
USER | The username of the RStudio user.
JWT_TOKEN | An identity JWT token used to authenticate against HiveServer2 and Livy
LIVY_URL | The url for the livy proxy to connect to for livy requests
GITHUB_URL | The DNS name for the version of github to connect to.

Some of these environment variables are used to setup some of the R config files, so the Dockerfile
actually writes dynamic scripts which will use those environment variables at runtime.

Note global changes should be added to the /usr/local/lib/R/etc/Rprofile.site rather than overwriting ~/.RProfile

## ODBC
R Studio can connect via ODBC to Hive using the library(odbc) package which Amazon provides.
The [odbc.ini](https://github.com/dwp/docker-ecr-ap-r-image/blob/master/build/odbc.ini) file specifies the DSN for the ODBC connection.
The connection uses SASL and username/password authentication where the JWT_TOKEN is used as a short lived password.

There is an ODBC PDF is available in the R-Studio image at /opt/amazon/hiveodbc/'Amazon ODBC Driver for Hive Install Guide.pdf'.

## Livy/Spark
R Studio can connect via Livy to Spark using the library(sparklyr) package.
Note that the connection details are in the [helpers.r](https://github.com/dwp/docker-ecr-ap-r-image/blob/master/build/helpers.r).

## CI

There is a GitHub Actions pipeline in the DWP organisation which builds and deploys the image to docker hub. The image is then mirrored to ECS via the [mirror images pipeline](https://ci.dataworks.dwp.gov.uk/teams/dataworks/pipelines/mirror-docker-images) in AWS Concourse.

There is also a pipeline for this repo which creates the ECS repository in mgmt and mgmt-dev.
