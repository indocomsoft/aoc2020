const std = @import("std");
const stdin = std.io.getStdIn().reader();
const stdout = std.io.getStdOut().writer();
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;

const InsnType = enum {
    jmp,
    nop,
    acc,
};
const Insn = struct { insnType: InsnType, arg: i64 };

const MAX_INPUT_SIZE = 1024;

fn readInput(allocator: *Allocator) !ArrayList(Insn) {
    var buf: [MAX_INPUT_SIZE]u8 = undefined;

    var list = ArrayList(Insn).init(allocator);
    while (true) {
        const line = (try stdin.readUntilDelimiterOrEof(&buf, '\n')) orelse return list;
        var iterator = std.mem.split(line, " ");
        var insnTypeString = iterator.next().?;
        var argString = iterator.next().?;

        const insnType = std.meta.stringToEnum(InsnType, insnTypeString).?;
        const arg = try std.fmt.parseInt(i64, argString, 10);

        try list.append(.{ .insnType = insnType, .arg = arg });
    }
}

fn part1(input: anytype) !i64 {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = &arena.allocator;

    var visited = std.AutoHashMap(i64, void).init(allocator);
    var acc: i64 = 0;
    var pc: i64 = 0;
    while (true) {
        if (visited.contains(pc)) {
            return acc;
        }
        try visited.putNoClobber(pc, {});
        const insn = input.items[@intCast(usize, pc)];
        switch (insn.insnType) {
            InsnType.jmp => {
                pc += insn.arg;
            },
            InsnType.nop => {
                pc += 1;
            },
            InsnType.acc => {
                pc += 1;
                acc += insn.arg;
            },
        }
    }
}

fn terminates(input: anytype) !?i64 {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = &arena.allocator;

    var visited = std.AutoHashMap(i64, void).init(allocator);
    var acc: i64 = 0;
    var pc: i64 = 0;
    while (true) {
        if (visited.contains(pc)) {
            return null;
        }
        if (pc >= input.items.len) {
            return acc;
        }
        try visited.putNoClobber(pc, {});
        const insn = input.items[@intCast(usize, pc)];
        switch (insn.insnType) {
            InsnType.jmp => {
                pc += insn.arg;
            },
            InsnType.nop => {
                pc += 1;
            },
            InsnType.acc => {
                pc += 1;
                acc += insn.arg;
            },
        }
    }
}

fn part2(input: anytype) !?i64 {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = &arena.allocator;

    for (input.items) |*insn, i| {
        const originalInsnType = insn.insnType;
        const newInsnType = switch (insn.insnType) {
            InsnType.acc => continue,
            InsnType.nop => InsnType.jmp,
            InsnType.jmp => InsnType.nop,
        };
        const newInsn = Insn{ .insnType = newInsnType, .arg = insn.arg };
        insn.* = newInsn;
        if (try terminates(input)) |acc| {
            return acc;
        }
        insn.* = Insn{ .insnType = originalInsnType, .arg = insn.arg };
    }
    return null;
}

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = &arena.allocator;

    const input = try readInput(allocator);
    const ans1 = try part1(input);
    try stdout.print("{}\n", .{ans1});
    const ans2 = (try part2(input)).?;
    try stdout.print("{}\n", .{ans2});
}
