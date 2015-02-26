# python-webapp-cookbook/

A cookbook for deploying webapps like GWM, ORVSD, or the Seagrant twins.
Design documentation is currently in a
[google doc](https://docs.google.com/a/osuosl.org/document/d/1CsCxTWM7fc0iXT8Lu4BnRJWtYLuwI6a-LFfEa5_BJ2w/edit).

## Supported Platforms

Centos 6
Centos 7?

## Attributes

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['create']['bacon']</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
</table>

## Usage

### create::default

Include `create` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[create::default]"
  ]
}
```

## License and Authors

Authors::

* Ian Kronquist
* Evan Tschuy
