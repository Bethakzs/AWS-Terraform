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
         body: JSON.stringify({ error: "Missing course ID. Please provide it as a query parameter: /get-course?id=123" })
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

   dynamodb.getItem(params, (err, data) => {
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
         if (!data.Item) {
            return callback(null, {
               statusCode: 404,
               headers: {
                  "Content-Type": "application/json",
                  "Access-Control-Allow-Origin": "*"
               },
               body: JSON.stringify({ error: "Course not found" })
            });
         }
         
         const course = {
            id: data.Item.id.S,
            title: data.Item.title.S,
            watchHref: data.Item.watchHref.S,
            authorId: data.Item.authorId.S,
            length: data.Item.length.S,
            category: data.Item.category.S,
         };
         
         callback(null, {
            statusCode: 200,
            headers: {
               "Content-Type": "application/json",
               "Access-Control-Allow-Origin": "*"
            },
            body: JSON.stringify(course)
         });
      }
   });
};