<p align="center">
  <img src="https://github.com/user-attachments/assets/92abdd72-aed4-43a4-a28a-7e8fa3f81c8d#gh-dark-mode-only" />
  <img src="https://github.com/user-attachments/assets/f779f274-611a-45f6-bacd-0032e3c33405#gh-light-mode-only" />
</p>


***

Inspired by the [Create](https://github.com/Creators-of-Create/Create/wiki/Internal---Ponder-UI) Minecraft mod, Ponder is an in-game user documentation API. With this API, any other addon can register their own storyboards and provide visual documentation for their addon, rather than having to maintain an online wiki/rely on word of mouth.

A couple of example storyboards are provided in lua/ponder/storyboards_cl/.

[![Discord Invite](https://img.shields.io/discord/654142834030542878?label=Chat&style=flat-square)](https://discord.gg/jgdzysxjST)
[![Workshop](https://img.shields.io/badge/Workshop-Download-informational?style=flat-square)](https://steamcommunity.com/sharedfiles/filedetails/?id=3404950276)
[![Linting Status](https://img.shields.io/github/actions/workflow/status/ACF-Team/Ponder/GLuaLint.yml?branch=master&label=Linter%20Status&style=flat-square)](https://github.com/ACF-Team/ACF-3/actions?query=workflow%3AGLuaLint)
[![Repository Size](https://img.shields.io/github/repo-size/ACF-Team/Ponder?label=Repository%20Size&style=flat-square)](https://github.com/ACF-Team/Ponder)
[![Commit Activity](https://img.shields.io/github/commit-activity/m/ACF-Team/Ponder?label=Commit%20Activity&style=flat-square)](https://github.com/ACF-Team/Ponder/graphs/commit-activity)
[![Developer Wiki](https://img.shields.io/badge/Developer_Wiki-bbccff)](https://github.com/ACF-Team/Ponder/wiki)

![gmod_Ot5eA9REfy](https://github.com/user-attachments/assets/99eff8c0-e307-4075-bc15-d7c27bc1a3c2)

## Documentation

- [**Ponder Wiki**](Ponder_Wiki.md) - Comprehensive guide to the Ponder system
- [**Quick Reference Guide**](Ponder_QuickReference.md) - Concise reference sheet for common instructions
- [**Example Storyboard**](lua/ponder/storyboards_cl/Ponder_Example.lua) - Complete example demonstrating various features
- [**Storyboard Template**](lua/ponder/storyboards_cl/Ponder_Template.lua) - Starter template for creating your own storyboards

***

# Detailed Documentation

This documentation provides comprehensive information about using the Ponder in-game tutorial system for Garry's Mod. Ponder allows you to create interactive, animated tutorials to explain game mechanics, addons, or any other concept.

## Key Concepts

Ponder is built around several key concepts:

- **Storyboard**: The main container for a tutorial
- **Chapter**: A section of a storyboard containing a sequence of instructions
- **Instruction**: An individual action like placing a model, showing text, or moving the camera
- **Environment**: The 3D space where the tutorial takes place
- **Playback**: Controls the playback of a storyboard

## Getting Started

If you're new to Ponder, we recommend following these steps:

1. Read the [Ponder Wiki](Ponder_Wiki.md) to understand the core concepts
2. Review the [Example Storyboard](lua/ponder/storyboards_cl/Ponder_Example.lua) to see how everything fits together
3. Use the [Quick Reference Guide](Ponder_QuickReference.md) as a handy reference while coding
4. Start creating your own storyboard using the [Storyboard Template](lua/ponder/storyboards_cl/Ponder_Template.lua)

## Creating Your First Storyboard

To create a basic storyboard:

1. Copy the [Storyboard Template](lua/ponder/storyboards_cl/Ponder_Template.lua) to a new file in your addon's `lua/ponder/storyboards_cl/` directory
2. Customize the storyboard properties (name, description, icon)
3. Add your own instructions to each chapter
4. Test your storyboard in-game

## Tips for Effective Tutorials

1. **Plan your storyboard** before coding
2. **Keep chapters focused** on one concept or step
3. **Use appropriate timing** to allow users to read and understand
4. **Add descriptive text** to guide the user through each step
5. **Test frequently** to ensure smooth animations and correct timing

## Need Help?

If you encounter issues or have questions:

1. Check the [Troubleshooting](Ponder_Wiki.md#troubleshooting) section in the wiki
2. Review the example files for reference implementations
3. Examine the Ponder source code for deeper understanding

## Contributing

If you find errors in this documentation or have suggestions for improvements, please let us know!
