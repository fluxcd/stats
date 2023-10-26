#!/usr/bin/env ruby

require 'ap'
require 'pry'

require 'active_support/all'

# commits_so_far = %w{03d50caa 18b2d4d6 b71353a4 62624387 128d3da5 e267f767 0773e5cf cb3feaa3 1bfa4c4e dd14c72e 1999ff43 aa3b4887 56625329 458602ad 036a5aff 8b877e28 1d51457c 3be3dc1b dbab09f2 373007bf d3c74fc6 f9b1515c 32310e84 5afe9a0a bc0c9a1f 30af67db b5b73107 79d4dce9 9a7205c9 dc38f527 0c4cd32b ec00ee72 76f446e2 73bd5f3c 23d2fcb0 2faf6f45 fe008045 3f112981 c7ac014a 97e183ce 0d062e6e f1cef3ee 92ff87e4}

commits_so_far = `git log main..netlify-stats --oneline --reverse |awk '{print $1}'|grep -v 17353663`.split("\n")

def fetch_from_commit(commit_hash)
  `git co #{commit_hash}`
  pages = File.open('pages.csv')
  ret = {}
  pages.lines.each do |line|
    v = line.chomp.split(',')
    ret[v.first] = v.last.to_i
  end

  ret
end

stats = commits_so_far.map do |c|
  f = fetch_from_commit(c)
  # binding.pry
  f
end

all_stats = {}
days_counted = 0

stats.each do |stat|
  stat.keys.each do |key|
    if all_stats[key].nil?
      all_stats[key] = 0
    end

    all_stats[key] += stat[key]
  end

  days_counted += 1
end

puts; puts

o_hash = ActiveSupport::OrderedHash.new

ordered_stats = all_stats.sort_by(&:last).reverse
ordered_stats.map do |n|
  o_hash[n[0]] = n[1]
  # puts "#{n[0]}: #{n[1]}"
end
  
ap o_hash
puts; puts '---'
puts "days_counted: #{days_counted}"
