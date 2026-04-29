require "json"
require "fileutils"

BENCHMARK_FILE_SIZE = 5 * 1024 * 1024 * 1024
BENCHMARK_FILE_PATH = File.expand_path("./tmp/benchmark/data.log")

namespace :benchmark do
  task :init do
    # Synchronize stdout because the output order is not as intended on Windows environment
    STDOUT.sync = true
  end

  task :prepare_1GB do
    FileUtils.mkdir_p(File.dirname(BENCHMARK_FILE_PATH))
    File.open(BENCHMARK_FILE_PATH, "w") do |f|
      dummy = <<~END
      10.0.1.49\t153.217.45.32\tNXID=96BF0F0067A053DD6FA643FF8C0D2102\t-\tGET /data7/68205925.gif709264834760.gif?vr_tagid1=1028&vr_tagid2=0001&vr_opt1=movie&vr_opt6=1019&endpoint=https%3A%2F%2Flog7.interactive-circle.jp%2Fdata7%2F68205925.gif&vr_opt2=27843_2102190_1000141701&vr_opt4=3575&vr_opt11=27843_2102190_1000141701&vr_opt19=d89d9b6f606fdbd85a82ed2d5fe7ab2a08d8672ec8a34500f4d198f3caf39132&vr_opt21=0&vr_opt22=0&url=https%3A//tver.jp/episodes/epmeq9mxxw&ref=https%3A%2F%2Fsearch.yahoo.co.jp%2F&vr_opt3=2700&vr_opt7=loop&vr_opt9=865317855741&vr_opt10=48&vr_opt18=1 HTTP/1.1\thttps://tver.jp/\tMozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36\tNXID=AA+/lt1ToGf/Q6ZvAiENjA==; NXID_flg=1\t0.000\t200
      END
      time = Time.parse("2000-01-01 00:00:00 +0900")
      data = time.strftime("%d/%b/%Y:%H:%M:%S") + " +0900\t" + dummy

      loop do
        f.puts data
        break if f.size > BENCHMARK_FILE_SIZE
      end
    end
  end

  task :show_info do
    # Output the information with markdown format
    puts "### Environment"
    puts "```"
    system "bundle exec ruby --version"
    system "bundle exec ruby bin/fluentd --version"
    puts "```\n"
  end

  desc "Run in_tail benchmark"
  task :"run:in_tail" => [:init, :show_info] do
    # Output the results with markdown format
    puts "### in_tail with 5 GB file"
    puts "```"
    system "bundle exec ruby bin/fluentd -r ./tasks/benchmark/patch_in_tail.rb --no-supervisor -c ./tasks/benchmark/conf/in_tail.conf -o ./tmp/benchmark/fluent.log"
    puts "```"

    # Rake::Task["benchmark:clean"].invoke
  end

  task :clean do
    FileUtils.rm_rf(File.dirname(BENCHMARK_FILE_PATH))
  end
end
