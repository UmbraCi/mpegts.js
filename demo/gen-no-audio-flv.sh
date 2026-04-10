#!/usr/bin/env bash
set -euo pipefail

if [ "${1:-}" = "" ]; then
  echo "用法: $0 <input_video> [output_flv]"
  echo "示例: $0 ./demo/input.mp4 ./demo/no-audio.flv"
  exit 1
fi

INPUT_FILE="$1"
OUTPUT_FILE="${2:-}"

if ! command -v ffmpeg >/dev/null 2>&1; then
  echo "错误: 未找到 ffmpeg，请先安装 ffmpeg"
  exit 1
fi

if ! command -v ffprobe >/dev/null 2>&1; then
  echo "错误: 未找到 ffprobe，请先安装 ffmpeg（包含 ffprobe）"
  exit 1
fi

if [ ! -f "$INPUT_FILE" ]; then
  echo "错误: 输入文件不存在: $INPUT_FILE"
  exit 1
fi

if [ "$OUTPUT_FILE" = "" ]; then
  INPUT_BASENAME="$(basename "$INPUT_FILE")"
  INPUT_STEM="${INPUT_BASENAME%.*}"
  INPUT_DIR="$(dirname "$INPUT_FILE")"
  OUTPUT_FILE="${INPUT_DIR}/${INPUT_STEM}-no-audio.flv"
fi

echo "开始生成无音频 FLV..."
echo "输入: $INPUT_FILE"
echo "输出: $OUTPUT_FILE"

ffmpeg -y -i "$INPUT_FILE" -c:v copy -an -f flv "$OUTPUT_FILE"

echo ""
echo "生成完成，开始校验流信息（应只有 video）..."
ffprobe -v error -show_streams "$OUTPUT_FILE"

