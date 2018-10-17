require 'nokogiri'
require 'json'
require 'open-uri'


class Scrapper
  attr_reader :email_array

  def initialize(department_url)
    @department_url = department_url
    @townhall_urls_hash = Hash.new
    self.get_all_the_urls_of_val_doise_townhalls
    @email_array = Hash.new
    self.get_all_the_emails_of_val_doise_townhalls
  end

  def get_the_email_of_a_townhall_from_its_webpage(townhall_url)
    page = Nokogiri::HTML(open(townhall_url))
    email = page.xpath('/html/body/div/main/section[2]/div/table/tbody/tr[4]/td[2]').text
    puts email
    return email
  end

  def get_all_the_urls_of_val_doise_townhalls
    page = Nokogiri::HTML(open(@department_url))
    a_elements = page.xpath('//a')

    a_elements.each do |a_element|
      link = a_element['href']
      if link.include?('./95/')
        link[0] = "http://annuaire-des-mairies.com"
        @townhall_urls_hash[a_element.text] = link #mon hash final récupère en clé le nom de la ville (a_element.text) et en valeur l'url (link)
      end
    end
  end

  def get_all_the_emails_of_val_doise_townhalls
    @townhall_urls_hash.each do |townhall_name, townhall_url|
      @email_array[townhall_name] = get_the_email_of_a_townhall_from_its_webpage(townhall_url)
    end
  end

  def perform
    puts @email_array
    File.open("./db/emails.json","w") do |f|
      f.write(@email_array.to_json)
    end
  end
end