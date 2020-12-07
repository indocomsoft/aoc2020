const std = @import("std");
const stdin = std.io.getStdIn().reader();
const stdout = std.io.getStdOut().writer();
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const ChildAdjList = std.StringHashMap(u8);
const AdjList = std.StringHashMap(ChildAdjList);

const MAX_INPUT_SIZE = 1024;

fn readInput(allocator: *Allocator) !AdjList {
    var list = AdjList.init(allocator);
    while (true) {
        if (stdin.readUntilDelimiterAlloc(allocator, '\n', MAX_INPUT_SIZE)) |line| {
            // Remove dot
            var iterator = std.mem.split(line[0 .. line.len - 1], " bags contain ");
            const color = iterator.next().?;
            const children = iterator.next().?;
            var childAdjList = ChildAdjList.init(allocator);
            if (!std.mem.eql(u8, children, "no other bags")) {
                var childIterator = std.mem.split(children, ", ");
                while (childIterator.next()) |child| {
                    const numString = std.mem.split(child, " ").next().?;
                    const childColor = std.mem.split(child[numString.len + 1 .. child.len], " bag").next().?;
                    const num = try std.fmt.parseUnsigned(u8, numString, 10);
                    try childAdjList.putNoClobber(childColor, num);
                }
            }
            try list.putNoClobber(color, childAdjList);
        } else |err| switch (err) {
            error.EndOfStream => return list,
            else => return err,
        }
    }
}

fn contains_shiny_gold(color: []const u8, input: anytype) bool {
    const childAdjList = input.get(color).?;
    if (childAdjList.contains("shiny gold")) {
        return true;
    }
    var childIterator = childAdjList.iterator();
    while (childIterator.next()) |child| {
        if (contains_shiny_gold(child.key, input)) {
            return true;
        }
    }
    return false;
}

fn part1(input: anytype) !void {
    var num: u16 = 0;
    var iterator = input.iterator();
    while (iterator.next()) |item| {
        if (contains_shiny_gold(item.key, input)) {
            num += 1;
        }
    }
    try stdout.print("{}\n", .{num});
}

fn total_num_content(color: []const u8, num: u8, input: anytype) u32 {
    var total: u32 = 0;
    const childAdjList = input.get(color).?;
    var iterator = childAdjList.iterator();
    while (iterator.next()) |child| {
        total += total_num_content(child.key, child.value, input);
    }
    return total * num + num;
}

fn part2(input: anytype) !void {
    const ans = total_num_content("shiny gold", 1, input) - 1;
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
