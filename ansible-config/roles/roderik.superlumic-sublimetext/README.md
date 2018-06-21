# superlumic-sublimetext

Ansible role to install and configure Sublime Text 3 on OSX. This role is part of the Superlumic project that aims to simplify repeat computer setups on OSX, 10.10 and up.

## Requirements

* OSX 10.10 or 10.11

## Role variables

Minimal set:

```yaml
sublime_packages:
  - dest: "Theme - Soda"
    repo: "https://github.com/buymeasoda/soda-theme.git"
    version: "master"
  - dest: "Base16"
    repo: "https://github.com/chriskempson/base16-textmate.git"
    version: "master"
sublime_text_color_scheme: "Packages/Base16/base16-eighties.dark.tmTheme"
sublime_text_theme: "Soda Dark 3.sublime-theme"
```

More extensive set:

```yaml
    - sublime_packages:
        - dest: "SideBarEnhancements"
          repo: "https://github.com/titoBouzout/SideBarEnhancements"
          version: "st3"
        - dest: "GitGutter"
          repo: "https://github.com/jisaacks/GitGutter.git"
          version: "master"
        - dest: "BracketHighlighter"
          repo: "https://github.com/facelessuser/BracketHighlighter.git"
          version: "master"
        - dest: "Theme - Soda"
          repo: "https://github.com/buymeasoda/soda-theme.git"
          version: "master"
        - dest: "Base16"
          repo: "https://github.com/chriskempson/base16-textmate.git"
          version: "master"
        - dest: "ApplySyntax"
          repo: "https://github.com/facelessuser/ApplySyntax.git"
          version: "master"
        - dest: "SublimeAllAutocomplete"
          repo: "https://github.com/alienhard/SublimeAllAutocomplete"
          version: "master"
        - dest: "Ansible"
          repo: "https://github.com/clifford-github/sublime-ansible.git"
          version: "master"
    - sublime_text_color_scheme: "Packages/Base16/base16-eighties.dark.tmTheme"
    - sublime_text_theme: "Soda Dark 3.sublime-theme"
```

## Dependencies

* [roderik.superlumic-homebrew](https://github.com/superlumic/ansible-role-homebrew)

# Usage

Check [Superlumic](https://github.com/superlumic/superlumic) for documentation

# License

MIT

# Author

[Roderik van der Veer](mailto:roderik@superlumic.com) - [@r0derik](https://twitter.com/r0derik)
