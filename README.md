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
- **智能处理**：保留最新/最优版本

### 4. 清理优化
- **空文件夹清理**：自动删除空文件夹
- **临时文件清理**：清理系统临时文件
- **大文件查找**：找出占用空间的大文件

## 📦 系统要求

### 最低配置
- **操作系统**：Windows 10/11, macOS 10.15+, Linux
- **Python**：3.8 或更高版本
- **内存**：4GB RAM
- **存储**：100MB 可用空间

### 推荐配置
- **操作系统**：Windows 11 / macOS 12+
- **Python**：3.11 或更高版本
- **内存**：8GB RAM 或更多
- **存储**：1GB 可用空间

## 🚀 快速安装

### 方法一：一键安装（推荐）
```bash
# 下载安装脚本
curl -O https://raw.githubusercontent.com/cao-organizer/file-organizer/main/install.sh

# 运行安装
bash install.sh
```

### 方法二：手动安装
```bash
# 1. 克隆仓库
git clone https://github.com/cao-organizer/file-organizer.git

# 2. 进入目录
cd file-organizer

# 3. 安装依赖
pip install -r requirements.txt

# 4. 安装到OpenClaw
openclaw skills install ./file-organizer
```

### 方法三：OpenClaw技能市场
```bash
# 在OpenClaw中直接安装
openclaw skills install file-organizer
```

## 📖 使用指南

### 基本使用
```bash
# 整理指定文件夹
openclaw file-organizer organize --path "~/Downloads"

# 批量重命名
openclaw file-organizer rename --pattern "photo_{num:03d}.jpg"

# 查找重复文件
openclaw file-organizer find-duplicates --path "~/Documents"

# 清理空文件夹
openclaw file-organizer clean-empty --path "~/Desktop"
```

### 配置文件
创建 `~/.config/file-organizer/config.yaml`：
```yaml
file_organizer:
  # 分类规则
  categories:
    documents: ['.pdf', '.doc', '.docx', '.txt', '.md']
    images: ['.jpg', '.png', '.gif', '.bmp', '.webp']
    videos: ['.mp4', '.avi', '.mov', '.mkv']
    audio: ['.mp3', '.wav', '.flac', '.m4a']
  
  # 行为设置
  behavior:
    backup_before_move: true
    ask_before_delete: true
    log_level: info
    max_file_size_mb: 100
```

### 图形界面（可选）
```bash
# 启动Web界面
openclaw file-organizer gui

# 在浏览器中打开 http://localhost:8080
```

## 🔧 高级功能

### 计划任务
```bash
# 每天凌晨2点自动整理下载文件夹
openclaw file-organizer schedule \
  --time "02:00" \
  --path "~/Downloads" \
  --action organize
```

### 批量处理
```bash
# 批量处理多个文件夹
openclaw file-organizer batch \
  --paths "~/Downloads,~/Desktop,~/Documents" \
  --actions "organize,find-duplicates,clean-empty"
```

### 导出报告
```bash
# 生成整理报告
openclaw file-organizer report \
  --path "~/Documents" \
  --format html \
  --output "整理报告.html"
```

## 🛡️ 安全特性

### 数据安全
- **操作前备份**：可选创建备份点
- **操作可撤销**：完整操作日志
- **权限检查**：不操作系统关键文件

### 隐私保护
- **完全本地处理**：不上传任何文件
- **可选加密**：敏感文件加密处理
- **日志清理**：定期清理操作日志

## 📊 性能表现

### 处理速度
- **小文件夹**（< 100文件）：< 10秒
- **中等文件夹**（< 1000文件）：< 1分钟
- **大文件夹**（< 10000文件）：< 5分钟

### 资源占用
- **内存使用**：< 100MB
- **CPU使用**：< 20%
- **磁盘IO**：优化过的批量操作

## 🐛 故障排除

### 常见问题

#### Q1: 安装失败
**解决方案**：
```bash
# 更新pip
pip install --upgrade pip

# 清理缓存
pip cache purge

# 重新安装
pip install file-organizer --no-cache-dir
```

#### Q2: 权限不足
**解决方案**：
```bash
# Windows: 以管理员身份运行
# macOS/Linux: 使用sudo
sudo openclaw file-organizer organize --path "/path/to/folder"
```

#### Q3: 文件处理失败
**解决方案**：
```bash
# 查看详细日志
openclaw file-organizer organize --path "~/folder" --verbose

# 跳过错误继续
openclaw file-organizer organize --path "~/folder" --skip-errors
```

### 获取帮助
```bash
# 查看帮助
openclaw file-organizer --help

# 查看版本
openclaw file-organizer --version

# 提交问题
openclaw file-organizer issue --describe "问题描述"
```

## 🔄 更新日志

### v1.0.0 (2026-03-01) - 首次发布
- ✅ 基础文件分类功能
- ✅ 批量重命名支持
- ✅ 重复文件检测
- ✅ 空文件夹清理
- ✅ 图形界面（Web）
- ✅ 计划任务支持
- ✅ 详细报告生成

### 计划功能
- [ ] 云存储集成（Google Drive, Dropbox）
- [ ] 移动端应用
- [ ] AI智能标签
- [ ] 团队协作功能
- [ ] 高级分析报告

## 🤝 贡献指南

### 报告问题
1. 在GitHub Issues中创建新问题
2. 描述详细的重现步骤
3. 提供系统信息和日志

### 提交代码
1. Fork仓库
2. 创建功能分支
3. 提交Pull Request
4. 通过所有测试

### 开发环境
```bash
# 设置开发环境
git clone https://github.com/cao-organizer/file-organizer.git
cd file-organizer
python -m venv venv
source venv/bin/activate  # Linux/macOS
venv\Scripts\activate     # Windows
pip install -r requirements-dev.txt
pytest tests/
```

## 📄 许可证

MIT License

版权所有 (c) 2026 草 (Cǎo)

特此免费授予任何获得本软件副本和相关文档文件（以下简称"软件"）的人士不受限制地处理本软件的权限，包括但不限于使用、复制、修改、合并、发布、分发、再许可和/或销售本软件的副本，并允许向其提供本软件的人士这样做，但须符合以下条件：

上述版权声明和本许可声明应包含在本软件的所有副本或重要部分中。

本软件按"原样"提供，不作任何明示或暗示的保证，包括但不限于对适销性、特定用途适用性和非侵权性的保证。在任何情况下，作者或版权持有人均不对因本软件或本软件的使用或其他交易而产生、引起或与之相关的任何索赔、损害或其他责任负责。

## 📞 联系支持

### 官方渠道
- **GitHub**: https://github.com/cao-organizer/file-organizer
- **文档**: https://docs.cao-organizer.com
- **邮箱**: support@cao-organizer.com

### 社区支持
- **OpenClaw社区**: https://community.openclaw.ai
- **Discord**: https://discord.gg/cao-organizer
- **QQ群**: 123456789

### 商业合作
- **企业版咨询**: enterprise@cao-organizer.com
- **定制开发**: custom@cao-organizer.com
- **合作伙伴**: partner@cao-organizer.com

---

**感谢使用智能文件整理器！** 🌱

让文件整理变得简单，让数字生活更有序。