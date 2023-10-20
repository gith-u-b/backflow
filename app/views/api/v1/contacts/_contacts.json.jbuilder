json.contracts contacts do |contact| 
	json.id contact.id
  json.name contact.name
	json.phone contact.phone
	json.locations contact.locations
	json.address contact.address
	json.is_default contact.is_default
end
