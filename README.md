> **⚠️ NOT MAINTAINED**
> 
> This project is no longer maintained - maybe some day I'll work on it again.

> GitHub version is outdated - install the plugin from [here](https://www.roblox.com/library/8359267635/Adonis-Configurator) to use the latest version.

# Adonis Configurator (Beta)

It's not entirely unexpected for someone to be unfamiliar with Luau syntax. This plugin aims to eliminate that hassle entirely, instead employing a GUI for installation and configuration.

## Requirements
Please familiarise yourself with Adonis' own syntax before using this (i.e "Username:UserId"). It will make your life easier until I streamline this process. You will need to open the Settings module in the loader to learn about this. I will work on including proper documentation at some point, but for now, this is a workaround.

## Installation

The average user should just click [here](https://www.roblox.com/library/8359267635/Adonis-Configurator) and install the plugin from Roblox.

You may also head [here](https://github.com/happyman090/Adonis-Configurator/releases) (the releases page) to download the version of your choice and install that (I have no idea why you would want to do that, but it's an option anyway).

If you would like to use the bleeding edge version of Adonis Configurator, you should compile it yourself using Rojo:

`rojo build /path/to/Adonis-Configurator -o AdonisConfigurator.rbxm`

## Notes

This is still a WIP with quite a few critical features that are currently missing. I would like to add:
- ~~a way to specify a loader's location (currently just looks for Adonis_Loader in ServerScriptService)~~ This feature has been added into the latest version!
- a description to each property so the user knows what a property is for
- a formatting guide somewhere inside the plugin (this may be in the form of advising the user what a value should look like when entering text input)

## Issues

Is something not working correctly? File an issue under the Issues tab, and I'll try sort it out there.

## Contributing

Feel free to contribute to this plugin in the form of a pull request. 

I don't think I need to elaborate much on what is allowed - just make sure that **you test your changes before you submit them** and that your submissions are sufficiently relevant and add value to the experience of this plugin. 

As for what isn't permitted, you should most certainly avoid submitting obfuscated code. Don't send in anything that violates Roblox's TOS or Community Rules either. I also ask that your code is clean - I will not merge code that is messy or cluttered, except where it is unavoidable. Please try to follow [Roblox's Style Guide](https://roblox.github.io/lua-style-guide/) (even though sometimes I don't).

Please note that all assets must be housed in the Assets folder and stored in the .rbxmx file type.
