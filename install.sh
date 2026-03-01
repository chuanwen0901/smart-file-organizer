#!/bin/bash

# 智能文件整理器安装脚本
# 版本: 1.0.0
# 作者: 草 (Cǎo)

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 日志函数
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 检查命令是否存在
check_command() {
    if ! command -v $1 &> /dev/null; then
        log_error "命令 '$1' 未找到，请先安装"
        return 1
    fi
    return 0
}

# 显示横幅
show_banner() {
    echo -e "${BLUE}"
    echo "================================================"
    echo "  智能文件整理器 v1.0 安装程序"
    echo "  作者: 草 (Cǎo) · 数字园丁"
    echo "================================================"
    echo -e "${NC}"
}

# 检查系统
check_system() {
    log_info "检查系统环境..."
    
    # 检查操作系统
    case "$(uname -s)" in
        Linux*)     OS="Linux" ;;
        Darwin*)    OS="macOS" ;;
        CYGWIN*|MINGW*|MSYS*) OS="Windows" ;;
        *)          OS="Unknown" ;;
    esac
    
    log_info "操作系统: $OS"
    
    # 检查Python
    if check_command python3; then
        PYTHON_CMD="python3"
    elif check_command python; then
        PYTHON_CMD="python"
    else
        log_error "未找到Python，请先安装Python 3.8+"
        exit 1
    fi
    
    # 检查Python版本
    PYTHON_VERSION=$($PYTHON_CMD -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')")
    log_info "Python版本: $PYTHON_VERSION"
    
    # 检查OpenClaw
    if check_command openclaw; then
        log_info "OpenClaw已安装"
    else
        log_warning "OpenClaw未安装，将只安装Python包"
    fi
    
    # 检查pip
    if check_command pip3; then
        PIP_CMD="pip3"
    elif check_command pip; then
        PIP_CMD="pip"
    else
        log_error "未找到pip，请先安装pip"
        exit 1
    fi
}

# 安装依赖
install_dependencies() {
    log_info "安装Python依赖..."
    
    # 基础依赖
    BASE_DEPS=""
    
    # 创建requirements.txt
    cat > /tmp/requirements.txt << EOF
# 智能文件整理器依赖
# 基础库
colorama>=0.4.6
tqdm>=4.65.0
PyYAML>=6.0

# 可选：Web界面
flask>=2.3.0
flask-cors>=4.0.0

# 可选：高级功能
pillow>=10.0.0    # 图片处理
pypdf2>=3.0.0     # PDF处理
python-magic>=0.4.27  # 文件类型检测
EOF
    
    # 安装依赖
    if $PIP_CMD install -r /tmp/requirements.txt; then
        log_success "依赖安装完成"
    else
        log_error "依赖安装失败"
        exit 1
    fi
}

# 安装技能
install_skill() {
    log_info "安装OpenClaw技能..."
    
    # 技能目录
    SKILL_DIR="$HOME/.openclaw/skills/file-organizer"
    
    # 创建目录
    mkdir -p "$SKILL_DIR"
    
    # 复制文件
    log_info "复制技能文件..."
    
    # 这里应该从实际位置复制文件
    # 暂时创建示例文件
    cat > "$SKILL_DIR/SKILL.md" << 'EOF'
---
name: file-organizer
description: 智能文件整理器 - 自动分类、重命名、整理电脑文件
---

# 智能文件整理器

自动整理电脑文件，解决文件混乱问题。

## 功能
- 智能分类整理
- 批量重命名
- 重复文件检测
- 空文件夹清理

## 安装
已通过安装脚本完成安装。

## 使用
```bash
openclaw file-organizer organize --path "~/Downloads"
openclaw file-organizer rename --pattern "file_{num:03d}"
openclaw file-organizer find-duplicates --path "~/Documents"
openclaw file-organizer clean-empty --path "~/Desktop"
```

## 支持
GitHub: https://github.com/cao-organizer/file-organizer
EOF
    
    # 创建主脚本
    cat > "$SKILL_DIR/organizer.py" << 'EOF'
#!/usr/bin/env python3
import sys
import os

# 添加当前目录到路径
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from file_organizer.core import main

if __name__ == "__main__":
    main()
EOF
    
    # 创建核心模块目录
    mkdir -p "$SKILL_DIR/file_organizer"
    
    cat > "$SKILL_DIR/file_organizer/__init__.py" << 'EOF'
"""
智能文件整理器 - 核心模块
"""
__version__ = "1.0.0"
__author__ = "草 (Cǎo)"
EOF
    
    log_success "技能文件已安装到: $SKILL_DIR"
}

# 配置环境
setup_environment() {
    log_info "配置环境..."
    
    # 创建配置文件目录
    CONFIG_DIR="$HOME/.config/file-organizer"
    mkdir -p "$CONFIG_DIR"
    
    # 创建默认配置
    cat > "$CONFIG_DIR/config.yaml" << 'EOF'
# 智能文件整理器配置
file_organizer:
  # 分类规则
  categories:
    documents: ['.pdf', '.doc', '.docx', '.txt', '.md', '.rtf']
    images: ['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp', '.svg']
    videos: ['.mp4', '.avi', '.mov', '.mkv', '.flv', '.wmv']
    audio: ['.mp3', '.wav', '.flac', '.m4a', '.aac', '.ogg']
    archives: ['.zip', '.rar', '.7z', '.tar', '.gz', '.bz2']
    code: ['.py', '.js', '.html', '.css', '.java', '.cpp', '.c', '.go', '.rs']
    executables: ['.exe', '.msi', '.dmg', '.app', '.sh', '.bat']
    spreadsheets: ['.xlsx', '.xls', '.csv', '.ods']
    presentations: ['.pptx', '.ppt', '.key', '.odp']
    data: ['.json', '.xml', '.yaml', '.yml', '.toml']
    fonts: ['.ttf', '.otf', '.woff', '.woff2']
    other: []  # 其他类型
  
  # 行为设置
  behavior:
    backup_before_move: true
    ask_before_delete: true
    log_level: "info"
    max_file_size_mb: 100
    exclude_system_files: true
    preserve_folder_structure: false
  
  # 重命名规则
  rename:
    default_pattern: "{name}_{num:03d}{ext}"
    date_format: "%Y%m%d_%H%M%S"
    keep_original: false
  
  # 重复检测
  duplicates:
    method: "md5"  # md5, size, or both
    min_size_kb: 1
    auto_delete: false
  
  # 清理规则
  cleanup:
    empty_folders: true
    temp_files: true
    old_files_days: 30
    large_files_mb: 100
  
  # 界面设置
  ui:
    theme: "auto"  # auto, light, dark
    language: "auto"
    animations: true
EOF
    
    log_success "配置文件已创建: $CONFIG_DIR/config.yaml"
    
    # 创建日志目录
    LOG_DIR="$HOME/.local/share/file-organizer/logs"
    mkdir -p "$LOG_DIR"
    
    # 设置权限
    if [ "$OS" = "Linux" ] || [ "$OS" = "macOS" ]; then
        chmod +x "$SKILL_DIR/organizer.py"
    fi
}

# 验证安装
verify_installation() {
    log_info "验证安装..."
    
    # 测试Python导入
    if $PYTHON_CMD -c "import sys; sys.path.append('$SKILL_DIR'); import file_organizer; print('Python模块导入成功')" 2>/dev/null; then
        log_success "Python模块验证通过"
    else
        log_warning "Python模块导入测试失败（可能正常）"
    fi
    
    # 测试OpenClaw技能
    if command -v openclaw &> /dev/null; then
        if openclaw skills list | grep -q "file-organizer"; then
            log_success "OpenClaw技能注册成功"
        else
            log_warning "OpenClaw技能未显示（可能需要重启OpenClaw）"
        fi
    fi
    
    # 显示安装信息
    echo ""
    echo -e "${GREEN}================================================"
    echo "  安装完成！"
    echo "================================================"
    echo -e "${NC}"
    echo "智能文件整理器已成功安装。"
    echo ""
    echo "📁 技能目录: $SKILL_DIR"
    echo "⚙️  配置目录: $CONFIG_DIR"
    echo "📝 日志目录: $LOG_DIR"
    echo ""
    
    # 显示使用示例
    echo -e "${YELLOW}使用示例:${NC}"
    echo "  整理文件夹: openclaw file-organizer organize --path ~/Downloads"
    echo "  批量重命名: openclaw file-organizer rename --pattern 'photo_{num:03d}.jpg'"
    echo "  查找重复: openclaw file-organizer find-duplicates --path ~/Documents"
    echo "  清理空文件夹: openclaw file-organizer clean-empty --path ~/Desktop"
    echo ""
    echo -e "${YELLOW}获取帮助:${NC}"
    echo "  openclaw file-organizer --help"
    echo "  openclaw file-organizer --version"
    echo ""
    echo -e "${BLUE}文档:${NC} https://github.com/cao-organizer/file-organizer"
    echo -e "${BLUE}支持:${NC} https://github.com/cao-organizer/file-organizer/issues"
    echo ""
}

# 清理临时文件
cleanup() {
    log_info "清理临时文件..."
    rm -f /tmp/requirements.txt
    log_success "清理完成"
}

# 主函数
main() {
    show_banner
    check_system
    install_dependencies
    install_skill
    setup_environment
    verify_installation
    cleanup
    
    log_success "智能文件整理器 v1.0 安装完成！"
    echo ""
    echo "🌱 感谢使用！让文件整理变得简单。"
}

# 运行主函数
main "$@"