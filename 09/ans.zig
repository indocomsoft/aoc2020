const std = @import("std");
const stdin = std.io.getStdIn().reader();
const stdout = std.io.getStdOut().writer();
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;

const MAX_INPUT_SIZE = 32;

fn readInput(allocator: *Allocator) !ArrayList(u64) {
    var buf: [MAX_INPUT_SIZE]u8 = undefined;

    var list = std.ArrayList(u64).init(allocator);
    while (true) {
        const line = (try stdin.readUntilDelimiterOrEof(&buf, '\n')) orelse return list;
        const num = try std.fmt.parseUnsigned(u64, line, 10);
        try list.append(num);
    }
}

fn part1(input: anytype, preamble_length: comptime_int) !?u64 {
    var i: usize = preamble_length;
    outer: while (i < input.items.len) : (i += 1) {
        const item = input.items[i];
        var j: usize = 0;
        while (j < preamble_length) : (j += 1) {
            var k: usize = 0;
            while (k < preamble_length) : (k += 1) {
                const a = input.items[i + j - preamble_length];
                const b = input.items[i + k - preamble_length];
                if (a + b == item) {
                    continue :outer;
                }
            }
        }
        return item;
    }
    return null;
}

fn sum(input: []const u64) u64 {
    var result: u64 = 0;
    for (input) |item| {
        result += item;
    }
    return result;
}

fn part2(input: anytype, part1_answer: u64) !?u64 {
    var i: usize = 0;
    while (i < input.items.len - 2) : (i += 1) {
        var j: usize = i + 1;
        while (j < input.items.len) : (j += 1) {
            const slice = input.items[i .. j + 1];
            if (sum(slice) == part1_answer) {
                const min = std.mem.min(u64, slice);
                const max = std.mem.max(u64, slice);
                return min + max;
            }
        }
    }
    return null;
}

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = &arena.allocator;

    const input = try readInput(allocator);
    const ans1 = (try part1(input, 25)).?;
    try stdout.print("{}\n", .{ans1});
    const ans2 = (try part2(input, ans1)).?;
    try stdout.print("{}\n", .{ans2});
}

const expect = @import("std").testing.expect;
test "test input" {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = &arena.allocator;

    var data = [_]u64{ 35, 20, 15, 25, 47, 40, 62, 55, 65, 95, 102, 117, 150, 182, 127, 219, 299, 277, 309, 576 };
    const input = ArrayList(u64).fromOwnedSlice(allocator, data[0..data.len]);
    expect((try part1(input, 5)).? == 127);
    expect((try part2(input, 127)).? == 62);
}
