const std = @import("std");
const stdin = std.io.getStdIn().reader();
const stdout = std.io.getStdOut().writer();
const allocator = std.heap.c_allocator;

const Data = struct { lo: u32, hi: u32, letter: u8, password: []u8 };

fn readInput() !std.ArrayList(Data) {
    var list = std.ArrayList(Data).init(allocator);
    while (true) {
        if (stdin.readUntilDelimiterAlloc(allocator, '\n', 1024)) |line| {
            var iterator = std.mem.split(line, " ");
            const rangeSlice = iterator.next().?;
            var rangeIterator = std.mem.split(rangeSlice, "-");
            const loSlice = rangeIterator.next().?;
            const hiSlice = rangeIterator.next().?;
            const letter = iterator.next().?[0];
            const passwordSlice = iterator.next().?;

            const password = try allocator.alloc(u8, passwordSlice.len);
            std.mem.copy(u8, password, passwordSlice);
            const lo = try std.fmt.parseUnsigned(u32, loSlice, 10);
            const hi = try std.fmt.parseUnsigned(u32, hiSlice, 10);

            try list.append(Data{ .lo = lo, .hi = hi, .letter = letter, .password = password });

            allocator.free(line);
        } else |err| switch (err) {
            error.EndOfStream => return list,
            else => return err,
        }
    }
}

fn part1(input: std.ArrayList(Data)) !void {
    var valid: i32 = 0;
    for (input.items) |data| {
        var numLetter: i32 = 0;
        for (data.password) |c| {
            if (c == data.letter) {
                numLetter += 1;
            }
        }
        if (numLetter >= data.lo and numLetter <= data.hi) {
            valid += 1;
        }
    }
    try stdout.print("{}\n", .{valid});
}

fn part2(input: std.ArrayList(Data)) !void {
    var valid: i32 = 0;
    for (input.items) |data| {
        if ((data.password[data.lo - 1] == data.letter) != (data.password[data.hi - 1] == data.letter)) {
            valid += 1;
        }
    }
    try stdout.print("{}\n", .{valid});
}

pub fn main() !void {
    const input = try readInput();
    try part1(input);
    try part2(input);
}
