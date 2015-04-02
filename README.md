# python-webapp

A cookbook for deploying webapps like GWM, ORVSD, or the Seagrant twins.
Design documentation is currently in a
[google doc](https://docs.google.com/a/osuosl.org/document/d/1CsCxTWM7fc0iXT8Lu4BnRJWtYLuwI6a-LFfEa5_BJ2w/edit).

## Supported Platforms

Centos 6
Centos 7?

## Running tests

### Running integration tests

[Detailed instructions](https://github.com/osuosl-cookbooks/python-webapp/wiki/Development-Workflow#using-your-virtual-machine)

```
$ kitchen converge [test suite]
$ kitchen verify [test suite]
```

### Running unit tests

[Detailed instructions](https://github.com/osuosl-cookbooks/python-webapp/wiki/Development-Workflow#writing-a-chefspec-unit-test)

```
$ rspec
```


## License and Authors

Authors::

* Ian Kronquist
* Evan Tschuy
* Elijah Caine