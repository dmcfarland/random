use mongodb::{
    bson::{doc, Document},
    Client, Collection,
};
use serde_json;

#[tokio::main]
async fn main() -> mongodb::error::Result<()> {
    let uri = std::env::var("MONGO_URI").unwrap_or("".to_string());
    let db_name = std::env::var("MONGO_DB").unwrap_or("".to_string());
    let collection_name = std::env::var("MONGO_COLLECTION").unwrap_or("".to_string());

    let client = Client::with_uri_str(uri).await?;
    let database = client.database(&db_name);
    let collection: Collection<Document> = database.collection(&collection_name);
    let document = collection.find_one(doc! {}).await?;
    println!("{}", serde_json::to_string_pretty(&document).unwrap());
    Ok(())
}
