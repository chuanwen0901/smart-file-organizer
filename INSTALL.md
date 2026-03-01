# 安装指南

## 快速安装

### 方法一：复制技能目录
1. 将 `skill` 目录复制到 OpenClaw 技能目录：
   - Windows: `%USERPROFILE%\.openclaw\skills\file-organizer`
   - Linux/macOS: `~/.openclaw/skills/file-organizer`
2. 重启 OpenClaw

### 方法二：使用安装脚本
- Linux/macOS: 运行 `install.sh`
- Windows: 运行 `install.bat`

## 验证安装
```bash
openclaw skills list | grep file-organizer
```

应该看到：
```
✓ ready   📦 file-organizer    智能文件整理器 - 自动分类、重命名、整理电脑文件     openclaw-workspace
```

## 使用方法
```bash
# 整理文件夹
openclaw file-organizer organize --path "~/Downloads"

# 获取帮助
openclaw file-organizer --help
```

## 支持
- 文档: 查看 README.md
- 问题: 查看 GitHub Issues
- 社区: OpenClaw Discord

版本: 1.0.0
发布日期: 20260301
