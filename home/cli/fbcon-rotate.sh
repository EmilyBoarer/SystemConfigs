#! /bin/sh

# Rotate the fbcon / tty for use on a portrait monitor

echo "3" | sudo tee /sys/class/graphics/fbcon/rotate
# See https://www.kernel.org/doc/html/latest/fb/fbcon.html
