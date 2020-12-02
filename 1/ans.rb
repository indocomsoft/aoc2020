#!/usr/bin/env ruby

input=STDIN.read.split.map(&:to_i)
puts input.combination(2).find{|x|x.sum==2020}.inject(:*)
puts input.combination(3).find{|x|x.sum==2020}.inject(:*)
