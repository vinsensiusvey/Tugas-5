class Article < ActiveRecord::Base
    has_many :comments, dependent: :restrict_with_error

    def self.import(file)
        spreadsheet = open_spreadsheet(file)
        header = spreadsheet.row(1)
        (2..spreadsheet.last_row).each do |i|
            row = Hash[[header, spreadsheet.row(i)].transpose]
            article = find_by_id(row["id"]) || new
            article.attributes = row.to_hash
            article.save!
        end
    end

    def self.open_spreadsheet(file)
        print file
        case File.extname(file.original_filename)
        when ".csv" then Roo::Csv.new(file.path, nil, :ignore)
        when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
        when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore)
        else raise "Unknown file type: #{file.original_filename}"
        end
    end
end
