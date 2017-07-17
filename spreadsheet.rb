require 'rubygems'
require 'nokogiri'
require 'open-uri'

def find_a_mail_in_string(string)
	mail = string.scan(/.*\@.*/)
	if mail != []
		mail = mail[0].lstrip
		return mail
	else
		return ""
	end

	
end

def get_the_email_of_a_townhal_from_its_webpage(url1) 

	page = Nokogiri::HTML(open(url1))
	
	xpath_content = '/html/body//table//td'
	content = page.xpath(xpath_content)
	
	return find_a_mail_in_string(content.text)

end

def get_all_the_urls_of_val_doise_townhalls 
	
	towns_hash ={}

	page = Nokogiri::HTML(open('http://annuaire-des-mairies.com/val-d-oise.html'))
	xpath1 = '///tr//p/a'
	towns = page.xpath(xpath1)

	towns.each do |town|
		town_name = town.text
		town_url = town["href"].byteslice(1,town["href"].length)
		towns_hash[:"#{town_name}"] = "http://annuaire-des-mairies.com#{town_url}"
	end

	return towns_hash
end


def get_emails_from_val_doise
	emails_hash = {}
	get_all_the_urls_of_val_doise_townhalls().each do |town_hash|
		email = get_the_email_of_a_townhal_from_its_webpage(town_hash[1])
		emails_hash[:"#{town_hash[0]}"]="#{email}"
	end
	return emails_hash		
end

