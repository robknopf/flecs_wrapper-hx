# flecs_wrapper-hx

Haxe haxelib for [flecs_wrapper](https://github.com/robknopf/flecs_wrapper.git), a wrapper library for the excellent flecs ecs library (https://github.com/SanderMertens/flecs.git).  Note that flecs_wrapper is not a 1:1 wrapper over flecs, but instead provides abstracted handles, callbacks and other assorted helpers for my gamedev. 

This haxelib vendors the flecs_wrapper repo as a submodule, exposes its Haxe bindings on the classpath, and compiles native code through hxcpp when you build your project.  As such, it is important that you include "--recursive" when pulling/cloning.

## Requirements

- Haxe **4.3+**
- **hxcpp** (desktop and wasm)
- **Neko** (hxcpp build tooling)
- **gcc/clang** (desktop)
- **Emscripten (`emcc`)** (wasm)

## Install

```bash
haxelib git flecs_wrapper-hx https://github.com/robknopf/flecs_wrapper-hx.git --recursive
```

`--recursive` pulls the flecs_wrapper submodule.

Local development:

```bash
git clone --recursive https://github.com/robknopf/flecs_wrapper-hx.git
haxelib dev flecs_wrapper-hx /path/to/flecs_wrapper-hx
```

## Usage

```hxml
-lib flecs_wrapper-hx
```

## License

MIT — see the flecs_wrapper-hx repository for details.
