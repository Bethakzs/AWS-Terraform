const AWS = require("aws-sdk");

const dynamodb = new AWS.DynamoDB({
   region: process.env.DYNAMODB_REGION,
   apiVersion: "2012-08-10",
});

exports.handler = (event, context, callback) => {
   const params = {
      Key: {
         id: {
            S: event.id,
         },
      },
      TableName: "courses",
   };

   dynamodb.deleteItem(params, (err, data) => {
      if (err) {
         console.log(err);
         callback(err);
      } else {
         callback(null, data);
      }
   });
};
