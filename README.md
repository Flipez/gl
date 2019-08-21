# Gl

- [Gl](#gl)
  * [Installation](#installation)
  * [Usage](#usage)
    + [Issues](#issues)
      - [List](#list)
      - [Open](#open)
    + [Merge Requests](#merge-requests)
      - [Interactive](#interactive)
      - [List](#list-1)
      - [Open](#open-1)
      - [Approve](#approve)
      - [Merge](#merge)
    + [Registry](#registry)
  * [Development](#development)
  * [Contributing](#contributing)
  * [License](#license)

Gl is a small CLI that hooks into your Git config and GitLab API to easily access information based
on the project your are currently in.

## Installation

    $ gem install gl

## Usage

Inside your git workspace you can issue the following commands:

```bash
$ gl

Commands:
  gl global          # commands unrelated to the current project
  gl help [COMMAND]  # Describe available commands or one specific command
  gl issues          # handle issues of the project
  gl mr              # handle merge requests of the project
  gl registry        # handle registry of the project
```

### Issues
#### List
```bash
$ gl issues list

+-----+----------------+-------------------------------------------------------------------------------+
| IID | Author         | Title                                                                         |
+-----+----------------+-------------------------------------------------------------------------------+
| 409 | XXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                  |
| 105 | XXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                  |
| 44  | XXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                  |
| 33  | XXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                  |
+-----+----------------+-------------------------------------------------------------------------------+
```
With interactive switch
```bash
$ gl issues list -i

Open a issue (Use ↑/↓ and ←/→ arrow keys, press Enter to select)
‣ 409 - XXXXXXXXXXXX - XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  408 - XXXXXXXXXXXX - XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  407 - XXXXXXXXXXXX - XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  406 - XXXXXXXXXXXX - XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  405 - XXXXXXXXXXXX - XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  404 - XXXXXXXXXXXX - XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
```
#### Open
Open a issue directly with the IID or viathe interactive list
```bash
$ gl issue open 409
```

### Merge Requests
#### Interactive
```bash
$ gl mr list -i

Select a merge request (Use ↑/↓ arrow keys, press Enter to select, and letter keys to filter)
‣ 2 - robert.mueller - WIP: Update README.md
```

In interactive mode you can also perform all the other actions
```bash
$ gl mr list -i

Select a merge request 2 - robert.mueller - WIP: Update README.md
┌────────────────────────────────────────WIP: Update README.md─────────────────────────────────────────┐
│                                                                                                      │
│ # Nec verum procul trahuntur velle                                                                   │
│                                                                                                      │
│ ## Foedantem blandis malorum mox                                                                     │
│                                                                                                      │
│     chipsetMyspace.perlUltra.font_document(iscsiStandbyPermalink(                                    │
│             computing_mac_modem, streamingSli));                                                     │
│     address_operating = 40 + binComputingTransistor + rw * minimize;                                 │
│     wired(-1, qbe_export);                                                                           │
│                                                                                                      │
└State: opened────────────────────────────────────────────────────────────────────────by robert.mueller┘
What to do next? (Use ↑/↓ arrow keys, press Enter to select)
‣ open
  merge
  approve
  exit

```

#### List
```bash
$ gl mr list

+-----+----------------+-----------------------+
| IID | Author         | Title                 |
+-----+----------------+-----------------------+
| 2   | robert.mueller | WIP: Update README.md |
+-----+----------------+-----------------------+
```

#### Open
```bash
$ gl mr open 2
```

#### Approve
```bash
$ gl mr approve 2
```

#### Merge
```bash
$ gl mr merge 2
```

### Registry
With the registry subcommand you can get a overview about the registry usage.

```bash
$ gl registry status

+---------------------------+------+-------------+
| Registry                  | Tags | Size        |
+---------------------------+------+-------------+
| XXXXXXXXXXXXXXXXXXXXXXXXX |   42 | 13511.85 MB |
+---------------------------+------+-------------+
```

```bash
$ gl registry list

+---------------------------+-----------------------+-----------+-------------------------------+-----------+
| Registry                  |                   Tag | Image_ID  | Created_at                    | Size      |
+---------------------------+-----------------------+-----------+-------------------------------+-----------+
| XXXXXXXXXXXXXXXXXXXXXXXXX |                latest | 90112d580 | 2019-08-19T12:23:11.129+02:00 | 305.42 MB |
| XXXXXXXXXXXXXXXXXXXXXXXXX |               v0.87.3 | 90112d580 | 2019-08-19T12:23:11.129+02:00 | 305.42 MB |
+---------------------------+-----------------------+-----------+-------------------------------+-----------+
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Flipez/gl.

## License

The gem is available as open source under the terms of the [AGPL-3.0](https://opensource.org/licenses/AGPL-3.0).
