#!/usr/bin/env ruby

require "nokogiri"
require "open3"

# TODO solve inflection
word = ARGV[0]
input_file = ENV["PATH_TO_XML"]
output_file = ENV["OUTPUT_FILE"]
xml, _ = Open3.capture2("rg 'd:title=\"#{word}\"' #{input_file} --max-count=1 --no-line-number")
doc = Nokogiri::XML.fragment(xml)

CASES = {
  "N" => "Nominative",
  "G" => "Genitive",
  "D" => "Dative",
  "A" => "Accusative",
  "I" => "Instrumental",
  "V" => "Vocative",
  "L" => "Locative",
}

GENDERS = {
  "m" => "masculine",
  "f" => "feminine",
  "n" => "neuter",
  "ž" => "feminine",
  "sr" => "neuter",
}

def inflection(node)
  raw = node.text.strip
  if (c = CASES[raw])
    c + " "
  else
    raw
  end
end

heading = doc.css(".hg.x_xh0").first
inflections_line = doc.css(".posg.x_xdh").first
gender = inflections_line.css(".pos").first.text
inflections = inflections_line.css(".infg").first
  .then do |container|
    container.css("> :not(.pr)").map { |x| inflection(x) }.join("").gsub(",", ", ") if container
  end

definitions = doc.css(".se2.x_xd1.hasSn").map { |x| x.text.strip }.join("\n  ")
definitions2 = doc.css(".msDict.x_xd1.t_core").map do |wrapper|
  wrapper.css(".gp.tg_eg").remove
  definition = wrapper.css(".df.t_standard").first&.text.strip
  synonim = wrapper.css(".xrg").map { |x| x.text.strip }.join(", ")
  examples = wrapper.css(".eg").map { |x| "*#{x.text.strip}*" }.join(" | ")

  definition + " " + synonim + " " + examples
end.join("\n  ")

# TODO: exclude .pr
# TODO: explanations in italic
phrases_wrapper = doc.css(".subEntryBlock.t_phrases")
phrases = phrases_wrapper.css(".subEntry").map { |x| x.text.strip }.join("\n  ")

result = "
- ### {{cloze #{heading.text}}}
  {{cloze #{GENDERS[gender] || gender}#{inflections}}}

  Definitions

  #{definitions}#{definitions2}

  #{phrases.empty? ? "" : "Phrases\n\n  " + phrases}
  #card
"

open(output_file, "a") { |f| f.puts(result) }
