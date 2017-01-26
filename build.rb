require 'csv'

cards = CSV.read('cards.csv')

corp_spec = [
  '^Agenda',
  '^ICE',
  '^ICE',
  '^ICE',
  '^(Asset)|(Upgrade)',
  '^Operation',
  '^(Agenda|Asset|ICE|Operation|Upgrade)',
  '^(Agenda|Asset|ICE|Operation|Upgrade)',
  '^(Agenda|Asset|ICE|Operation|Upgrade)',
  '^(Agenda|Asset|ICE|Operation|Upgrade)'
]
runner_spec = [
  'Icebreaker',
  '^Event',
  '^Program(?!: Icebreaker)',
  '^Hardware',
  '^Resource',
  '^(Event|Hardware|Program|Resource)',
  '^(Event|Hardware|Program|Resource)',
  '^(Event|Hardware|Program|Resource)',
  '^(Event|Hardware|Program|Resource)',
  '^(Event|Hardware|Program|Resource)'
]

def choose_pack(cards, spec)
  remaining = cards.dup
  pack = []
  spec.each do |card_spec|
    # print "#{card_spec} --> "
    possible = remaining.select { |card| card[2].match("#{card_spec}") }
    card = possible[(possible.size*rand()).to_i]
    remaining.delete(card)
    pack << card

    # puts "#{card[2]} #{card[4]}" #" -- #{card.inspect}"
  end
  pack.sort_by { |card| card[2] }
end

# puts choose_pack(cards, corp_spec).inspect
# puts choose_pack(cards, runner_spec).inspect

# puts choose_pack(cards, corp_spec).inspect
# choose_pack(cards, runner_spec)

def render_draft_pack(cards, spec, filename)
  File.open(filename, "w") do |f|
    f.puts "<html>"
    f.puts "<head>"
    f.puts "<style>"
    f.puts "@page { size: letter; margin-left: 5pt; margin-right: 5pt; }"
    f.puts ".page-break { display: block; page-break-before: always; float: clear;}"
    f.puts "img { width: 100pt; }"
    f.puts ".card { display:inline-block; height: 280px; width: 180px;}"
    f.puts "</style>"
    f.puts "</head>"
    f.puts "<body>"

    4.times do |i|
      render_page(cards, spec, f)
      f.puts "<hr class='page-break'>" unless i == 3
    end
  end
end

def render_page(cards, spec, f)
  choose_pack(cards, spec).each_with_index do |card, i|
    f.puts "<div class='card'>"
    f.puts "<img src='#{card[1]}'><br/>"
    f.puts "<span>#{card[4]} : #{card[3]}</span>"
    f.puts "</div>"
    f.puts "<br/>" if i % 4 == 3
  end
end

render_draft_pack(cards, corp_spec, "corp-draft1.html")
render_draft_pack(cards, corp_spec, "corp-draft2.html")
render_draft_pack(cards, runner_spec, "runner-draft1.html")
render_draft_pack(cards, runner_spec, "runner-draft2.html")
