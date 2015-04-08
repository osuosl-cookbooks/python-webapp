# python-webapp

A cookbook for deploying webapps like GWM, ORVSD, or the Seagrant twins.
Design documentation is currently in a
[google doc](https://docs.google.com/a/osuosl.org/document/d/1CsCxTWM7fc0iXT8Lu4BnRJWtYLuwI6a-LFfEa5_BJ2w/edit).

## Supported Platforms

* Centos 6
* Centos 7
* Ubuntu 12.04
* Ubuntu 14.04

## Running tests

To run all tests, including style checks with both foodcritic and rubocop,
we use Rake. Rake allows for a granular level of testing, including running
integration, style, and unit testing from one tool.

To run all tests using a Vagrant virtual machine, run:

```
$ rake
```

If you have access to an Openstack environment, you can set up your environment
variables to allow you to run integration tests on Openstack. Setting that up
is beyond the scope of this guide; if you're already set up, you can run style
and unit tests locally and integration tests on Openstack with:

```
$ rake cloud
```


### Running integration tests

[Detailed instructions](https://github.com/osuosl-cookbooks/python-webapp/wiki/Development-Workflow#using-your-virtual-machine)

All integration tests:

```
$ rake integration:cloud
$ rake integration:vagrant
```

Individual integration test:

```
$ kitchen converge [test suite]
$ kitchen verify [test suite]
```

### Running unit tests

[Detailed instructions](https://github.com/osuosl-cookbooks/python-webapp/wiki/Development-Workflow#writing-a-chefspec-unit-test)

```
$ rake spec
```


## License and Authors

Authors::

* Ian Kronquist
* Evan Tschuy
* Elijah Caine
