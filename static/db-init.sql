
/* Step 1: 
Connect to Babelfish for Aurora PostgreSQL database using SQL Server client as master user 
and install the pgvector extension using following SQL command:*/

exec sys.sp_execute_postgresql 'CREATE EXTENSION vector WITH SCHEMA sys';

--Alternatively, you can use PostgreSQL client to connect to Aurora PostgreSQL as master user and install the pgvector extension by connecting to babelfish_db database using following SQL command:

postgresql => \c babelfish_db
babelfish_db=> CREATE EXTENSION vector WITH SCHEMA sys;


/*Step 2:  
Enable Amazon Aurora machine learning with Babelfish for Aurora PostgreSQL using SQL Server client with following SQL command:*/
exec sys.sp_execute_postgresql 'CREATE EXTENSION aws_commons';
exec sys.sp_execute_postgresql 'CREATE EXTENSION aws_ml';

--Alternatively, you can use PostgreSQL client to connect to Aurora PostgreSQL to install aws_ml extension using following SQL command:
babelfish_db=> CREATE EXTENSION aws_ml CASCADE;

--List the extensions enabled using following command:
babelfish_db=> \dx

--Grant privileges to master_dbo schema using PostgreSQL client for Aurora PostgreSQL database using following commands:
babelfish_db=> GRANT usage ON SCHEMA aws_bedrock TO master_dbo;
babelfish_db=> GRANT ALL ON ALL FUNCTIONS IN SCHEMA aws_bedrock TO master_dbo;
babelfish_db=> GRANT usage ON SCHEMA aws_comprehend TO master_dbo;
babelfish_db=> GRANT ALL ON ALL FUNCTIONS IN SCHEMA aws_comprehend TO master_dbo;


/*Step 3: 
Create hotel schema, tables and procedures from SQL Server client on Babelfish 
for Aurora PostgreSQL for hotel inventory and hotel reviews:*/

CREATE SCHEMA hotel;

CREATE TABLE hotel.categories (category_id bigint PRIMARY KEY IDENTITY, name text);

CREATE TABLE hotel.hotels ( 
id bigint NOT NULL PRIMARY KEY IDENTITY,
hotelname text,
overview text,
vote_average double precision,
vote_count bigint,
popularity double precision,
category_id bigint,
roomtype text,
keywords text,
description text);

ALTER TABLE hotel.hotels ADD FOREIGN KEY (category_id) REFERENCES hotel.categories (category_id);

CREATE TABLE hotel.reviews (
id bigint,
username text,
rating text,
review text,
created datetime,
updated datetime);

--Insert data into above tables using SQL Server client to Babelfish for Aurora PostgreSQL:
insert into hotel.categories values (11, 'Full Service Hotels');
insert into hotel.categories values (22, 'Boutique Hotels');
insert into hotel.categories values (33, 'Budget Friendly Hotels');
insert into hotel.categories values (44, 'Luxury Hotels');
insert into hotel.categories values (55, 'Resort Hotels');
insert into hotel.categories values (66, 'Business Hotels');
insert into hotel.categories values (77, 'Extended Stay Hotels');
insert into hotel.categories values (88, 'Eco Friendly Hotels');

--Insert some sample data in hotels table
insert into hotel.hotels (id, hotelname,overview,vote_average,vote_count,popularity,category_id,roomtype,keywords,description)insert into hotel.hotels (id, hotelname,overview,vote_average,vote_count,popularity,category_id,roomtype,keywords,description) values
           (101, 'Grand Palace Hotel', 'A luxurious 5-star hotel in the heart of the city.', 4.7, 2345, 98.5, 1, 'Deluxe Suite, Standard Room', 'luxury, city center, spa', 'Experience the ultimate in comfort and elegance at our award-winning hotel. Indulge in our world-class amenities, including a rooftop pool, fine dining restaurant, and rejuvenating spa.');
insert into hotel.hotels (id, hotelname,overview,vote_average,vote_count,popularity,category_id,roomtype,keywords,description) values
           (102, 'Seaside Resort', 'A beachfront paradise with breathtaking ocean views.', 4.3, 1876, 85.2, 2, 'Ocean View Room, Family Suite', 'beach, resort, swimming pool', 'Escape to our tropical oasis and unwind in our spacious accommodations with direct access to the sandy beaches and crystal-clear waters. Enjoy a variety of water sports, relax by the pool, or indulge in our delectable seafood cuisine.');

insert into hotel.hotels (id, hotelname,overview,vote_average,vote_count,popularity,category_id,roomtype,keywords,description) values
           (103, 'Mountain Retreat', 'A cozy hideaway surrounded by stunning natural scenery.', 4.5, 987, 72.1, 3, 'Cabin, Chalet', 'nature, hiking, mountain views', 'Immerse yourself in the serene beauty of the mountains at our rustic retreat. Explore the nearby hiking trails, enjoy stargazing by the firepit, or simply relax in our cozy accommodations and take in the fresh mountain air.');

insert into hotel.hotels (id, hotelname,overview,vote_average,vote_count,popularity,category_id,roomtype,keywords,description) values
           (104, 'Historic Inn', 'A charming and historic inn with a rich cultural heritage.', 4.2, 1456, 68.9, 4, 'Classic Room, Suite', 'historic, boutique, antiques', 'Step back in time and experience the enchanting ambiance of our meticulously restored inn. Discover the rich history behind our elegant decor and antique furnishings, and enjoy our modern amenities blended with old-world charm.');

insert into hotel.hotels (id, hotelname,overview,vote_average,vote_count,popularity,category_id,roomtype,keywords,description) values
            (105, 'Urban Loft Hotel', 'A trendy and stylish hotel in the heart of the city.', 4.6, 2098, 91.3, 5, 'Loft Suite, Studio', 'modern, design, city life', 'Experience the pulse of the city at our chic urban hotel. Unwind in our contemporary loft-style accommodations with industrial-chic decor and floor-to-ceiling windows. Explore the vibrant nightlife, trendy restaurants, and cultural hotspots right outside our doors.');

insert into hotel.hotels (id, hotelname,overview,vote_average,vote_count,popularity,category_id,roomtype,keywords,description) values
           (106, 'Eco-Friendly Resort', 'A sustainable and environmentally-conscious resort.', 4.4, 1234, 79.8, 6, 'Eco-Lodge, Treehouse', 'green, eco-friendly, nature', 'Reconnect with nature and embrace a sustainable lifestyle at our eco-friendly resort. Stay in our unique accommodations built with sustainable materials, enjoy farm-to-table dining, and participate in various eco-activities and educational programs.');

insert into hotel.hotels (id, hotelname,overview,vote_average,vote_count,popularity,category_id,roomtype,keywords,description) values
            (107, 'Vineyard Estate', 'A picturesque estate surrounded by rolling vineyards.', 4.8, 876, 65.4, 7, 'Vineyard View Room, Villa', 'wine, vineyards, countryside', 'Indulge in the ultimate wine country experience at our luxurious estate. Savor award-winning wines at our on-site winery, stroll through the vineyards, and enjoy farm-fresh cuisine prepared with locally sourced ingredients.');

insert into hotel.hotels (id, hotelname,overview,vote_average,vote_count,popularity,category_id,roomtype,keywords,description) values
            (108, 'Desert Oasis', 'A tranquil retreat in the heart of the desert.', 4.6, 1567, 78.2, 8, 'Desert View Room, Casita', 'desert, spa, relaxation', 'Escape the hustle and bustle and find serenity at our desert oasis. Unwind in our secluded accommodations, indulge in rejuvenating spa treatments, and marvel at the stunning desert landscapes and starry night skies.');

insert into hotel.hotels (id, hotelname,overview,vote_average,vote_count,popularity,category_id,roomtype,keywords,description) values
            (109, 'Ski Resort', 'A winter wonderland for ski enthusiasts.', 4.7, 2098, 93.6, 9, 'Ski-In/Ski-Out Room, Chalet', 'skiing, snowboarding, winter sports', 'Experience the ultimate winter getaway at our world-class ski resort. Hit the slopes with direct access to pristine ski runs, enjoy après-ski activities, and cozy up by the fireplace in our luxurious accommodations.');

insert into hotel.hotels (id, hotelname,overview,vote_average,vote_count,popularity,category_id,roomtype,keywords,description) values
           (110, 'Tropical Island Resort', 'A slice of paradise on a pristine tropical island.', 4.9, 3456, 98.1, 10, 'Overwater Villa, Beach Bungalow', 'island, beach, snorkeling', 'Escape to our secluded island resort and experience the ultimate tropical paradise. Relax in our overwater villas, explore the vibrant coral reefs, or simply bask in the sun on our white sandy beaches.');

--Insert some sample reviews
insert into hotel.reviews (id,username,rating,review,created,updated) values (1001, 'John', 6.8, 'Very clean hotel, supportive staff. Very close to beach', '21-Feb-2024 10:00:00', '21-Feb-2024 10:00:00');

insert into hotel.reviews (id,username,rating,review,created,updated) values (1003, 'Smith', 6.8, 'Poor service and unhygenic facilities. Close to beach but unclean', '2-March-2024 09:00:00', '2-March-2024 09:00:00');

insert into hotel.reviews (id,username,rating,review,created,updated) values  (101,'SarahW','4','Our family had a wonderful stay at the Grand Palace Hotel. The location in the city center was perfect for exploring all the top attractions. The rooms were spacious and comfortable, and the kids loved the rooftop pool. The only minor issue was some noise from the street at night, but overall, we were very pleased.','2023-03-20 18:45:00','2023-03-20 18:45:00');

insert into hotel.reviews (id,username,rating,review,created,updated) values (101,'TravelBuddy22','5','Wow, what an amazing hotel! The Grand Palace Hotel truly lives up to its name. From the moment we arrived, we were treated like royalty. The rooms were immaculate, the spa was heavenly, and the fine dining restaurant was out of this world. We can''t say enough good things about our experience here.' ,'2023-02-10 10:15:00' ,'2023-02-10 10:15:00');

insert into hotel.reviews (id,username,rating,review,created,updated) values (101 ,'BusinessTraveler789','3','The Grand Palace Hotel was a decent option for my business trip. The location was convenient, and the rooms were comfortable enough. However, I was a bit disappointed with the level of service, as requests often took a long time to be fulfilled. The spa was nice, but the prices were quite high.','2023-01-05 14:20:00','2023-01-05 14:20:00');

insert into hotel.reviews (id,username,rating,review,created,updated) values (105 ,'JohnDoe','5' ,'The Urban Loft Hotel was an absolute gem! From the moment I stepped inside, I was captivated by the trendy and stylish atmosphere. The loft-style room was spacious, with floor-to-ceiling windows that offered stunning city views. The industrial-chic decor added a unique touch, making me feel like I was in the heart of a urban oasis.','2023-04-01 12:00:00' ,'2023-04-01 12:00:00');

insert into hotel.reviews (id,username,rating,review,created,updated) values (105 ,'SarahW' ,'4','I had a fantastic stay at the Urban Loft Hotel. The location was perfect, right in the middle of the city''s vibrant nightlife and trendy restaurants. The hotel staff was incredibly friendly and accommodating. My only minor complaint would be that the room was a bit small, but the modern design and floor-to-ceiling windows made up for it.' ,'2023-03-15 10:30:00','2023-03-15 10:30:00');

insert into hotel.reviews (id,username,rating,review,created,updated) values (105,'TravelBug22' ,'5' ,'If you''re looking for a trendy and stylish hotel experience in the heart of the city, look no further than the Urban Loft Hotel. From the moment I arrived, I was impressed by the modern and chic decor. The loft-style room was spacious and comfortable, with large windows that provided great city views. The staff was friendly and helpful, and the hotel''s location was perfect for exploring the city''s top attractions and nightlife.' ,'2023-02-28 18:45:00' ,'2023-02-28 18:45:00');

--Add a column of vector data type to hotels table for storing vector embeddings and add columns sentiment and confidence to reviews table for sentiment analysis using following command:
ALTER TABLE hotel.hotels ADD hotel_embedding sys.vector(1536);
ALTER TABLE hotel.reviews ADD sentiment varchar(100);
ALTER TABLE hotel.reviews ADD confidence real;

--Create T-SQL procedures to generating embeddings on Babelfish for Aurora PostgreSQL and invoke Titan Embeddings model with Amazon Bedrock using following SQL commands:
CREATE FUNCTION hotel.make_json_2(@prompt varchar(MAX), @data TEXT)
returns varchar(MAX)
AS BEGIN
DECLARE @json_val varchar(MAX) ;
SET @json_val = CONCAT('{"inputText":"', @prompt, ' ', @data, '"}')
Return @json_val
END;

CREATE procedure hotel.ss_generate_hotel_embeddings(@photelid bigint)
AS Begin
DECLARE @v sys.vector(1536) = Null; 
DECLARE @vtext varchar(max) = Null;
DECLARE @rcnt integer = 0 ;
DECLARE @id bigint;
DECLARE @hotelname varchar(max);
DECLARE @overview varchar(max);
DECLARE @keywords varchar(max);
DECLARE @category_id bigint;
DECLARE @description varchar(max);
Declare @vtext_for varchar(max) = Null;
-- declare cursor
DECLARE cursor1 CURSOR FOR
SELECT id, hotelname, overview, keywords, category_id, description
FROM hotel.hotels 
WHERE hotel_embedding IS NULL and ((@photelid is NULL) OR (@photelid IS NOT NULL and id = @photelid))
GROUP BY id, hotelname, overview, keywords, category_id
-- open cursor
OPEN cursor1;
-- loop through a cursor
FETCH NEXT FROM cursor1 INTO @id, @hotelname, @overview, @keywords, @category_id, @description;
WHILE @@FETCH_STATUS = 0
BEGIN
PRINT CONCAT('working on hotel id: ', @id);
SET @vtext = CONCAT(@hotelname, ' ', @overview, ' ' , @keywords, ' ' , @category_id);
Set @vtext_for = CAST(hotel.make_json_2('', @vtext) AS text);
Select @v = aws_bedrock.invoke_model_get_embeddings('amazon.titan-embed-text-v1','application/json','embedding', CAST(@vtext_for as text));
UPDATE hotel.hotels set hotel_embedding = @v WHERE id = @photelid ;
FETCH NEXT FROM cursor1 INTO @id, @hotelname, @overview, @keywords, @category_id, @description;
END
CLOSE cursor1; 
deallocate cursor1;
END;

--Create TSQL procedure to get top 5 hotels based on user search query

SQL> CREATE procedure hotel.ss_get_top5_hotels(@search_query varchar(max))
as begin
DECLARE @v sys.vector(1536); 
Declare @vtext_for varchar(max)
Print CONCAT(' inputText: ', @search_query);
Set @vtext_for = CAST(hotel.make_json_2('', @search_query) AS text); 
Select @v = aws_bedrock.invoke_model_get_embeddings('amazon.titan-embed-text-v1','application/json','embedding', CAST(@vtext_for as text));
--PRINT CONCAT(' embed info:', @v);
SELECT top 5 h.id, h.hotelname, h.description, h.overview FROM hotel.hotels h ORDER BY h.hotel_embedding ↔ @v 
END;

Create TSQL procedure to generate review summary for the hotels based on user search query by invoking Anthropic Claude 2 model using Amazon Bedrock from Babelfish for Aurora PostgreSQL:

SQL> CREATE FUNCTION hotel.make_json_3(@input1 varchar(MAX), @data TEXT)
returns varchar(MAX)
AS BEGIN
DECLARE @json_val varchar(MAX) ;
SET @json_val = CONCAT('{"prompt":"', @input1, ' ', @data,' ','","max_tokens_to_sample":4096,','"temperature":0.5,','"top_k":250,','"top_p":0.5,','"stop_sequences":[]','}')
Return @json_val
END;

SQL> CREATE procedure hotel.ss_get_reviews_summary(@photelid bigint) 
as BEGIN
DECLARE @v1 varchar(max) ;
Declare @vtext_for varchar(max);
WITH 
p AS ( 
SELECT '\n\nHuman: Please provide a summary of the following text.\n<text>\n{doc_text}\n </text>\n\nAssistant:' collate "C" AS prompt)
, h AS (
SELECT id, STRING_AGG(review, '\n') AS reviews 
FROM hotel.reviews
WHERE id = @photelid
GROUP BY id)
SELECT @v1 = replace(p.prompt, '{doc_text}', h.reviews) FROM h CROSS JOIN p ; 
select @vtext_for = CAST(hotel.make_json_3('', @v1) AS text); 
PRINT CONCAT(' format info:', @vtext_for);
SELECT aws_bedrock.invoke_model('anthropic.claude-v2', 'application/json', 'application/json', @vtext_for) ; 
END;

Execute following DML statement to update the sentiment analysis in hotel reviews table using AWS Comprehend integration with Babelfish for Aurora PostgreSQL:

SQL> UPDATE hotel.reviews
SET sentiment = (aws_comprehend.detect_sentiment (review, 'en')).sentiment,
confidence = (aws_comprehend.detect_sentiment (review, 'en')).confidence
WHERE reviews.review IS NOT NULL AND
LENGTH(TRIM(reviews.review)) > 0 AND
reviews.sentiment IS NULL;



