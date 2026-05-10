# Video Memory Map – DOS Maze Game

## Segment 0xB800

The CGA/VGA text-mode buffer starts at physical address `0xB8000`.
In 16-bit real mode, this is accessed as segment `0xB800`, offset `0x0000`.

## Cell Layout (2 bytes per character cell)

```
┌─────────────────┬────────────────────────────┐
│   High Byte     │         Low Byte           │
│  (Attribute)    │      (ASCII Code)          │
├────────┬────────┤                            │
│ BG [7:4]│FG[3:0]│                            │
└────────┴────────┴────────────────────────────┘
```

## Color Codes

| Code | Color         |
|------|---------------|
| 0x0  | Black         |
| 0x1  | Blue          |
| 0x2  | Green         |
| 0x3  | Cyan          |
| 0x4  | Red           |
| 0x5  | Magenta       |
| 0x6  | Brown/Yellow  |
| 0x7  | Light Grey    |
| 0xE  | Yellow (bright)|
| 0xF  | White (bright) |

## Key Offsets Used in This Game

| Offset | Description               |
|--------|---------------------------|
| 0      | Top-left (row 0, col 0)   |
| 164    | finishPos (row 1, col 2)  |
| 2160   | playerPos (row 13, col 40)|
| 3840   | Last row start (row 24)   |
| 3998   | Bottom-right corner       |

## Row/Column Formula

```
offset = (row × 80 + col) × 2
```
