import 'main.dart' as m;

/// Prints content for /docs/cli-usage
///
/// To update the cli-usage docs: run this script, copy its output
/// to your clipboard and then replace
/// the contents of docs/cli_usage.mdx in the monarch_site repo.
///
/// ```
/// dart cli_usage_doc.dart | pbcopy
/// ```
void main(List<String> arguments) async {
  print('''
The Monarch CLI supports the following commands:

- `monarch init`: ${m.runner.commands['init']!.description}
- `monarch run`: ${m.runner.commands['run']!.description}
- `monarch upgrade`: ${m.runner.commands['upgrade']!.description}
- `monarch newsletter`: ${m.runner.commands['newsletter']!.description}

The command you will use the most is `monarch run`.

### `monarch run`
Usage: `${m.runner.commands['run']!.invocation}`

Arguments:
```text
${m.runner.commands['run']!.argParser.usage}
```

```text
${m.runner.argParser.usage}
```
''');
}
