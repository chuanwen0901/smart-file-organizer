#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
智能文件整理器 - 核心功能模块
作者: 草 (Cǎo)
版本: 0.1.0
"""

import os
import sys
import shutil
import hashlib
import datetime
import json
from pathlib import Path
from typing import Dict, List, Tuple, Optional
import argparse

class FileOrganizer:
    """文件整理器核心类"""
    
    def __init__(self, config_path: Optional[str] = None):
        """初始化整理器"""
        self.config = self.load_config(config_path)
        self.stats = {
            'files_processed': 0,
            'files_moved': 0,
            'files_renamed': 0,
            'duplicates_found': 0,
            'errors': 0
        }
        
        # 默认分类规则
        self.default_categories = {
            '文档': ['.pdf', '.doc', '.docx', '.txt', '.xlsx', '.pptx', '.md'],
            '图片': ['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.svg', '.webp'],
            '视频': ['.mp4', '.avi', '.mov', '.mkv', '.flv', '.wmv'],
            '音频': ['.mp3', '.wav', '.flac', '.m4a', '.aac'],
            '压缩包': ['.zip', '.rar', '.7z', '.tar', '.gz'],
            '代码': ['.py', '.js', '.html', '.css', '.java', '.cpp', '.c'],
            '可执行文件': ['.exe', '.msi', '.bat', '.sh'],
            '其他': []  # 其他类型文件
        }
        
    def load_config(self, config_path: Optional[str]) -> Dict:
        """加载配置文件"""
        default_config = {
            'backup_before_move': True,
            'ask_before_delete': True,
            'log_level': 'INFO',
            'max_file_size_mb': 100,  # 最大处理文件大小(MB)
            'exclude_dirs': ['System Volume Information', '$RECYCLE.BIN', 'Windows'],
            'exclude_extensions': ['.sys', '.dll', '.ini']
        }
        
        if config_path and os.path.exists(config_path):
            try:
                with open(config_path, 'r', encoding='utf-8') as f:
                    user_config = json.load(f)
                    default_config.update(user_config)
            except Exception as e:
                print(f"⚠️ 配置文件加载失败: {e}, 使用默认配置")
                
        return default_config
    
    def get_file_hash(self, file_path: str) -> str:
        """计算文件MD5哈希值"""
        try:
            hasher = hashlib.md5()
            with open(file_path, 'rb') as f:
                # 只读取前1MB来计算哈希，提高大文件处理速度
                buf = f.read(1024 * 1024)
                hasher.update(buf)
            return hasher.hexdigest()
        except Exception as e:
            print(f"⚠️ 计算文件哈希失败 {file_path}: {e}")
            return ""
    
    def organize_by_type(self, source_dir: str, target_dir: Optional[str] = None) -> Dict:
        """按文件类型整理"""
        if target_dir is None:
            target_dir = source_dir
            
        results = {
            'categories': {},
            'moved_files': [],
            'errors': []
        }
        
        try:
            # 确保目标目录存在
            os.makedirs(target_dir, exist_ok=True)
            
            # 遍历源目录
            for root, dirs, files in os.walk(source_dir):
                # 跳过排除的目录
                dirs[:] = [d for d in dirs if d not in self.config['exclude_dirs']]
                
                for file in files:
                    file_path = os.path.join(root, file)
                    
                    # 跳过排除的文件类型
                    if any(file.endswith(ext) for ext in self.config['exclude_extensions']):
                        continue
                    
                    # 检查文件大小限制
                    try:
                        file_size_mb = os.path.getsize(file_path) / (1024 * 1024)
                        if file_size_mb > self.config['max_file_size_mb']:
                            print(f"⚠️ 跳过大文件: {file} ({file_size_mb:.1f}MB)")
                            continue
                    except:
                        pass
                    
                    # 获取文件扩展名
                    _, ext = os.path.splitext(file)
                    ext = ext.lower()
                    
                    # 确定文件类别
                    category = '其他'
                    for cat, exts in self.default_categories.items():
                        if ext in exts:
                            category = cat
                            break
                    
                    # 创建类别目录
                    category_dir = os.path.join(target_dir, category)
                    os.makedirs(category_dir, exist_ok=True)
                    
                    # 移动文件
                    try:
                        target_path = os.path.join(category_dir, file)
                        
                        # 处理文件名冲突
                        counter = 1
                        while os.path.exists(target_path):
                            name, ext = os.path.splitext(file)
                            target_path = os.path.join(category_dir, f"{name}_{counter}{ext}")
                            counter += 1
                        
                        if source_dir != target_dir or root != category_dir:
                            shutil.move(file_path, target_path)
                            results['moved_files'].append({
                                'from': file_path,
                                'to': target_path,
                                'category': category
                            })
                        
                        # 更新统计
                        if category not in results['categories']:
                            results['categories'][category] = 0
                        results['categories'][category] += 1
                        
                        self.stats['files_processed'] += 1
                        self.stats['files_moved'] += 1
                        
                    except Exception as e:
                        results['errors'].append(f"移动文件失败 {file}: {e}")
                        self.stats['errors'] += 1
                        
        except Exception as e:
            results['errors'].append(f"整理过程出错: {e}")
            
        return results
    
    def batch_rename(self, directory: str, pattern: str = "file_{num:03d}") -> Dict:
        """批量重命名文件"""
        results = {
            'renamed_files': [],
            'errors': []
        }
        
        try:
            files = []
            for item in os.listdir(directory):
                item_path = os.path.join(directory, item)
                if os.path.isfile(item_path):
                    files.append(item)
            
            # 按修改时间排序
            files.sort(key=lambda x: os.path.getmtime(os.path.join(directory, x)))
            
            for i, file in enumerate(files, 1):
                old_path = os.path.join(directory, file)
                name, ext = os.path.splitext(file)
                
                # 生成新文件名
                new_name = pattern.format(num=i, name=name, ext=ext[1:], 
                                         date=datetime.datetime.now().strftime('%Y%m%d'))
                new_name = f"{new_name}{ext}"
                new_path = os.path.join(directory, new_name)
                
                try:
                    os.rename(old_path, new_path)
                    results['renamed_files'].append({
                        'old_name': file,
                        'new_name': new_name
                    })
                    self.stats['files_renamed'] += 1
                except Exception as e:
                    results['errors'].append(f"重命名失败 {file}: {e}")
                    self.stats['errors'] += 1
                    
        except Exception as e:
            results['errors'].append(f"批量重命名出错: {e}")
            
        return results
    
    def find_duplicates(self, directory: str) -> Dict:
        """查找重复文件"""
        results = {
            'duplicates': {},
            'total_files': 0,
            'unique_files': 0,
            'wasted_space_mb': 0
        }
        
        try:
            file_hashes = {}
            
            for root, dirs, files in os.walk(directory):
                for file in files:
                    file_path = os.path.join(root, file)
                    
                    try:
                        file_hash = self.get_file_hash(file_path)
                        if file_hash:
                            if file_hash not in file_hashes:
                                file_hashes[file_hash] = []
                            file_hashes[file_hash].append(file_path)
                    except Exception as e:
                        print(f"⚠️ 处理文件失败 {file}: {e}")
            
            # 找出重复文件
            for file_hash, paths in file_hashes.items():
                if len(paths) > 1:
                    # 按文件大小排序，保留最大的（假设是最新的）
                    paths.sort(key=lambda x: os.path.getsize(x), reverse=True)
                    
                    results['duplicates'][file_hash] = {
                        'keep': paths[0],
                        'duplicates': paths[1:],
                        'size_mb': os.path.getsize(paths[0]) / (1024 * 1024)
                    }
                    
                    wasted_space = sum(os.path.getsize(p) for p in paths[1:]) / (1024 * 1024)
                    results['wasted_space_mb'] += wasted_space
                    self.stats['duplicates_found'] += len(paths) - 1
            
            results['total_files'] = sum(len(paths) for paths in file_hashes.values())
            results['unique_files'] = len(file_hashes)
            
        except Exception as e:
            results['errors'] = [f"查找重复文件出错: {e}"]
            
        return results
    
    def clean_empty_folders(self, directory: str) -> Dict:
        """清理空文件夹"""
        results = {
            'removed_folders': [],
            'errors': []
        }
        
        try:
            for root, dirs, files in os.walk(directory, topdown=False):
                for dir_name in dirs:
                    dir_path = os.path.join(root, dir_name)
                    
                    # 跳过排除的目录
                    if dir_name in self.config['exclude_dirs']:
                        continue
                    
                    try:
                        # 检查是否为空
                        if not os.listdir(dir_path):
                            os.rmdir(dir_path)
                            results['removed_folders'].append(dir_path)
                    except Exception as e:
                        results['errors'].append(f"删除文件夹失败 {dir_path}: {e}")
                        
        except Exception as e:
            results['errors'].append(f"清理空文件夹出错: {e}")
            
        return results
    
    def print_stats(self):
        """打印统计信息"""
        print("\n" + "="*50)
        print("[STATS] 整理统计")
        print("="*50)
        print(f"处理文件数: {self.stats['files_processed']}")
        print(f"移动文件数: {self.stats['files_moved']}")
        print(f"重命名文件数: {self.stats['files_renamed']}")
        print(f"发现重复文件: {self.stats['duplicates_found']}")
        print(f"错误数: {self.stats['errors']}")
        print("="*50)

def main():
    """主函数"""
    parser = argparse.ArgumentParser(description='智能文件整理器')
    parser.add_argument('--organize', help='整理指定目录的文件')
    parser.add_argument('--rename', help='批量重命名指定目录的文件')
    parser.add_argument('--find-duplicates', help='查找重复文件')
    parser.add_argument('--clean-empty', help='清理空文件夹')
    parser.add_argument('--config', help='配置文件路径')
    
    args = parser.parse_args()
    
    organizer = FileOrganizer(args.config)
    
    if args.organize:
        print(f"📁 开始整理目录: {args.organize}")
        results = organizer.organize_by_type(args.organize)
        print(f"✅ 整理完成! 移动了 {len(results['moved_files'])} 个文件")
        
    elif args.rename:
        print(f"🏷️  开始重命名目录: {args.rename}")
        results = organizer.batch_rename(args.rename)
        print(f"✅ 重命名完成! 重命名了 {len(results['renamed_files'])} 个文件")
        
    elif args.find_duplicates:
        print(f"🔍 开始查找重复文件: {args.find_duplicates}")
        results = organizer.find_duplicates(args.find_duplicates)
        print(f"✅ 找到 {len(results['duplicates'])} 组重复文件")
        print(f"💾 可节省空间: {results['wasted_space_mb']:.2f} MB")
        
    elif args.clean_empty:
        print(f"🧹 开始清理空文件夹: {args.clean_empty}")
        results = organizer.clean_empty_folders(args.clean_empty)
        print(f"✅ 清理完成! 删除了 {len(results['removed_folders'])} 个空文件夹")
        
    else:
        print("请指定操作类型，使用 --help 查看帮助")
        
    organizer.print_stats()

if __name__ == "__main__":
    main()