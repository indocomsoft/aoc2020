const std = @import("std");
const stdin = std.io.getStdIn().reader();
const stdout = std.io.getStdOut().writer();
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;

const MAX_INPUT_SIZE = 1024;

fn readInput(allocator: *Allocator) !ArrayList(u64) {
    var buf: [MAX_INPUT_SIZE]u8 = undefined;
    var list = std.ArrayList(u64).init(allocator);
    const line = (try stdin.readUntilDelimiterOrEof(&buf, '\n')).?;
    var iterator = std.mem.split(line, ",");
    while (iterator.next()) |item| {
        const num = try std.fmt.parseUnsigned(u64, item, 10);
        try list.append(num);
    }
    return list;
}

fn run_game(input: anytype, stop: u64) !u64 {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = &arena.allocator;

    var map = std.AutoHashMap(u64, u64).init(allocator);
    for (input.items) |item, i| {
        try map.put(item, i + 1);
    }

    var num = input.items[input.items.len - 1];

    var turn: u64 = input.items.len + 1;
    while (turn <= stop) : (turn += 1) {
        const newNum = if (map.contains(num)) (turn - map.get(num).? - 1) else 0;
        try map.put(num, turn - 1);
        num = newNum;
    }

    return num;
}

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = &arena.allocator;

    const input = try readInput(allocator);
    const ans1 = try run_game(input, 2020);
    try stdout.print("{}\n", .{ans1});
    const ans2 = try run_game(input, 30000000);
    try stdout.print("{}\n", .{ans2});
}

const expect = @import("std").testing.expect;
test "test input" {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = &arena.allocator;

    var data = [_]u64{ 0, 3, 6 };
    const input = ArrayList(u64).fromOwnedSlice(allocator, data[0..data.len]);
    expect((try run_game(input, 2020)) == 436);
}
