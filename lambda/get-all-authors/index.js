const AWS = require("aws-sdk");

const dynamodb = new AWS.DynamoDB({
   region: process.env.DYNAMODB_REGION,
   apiVersion: "2012-08-10",
});

exports.handler = (event, context, callback) => {
   const params = {
      TableName: "authors",
   };

   dynamodb.scan(params, (err, data) => {
      if (err) {
         console.log(err);
         callback(err);
      } else {
         const authors = data.Items.map((item) => ({
            id: item.id.S,
            firstName: item.firstName.S,
            lastName: item.lastName.S,
         }));
         callback(null, authors);
      }
   });
};
