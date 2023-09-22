class ContactManagementSystem
  def initialize(file_name)
    @file_name = file_name
    @contacts = load_contacts
  end

  def load_contacts
    contacts = []
    begin
      File.open(@file_name, "r") do |file|
        file.each_line do |line|
          name, mobile = line.chomp.split(',')
          contacts << { name: name, mobile: mobile }
        end
      end
    rescue Errno::ENOENT
      puts "No contacts found. Starting with an empty list."
    end
    contacts
  end

  def save_contacts
    File.open(@file_name, "w") do |file|
      @contacts.each do |contact|
        file.puts "#{contact[:name]},#{contact[:mobile]}"
      end
    end
  end

  def add_contact(name, mobile)
    @contacts << { name: name, mobile: mobile }
    puts "Contact '#{name}' added successfully."
  end

  def view_contacts
    if @contacts.empty?
      puts "No contacts to display."
    else
      puts "Contacts:"
      @contacts.each_with_index do |contact, index|
        puts "#{index + 1}. Name: #{contact[:name]}, Mobile: #{contact[:mobile]}"
      end
    end
  end

  def edit_contact(name, new_name, new_mobile)
    contact = @contacts.find { |c| c[:name] == name }
    if contact
      contact[:name] = new_name
      contact[:mobile] = new_mobile
      puts "Contact '#{name}' edited successfully."
    else
      puts "Contact '#{name}' not found."
    end
  end

  def delete_contact(name)
    contact = @contacts.find { |c| c[:name] == name }
    if contact
      @contacts.delete(contact)
      puts "Contact '#{name}' deleted successfully."
    else
      puts "Contact '#{name}' not found."
    end
  end

  def search_contact(name)
    matching_contacts = @contacts.select { |c| c[:name] == name }
    if matching_contacts.empty?
      puts "No contacts found with the name '#{name}'."
    else
      puts "Matching Contacts:"
      matching_contacts.each do |contact|
        puts "Name: #{contact[:name]}, Mobile: #{contact[:mobile]}"
      end
    end
  end
end

# Main program
cms = ContactManagementSystem.new("contacts.txt")

loop do
  puts "\nContact Management System Menu:"
  puts "1. Add Contact"
  puts "2. View Contacts"
  puts "3. Edit Contact"
  puts "4. Delete Contact"
  puts "5. Search Contact"
  puts "6. Exit"

  print "Enter your choice: "
  choice = gets.chomp.to_i

  case choice
  when 1
    print "Enter name: "
    name = gets.chomp
    print "Enter mobile number: "
    mobile = gets.chomp
    cms.add_contact(name, mobile)
    cms.save_contacts
  when 2
    cms.view_contacts
  when 3
    print "Enter the name of the contact to edit: "
    name = gets.chomp
    print "Enter the new name: "
    new_name = gets.chomp
    print "Enter the new mobile number: "
    new_mobile = gets.chomp
    cms.edit_contact(name, new_name, new_mobile)
    cms.save_contacts
  when 4
    print "Enter the name of the contact to delete: "
    name = gets.chomp
    cms.delete_contact(name)
    cms.save_contacts
  when 5
    print "Enter the name to search for: "
    name = gets.chomp
    cms.search_contact(name)
  when 6
    puts "Exiting the program."
    break
  else
    puts "Invalid choice. Please enter a valid option."
  end
end
