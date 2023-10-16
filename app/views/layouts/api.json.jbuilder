json.success @success
json.message @message
json.data JSON.parse(yield) if @success
