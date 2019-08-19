# Gl

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

```bash
$ gl mr list

+-----+--------------+-------------------------------------------------------------------------------+
| IID | Author       | Title                                                                         |
+-----+--------------+-------------------------------------------------------------------------------+
| 268 | XXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                               |
| 264 | XXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                               |
| 217 | XXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                               |
| 213 | XXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                               |
| 188 | XXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                               |
+-----+--------------+-------------------------------------------------------------------------------+
```

Both commands offer a interactive switch which opens the selected merge request/issue after selecting:

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

Your can also directly open an issue or merge request with a IID:

```bash
$ gl issue open 409
# or
$ gl mr open 213
```

With the registry subcommand you can get a overview about the registry usage.

```bash
$ gl registry status

+---------------------------+------+-------------+
| Registry                  | Tags | Size        |
+---------------------------+------+-------------+
| XXXXXXXXXXXXXXXXXXXXXXXXX |   42 | 13511.85 MB |
+---------------------------+------+-------------+
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Flipez/gl.

## License

The gem is available as open source under the terms of the [AGPL-3.0](https://opensource.org/licenses/AGPL-3.0).
