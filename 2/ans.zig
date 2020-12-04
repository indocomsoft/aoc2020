const std = @import("std");
const stdin = std.io.getStdIn().reader();
const stdout = std.io.getStdOut().writer();

const Data = struct { lo: u32, hi: u32, letter: u8, password: []u8 };

const MAX_INPUT_SIZE = 1024;

fn readInput(allocator: *std.mem.Allocator) !std.ArrayList(Data) {
    var buf: [MAX_INPUT_SIZE]u8 = undefined;

    var list = std.ArrayList(Data).init(allocator);
    while (true) {
        const line = (try stdin.readUntilDelimiterOrEof(&buf, '\n')) orelse return list;
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
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = &arena.allocator;

    const input = try readInput(allocator);
    try part1(input);
    try part2(input);
}
