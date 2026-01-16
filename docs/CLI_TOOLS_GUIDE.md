# CLI Tools & Utilities Guide

A comprehensive reference for all CLI tools and utilities installed in this dotfiles configuration. Tools are organized by category with descriptions and searchable keywords.

## Table of Contents

- [Shell & Terminal Environments](#shell--terminal-environments)
- [Text Editors & Development Tools](#text-editors--development-tools)
- [File Management & Navigation](#file-management--navigation)
- [Git & Version Control](#git--version-control)
- [System Monitoring & Performance](#system-monitoring--performance)
- [Network & Cloud Tools](#network--cloud-tools)
- [Container & Infrastructure Tools](#container--infrastructure-tools)
- [Database Tools](#database-tools)
- [Programming Languages & Runtimes](#programming-languages--runtimes)
- [Code Formatters & Linters](#code-formatters--linters)
- [Security & Secrets Management](#security--secrets-management)
- [Productivity & Utilities](#productivity--utilities)
- [Media & Graphics](#media--graphics)
- [AI & LLM Tools](#ai--llm-tools)
- [Window Management & System Customization](#window-management--system-customization)
- [Package Managers](#package-managers)

---

## Shell & Terminal Environments

### fish

Modern shell with auto-suggestions and syntax highlighting.
**Keywords:** shell, command-line, autocomplete, friendly

### bash

Standard Unix shell for scripting and command execution.
**Keywords:** shell, scripting, posix, unix

### tmux

Terminal multiplexer for managing multiple terminal sessions.
**Keywords:** multiplexer, sessions, panes, windows, terminal

### zellij

Modern terminal workspace with layouts and plugins.
**Keywords:** multiplexer, workspace, rust, terminal, tmux-alternative

### ghostty

Fast, feature-rich GPU-accelerated terminal emulator.
**Keywords:** terminal, emulator, gpu, performance

### kitty

GPU-based terminal emulator with advanced features.
**Keywords:** terminal, emulator, gpu, images, unicode

### starship

Cross-shell prompt with git integration and customization.
**Keywords:** prompt, shell, git-status, customizable

---

## Text Editors & Development Tools

### nvim (exact_nvim)

Highly extensible text editor with Lua configuration.
**Keywords:** editor, vim, lua, neovim, ide

### bob

Neovim version manager.
**Keywords:** neovim, version-manager, nvim

### cursor

AI-powered code editor built on VSCode.
**Keywords:** editor, ai, vscode, copilot

### visual-studio-code

Microsoft's popular code editor.
**Keywords:** editor, vscode, ide, microsoft

### sublime-text

Fast, sophisticated text editor.
**Keywords:** editor, fast, gui

### neovim-remote

Control Neovim remotely via RPC.
**Keywords:** neovim, remote, rpc, control

---

## File Management & Navigation

### yazi

Blazing fast terminal file manager with image preview.
**Keywords:** file-manager, tui, preview, ranger-alternative

### eza

Modern replacement for ls with git integration.
**Keywords:** ls, directory, listing, colors, git

### fd

Fast and user-friendly alternative to find.
**Keywords:** find, search, files, fast, rust

### fzf

Fuzzy finder for command-line.
**Keywords:** fuzzy, search, finder, interactive

### fzf-lua

Lua implementation of fzf for Neovim.
**Keywords:** fuzzy, neovim, lua, search

### zoxide

Smarter cd command that learns your habits.
**Keywords:** cd, navigation, jump, autojump, z

### tree

Display directory structure in tree format.
**Keywords:** directory, tree, structure, visualization

### dust

Intuitive version of du for disk usage.
**Keywords:** disk-usage, du, storage, space

### fselect

Find files with SQL-like queries.
**Keywords:** find, search, sql, query, files

---

## Git & Version Control

### git

Distributed version control system.
**Keywords:** vcs, version-control, source-control

### git-delta

Syntax-highlighting pager for git/diff output.
**Keywords:** git, diff, pager, syntax-highlighting

### git-flow

Git extensions for Vincent Driessen's branching model.
**Keywords:** git, workflow, branching, release

### lazygit

Simple terminal UI for git commands.
**Keywords:** git, tui, terminal-ui, interactive

### gitui

Blazing fast terminal UI for git.
**Keywords:** git, tui, rust, fast

### gh

GitHub CLI tool for repository management.
**Keywords:** github, cli, pull-request, issues

### gh-copilot

GitHub Copilot CLI integration.
**Keywords:** github, copilot, ai, cli

### github-copilot

AI pair programmer from GitHub.
**Keywords:** ai, coding-assistant, github, suggestions

### hub

Command-line wrapper for git with GitHub features.
**Keywords:** git, github, wrapper, pull-request

### gitleaks

Detect secrets and credentials in git repos.
**Keywords:** security, secrets, scanning, credentials

### gittype

Analyze git repository statistics.
**Keywords:** git, statistics, analysis, metrics

### gitlogue

Git log viewer with filtering capabilities.
**Keywords:** git, log, viewer, history

### lefthook

Fast git hooks manager.
**Keywords:** git, hooks, pre-commit, automation

---

## System Monitoring & Performance

### btop

Resource monitor with beautiful TUI.
**Keywords:** monitor, cpu, memory, process, tui

### bottom

Graphical process/system monitor.
**Keywords:** monitor, system, process, tui, htop-alternative

### procs

Modern replacement for ps.
**Keywords:** process, ps, system, monitor

### htop

Interactive process viewer (implied by bottom/btop).
**Keywords:** process, monitor, system, interactive

### mtr

Network diagnostic tool combining ping and traceroute.
**Keywords:** network, diagnostic, ping, traceroute

### trippy (trip)

Network diagnostic tool with TUI.
**Keywords:** network, traceroute, diagnostic, tui

### rustnet-monitor

Network monitoring TUI.
**Keywords:** network, monitor, tui, rust

### ports-cli

View and manage open ports.
**Keywords:** ports, network, tcp, udp

### toktop

Process monitor focused on top processes.
**Keywords:** process, monitor, top, system

### systemd-manager-tui

TUI for managing systemd services (Linux).
**Keywords:** systemd, services, linux, tui, manager

---

## Network & Cloud Tools

### awscli

Official AWS command-line interface.
**Keywords:** aws, cloud, amazon, cli

### aws-shell

Interactive shell for AWS CLI.
**Keywords:** aws, shell, interactive, autocomplete

### tailscale

Mesh VPN for secure networking.
**Keywords:** vpn, mesh, network, security

### mosh

Mobile shell for remote connections.
**Keywords:** ssh, remote, mobile, connection

### doggo

Modern DNS client with colors.
**Keywords:** dns, lookup, dig, query

### dnslookup

DNS lookup tool.
**Keywords:** dns, lookup, query, nameserver

### ngrok

Expose local servers to the internet.
**Keywords:** tunnel, expose, localhost, webhook

### wireshark

Network protocol analyzer.
**Keywords:** network, packet, analyzer, sniffer

### wtfis

IP/domain OSINT lookup tool.
**Keywords:** osint, ip, domain, lookup, whois

### cariddi

Crawler for endpoints and secrets.
**Keywords:** crawler, endpoints, security, osint

### filessh

Transfer files over SSH.
**Keywords:** ssh, transfer, files, secure

### jocalsend

Local network file sharing TUI.
**Keywords:** file-sharing, local, network, tui

### switchaudio-osx

Change audio devices from command line (macOS).
**Keywords:** audio, macos, device, switch

---

## Container & Infrastructure Tools

### act

Run GitHub Actions locally.
**Keywords:** github-actions, local, testing, ci

### lazydocker

Simple terminal UI for Docker.
**Keywords:** docker, tui, containers, management

### terraform

Infrastructure as code tool.
**Keywords:** iac, infrastructure, cloud, provisioning

### terragrunt

Terraform wrapper for DRY configurations.
**Keywords:** terraform, wrapper, iac, dry

### terrascan

Static code analyzer for IaC.
**Keywords:** security, iac, scanner, terraform

### tflint

Terraform linter.
**Keywords:** terraform, linter, iac, validation

### kdash

Kubernetes dashboard in terminal.
**Keywords:** kubernetes, k8s, dashboard, tui

### taws

Terminal UI for AWS.
**Keywords:** aws, tui, cloud, management

---

## Database Tools

### mongosh

MongoDB shell.
**Keywords:** mongodb, database, shell, nosql

### mongodb-community@6.0

MongoDB database server.
**Keywords:** mongodb, database, server, nosql

### mongodb-compass

GUI for MongoDB.
**Keywords:** mongodb, gui, database, client

### vi-mongo

Vi-like TUI for MongoDB.
**Keywords:** mongodb, tui, vim-like, database

### pgadmin4

PostgreSQL administration tool.
**Keywords:** postgresql, admin, gui, database

### postgres-unofficial

PostgreSQL database.
**Keywords:** postgresql, database, sql

### libpq

PostgreSQL client library.
**Keywords:** postgresql, library, client, database

---

## Programming Languages & Runtimes

### node

JavaScript runtime.
**Keywords:** javascript, runtime, nodejs, npm

### nvm

Node Version Manager.
**Keywords:** node, version-manager, nodejs, npm

### fnm

Fast Node Manager (alternative to nvm).
**Keywords:** node, version-manager, fast, rust

### pnpm

Fast, disk space efficient package manager.
**Keywords:** node, package-manager, npm, fast

### yarn

JavaScript package manager.
**Keywords:** node, package-manager, npm, javascript

### rustup

Rust toolchain installer.
**Keywords:** rust, toolchain, compiler, cargo

### lua

Lightweight scripting language.
**Keywords:** scripting, language, lua, embedded

### luajit

Just-In-Time compiler for Lua.
**Keywords:** lua, jit, compiler, performance

### luarocks

Package manager for Lua.
**Keywords:** lua, package-manager, modules

### uv

Fast Python package installer.
**Keywords:** python, package-manager, pip, fast

### pipx

Install Python apps in isolated environments.
**Keywords:** python, isolation, tools, pip

### pip

Python package installer.
**Keywords:** python, package-manager, pypi

### nix

Functional package manager.
**Keywords:** package-manager, functional, reproducible

### temurin@11

OpenJDK distribution.
**Keywords:** java, jdk, openjdk, runtime

### maven

Java project management tool.
**Keywords:** java, build, dependency, management

---

## Code Formatters & Linters

### prettier

Opinionated code formatter.
**Keywords:** formatter, javascript, typescript, code-style

### prettierd

Prettier daemon for faster formatting.
**Keywords:** formatter, daemon, fast, prettier

### eslint

JavaScript linter.
**Keywords:** linter, javascript, code-quality

### eslint_d

ESLint daemon for faster linting.
**Keywords:** linter, daemon, fast, javascript

### ruff

Fast Python linter and formatter.
**Keywords:** python, linter, formatter, fast, rust

### ruff-lsp

Language server for ruff.
**Keywords:** python, lsp, linter, ruff

### yapf

Python formatter from Google.
**Keywords:** python, formatter, code-style

### markdownlint-cli

Markdown linter.
**Keywords:** markdown, linter, style, documentation

### pre-commit

Git hooks framework.
**Keywords:** git, hooks, linting, automation

### shfmt

Shell script formatter.
**Keywords:** shell, bash, formatter, script

### stylua

Lua code formatter.
**Keywords:** lua, formatter, code-style

---

## Security & Secrets Management

### 1password

Password manager.
**Keywords:** password, secrets, vault, security

### 1password-cli

1Password command-line tool.
**Keywords:** password, cli, secrets, security

### gnupg

GNU Privacy Guard for encryption.
**Keywords:** encryption, gpg, pgp, security

### comply

Compliance automation tool.
**Keywords:** compliance, security, audit, soc2

### claws

CLI AWS security tool.
**Keywords:** aws, security, cli, cloud, tui

### pillager

Hunt for credentials in filesystems.
**Keywords:** security, credentials, scanner, secrets

---

## Productivity & Utilities

### chezmoi

Dotfile manager.
**Keywords:** dotfiles, config, management, sync

### pomo

Pomodoro timer.
**Keywords:** timer, pomodoro, productivity, focus

### clock-tui (tclock)

Terminal clock application.
**Keywords:** clock, time, tui, timer

### toilet

ASCII art text generator.
**Keywords:** ascii, art, text, banner

### lolcat

Rainbow coloring for text output.
**Keywords:** colors, rainbow, fun, text

### terminal-notifier

macOS notifications from command line.
**Keywords:** notifications, macos, alert, terminal

### nb

Note-taking and bookmarking CLI.
**Keywords:** notes, bookmarks, cli, knowledge

### hoard

CLI command/snippet organizer.
**Keywords:** snippets, commands, organize, save

### tracker

Time tracking tool.
**Keywords:** time, tracking, productivity, log

### pngpaste

Paste PNG images from clipboard (macOS).
**Keywords:** clipboard, paste, image, macos

### television

Fuzzy finder with preview.
**Keywords:** fuzzy, finder, preview, search

### tlrc

Modern tldr client.
**Keywords:** help, examples, documentation, man

### session-manager-plugin

AWS Session Manager plugin.
**Keywords:** aws, ssh, session, plugin

---

## Media & Graphics

### chafa

Display images in terminal.
**Keywords:** images, terminal, display, ascii

### imagemagick

Image manipulation tools.
**Keywords:** images, convert, resize, edit

### ffmpegthumbnailer

Generate video thumbnails.
**Keywords:** video, thumbnail, ffmpeg, preview

### vhs

Record terminal sessions as GIFs.
**Keywords:** recording, gif, terminal, demo

### poppler

PDF rendering library.
**Keywords:** pdf, rendering, library, documents

### qpdf

PDF transformation tool.
**Keywords:** pdf, transform, merge, split

### pandoc

Universal document converter.
**Keywords:** markdown, converter, document, latex

### basictex

Minimal TeX distribution for macOS.
**Keywords:** latex, tex, typesetting, pdf

### fontconfig

Font configuration library.
**Keywords:** fonts, configuration, system

### fontforge

Font editor.
**Keywords:** fonts, editor, typography, design

### foxit-pdf-editor

PDF editing software.
**Keywords:** pdf, editor, gui, documents

---

## AI & LLM Tools

### aichat

Chat with AI in terminal.
**Keywords:** ai, chat, gpt, llm, terminal

### aider-chat

AI pair programming tool.
**Keywords:** ai, coding, pair-programming, gpt

### claude

Anthropic's Claude AI CLI.
**Keywords:** ai, claude, anthropic, cli, coding

### claude-code-acp

Claude Code agent communication protocol.
**Keywords:** claude, agent, protocol, ai

### oterm

Terminal interface for OpenAI/LLM APIs.
**Keywords:** openai, terminal, llm, chat

### specify-cli

GitHub Spec-Kit for planning.
**Keywords:** planning, specification, github, development

---

## Window Management & System Customization

### yabai

Tiling window manager for macOS.
**Keywords:** window-manager, tiling, macos, wm

### skhd

Hotkey daemon for macOS.
**Keywords:** hotkeys, keyboard, shortcuts, macos

### karabiner-elements

Keyboard customizer for macOS.
**Keywords:** keyboard, remapping, macos, customization

### hammerspoon

Automation tool for macOS.
**Keywords:** automation, macos, lua, scripting

### VimMode.spoon

Vim keybindings for macOS.
**Keywords:** vim, keybindings, macos, hammerspoon

### raycast

Productivity launcher for macOS.
**Keywords:** launcher, productivity, macos, spotlight

### betterdisplay

Display management for macOS.
**Keywords:** display, monitor, macos, resolution

### displaycal

Display calibration tool.
**Keywords:** calibration, color, display, monitor

---

## Package Managers

### homebrew

macOS package manager (implied by Brewfile).
**Keywords:** package-manager, macos, brew, install

### cargo

Rust package manager.
**Keywords:** rust, package-manager, crates, build

### go

Go language toolchain (includes go install).
**Keywords:** golang, package-manager, modules

### npm

Node package manager.
**Keywords:** javascript, package-manager, node

### fisher

Fish shell plugin manager.
**Keywords:** fish, plugins, shell, package-manager

### rustlings

Interactive Rust exercises.
**Keywords:** rust, learning, exercises, tutorial

---

## Miscellaneous Utilities

### ast-grep

Structural search/replace for code.
**Keywords:** search, ast, code, refactor

### atac

API testing tool.
**Keywords:** api, testing, http, rest

### atuin

Shell history sync and search.
**Keywords:** history, shell, sync, search

### bat

Cat clone with syntax highlighting.
**Keywords:** cat, syntax, highlighting, pager

### bat-extras

Additional scripts for bat.
**Keywords:** bat, scripts, utilities

### cmake

Cross-platform build system.
**Keywords:** build, c, cpp, compilation

### codex

CLI for OpenAI Codex.
**Keywords:** ai, openai, code, generation

### coreutils

GNU core utilities.
**Keywords:** gnu, utilities, unix, tools

### duck

Cyberduck CLI.
**Keywords:** ftp, s3, cloud, storage, cli

### cyberduck

FTP/cloud storage client.
**Keywords:** ftp, s3, cloud, storage, gui

### eva

Calculator REPL.
**Keywords:** calculator, math, repl, eval

### graphviz

Graph visualization software.
**Keywords:** graph, visualization, dot, diagram

### highlight

Source code to formatted text converter.
**Keywords:** syntax, highlighting, source, converter

### jq

JSON processor.
**Keywords:** json, query, filter, parse

### jql

JSON query language.
**Keywords:** json, query, filter, sql-like

### oq

Jq wrapper with output formats.
**Keywords:** json, query, jq, convert

### mq

Message queue CLI tool.
**Keywords:** queue, message, cli, broker

### qo

Query optimizer tool.
**Keywords:** query, optimizer, cli

### sevenzip

File archiver with high compression.
**Keywords:** archive, compression, zip, 7z

### sq

Swiss-army knife for data.
**Keywords:** data, query, sql, csv

### duck

Command-line interface for cloud storage.
**Keywords:** cloud, storage, cli, backup

### gobackup

Backup tool for databases and files.
**Keywords:** backup, database, files, restore

### sad

Batch find-and-replace tool.
**Keywords:** search, replace, batch, regex

### serpl

Search and replace with preview.
**Keywords:** search, replace, preview, interactive

### wget

Network downloader.
**Keywords:** download, http, ftp, web

### tree-sitter

Parser generator tool.
**Keywords:** parser, syntax, tree, language

### mcp-probe

MCP server testing tool.
**Keywords:** mcp, testing, probe, debug

### mcphub

MCP server hub/manager.
**Keywords:** mcp, server, hub, management

### taproom

Homebrew tap manager.
**Keywords:** homebrew, tap, package, manager

### inkdrop-visualizer

Visualizer for Inkdrop notes.
**Keywords:** notes, visualization, inkdrop

### lazynpm

Terminal UI for npm.
**Keywords:** npm, tui, package, manager

### lazyssh

Terminal UI for SSH connections.
**Keywords:** ssh, tui, connections, management

### ov

Feature-rich pager.
**Keywords:** pager, viewer, less, terminal

### termframe

Display markdown in terminal.
**Keywords:** markdown, terminal, display, render

### opencode

Open code in editor from CLI.
**Keywords:** editor, open, cli, integration

### beads (bd)

Issue tracking in git.
**Keywords:** issues, tracking, git, project

### tattoy

Terminal animation tool.
**Keywords:** animation, terminal, ascii, tui

### theattyr

Theater-style terminal presentation.
**Keywords:** presentation, terminal, slides, theater

### dcv

Docker compose viewer.
**Keywords:** docker, compose, viewer, tui

### reddix

Reddit TUI client.
**Keywords:** reddit, tui, client, social

### stormy

Weather forecast in terminal.
**Keywords:** weather, forecast, terminal, cli

### trex

TUI for T-Rex game.
**Keywords:** game, tui, fun, chrome

### tuios

TUI operating system simulator.
**Keywords:** tui, simulator, os, learning

### ziina

Payment CLI tool.
**Keywords:** payment, money, cli, fintech

### astroterm

Terminal astronomy tool.
**Keywords:** astronomy, terminal, space, stars

### bbrew

Better brew command wrapper.
**Keywords:** homebrew, wrapper, brew, utility

### inspect-cert-chain

TLS certificate chain inspector.
**Keywords:** tls, ssl, certificate, security

### cmdperf

Command performance profiling.
**Keywords:** performance, profiling, benchmark, shell

### basalt-tui

Basalt stone TUI.
**Keywords:** tui, basalt, terminal

### cargo-audit

Security audit for Rust dependencies.
**Keywords:** rust, security, audit, dependencies

### cargo-deny

Cargo plugin for linting dependencies.
**Keywords:** rust, dependencies, linting, security

### cargo-vet

Supply chain auditing for Rust.
**Keywords:** rust, audit, supply-chain, security

### csvlint

CSV file validator.
**Keywords:** csv, validation, linting, data

### csvi

Interactive CSV viewer and editor.
**Keywords:** csv, viewer, editor, interactive

### ssh-list

List and manage SSH connections.
**Keywords:** ssh, connections, list, management

### ugdb

Ugly debugger TUI.
**Keywords:** debugger, gdb, tui, rust

### kanha

CLI utility tool.
**Keywords:** utility, cli, tools

### regname

Container registry name parser.
**Keywords:** docker, registry, parser, container

### hygg

Hygge-inspired terminal tool.
**Keywords:** terminal, hygge, utility, tui

### nowplaying-cli

Display currently playing media (macOS).
**Keywords:** music, nowplaying, macos, spotify

### bagels

Python development utilities.
**Keywords:** python, utilities, development, tools

### cfn-lint

CloudFormation template validator.
**Keywords:** aws, cloudformation, linter, validation

### ghostty_animation

ASCII animations for Ghostty terminal.
**Keywords:** animation, ghostty, terminal, ascii

### meteor

Full-stack JavaScript platform.
**Keywords:** javascript, framework, fullstack, nodejs

### figma

Design and prototyping tool.
**Keywords:** design, ui, ux, prototyping

### notion

Note-taking and organization app.
**Keywords:** notes, wiki, organization, productivity

### notion-calendar

Calendar application from Notion.
**Keywords:** calendar, scheduling, notion, productivity

### obsidian

Knowledge base on local markdown files.
**Keywords:** notes, markdown, knowledge-base, pkm

### linear-linear

Linear issue tracker.
**Keywords:** issues, project, management, tracker

### slack

Team communication platform.
**Keywords:** chat, team, communication, messaging

### zoom

Video conferencing application.
**Keywords:** video, conference, meeting, call

### postman

API development environment.
**Keywords:** api, testing, rest, development

### github

GitHub Desktop application.
**Keywords:** git, github, gui, version-control

### google-chrome

Google's web browser.
**Keywords:** browser, web, chrome, google

### microsoft-edge

Microsoft's web browser.
**Keywords:** browser, web, edge, microsoft

### chromedriver

WebDriver for Chrome browser.
**Keywords:** selenium, testing, automation, chrome

### macfuse

File system integration for macOS.
**Keywords:** filesystem, fuse, macos, mount

### mountain-duck

Mount cloud storage as disk.
**Keywords:** cloud, mount, disk, storage

### sf-symbols

Apple's SF Symbols font.
**Keywords:** fonts, symbols, icons, macos

### shottr

Screenshot tool for macOS.
**Keywords:** screenshot, capture, macos, annotation

---

## Installation Sources

- **Homebrew**: Core system packages and applications
- **Cargo**: Rust-based CLI tools
- **Go**: Go-based CLI applications
- **NPM**: Node.js global packages
- **UV**: Python CLI tools and applications
- **Direct installs**: Custom scripts and binaries

---

## Quick Search Tips

Use your text editor's search function (Ctrl/Cmd+F) to find tools by:

- **Name**: Search for the exact tool name
- **Category**: Search for category headers like "Network" or "Database"
- **Keywords**: Search for functionality like "monitor", "git", "terminal", etc.
- **Language**: Search for "rust", "python", "javascript", etc.

---

_Last updated: 2026-01-07_
