namespace :fetcher do
  def get_citizen_data(kelurahan)
    begin
      Kelurahan.transaction do
        grand_parent = kelurahan.kecamatan_id
        parent = kelurahan.id
        puts("Fetch #{kelurahan.name} #{grand_parent} > #{parent}")

        response = HTTParty.get("http://data.kpu.go.id/ss8.php?cmd=select&grandparent=#{grand_parent}&parent=#{parent}")
        doc = Nokogiri::HTML(response.body)
        tpses = doc.search('option')

        tpses.each do |tps_option|
          tps = tps_option.children.to_s

          puts("TPS #{kelurahan.name} #{grand_parent} > #{parent} > \##{tps}/#{tpses.length}")
          response = HTTParty.get("http://data.kpu.go.id/ss8.php?cmd=select&grandparent=#{grand_parent}&parent=#{parent}",
                                  cookies: {gov2portal: "cookie%5Bfilter_#{parent}_filterTPS_new%5D%3D#{tps}%26cookie%5Bsearch%5D%3D%26cookie%5Bnama%5D%3D%26cookie%5Btl%5D%3D; path=/"})
          doc = Nokogiri::HTML(response.body)
          last_table = doc.search('table').last

          rows = last_table.xpath("tr")
          citizen_rows = rows[2, rows.length - 3]

          citizen_rows.each do |citizen|
            nik = citizen.xpath("td[2]").children.to_s.strip
            name = citizen.xpath("td[3]").children.to_s.strip
            location_of_birth = citizen.xpath("td[4]").children.to_s.strip
            # puts(nik, name, location_of_birth)

            Citizen.create!(nik: nik, name: name, location_of_birth: location_of_birth, kelurahan_id: parent, tps_id: tps)
          end
        end

        kelurahan.fetched = true
        kelurahan.save!
      end
    rescue Exception => e
      puts e.message
    end
  end

  task :fetch_citizen_data => :environment do
    puts "fetch_citizen_data"
    kelurahans = Kelurahan.where(fetched: false)
    Parallel.each(kelurahans, :in_threads => 15) do |kelurahan|
      get_citizen_data(kelurahan)
    end
  end
end
