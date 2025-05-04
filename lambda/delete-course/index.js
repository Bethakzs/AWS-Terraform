const AWS = require("aws-sdk");

const dynamodb = new AWS.DynamoDB({
   region: process.env.DYNAMODB_REGION,
   apiVersion: "2012-08-10",
});

exports.handler = (event, context, callback) => {
   const id = event.queryStringParameters && event.queryStringParameters.id;
   
   if (!id) {
      return callback(null, {
         statusCode: 400,
         headers: {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*"
         },
         body: JSON.stringify({ error: "Missing course ID. Please provide it as a query parameter: /delete-course?id=123" })
      });
   }
   
   const params = {
      Key: {
         id: {
            S: id,
         },
      },
      TableName: "courses",
   };

   dynamodb.deleteItem(params, (err, data) => {
      if (err) {
         console.log(err);
         callback(null, {
            statusCode: 500,
            headers: {
               "Content-Type": "application/json",
               "Access-Control-Allow-Origin": "*"
            },
            body: JSON.stringify({ error: err.message })
         });
      } else {
         callback(null, {
            statusCode: 204,
            headers: {
               "Content-Type": "application/json",
               "Access-Control-Allow-Origin": "*"
            },
            body: JSON.stringify({})
         });
      }
   });
};