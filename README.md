# 📁 智能文件整理器 v1.0

## 🌟 产品简介
**智能文件整理器**是一款基于OpenClaw的AI助手技能，能够自动分类、重命名、整理电脑文件，解决文件混乱问题。

## 🎯 核心功能

### 1. 智能分类整理
- **按类型分类**：文档、图片、视频、音频、压缩包等
- **按时间整理**：按年/月/日自动归档
- **智能识别**：自动识别文件内容并分类

### 2. 批量重命名
- **序列重命名**：file_001, file_002...
- **时间戳重命名**：20240301_文档.pdf
- **内容重命名**：从文件内容提取关键词

### 3. 重复文件检测
- **精确检测**：MD5哈希校验
- **空间回收**：找出重复文件节省空间

### 4. 清理优化
- **空文件夹清理**：删除空文件夹
- **临时文件清理**：清理系统临时文件
- **大文件查找**：找出占用空间的大文件

## 🚀 性能特点
- **高速处理**：1759+ 文件/秒
- **跨平台**：Windows、Linux、macOS全兼容
- **智能缓存**：优化内存使用
- **安全可靠**：操作前备份，错误恢复

## 📦 安装方法

### 方法一：通过GitHub直接安装（推荐）
```bash
# 下载最新版本
curl -L -o file-organizer.zip https://github.com/chuanwen0901/smart-file-organizer/archive/refs/heads/main.zip

# 解压文件
unzip file-organizer.zip

# 复制到OpenClaw技能目录
cp -r smart-file-organizer-main/skill ~/.openclaw/workspace/skills/file-organizer

# 重启OpenClaw
openclaw gateway restart
```

### 方法二：使用安装脚本

#### Windows
```bash
# 下载安装脚本
curl -L -o install.bat https://raw.githubusercontent.com/chuanwen0901/smart-file-organizer/main/install.bat

# 运行安装
install.bat
```

#### Linux/macOS
```bash
# 下载安装脚本
curl -L -o install.sh https://raw.githubusercontent.com/chuanwen0901/smart-file-organizer/main/install.sh

# 设置权限并运行
chmod +x install.sh
./install.sh
```

### 方法三：手动安装
1. 下载技能包：`file-organizer-clawhub-package.zip`
2. 解压到OpenClaw技能目录：`~/.openclaw/workspace/skills/file-organizer/`
3. 重启OpenClaw网关

## 🛠 使用方法

### 基本命令
```bash
# 整理指定文件夹
openclaw file-organizer organize --path "~/Downloads"

# 批量重命名
openclaw file-organizer rename --pattern "photo_{num}.jpg"

# 查找重复文件
openclaw file-organizer find-duplicates

# 清理空文件夹
openclaw file-organizer clean-empty
```

### 配置示例
```yaml
file_organizer:
  rules:
    documents: ['.pdf', '.doc', '.docx', '.txt']
    images: ['.jpg', '.png', '.gif', '.bmp']
    videos: ['.mp4', '.avi', '.mov', '.mkv']
  actions:
    move_to_categories: true
    create_backup: true
    ask_before_delete: true
```

## 📊 测试结果
- **整理测试**：✅ 通过 (0.02秒处理21个文件)
- **重命名测试**：✅ 通过 (0.01秒重命名10个文件)
- **重复检测测试**：✅ 通过 (精确MD5校验)
- **空文件夹清理测试**：✅ 通过 (正确识别和清理)
- **性能测试**：✅ **优秀** (1759.1文件/秒)

## 🎯 使用场景

### 个人使用
- 整理下载文件夹
- 整理照片和视频
- 整理工作文档

### 办公使用
- 批量处理客户文件
- 整理项目资料
- 备份文件整理

### 开发者使用
- 整理代码文件
- 整理日志文件
- 整理测试数据

## 🔧 技术细节

### 系统要求
- Windows 10/11, Linux, macOS
- Python 3.8+
- OpenClaw 2026.2.0+

### 文件结构
```
file-organizer/
├── SKILL.md          # 技能定义文件
├── organizer.py      # 核心处理逻辑
├── package.json      # 元数据文件
├── README.md         # 本文档
├── INSTALL.md        # 详细安装指南
├── CHANGELOG.md      # 版本更新日志
├── ANNOUNCEMENT.md   # 发布公告
├── LICENSE           # MIT许可证
├── install.bat       # Windows安装脚本
└── install.sh        # Linux/macOS安装脚本
```

## 🤝 贡献指南
欢迎提交Issue和Pull Request！
1. Fork本仓库
2. 创建功能分支
3. 提交更改
4. 推送到分支
5. 创建Pull Request

## 📄 许可证
MIT License - 详见 [LICENSE](LICENSE) 文件

## 🔗 相关链接
- **GitHub仓库**：https://github.com/chuanwen0901/smart-file-organizer
- **问题反馈**：https://github.com/chuanwen0901/smart-file-organizer/issues
- **ClawHub发布包**：`file-organizer-clawhub-package.zip`
- **作者**：chuanwen0901
- **联系方式**：通过GitHub Issues

## 📈 版本历史

### v1.0.0 (2026-03-01)
- 初始发布版本
- 智能文件分类
- 批量重命名
- 重复文件检测
- 空文件夹清理
- 跨平台支持
- 完整文档和安装脚本

---

**提示**：使用前建议先在小规模文件夹上测试，确保功能符合预期。所有删除操作都有安全保护机制。