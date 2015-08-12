# python-webapp

A cookbook for deploying webapps like GWM, ORVSD, or the Seagrant twins.
Design documentation is currently in a
[google doc](https://docs.google.com/a/osuosl.org/document/d/1CsCxTWM7fc0iXT8Lu4BnRJWtYLuwI6a-LFfEa5_BJ2w/edit).

## Supported Platforms

* Centos 6
* Centos 7
* Ubuntu 12.04
* Ubuntu 14.04

## Usage

### Resource

```
    python_webapp "python_app_name" do
      option "option_value"
    end
```

<br />

Option                  | Type      | Description                                   | Default Value
----------------------- | --------- | --------------------------------------------- | -------------
`:create_user`          | Boolean   | Creates a user on the sever                   | `false`
`:path`                 | String/Nil| Path to application                           | `nil` with a [calculated default](#notes).
`:owner`                | String    | Owner of application files (user)             | `chef`
`:group`                | String    | Owner of application files (group)            | `chef`
`:repository`           | String    | URL to git repository                         | `This is required`
`:revision`             | String    | Branch or Commit Hash of Repo                 | `master`
`:virtualenv_path`      | String    | Path to python virtualenv                     | `nil` with a [calculated default](#notes).
`:config_template`      | String/Nil| Path to app config template                   | `nil` with a [calculated default](#notes).
`:config_destination`   | String/Nil| Path to app config location on server         | `nil` with a [calculated default](#notes).
`:config_vars`          | Hash      | Variables for the config template             | Required if config_template is set. It can be an empty string
`:requirements_file`    | String/Nil| Application's dependencies file.              | `nil` with a [calculated default](#notes).
`:django_migrate`       | Boolean   | Whether or not to run django migrations       | `false`
`:django_collectstatic` | Boolean   | Whether or not to run django collectstatic    | `false`
`:interpreter`          | String    | Python command (python, python3, etc)         | `python`
`:gunicorn_port`        | Int/Nil   | Port to run gunicorn on                       | `nil`
`:wsgi_module`          | String/Nil| wsgi module and variable for gunicorn to use  | `nil` with a [calculated default](#notes).

For more information on some of these resources (and the sane defaults
python-webapp sets in case of certain values being) see the [Notes
section](#notes) below.

### Example

**SETUP:** Before you can use the python-webapp cookbook add the following
information to the corresponding files:

* Add `depends 'python-webapp'` to your metadata.rb.
* Add `cookbook 'python-webapp', git:
  'git://github.com/osuosl-cookbooks/python-webapp.git', branch: 'master'` to your
  Berksfile

**Note:** Once this cookbook is on [Chef
Supermarket](https://supermarket.chef.io/cookbooks?utf8=%E2%9C%93&q=python-webapp)
you will not need to include the `git: ...` part of the above line to your
Berksfile.

**RECIPE USAGE:** The following code would go in a `some_recipe.rb` file:

```
    proj_path = '/opt/test_app'

    python-webapp 'test_app' do
      create_user true
      owner 'test_app'
      group 'test_app'

      repository 'https://github.com/osuosl/python-test-apps.git'
      revision 'develop'

      config_template 'config.yml.erb'
      config_destination "#{proj_path}/config.yml"
      config_vars(
          path: proj_path,
          engine: 'django.db.backends.sqlite3',
          dbname: "#{proj_path}/yourdatabasename.db"
      )
      interpreter 'python2.7'   # can be left out if your systems default python
                                # interpreter is your interpreter as well

      django_migrate true
      django_collectstatic true

      gunicorn_port 8888
    end
```

In the above example `test_app` should be the name of your python application.

More examples of the python-webapp's usage can be found in this
[repo's tests](https://github.com/osuosl-cookbooks/python-webapp/tree/master/test/cookbooks/python-webapp-test)

### Notes

**Sane Defaults:**
* `path` is calculated as `/opt/${ project_name }`
* `virtualenv_path` is calculated to be `/opt/${ project_name }/venv`
* `config_destination` is calculated to be `${ path }/settings.py`
* `requirements_file` is calculated to be `setup.py`
* `config_template` is calculated to be `settings.py.erb`
* `wsgi_module` is calculated to be `${project_name }.wsgi:application`

**Python Versions:** If you are using a version of python in `interpreter` that
does not come by default on your system you have to install this seperately;
python-webapp will not automatically install a given version of python for your
system.

**`gunicorn_port`:** The gunicorn_port resource both specifies the port gunicorn
will run on and that you are using gunicorn. By not specifying gunicorn_port
you are specifying that you aren't using gunicorn.

**`requirements_file`:** The requirements_file default value assumes your python
webapp is a python package (i.e., it has a setup.py) however without a setup.py
you must include a requirements file, usually created with the command `pip
freeze > requirements.txt` inside of your virtualenv.

**`config_template`:** this is found in
`<cookbook_dir>/templates/<recipe_name>/some_file.erb`.

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
