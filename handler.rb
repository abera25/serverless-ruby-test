require 'json'
require 'aws-sdk-dynamodb'

def hello(event:, context:)
	{
		statusCode: 200,
		body: {
			message: 'Go Serverless! Your function executed successfully!',
			input: event
		}.to_json
	}
end

def createUser(event:, context:)
	dynamodb = Aws::DynamoDB::Client.new
	body = JSON.parse(event["body"])

	dynamodb.put_item({
		table_name: 'users',
		item: {
			'id' => body["id"],
			'name' => body["name"],
			'email' => body["email"]
		}
	})

	{
		statusCode: 200,
		body: JSON.generate({ message: 'User created successfully' })
	}
end

def getUser(event:, context:)
	dynamodb = Aws::DynamoDB::Client.new
	id = event["pathParameters"]["id"]

	result = dynamodb.get_item({
		table_name: 'users',
		key: { 'id' => id }
	})

	if result.item
		{
			statusCode: 200,
			body: JSON.generate(result.item)
		}
	else
		{
			statusCode: 404,
			body: JSON.generate({ message: 'User not found' })
		}
	end
end
