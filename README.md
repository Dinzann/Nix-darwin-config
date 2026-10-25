# nix-darwin 配置

用 [nix-darwin](https://github.com/nix-darwin/nix-darwin) 声明式管理本机 macOS 配置，并用其 `homebrew.*` 选项管理 Homebrew 软件包（包仍由 Brew 安装，不是换成 nixpkgs）。

本机主机名 / flake 配置名：`Dinzann`  
主用户：`dinzann`

## 目录结构

```
~/.config/nix-darwin/
├── flake.nix                 # 系统入口；nixpkgs 走清华 git 镜像
├── flake.lock
├── modules/
│   ├── homebrew.nix          # Homebrew taps / brews / casks
│   └── nix.custom.conf       # Determinate Nix 国内二进制缓存
└── scripts/
    └── install-mirrors.sh    # 将 nix.custom.conf 安装到 /etc/nix/
```

## 全新安装 / 重置系统后

按顺序执行：

### 1. 安装 Determinate Nix

按官网安装：[https://docs.determinate.systems/](https://docs.determinate.systems/)

装好后应存在 `/etc/nix/`（且 `nix.enable = false`，由 Determinate 管 Nix 本身）。

### 2. 安装 Homebrew（若尚未安装）

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

可选：在 shell 里配置 Homebrew 国内 bottle 镜像（与本仓库无关，常见写法见 USTC / TUNA 文档）。

### 3. 克隆本仓库

```bash
git clone git@github.com:Dinzann/Nix-darwin-config.git ~/.config/nix-darwin
cd ~/.config/nix-darwin
```

### 4. 启用国内 Nix 二进制缓存

```bash
./scripts/install-mirrors.sh
```

会把 `modules/nix.custom.conf` 符号链接到 `/etc/nix/nix.custom.conf`。  
可用下面命令确认：

```bash
nix show-config | grep substituters
```

### 5. 首次应用配置

```bash
cd ~/.config/nix-darwin
sudo darwin-rebuild switch --flake .#Dinzann
```

第一次会安装 nix-darwin，并按 `modules/homebrew.nix` 用 `brew bundle` 安装声明的 formulae / casks。  
未写进列表的 Homebrew 包会因 `cleanup = "uninstall"` 被卸载。

---

## 日常使用

### 应用配置更改

改完 `flake.nix` 或 `modules/` 后：

```bash
cd ~/.config/nix-darwin
sudo darwin-rebuild switch --flake .#Dinzann
```

### 增删 Homebrew 软件

编辑 `modules/homebrew.nix`：

- `taps`：额外 tap
- `brews`：命令行 formula
- `casks`：GUI / 字体等 cask

保存后再执行上面的 `darwin-rebuild switch`。

### 更新 flake 输入（nixpkgs / nix-darwin）

```bash
cd ~/.config/nix-darwin
nix flake update          # 或：nix flake update nixpkgs
sudo darwin-rebuild switch --flake .#Dinzann
```

说明：

- `nixpkgs` 从清华 git 镜像拉取，一般不需要魔法
- 更新 `nix-darwin` 输入时仍可能访问 GitHub；日常 rebuild（已 lock）通常不必

---

## 国内镜像说明

| 用途 | 位置 | 说明 |
|------|------|------|
| nixpkgs 源码 / flake 输入 | `flake.nix` → `inputs.nixpkgs` | 清华 `git/nixpkgs.git` |
| 二进制缓存（substituters） | `modules/nix.custom.conf` | 清华 + 中科大，需先跑 `install-mirrors.sh` |
| Homebrew | 不在本仓库 | 自行在 shell 环境变量里配 bottle / API 镜像 |

注意：当前使用 Determinate Nix（`nix.enable = false`），写在 `flake.nix` 里的 `nix.settings.substituters` **不会**写入 `/etc/nix`。二进制缓存必须以 `nix.custom.conf` 为准。

---

## 常见问题

### `libtiff` / `webp` 循环依赖警告

Homebrew 本地 keg 元数据过旧时的提示，一般不影响使用。若要清理：

```bash
brew update
brew uninstall --ignore-dependencies --force libtiff webp
brew install libtiff webp
```

### 换主机名或用户名

同步修改 `flake.nix` 中的：

- `darwinConfigurations."<主机名>"`
- `system.primaryUser`

主机名可用 `scutil --get LocalHostName` 查看。

### 与 `~/dotfile` 的关系

本仓库与 stow 管理的 `~/dotfile` **相互独立**。应用配置、字体、zsh 等仍用 dotfile；系统与 Homebrew 列表用本仓库。
