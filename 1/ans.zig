const std = @import("std");
const stdin = std.io.getStdIn().reader();
const stdout = std.io.getStdOut().writer();

const MAX_INPUT_SIZE = 1024;

fn readInput(allocator: *std.mem.Allocator) !std.ArrayList(i32) {
    var buf: [MAX_INPUT_SIZE]u8 = undefined;
    var fba = std.heap.FixedBufferAllocator.init(&buf);
    const thisAllocator = &fba.allocator;

    var list = std.ArrayList(i32).init(allocator);
    while (true) {
        if (stdin.readUntilDelimiterAlloc(thisAllocator, '\n', MAX_INPUT_SIZE)) |line| {
            const num = try std.fmt.parseInt(i32, line, 10);
            try list.append(num);
        } else |err| switch (err) {
            error.EndOfStream => return list,
            else => return err,
        }
    }
}

fn part1(input: std.ArrayList(i32)) !void {
    for (input.items) |a| {
        for (input.items) |b| {
            if (a == b) {
                continue;
            }
            if (a + b == 2020) {
                try stdout.print("{}\n", .{a * b});
                return;
            }
        }
    }
}

fn part2(input: std.ArrayList(i32)) !void {
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
                    try stdout.print("{}\n", .{a * b * c});
                    return;
                }
            }
        }
    }
}

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = &arena.allocator;

    const input = try readInput(allocator);
    // Part 1
    try part1(input);
    // Part 2
    try part2(input);
}
