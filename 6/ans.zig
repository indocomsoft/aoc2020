const std = @import("std");
const stdin = std.io.getStdIn().reader();
const stdout = std.io.getStdOut().writer();
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const HashSet = std.AutoHashMap(u8, void);

fn readInput(allocator: *Allocator) !ArrayList(ArrayList([]const u8)) {
    var list = ArrayList(ArrayList([]const u8)).init(allocator);
    const input = try stdin.readAllAlloc(allocator, 16777216);
    var lineIterator = std.mem.split(input, "\n");
    var curList = ArrayList([]const u8).init(allocator);
    while (lineIterator.next()) |line| {
        if (line.len == 0) {
            try list.append(curList);
            curList = ArrayList([]const u8).init(allocator);
            continue;
        }
        try curList.append(line);
    }
    return list;
}

fn part1(input: anytype) !void {
    var ans: u32 = 0;
    for (input.items) |group| {
        var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
        defer arena.deinit();
        const allocator = &arena.allocator;
        var set = HashSet.init(allocator);
        for (group.items) |entries| {
            for (entries) |c| {
                try set.put(c, {});
            }
        }
        ans += set.count();
    }
    try stdout.print("{}\n", .{ans});
}

fn part2(input: anytype) !void {
    var ans: u32 = 0;
    for (input.items) |group| {
        var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
        defer arena.deinit();
        const allocator = &arena.allocator;
        var set = HashSet.init(allocator);
        for (group.items[0]) |c| {
            try set.put(c, {});
        }
        for (group.items) |entries| {
            var currentSet = HashSet.init(allocator);
            for (entries) |c| {
                try currentSet.put(c, {});
            }
            var newSet = HashSet.init(allocator);
            var setIterator = set.iterator();
            while (setIterator.next()) |entry| {
                if (currentSet.contains(entry.key)) {
                    try newSet.put(entry.key, {});
                }
            }
            set = newSet;
        }
        ans += set.count();
    }
    try stdout.print("{}\n", .{ans});
}

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = &arena.allocator;

    const input = try readInput(allocator);
    try part1(input);
    try part2(input);
}
