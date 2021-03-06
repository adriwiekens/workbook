# -*- encoding : utf-8 -*-
require 'spreadsheet'

module Workbook
  module Writers
    module HtmlWriter

      # Generates an Spreadsheet (from the spreadsheet gem) in order to build an XlS
      #
      # @param [Hash] options A hash with options
      # @return [Spreadsheet] A Spreadsheet object, ready for writing or more lower level operations
      def to_html options={}
        options = {:style_with_inline_css=>false}.merge(options)
        builder = Nokogiri::HTML::Builder.new do |doc|
          doc.html {
            doc.body {
              self.each{|sheet|
                doc.h1 {
                  doc.text sheet.name
                }
                sheet.each{|table|
                  doc.h2 {
                    doc.text table.name
                  }
                  doc.table {
                    table.each{|row|
                      doc.tr {
                        row.each {|cell|
                          classnames = cell.format.all_names.join(" ").strip
                          td_options = classnames != "" ? {:class=>classnames} : {}
                          td_options = td_options.merge({:style=>cell.format.to_css}) if options[:style_with_inline_css] and cell.format.to_css != ""
                          td_options = td_options.merge({:colspan=>cell.colspan}) if cell.colspan
                          td_options = td_options.merge({:rowspan=>cell.rowspan}) if cell.rowspan
                          unless cell.value.class == Workbook::NilValue
                            doc.td(td_options) {
                              doc.text cell.value
                            }
                          end
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        end
        return builder.to_html
      end



      # Write the current workbook to Microsoft Excel format (using the spreadsheet gem)
      #
      # @param [String] filename
      # @param [Hash] options   see #to_xls
      def write_to_html filename="#{title}.html", options={}
        File.open(filename, 'w') {|f| f.write(to_html(options)) }
        return filename
      end
    end
  end
end
