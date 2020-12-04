const std = @import("std");
const stdin = std.io.getStdIn().reader();
const stdout = std.io.getStdOut().writer();

const ArrayList = std.ArrayList;
const HashMap = std.StringHashMap([]const u8);

const REQUIRED_FIELDS = [_][]const u8{ "byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid" };
const VALID_EYE_COLORS = [_][]const u8{ "amb", "blu", "brn", "gry", "grn", "hzl", "oth" };

fn readInput(allocator: *std.mem.Allocator) !ArrayList(HashMap) {
    var list = ArrayList(HashMap).init(allocator);
    const input = try stdin.readAllAlloc(allocator, 16777216);
    var lineIterator = std.mem.split(input, "\n");
    var curList = HashMap.init(allocator);
    while (lineIterator.next()) |line| {
        if (line.len == 0) {
            try list.append(curList);
            curList = HashMap.init(allocator);
            continue;
        }
        var entryIterator = std.mem.split(line, " ");
        while (entryIterator.next()) |item| {
            var kvIterator = std.mem.split(item, ":");
            const k = kvIterator.next().?;
            const v = kvIterator.next().?;
            try curList.putNoClobber(k, v);
        }
    }
    return list;
}

fn part1(input: ArrayList(HashMap)) !void {
    var valid: i32 = 0;
    outer: for (input.items) |passport| {
        for (REQUIRED_FIELDS) |field| {
            if (!passport.contains(field)) {
                continue :outer;
            }
        }
        valid += 1;
    }
    try stdout.print("{}\n", .{valid});
}

fn part2(input: ArrayList(HashMap)) !void {
    var valid: i32 = 0;
    outer: for (input.items) |passport| {
        for (REQUIRED_FIELDS) |field| {
            if (!passport.contains(field)) {
                continue :outer;
            }
        }
        if (!(try valid_passport(passport))) {
            continue;
        }
        valid += 1;
    }
    try stdout.print("{}\n", .{valid});
}

fn valid_passport(passport: HashMap) !bool {
    const birthYearString = passport.get("byr").?;
    if (birthYearString.len != 4) {
        return false;
    }
    const birthYear = try std.fmt.parseUnsigned(u32, birthYearString, 10);
    if (!(birthYear >= 1920 and birthYear <= 2002)) {
        return false;
    }

    const issueYearString = passport.get("iyr").?;
    if (issueYearString.len != 4) {
        return false;
    }
    const issueYear = try std.fmt.parseUnsigned(u32, issueYearString, 10);
    if (!(issueYear >= 2010 and issueYear <= 2020)) {
        return false;
    }

    const expirationYearString = passport.get("eyr").?;
    if (expirationYearString.len != 4) {
        return false;
    }
    const expirationYear = try std.fmt.parseUnsigned(u32, expirationYearString, 10);
    if (!(expirationYear >= 2020 and expirationYear <= 2030)) {
        return false;
    }

    const heightString = passport.get("hgt").?;
    const unit = heightString[heightString.len - 2 ..];
    const height = try std.fmt.parseUnsigned(u32, heightString[0 .. heightString.len - 2], 10);
    if (std.mem.eql(u8, unit, "cm")) {
        if (!(height >= 150 and height <= 193)) {
            return false;
        }
    } else if (std.mem.eql(u8, unit, "in")) {
        if (!(height >= 59 and height <= 76)) {
            return false;
        }
    } else {
        return false;
    }

    const hairColorString = passport.get("hcl").?;
    if (hairColorString.len != 7) {
        return false;
    }
    if (hairColorString[0] != '#') {
        return false;
    }
    for (hairColorString[1..6]) |c| {
        if (!((c >= '0' and c <= '9') or (c >= 'a' and c <= 'f'))) {
            return false;
        }
    }

    const eyeColorString = passport.get("ecl").?;
    if (!validEyeColor(eyeColorString)) {
        return false;
    }

    const passportId = passport.get("pid").?;
    if (passportId.len != 9) {
        return false;
    }
    _ = std.fmt.parseUnsigned(u32, passportId, 10) catch |_| return false;

    return true;
}

fn validEyeColor(eyeColorString: []const u8) bool {
    for (VALID_EYE_COLORS) |color| {
        if (std.mem.eql(u8, color, eyeColorString)) {
            return true;
        }
    }
    return false;
}

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = &arena.allocator;

    const input = try readInput(allocator);
    try part1(input);
    try part2(input);
}
