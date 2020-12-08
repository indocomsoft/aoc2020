const std = @import("std");
const stdin = std.io.getStdIn().reader();
const stdout = std.io.getStdOut().writer();

const MAX_INPUT_SIZE = 1024;

fn readInput(allocator: *std.mem.Allocator, reader: struct {  }) !std.ArrayList(i32) {
    var buf: [MAX_INPUT_SIZE]u8 = undefined;
    var list = std.ArrayList(i32).init(allocator);
    while (true) {
        const line = (try reader.readUntilDelimiterOrEof(&buf, '\n')) orelse return list;
        const num = try std.fmt.parseInt(i32, line, 10);
        try list.append(num);
    }
}

fn part1(input: std.ArrayList(i32)) !i64 {
    for (input.items) |a| {
        for (input.items) |b| {
            if (a == b) {
                continue;
            }
            if (a + b == 2020) {
                return a * b;
            }
        }
    }
    unreachable;
}

fn part2(input: std.ArrayList(i32)) !i64 {
    for (input.items) |a| {
        for (input.items) |b| {
            if (a == b) {
                continue;
            }
            for (input.items) |c| {
                if (a == c or b == c) {
                    continue;
                }
                if (a + b + c == 2020) {
                    return a * b * c;
                }
            }
        }
    }
    unreachable;
}

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = &arena.allocator;

    const input = try readInput(allocator, stdin);
    // Part 1
    const ans1 = try part1(input);
    try stdout.print("{}\n", .{ans1});
    // Part 2
    const ans2 = try part2(input);
    try stdout.print("{}\n", .{ans2});
}

const expect = @import("std").testing.expect;
test "test input" {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = &arena.allocator;
    const reader = std.io.Reader()
    var input = std.ArrayList(i32).init(allocator);
    try input.append(1721);
    try input.append(979);
    try input.append(366);
    try input.append(299);
    try input.append(675);
    try input.append(1456);
    expect((try part1(input)) == 514579);
    expect((try part2(input)) == 241861950);
}
