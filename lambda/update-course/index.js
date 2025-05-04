const AWS = require("aws-sdk");

const dynamodb = new AWS.DynamoDB({
   region: process.env.DYNAMODB_REGION,
   apiVersion: "2012-08-10",
});

exports.handler = (event, context, callback) => {
   try {
      const courseData = typeof event.body === 'string' ? JSON.parse(event.body) : event.body;
      
      const queryId = event.queryStringParameters && event.queryStringParameters.id;
      
      if (!queryId) {
         return callback(null, {
            statusCode: 400,
            headers: {
               "Content-Type": "application/json",
               "Access-Control-Allow-Origin": "*"
            },
            body: JSON.stringify({ error: "Missing course ID. Please provide it as a query parameter: /update-course?id=123" })
         });
      }

      if (!courseData || !courseData.title || !courseData.authorId || 
          !courseData.length || !courseData.category) {
         return callback(null, {
            statusCode: 400,
            headers: {
               "Content-Type": "application/json",
               "Access-Control-Allow-Origin": "*"
            },
            body: JSON.stringify({ error: "Missing required course fields: title, authorId, length, category" })
         });
      }
      
      const params = {
         Item: {
            id: {
               S: queryId,
            },
            title: {
               S: courseData.title,
            },
            watchHref: {
               S: courseData.watchHref || `http://www.pluralsight.com/courses/${queryId}`,
            },
            authorId: {
               S: courseData.authorId,
            },
            length: {
               S: courseData.length,
            },
            category: {
               S: courseData.category,
            },
         },
         TableName: "courses",
      };
      
      dynamodb.putItem(params, (err, data) => {
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
            const updatedCourse = {
               id: params.Item.id.S,
               title: params.Item.title.S,
               watchHref: params.Item.watchHref.S,
               authorId: params.Item.authorId.S,
               length: params.Item.length.S,
               category: params.Item.category.S,
            };
            
            callback(null, {
               statusCode: 200,
               headers: {
                  "Content-Type": "application/json",
                  "Access-Control-Allow-Origin": "*"
               },
               body: JSON.stringify(updatedCourse)
            });
         }
      });
   } catch (error) {
      console.log(error);
      callback(null, {
         statusCode: 400,
         headers: {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*"
         },
         body: JSON.stringify({ error: "Invalid request body" })
      });
   }
};