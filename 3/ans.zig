const std = @import("std");
const stdin = std.io.getStdIn().reader();
const stdout = std.io.getStdOut().writer();
const allocator = std.heap.c_allocator;

fn readInput() !std.ArrayList([]u8) {
    var list = std.ArrayList([]u8).init(allocator);
    while (true) {
        if (stdin.readUntilDelimiterAlloc(allocator, '\n', 1024)) |line| {
            try list.append(line);
        } else |err| switch (err) {
            error.EndOfStream => return list,
            else => return err,
        }
    }
}

fn check(input: std.ArrayList([]u8), rowJump: usize, colJump: usize) !u32 {
    var numTrees: u32 = 0;
    var i: usize = rowJump;
    var j: usize = colJump;
    while (true) {
        if (input.items[i][j] == '#') {
            numTrees += 1;
        }
        i += rowJump;
        if (i >= input.items.len) {
            break;
        }
        j = (j + colJump) % input.items[i].len;
    }
    return numTrees;
}

fn part1(input: std.ArrayList([]u8)) !void {
    try stdout.print("{}\n", .{check(input, 1, 3)});
}

fn part2(input: std.ArrayList([]u8)) !void {
    const slope11 = try std.math.big.int.Managed.initSet(allocator, try check(input, 1, 1));
    const slope13 = try std.math.big.int.Managed.initSet(allocator, try check(input, 1, 3));
    const slope15 = try std.math.big.int.Managed.initSet(allocator, try check(input, 1, 5));
    const slope17 = try std.math.big.int.Managed.initSet(allocator, try check(input, 1, 7));
    const slope21 = try std.math.big.int.Managed.initSet(allocator, try check(input, 2, 1));
    var result = try std.math.big.int.Managed.init(allocator);
    try result.mul(slope11.toConst(), slope13.toConst());
    try result.mul(result.toConst(), slope15.toConst());
    try result.mul(result.toConst(), slope17.toConst());
    try result.mul(result.toConst(), slope21.toConst());
    try stdout.print("{}\n", .{result});
}

pub fn main() !void {
    const input = try readInput();
    try part1(input);
    try part2(input);
}
