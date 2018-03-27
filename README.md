
This is a template project, so the intention is that you copy it to start a new project of your own. It's not particularly designed for updates, so as changes are made to the service, you need to fold them into your own services with a bit of care.

This project provisions infrastructure for a service stack, including code repository, pipeline, and some rudimentary tests. It includes its own base networking, so it has a VPC, subnets, routing, bastion, etc.

If you want to share a set of networking resources across multiple services, you should use the "bare" service stack template instead (coming soon!).

Usage:
======

1. Grab everything under the `service-template` folder.
2. Copy the `example-service-configuration.mk` file to `service-configuration.mk` and edit it to suit your needs.
3. Run `make` to see what you can do with it.


```
curl -LfOs https://github.com/kief/spin-template-standalone-service/archive/latest.tar.gz
tar xzf latest.tar.gz spin-template-standalone-service-latest/service-template
mv spin-template-standalone-service-latest/service-template myservice
rmdir spin-template-standalone-service-latest
cp myservice/example-service-configuration.mk myservice/service-configuration.mk
```

Updating:
---------

Download the latest template files and copy them over your project folder. Do this at your own risk!

```
curl -LfOs https://github.com/kief/spin-template-standalone-service/archive/latest.tar.gz
tar xzf latest.tar.gz spin-template-standalone-service-latest/service-template
rsync -plrv spin-template-standalone-service-latest/service-template/ ./myservice/
```


