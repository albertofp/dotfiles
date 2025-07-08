# Content Load Balancer for `jw-sg-backend`

## Overview

Create a load balancer that the `jw-sg-backend` API will connect to in order to access content services.

## Current Architecture

`jw-sg-backend` instantiates rpc clients for each content service it needs to use:

* `consumer-api`
* `user-profile-api`
* `gefjon`
* `idservice`
* `content-api`
    * `ro_client`
    * `rw_client`
    * `caching_client`
* `recommender`
* `experimentsconfigs-api`

## Goals

* Decouple the `jw-sg-backend` API from the content services it needs to use.
* Facilitate adding/removing content services
