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
    python_webapp "python_app_name" do
      option "option_value"
    end
```

Option                  | Type      | Description                                   | Default Value
----------------------- | --------- | --------------------------------------------- | -------------
`:create_user`          | Boolean   | Creates a user on the sever                   | `false`
`:path`                 | String/Nil| Path to application                           | `/opt/#{ project_name }`
`:owner`                | String    | Owner of application files (user)             | `chef`
`:group`                | String    | Owner of application files (group)            | `chef`
`:repository`           | String    | URL to git repository                         | `nil`
`:revision`             | String    | Branch or Commit Hash of Repo                 | `master`
`:virtualenv_path`      | String    | Path to python virtualenv                     | `/opt/venv_#{ project_name }`
`:config_template`      | String/Nil| Path to app config template                   | `settings.py.erb`
`:config_destination`   | String/Nil| Path to app config location on server         | `nil`
`:config_vars`          | Hash      | Variables for the config template             | `nil`
`:requirements_file`    | String/Nil| Application's dependencies file.              | `setup.py`
`:django_migrate`       | Boolean   | Whether or not to run django migrations       | `false`
`:django_collectstatic` | Boolean   | Whether or not to run django collectstatic    | `false`
`:interpreter`          | String    | Python command (python, python3, etc)         | `python`
`:gunicorn_port`        | Int/Nil   | Port to run gunicorn on                       | `nil`

For more information on some of thesse resources see the 'Notes' section below.

### Example

**SETUP:** Before you can use the python-webapp cookbook add the following
informtion to the corresponding files:

* Add `depends 'python-webapp'` to your metadata.rb.
* Add `cookbook 'python-webapp', git:
  'git://github.com/osuosl-cookbooks/python-webapp.git', branch: 'master'` to your
  Berksfile

**RECIPE USAGE:** The following code would go in a `some_recipe.rb` file:

```
    path = '/opt/test_app'

    python-webapp 'test_app' do
      create_user true
      owner 'test_app'
      group 'test_app'

      repository 'https://github.com/osuosl/python-test-apps.git'
      revision 'develop'

      config_template 'config.yml.erb'
      config_destination "#{path}/config.yml"
      config_vars(
          path: path,
          engine: 'django.db.backends.sqlite3',
          dbname: "#{path}/yourdatabasename.db"
      )
      interpreter 'python2.7'

      django_migrate true
      django_collectstatic true

      gunicorn_port 8888
    end
```

In the above example `test_app` should be the name of your python application.

More examples of the python-webapp's usage can be found in this repo's `test`
directory at
https://github.com/osuosl-cookbooks/python-webapp/tree/master/test/cookbooks/python-webapp-test

### Notes

**python versions:** If you are using a version of python that does not come by
default on your system you have to install this seperately; python-webapp will
not automatically install a given version of python for your system.

**wsgy.py:** One assumption made by python webapp is that if you are running a
Flask application you have included a wsgi.py file in your Flask application's
main directory. You do not need to include a wsgi.py for a Django project.

**gunicorn_port:**  The gunicorn_port resource is also a gunicorn specifier in
that when you specify the port for gunicorn to run on you are also specifying
that you want to run guicorn at all. Without the gunicorn_port being specified
gunicorn will not run at all.

**requirements_file:** The requirements_file default value assumes your python
webapp is a python package (i.e., it has a setup.py) however without a setup.py
you must include a requirements fie, usually created with the command `pip
freeze > requirements.txt` inside of your virtualenv.

**config_template:** this is found in
<cookbook_dir>/templates/<recipe_name>/some_file.erb.

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
