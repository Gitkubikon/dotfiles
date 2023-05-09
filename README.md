こんにちわ!
------------
As your humble servant, I welcome you to my dotfiles repository, where you will find the meticulously crafted configuration files that I use to satisfy all of my nerdy whims and fancies in my Hyprland Arch Linux environment.

If you're anything like me, you're probably an anime-loving, ramen-scarfing weaboo, who loves nothing more than customizing your computer to fit your kawaii aesthetic. Fear not, my fellow otaku, for my dotfiles will help you achieve just that!

My dotfiles are so sugoi that they'll make your computer feel like a plushy Totoro, with all the right bells and whistles. But don't take my word for it, try it out for yourself!

Installation
------------

But first things first, to install these bad boys, you'll need to have chezmoi-chan installed on your machine. Don't worry, it's easy-peasy to install - just follow the official documentation (or ask your senpai for help).

    chezmoi init --apply git@github.com:Gitkubikon/dotfiles.git

This will apply my dotfiles to your home directory, creating any necessary directories and files.

Philosophy
----------

But that's not all! My dotfiles are also designed to be efficient in use. I handpicked the programs and utilities I use, making sure they're lightweight and speedy. I avoid bloating my system with unnecessary packages or services, so you can enjoy a hassle-free and zippy experience.

Components
----------

My dotfiles repository contains configuration files for the following programs:

*  zsh: A shell that keeps you kawaii and organized.
*  LunarVim: The magical editor that makes coding a fairy tale.
*  hyprland: The window manager that lets you fly through your tasks.
*  youtube-music: The music player that helps you stay in tune with your kawaii side.
*  firefox: The browser that's purrfect for your browsing needs, featuring configs for treestyletab and cattpuccin colortheme.
*  waybar: The status bar that adds some spice to your desktop.

### Chezmoi Commands

| Command                  | Description                                                                                     |
| ------------------------ | ----------------------------------------------------------------------------------------------- |
| `chezmoi init`            | Initialize a new Chezmoi repository.                                                            |
| `chezmoi add <path>`      | Add a file or directory to the Chezmoi repository. If the path is a directory, all of its contents will be added recursively. |
| `chezmoi apply`           | Create symlinks from the files in the Chezmoi repository to their appropriate locations in the user's home directory. |
| `chezmoi edit <path>`     | Open a file for editing using the user's preferred text editor.                                |
| `chezmoi cd`              | Change to the root of the Chezmoi repository.                                                   |
| `chezmoi update`          | Pull changes from the Chezmoi source repository and apply them.                                 |
| `chezmoi diff`            | Show differences between the current state of dotfiles in your home directory and the version controlled by Chezmoi. |
| `chezmoi status`          | Show the status of your dotfiles, indicating which ones are being managed by Chezmoi.           |
| `chezmoi forget <path>`   | Stop managing a file or directory with Chezmoi. This will remove the symlink in your home directory and delete the file from the Chezmoi repository. |
| `chezmoi import <url>`    | Import a file or directory from a URL into the Chezmoi repository.                              |
| `chezmoi clean`           | Remove any files and directories in your home directory that are not being managed by Chezmoi.  |
| `chezmoi archive <file>`  | Create an archive of the dotfiles managed by Chezmoi.                                           |

Note that this is not an exhaustive list of Chezmoi commands, and there are many more options and subcommands available for each of these. I recommend checking out the Chezmoi documentation for more information on how to use these commands and customize your dotfile management workflow.

Conclusion
----------

And if you have any questions or suggestions, please don't hesitate to hit me up. I'll be more than happy to help my fellow Kohai's!

ありがとうございます, and happy customizing!
