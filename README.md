# python-webapp

A cookbook for deploying webapps like GWM, ORVSD, or the Seagrant twins.
Design documentation is currently in a
[google doc](https://docs.google.com/a/osuosl.org/document/d/1CsCxTWM7fc0iXT8Lu4BnRJWtYLuwI6a-LFfEa5_BJ2w/edit).

## Supported Platforms

Centos 6

Centos 7?

## Usage

### Resource

```
python-webapp "python-app-name" do
  option "option_value"
end
```

Option                  | Type      | Description                            | Default Value
----------------------- | --------- | -------------------------------------- | -------------
`:create_user`          | Boolean   | Creates a user on the sever            | `false`
`:path`                 | String/Nil| Path to application                    | `nil`
`:owner`                | String    | Owner of application files (user)      | `chef`
`:group`                | String    | Owner of application files (group)     | `chef`
`:repository`           | String    | URL to git repository                  | `nil`
`:revision`             | String    | Branch or Commit Hash of Repo          | `master`
`:virtualenv_path`      | String    | Path to python virtualenv              | `nil`
`:config_template`      | String/Nil| Path to app config template            | `settings.py.erb`
`:config_destination`   | String/Nil| Path to app config location on server  | `nil`
`:config_vars`          | Hash      | Variables for the config template      | `nil`
`:requirements_file`    | String/Nil| Application's dependencies file.       | `setup.py`
`:django_migrate`       | Boolean   | Whether or not to run django migrations| `false`
`:django_collectstatic` | Boolean   | 
`:interpreter`          | String    | 
`:gunicorn_port`        | Int/Nil   | 

### Example

```
python-webapp 'test_app' do
  create_user true
  owner 'test_app'
  group 'test_app'

  repository 'https://github.com/osuosl/python-test-apps.git'

  config_template 'config.yml.erb'
  config_destination "#{path}/config.yml"
  config_vars hash
  django_migrate true
  django_collectstatic true
  interpreter 'python2.7'
  revision 'cookbook_test'

  gunicorn_port 8888
end
```

### Notes


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
