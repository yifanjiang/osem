prawn_document(:force_download=>true, :filename => @pdf_filename) do |pdf|
  table_array = []
  header_array = ["No",
                  "Last Name",
                  "First Name",
                  "Public Name",
                  "Email"
                  "Registered on"
                 ]
  table_array << header_array
  counter = 0
  @event_registrations_pdf.each do |registration|
  counter += 1
    row = []
    row << counter
    row << registration.last_name
    row << registration.first_name
    row << registration.public_name
    row << registration.email
    row << 
    table_array << row
  end

  pdf.text "#{@conference.title} - Registrations for #{@event.title}", :font_size => 25, :style => :bold
  pdf.text " "
  pdf.table table_array, :header => true, :cell_style => {:size => 5, :border_width => 1}
end
