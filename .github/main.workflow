workflow "Code Quality" {
  on = "push"
  resolves = [
    "PHPStan",
    "PHP-CS-Fixer",
    "Psalm"
  ]
}

action "PHPStan" {
  uses = "docker://oskarstark/phpstan-ga:with-extensions"
  args = "analyse src tests --level max --configuration extension.neon"
  secrets = ["GITHUB_TOKEN"]
}

action "PHP-CS-Fixer" {
  uses = "docker://oskarstark/php-cs-fixer-ga"
  secrets = ["GITHUB_TOKEN"]
  args = "--config=.php_cs.dist --diff --dry-run"
}

action "Psalm" {
  needs="PHPStan"
  uses = "docker://mickaelandrieu/psalm-ga"
  secrets = ["GITHUB_TOKEN"]
  args = "--find-dead-code --diff --diff-methods"
}