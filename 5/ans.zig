const std = @import("std");
const stdin = std.io.getStdIn().reader();
const stdout = std.io.getStdOut().writer();
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;

const MAX_INPUT_SIZE = 16;

fn readInput(allocator: *Allocator) !ArrayList(u16) {
    var buf: [MAX_INPUT_SIZE]u8 = undefined;

    var list = ArrayList(u16).init(allocator);
    while (true) {
        const line = (try stdin.readUntilDelimiterOrEof(&buf, '\n')) orelse return list;
        for (line) |*c| {
            if (c.* == 'B' or c.* == 'R') {
                c.* = '1';
            } else if (c.* == 'F' or c.* == 'L') {
                c.* = '0';
            }
        }
        const seatId = try std.fmt.parseUnsigned(u16, line[0..10], 2);
        try list.append(seatId);
    }
}

fn part1(input: ArrayList(u16)) !void {
    try stdout.print("{}\n", .{input.items[input.items.len - 1]});
}

fn part2(input: ArrayList(u16)) !void {
    const min = input.items[0];
    var i: usize = 0;
    while (i < input.items.len) : (i += 1) {
        if (input.items[i] != min + i) {
            try stdout.print("{}\n", .{min + i});
            return;
        }
    }
}

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = &arena.allocator;

    const input = try readInput(allocator);
    std.sort.sort(u16, input.items, {}, comptime std.sort.asc(u16));
    try part1(input);
    try part2(input);
}
