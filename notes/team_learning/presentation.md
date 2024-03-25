# Intro to (Neo)vim

## Why Vim

- lightweight
- standard package in most linux distros
- FOSS (the less microsoft in my life, the better)
- very customizeable
  - lua files are simply better than a huge json blob(vscode)
  - initial setup takes more work, but easier to configure to your liking
- setup is easily reproducible (just copy over your .config/nvim directory)
- vim motions

Concept of **IDE** vs **PDE**
-> Make it exactly what you want it to be, less compromises

## Modes

Vim is a *modal* text editor, meaning there are different modes you can be in.

- **NORMAL** default, for movement and text operations
- **INSERT** for typing
- **VISUAL** for selecting things

Additionally, you can do `:` to enter commands.  There are tons of different options here, and plugins often come with custom ones like `:GitBlameToggle` or `:GoAddTags`

## Vim Motions

Philosophy:
- less hand movement , more speed/efficiency
- avoid context switching

Showcase of basic concepts:

- Movement
- Basic keybinds (c, d, a, i, y)
- Textobjects

### Examples

Vertical movement:
```
k       - move up a line
j       - move down a line
Ctrl+U  - move up half a screen
Ctrl+D  - move down half a screen
gg      - jump to start of document
G       - jump to end of document
```

Horizontal movement:
```
h       - move left
l       - move right
0       - start of line
$       - end of line
I       - start of line + enter insert mode
A       - end of line + enter insert mode
w       - start of next word
b       - start of previous word
```

Textobjects:
```
ciw   - "change in word"
dif   - "delete in function"
yi"   - yank(copy) inside ""
```

```
# <command> <amount> <movement>
d10j # deletes current line and 10 below

```

## But what about....

- ...autocomplete? LSP is a widely adopted standard and easy to setup

- ...copilot? Neo/-vim both have plugins to seamlessly integrate it

- ...debugging? Also possible

- ...database UI? dadbod

- (almost) everything JetBrains/VSCode etc can do, Neovim is also capable of doing

## Plugins

The vim ecosystem is vast and you can optimize your workflow with plugins, like:

- Telescope
- Leap
- Oil
- Ufo

## Inspiration/references

[The Psychology of Keyboard Shortcuts - Why Otters Would Code in Neovim](https://www.youtube.com/watch?v=fbg7lsZjxew)
