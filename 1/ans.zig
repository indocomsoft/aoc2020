const std = @import("std");
const stdin = std.io.getStdIn().reader();
const stdout = std.io.getStdOut().writer();
const allocator = std.heap.c_allocator;

fn readInput() !std.ArrayList(i32) {
    var list = std.ArrayList(i32).init(allocator);
    while (true) {
        if (stdin.readUntilDelimiterAlloc(allocator, '\n', 1024)) |line| {
            const num = try std.fmt.parseInt(i32, line, 10);
            allocator.free(line);
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
                stdout.print("{}\n", .{a * b}) catch unreachable;
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
                    stdout.print("{}\n", .{a * b * c}) catch unreachable;
                    return;
                }
            }
        }
    }
}

pub fn main() void {
    const input = readInput() catch unreachable;
    // Part 1
    part1(input) catch unreachable;
    // Part 2
    part2(input) catch unreachable;
}
