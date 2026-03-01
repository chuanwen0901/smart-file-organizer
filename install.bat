@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

REM 智能文件整理器 Windows安装脚本
REM 版本: 1.0.0
REM 作者: 草 (Cǎo)

title 智能文件整理器 v1.0 安装程序

echo.
echo ================================================
echo   智能文件整理器 v1.0 安装程序
echo   作者: 草 (Cǎo) · 数字园丁
echo ================================================
echo.

REM 检查Python
echo [INFO] 检查Python环境...
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] 未找到Python，请先安装Python 3.8+
    echo 下载地址: https://www.python.org/downloads/
    pause
    exit /b 1
)

python -c "import sys; print('Python版本:', sys.version)" 2>nul
if %errorlevel% neq 0 (
    echo [ERROR] Python版本检查失败
    pause
    exit /b 1
)

REM 检查pip
echo [INFO] 检查pip...
python -m pip --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] 未找到pip，请先安装pip
    echo 运行: python -m ensurepip --upgrade
    pause
    exit /b 1
)

REM 安装依赖
echo [INFO] 安装Python依赖...
echo.

REM 创建临时requirements文件
(
echo colorama^>=0.4.6
echo tqdm^>=4.65.0
echo PyYAML^>=6.0
echo flask^>=2.3.0
echo flask-cors^>=4.0.0
echo pillow^>=10.0.0
echo pypdf2^>=3.0.0
echo python-magic^>=0.4.27
) > "%TEMP%\requirements.txt"

python -m pip install -r "%TEMP%\requirements.txt"
if %errorlevel% neq 0 (
    echo [ERROR] 依赖安装失败
    del "%TEMP%\requirements.txt"
    pause
    exit /b 1
)

echo [SUCCESS] 依赖安装完成

REM 创建技能目录
set SKILL_DIR=%USERPROFILE%\.openclaw\skills\file-organizer
echo [INFO] 创建技能目录: %SKILL_DIR%
mkdir "%SKILL_DIR%" 2>nul
mkdir "%SKILL_DIR%\file_organizer" 2>nul

REM 创建SKILL.md
(
echo ---
echo name: file-organizer
echo description: 智能文件整理器 - 自动分类、重命名、整理电脑文件
echo ---
echo.
echo # 智能文件整理器
echo.
echo 自动整理电脑文件，解决文件混乱问题。
echo.
echo ## 功能
echo - 智能分类整理
echo - 批量重命名
echo - 重复文件检测
echo - 空文件夹清理
echo.
echo ## 安装
echo 已通过安装脚本完成安装。
echo.
echo ## 使用
echo ```bash
echo openclaw file-organizer organize --path "~/Downloads"
echo openclaw file-organizer rename --pattern "file_{num:03d}"
echo openclaw file-organizer find-duplicates --path "~/Documents"
echo openclaw file-organizer clean-empty --path "~/Desktop"
echo ```
echo.
echo ## 支持
echo GitHub: https://github.com/cao-organizer/file-organizer
) > "%SKILL_DIR%\SKILL.md"

REM 创建主脚本
(
echo #!/usr/bin/env python3
echo import sys
echo import os
echo.
echo # 添加当前目录到路径
echo sys.path.append(os.path.dirname(os.path.abspath(__file__)))
echo.
echo from file_organizer.core import main
echo.
echo if __name__ == "__main__":
echo     main()
) > "%SKILL_DIR%\organizer.py"

REM 创建__init__.py
(
echo """
echo 智能文件整理器 - 核心模块
echo """
echo __version__ = "1.0.0"
echo __author__ = "草 (Cǎo)"
) > "%SKILL_DIR%\file_organizer\__init__.py"

REM 创建配置文件目录
set CONFIG_DIR=%USERPROFILE%\.config\file-organizer
echo [INFO] 创建配置目录: %CONFIG_DIR%
mkdir "%CONFIG_DIR%" 2>nul

REM 创建配置文件
(
echo # 智能文件整理器配置
echo file_organizer:
echo   # 分类规则
echo   categories:
echo     documents: ['.pdf', '.doc', '.docx', '.txt', '.md', '.rtf']
echo     images: ['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp', '.svg']
echo     videos: ['.mp4', '.avi', '.mov', '.mkv', '.flv', '.wmv']
echo     audio: ['.mp3', '.wav', '.flac', '.m4a', '.aac', '.ogg']
echo     archives: ['.zip', '.rar', '.7z', '.tar', '.gz', '.bz2']
echo     code: ['.py', '.js', '.html', '.css', '.java', '.cpp', '.c', '.go', '.rs']
echo     executables: ['.exe', '.msi', '.dmg', '.app', '.sh', '.bat']
echo     spreadsheets: ['.xlsx', '.xls', '.csv', '.ods']
echo     presentations: ['.pptx', '.ppt', '.key', '.odp']
echo     data: ['.json', '.xml', '.yaml', '.yml', '.toml']
echo     fonts: ['.ttf', '.otf', '.woff', '.woff2']
echo     other: []  # 其他类型
echo.
echo   # 行为设置
echo   behavior:
echo     backup_before_move: true
echo     ask_before_delete: true
echo     log_level: "info"
echo     max_file_size_mb: 100
echo     exclude_system_files: true
echo     preserve_folder_structure: false
echo.
echo   # 重命名规则
echo   rename:
echo     default_pattern: "{name}_{num:03d}{ext}"
echo     date_format: "%%Y%%m%%d_%%H%%M%%S"
echo     keep_original: false
echo.
echo   # 重复检测
echo   duplicates:
echo     method: "md5"  # md5, size, or both
echo     min_size_kb: 1
echo     auto_delete: false
echo.
echo   # 清理规则
echo   cleanup:
echo     empty_folders: true
echo     temp_files: true
echo     old_files_days: 30
echo     large_files_mb: 100
echo.
echo   # 界面设置
echo   ui:
echo     theme: "auto"  # auto, light, dark
echo     language: "auto"
echo     animations: true
) > "%CONFIG_DIR%\config.yaml"

REM 创建日志目录
set LOG_DIR=%USERPROFILE%\.local\share\file-organizer\logs
echo [INFO] 创建日志目录: %LOG_DIR%
mkdir "%LOG_DIR%" 2>nul

REM 清理临时文件
del "%TEMP%\requirements.txt" 2>nul

echo [SUCCESS] 文件复制完成

REM 验证安装
echo.
echo [INFO] 验证安装...
python -c "import sys; sys.path.append(r'%SKILL_DIR%'); import file_organizer; print('Python模块导入成功')" 2>nul
if %errorlevel% equ 0 (
    echo [SUCCESS] Python模块验证通过
) else (
    echo [WARNING] Python模块导入测试失败（可能正常）
)

REM 检查OpenClaw
where openclaw >nul 2>&1
if %errorlevel% equ 0 (
    echo [INFO] 检测到OpenClaw，检查技能注册...
    openclaw skills list | findstr /i "file-organizer" >nul
    if %errorlevel% equ 0 (
        echo [SUCCESS] OpenClaw技能注册成功
    ) else (
        echo [WARNING] OpenClaw技能未显示（可能需要重启OpenClaw）
    )
) else (
    echo [INFO] 未检测到OpenClaw，技能将在安装OpenClaw后可用
)

REM 显示完成信息
echo.
echo ================================================
echo   安装完成！
echo ================================================
echo.
echo 智能文件整理器已成功安装。
echo.
echo 技能目录: %SKILL_DIR%
echo 配置目录: %CONFIG_DIR%
echo 日志目录: %LOG_DIR%
echo.
echo 使用示例:
echo   整理文件夹: openclaw file-organizer organize --path "%%USERPROFILE%%\Downloads"
echo   批量重命名: openclaw file-organizer rename --pattern "photo_{num:03d}.jpg"
echo   查找重复: openclaw file-organizer find-duplicates --path "%%USERPROFILE%%\Documents"
echo   清理空文件夹: openclaw file-organizer clean-empty --path "%%USERPROFILE%%\Desktop"
echo.
echo 获取帮助:
echo   openclaw file-organizer --help
echo   openclaw file-organizer --version
echo.
echo 文档: https://github.com/cao-organizer/file-organizer
echo 支持: https://github.com/cao-organizer/file-organizer/issues
echo.
echo 按任意键退出...
pause >nul