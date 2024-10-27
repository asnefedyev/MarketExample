use TestDb;

go

DROP TABLE IF EXISTS dbo.ProductVersion;
DROP TABLE IF EXISTS dbo.Product;
DROP TABLE IF EXISTS dbo.EventLog; 
DROP FUNCTION IF EXISTS dbo.get_versions_products;

go

CREATE TABLE dbo.Product (
	ID uniqueidentifier NOT NULL,
	Name varchar(255) NOT NULL,
	Description varchar(max) NULL,
	CONSTRAINT Product__ID__PK PRIMARY KEY (ID),
	CONSTRAINT Product__name__UNIQUE UNIQUE (Name)
);
CREATE NONCLUSTERED INDEX Product__Name__IDX ON dbo.Product (Name);
/*
При наличии компонента Full-text Search лучше создать полнотекстовый индекс и использовать оператор CONTAINS
для полнотекстового поиска.
Подготовка:
CREATE UNIQUE INDEX Product__Name__UIDX ON dbo.Product(Name);
CREATE FULLTEXT CATALOG ft AS DEFAULT;
CREATE FULLTEXT INDEX ON dbo.Product([Name])
   KEY INDEX Product__Name__UIDX
   WITH STOPLIST = SYSTEM; 
*/
ALTER INDEX Product__name__UNIQUE ON
    dbo.Product
SET (
    ALLOW_ROW_LOCKS  = ON,
    ALLOW_PAGE_LOCKS = ON
    );
    
go
 
CREATE TABLE dbo.ProductVersion (
	ID uniqueidentifier NOT NULL,
	ProductID uniqueidentifier NOT NULL,
	Name varchar(255) NOT NULL,
	Description varchar(max) NULL,
	CreatingDate datetime DEFAULT GETDATE() NOT NULL,
	Width real NOT NULL,
	Height real NOT NULL,
	[Length] real NOT NULL,
	CONSTRAINT ProductVersion__ID__PK PRIMARY KEY (ID),
	  CONSTRAINT ProductVersion__ProductID__FK FOREIGN KEY (ProductID) REFERENCES dbo.Product(ID) ON DELETE CASCADE
);
CREATE NONCLUSTERED INDEX ProductVersion__Name__IDX ON dbo.ProductVersion (Name);
CREATE NONCLUSTERED INDEX ProductVersion__CreatingDate__IDX ON dbo.ProductVersion (CreatingDate);
CREATE NONCLUSTERED INDEX ProductVersion__Heigth__IDX ON dbo.ProductVersion (Height);
CREATE NONCLUSTERED INDEX ProductVersion__Width__IDX ON dbo.ProductVersion (Width);
CREATE NONCLUSTERED INDEX ProductVersion__Length__IDX ON dbo.ProductVersion ([Length]);

ALTER INDEX ProductVersion__Name__IDX ON
    dbo.ProductVersion
SET (
    ALLOW_ROW_LOCKS  = ON,
    ALLOW_PAGE_LOCKS = ON
    );
   
ALTER INDEX ProductVersion__CreatingDate__IDX ON
    dbo.ProductVersion
SET (
    ALLOW_ROW_LOCKS  = ON,
    ALLOW_PAGE_LOCKS = ON
    );
   
ALTER INDEX ProductVersion__Heigth__IDX ON
    dbo.ProductVersion
SET (
    ALLOW_ROW_LOCKS  = ON,
    ALLOW_PAGE_LOCKS = ON
    );
   
ALTER INDEX ProductVersion__Width__IDX ON
    dbo.ProductVersion
SET (
    ALLOW_ROW_LOCKS  = ON,
    ALLOW_PAGE_LOCKS = ON
    );
   
ALTER INDEX ProductVersion__Length__IDX ON
    dbo.ProductVersion
SET (
    ALLOW_ROW_LOCKS  = ON,
    ALLOW_PAGE_LOCKS = ON
    );
   
go

CREATE TABLE dbo.EventLog (
	ID uniqueidentifier NOT NULL,
	EventDate datetime DEFAULT GetDate() NOT NULL,
	Description varchar(max) NULL,
	CONSTRAINT EventLog__ID__PK PRIMARY KEY (ID)
);
CREATE NONCLUSTERED INDEX EventLog__EventDate__IDX ON dbo.EventLog (EventDate);

ALTER INDEX EventLog__EventDate__IDX ON
    dbo.EventLog
SET (
    ALLOW_ROW_LOCKS  = ON,
    ALLOW_PAGE_LOCKS = ON
    );
   
go

CREATE TRIGGER dbo.Product__INSERT__TRG
ON dbo.Product
AFTER INSERT
AS
insert into dbo.EventLog ([ID], [EventDate], [Description])
select newid(), getdate(), cast(inserted.ID as varchar(36))
from inserted;
   
go

CREATE TRIGGER dbo.Product__UPDATE__TRG
ON dbo.Product
AFTER UPDATE
AS
insert into dbo.EventLog ([ID], [EventDate], [Description])
select newid(), getdate(), cast(inserted.ID as varchar(36))
from inserted;

go

CREATE TRIGGER dbo.Product__DELETE__TRG
ON dbo.Product
AFTER DELETE
AS
insert into dbo.EventLog ([ID], [EventDate], [Description])
select newid(), getdate(), cast(deleted.ID as varchar(36))
from deleted;

go

CREATE TRIGGER dbo.ProductVersion__INSERT__TRG
ON dbo.ProductVersion
AFTER INSERT
AS
insert into dbo.EventLog ([ID], [EventDate], [Description])
select newid(), getdate(), cast(inserted.ID as varchar(36))
from inserted;
   
go

CREATE TRIGGER dbo.ProductVersion__UPDATE__TRG
ON dbo.ProductVersion
AFTER UPDATE
AS
insert into dbo.EventLog ([ID], [EventDate], [Description])
select newid(), getdate(), cast(inserted.ID as varchar(36))
from inserted;

go

CREATE TRIGGER dbo.ProductVersion__DELETE__TRG
ON dbo.ProductVersion
AFTER DELETE
AS
insert into dbo.EventLog ([ID], [EventDate], [Description])
select newid(), getdate(), cast(deleted.ID as varchar(36))
from deleted;

go

INSERT INTO dbo.product (ID,Name,Description) VALUES
	 (N'8D16AE51-8584-4995-B4BC-041024BC08ED',N'Кофе',N'Арабика, жареная на месте'),
	 (N'3C0675A6-13B4-4EA2-A311-05610914BCEC',N'Бензин',N'АИ-92, эколомичный топливо для автомобилей'),
	 (N'650C8B80-3D55-4040-9000-061908372941',N'Кроссовки',N'Легкие кроссовки для бега'),
	 (N'663AE600-56FC-4BB2-8BEC-124AB253C5E7',N'Автозапчасть (Фильтр масла)',N'Масляный фильтр для дизельных двигателей'),
	 (N'105296EA-8B00-4FFF-9B33-16184F696BDD',N'Кроссовки для футбола',N'Кроссовки с шипами для футбольного поля'),
	 (N'3F6CA898-B964-42C9-8FC1-1E651C363E51',N'Футболка',N'Удобная футболка из хлопка'),
	 (N'E7BF045D-7111-4FF3-AC88-226A01041C25',N'Слиток золота',N'Слиток 1 унция, 999 пробы'),
	 (N'78CDD529-9410-4382-9C16-2D251A53D544',N'Сандалии',N'Летние сандалии из натуральной кожи'),
	 (N'13E5EBA8-C16F-445B-8FE2-457D7D7E6872',N'Плащ дождевик',N'Плащ для защиты от дождя'),
	 (N'A8C5649E-DB25-4ED3-9148-46CCB97BCDB2',N'Хлеб',N'Свежий хлеб на закваске');
INSERT INTO dbo.product (ID,Name,Description) VALUES
	 (N'153E0982-FC86-4BDC-B73F-491D157D153C',N'Консервы (Горошек)',N'Консервированный зелёный горошек'),
	 (N'9DA0F18B-823F-4D7C-AA83-4CD9A2882DF9',N'Фен',N'Фен для укладки волос с ионизацией'),
	 (N'31D9AEB0-EC53-4B24-8E4D-535EDECA4AA4',N'Сахар',N'Сахар в пакетах по 1 кг'),
	 (N'AB9199C1-E716-4675-97ED-590E8CC9A975',N'Кошачий корм',N'Корм для кошек с курицей'),
	 (N'ADD78760-8C09-4340-A72F-5ADA0948FCFC',N'Зубная паста',N'С освежающим эффектом'),
	 (N'106D7AC7-330A-4B15-918F-5C76F717C982',N'Чай',N'Зеленый чай, без добавок'),
	 (N'D32BF7E3-C2DF-4DC5-A824-6B42AEA9BB8D',N'Лампочка',N'Энергосберегающая LED-лампочка'),
	 (N'C1EC1620-BF53-4D7E-A446-6E0854398026',N'Палатка',N'Легкая палатка для кемпинга');
INSERT INTO dbo.product (ID,Name,Description) VALUES
	 (N'4C2732EC-E85A-47BA-9FA6-7F2C17795C57',N'Перчатки',N'Теплые перчатки, водоотталкивающие'),
	 (N'CDEAC342-A0EC-4476-B0AB-80544187CFEF',N'Паутина для комаров',N'Эффективная паутина для защиты от насекомых'),
	 (N'AE4147A7-46F1-4CC9-8793-9582ACC113E6',N'Томатный сок',N'Сок из отборных помидоров'),
	 (N'9CBA042D-2354-4AD5-8E78-97CA3D364212',N'Ванная принадлежность',N'Набор для ванной с креплениями'),
	 (N'4E18DC21-418E-46F1-B110-9DF9C1AA1B96',N'Автозапчасть (Тормозная система)',N'Тормозные диски для легкового автомобиля'),
	 (N'B7B5430F-F4E0-4800-A2EF-A54615E559A4',N'Огурцы',N'Свежие огурцы, органического производства'),
	 (N'0C9F20A6-A10E-4EC2-A79D-A9161B2F32C4',N'Шапка',N'Шапка-ушанка на зиму'),
	 (N'FCB4E08E-CA92-48F7-823C-B567CCBA583C',N'Джинсы',N'Стильные джинсы с низкой посадкой'),
	 (N'57EC6256-0385-4705-B66A-BA542E520FDD',N'Крем для рук',N'Увлажняющий крем для рук'),
	 (N'BE6DE21D-82BC-4ABE-AAE9-BD3724A5A41F',N'Кофеварка',N'Автоматическая кофеварка');
INSERT INTO dbo.product (ID,Name,Description) VALUES
	 (N'2A54C34F-D289-48A6-89D1-BFF5BEED018B',N'Виктория Бэкхэм',N'Парфюм для женщин'),
	 (N'CA6CB274-C5C3-4369-89B7-D04305992056',N'Асфальт',N'Асфальт для укладки дороги'),
	 (N'E9D60828-C616-4B27-A617-D10982E2F14E',N'Масло',N'Кунжутное масло, холодного отжима'),
	 (N'665D1465-893F-409C-951E-DAE187792ADB',N'Спортивная куртка',N'Легкая куртка для активного отдыха'),
	 (N'988F09B8-5B58-4F54-BF85-DBCB21EB09FA',N'Шампунь',N'Шампунь с аргановым маслом'),
	 (N'DC59285D-06AD-4D9C-AF52-E6F1E4DF8485',N'Шорты',N'Комфортные шорты для лета'),
	 (N'63FCCC5C-A7DA-428F-B14E-F1B808BD710B',N'Консервы (Тунец)',N'Консервы с тунцом в масле'),
	 (N'EAB6EA19-4713-4A83-9535-F3571CA1F181',N'Корм для собак',N'Сбалансированный корм для собак всех пород'),
	 (N'5D2328DC-9FB7-46B1-90FD-F7489C7891C1',N'Скотч',N'Клейкая лента для упаковки'),
	 (N'AFF7437C-5FB8-464C-B3CA-F75A2C71B038',N'Очки для плавания',N'Защитные очки для плавания'),
	 (N'B97A35FB-D8B3-46FA-8A6D-F92192C806A3',N'Футляр для очков',N'Твердый футляр для защиты очков');

go

INSERT INTO dbo.ProductVersion (ID, ProductID, Name, Description, CreatingDate, Width, Height, Length) VALUES
(NEWID(), N'8D16AE51-8584-4995-B4BC-041024BC08ED', N'Кофе 250г', N'Упаковка 250 грамм', GETDATE(), 10.0, 5.0, 15.0),
(NEWID(), N'8D16AE51-8584-4995-B4BC-041024BC08ED', N'Кофе 500г', N'Упаковка 500 грамм', GETDATE(), 12.0, 7.0, 20.0),
(NEWID(), N'8D16AE51-8584-4995-B4BC-041024BC08ED', N'Кофе 1кг', N'Упаковка 1 килограмм', GETDATE(), 14.0, 9.0, 25.0),
(NEWID(), N'3C0675A6-13B4-4EA2-A311-05610914BCEC', N'Бензин АИ-92', N'Топливо АИ-92', GETDATE(), 20.0, 10.0, 15.0),
(NEWID(), N'3C0675A6-13B4-4EA2-A311-05610914BCEC', N'Бензин АИ-95', N'Топливо АИ-95', GETDATE(), 20.0, 10.0, 15.0),
(NEWID(), N'650C8B80-3D55-4040-9000-061908372941', N'Кроссовки (размер 42)', N'Лёгкие кроссовки', GETDATE(), 30.0, 15.0, 40.0),
(NEWID(), N'650C8B80-3D55-4040-9000-061908372941', N'Кроссовки (размер 43)', N'Лёгкие кроссовки', GETDATE(), 30.0, 15.0, 40.0),
(NEWID(), N'650C8B80-3D55-4040-9000-061908372941', N'Кроссовки (размер 44)', N'Лёгкие кроссовки', GETDATE(), 30.0, 15.0, 40.0),
(NEWID(), N'663AE600-56FC-4BB2-8BEC-124AB253C5E7', N'Фильтр масла (тип А)', N'Масляный фильтр', GETDATE(), 5.0, 4.0, 6.0),
(NEWID(), N'663AE600-56FC-4BB2-8BEC-124AB253C5E7', N'Фильтр масла (тип Б)', N'Фильтр для дизеля', GETDATE(), 5.0, 4.0, 6.0),
(NEWID(), N'105296EA-8B00-4FFF-9B33-16184F696BDD', N'Кроссовки для футбола (размер 41)', N'Кроссовки с шипами', GETDATE(), 30.0, 15.0, 40.0),
(NEWID(), N'105296EA-8B00-4FFF-9B33-16184F696BDD', N'Кроссовки для футбола (размер 42)', N'Кроссовки с шипами', GETDATE(), 30.0, 15.0, 40.0);

INSERT INTO dbo.ProductVersion (ID, ProductID, Name, Description, CreatingDate, Width, Height, Length) VALUES
(NEWID(), N'3F6CA898-B964-42C9-8FC1-1E651C363E51', N'Футболка (размер S)', N'Удобная футболка из хлопка, размер S', GETDATE(), 10.0, 1.0, 15.0),
(NEWID(), N'3F6CA898-B964-42C9-8FC1-1E651C363E51', N'Футболка (размер M)', N'Удобная футболка из хлопка, размер M', GETDATE(), 10.0, 1.0, 15.0),
(NEWID(), N'3F6CA898-B964-42C9-8FC1-1E651C363E51', N'Футболка (размер L)', N'Удобная футболка из хлопка, размер L', GETDATE(), 10.0, 1.0, 15.0),
(NEWID(), N'E7BF045D-7111-4FF3-AC88-226A01041C25', N'Слиток золота (1 унция)', N'Слиток золота 999 пробы, вес 1 унция', GETDATE(), 2.0, 1.0, 4.0),
(NEWID(), N'E7BF045D-7111-4FF3-AC88-226A01041C25', N'Слиток золота (5 унций)', N'Слиток золота 999 пробы, вес 5 унций', GETDATE(), 10.0, 1.0, 4.0),
(NEWID(), N'78CDD529-9410-4382-9C16-2D251A53D544', N'Сандалии (размер 41)', N'Летние сандалии из натуральной кожи, размер 41', GETDATE(), 10.0, 5.0, 15.0),
(NEWID(), N'78CDD529-9410-4382-9C16-2D251A53D544', N'Сандалии (размер 42)', N'Летние сандалии из натуральной кожи, размер 42', GETDATE(), 10.0, 5.0, 15.0),
(NEWID(), N'13E5EBA8-C16F-445B-8FE2-457D7D7E6872', N'Плащ дождевик (цвет черный)', N'Плащ дождевик черного цвета', GETDATE(), 20.0, 1.5, 30.0),
(NEWID(), N'13E5EBA8-C16F-445B-8FE2-457D7D7E6872', N'Плащ дождевик (цвет синий)', N'Плащ дождевик синего цвета', GETDATE(), 20.0, 1.5, 30.0),
(NEWID(), N'A8C5649E-DB25-4ED3-9148-46CCB97BCDB2', N'Хлеб (белый)', N'Свежий белый хлеб на закваске', GETDATE(), 15.0, 10.0, 25.0),
(NEWID(), N'A8C5649E-DB25-4ED3-9148-46CCB97BCDB2', N'Хлеб (полблин)', N'Свежий хлеб из полблинного теста', GETDATE(), 15.0, 10.0, 25.0);

INSERT INTO dbo.ProductVersion (ID, ProductID, Name, Description, CreatingDate, Width, Height, Length) VALUES
(NEWID(), N'78CDD529-9410-4382-9C16-2D251A53D544', N'Сандалии (размер 41)', N'Удобные сандалии из натуральной кожи, размер 41', GETDATE(), 10.0, 5.0, 15.0),
(NEWID(), N'78CDD529-9410-4382-9C16-2D251A53D544', N'Сандалии (размер 42)', N'Удобные сандалии из натуральной кожи, размер 42', GETDATE(), 10.0, 5.0, 15.0),
(NEWID(), N'78CDD529-9410-4382-9C16-2D251A53D544', N'Сандалии (размер 43)', N'Удобные сандалии из натуральной кожи, размер 43', GETDATE(), 10.0, 5.0, 15.0),
(NEWID(), N'13E5EBA8-C16F-445B-8FE2-457D7D7E6872', N'Плащ дождевик (размер M)', N'Плащ дождевик, размер M, защитит от дождя', GETDATE(), 20.0, 1.5, 30.0),
(NEWID(), N'13E5EBA8-C16F-445B-8FE2-457D7D7E6872', N'Плащ дождевик (размер L)', N'Плащ дождевик, размер L, защитит от дождя', GETDATE(), 20.0, 1.5, 30.0),
(NEWID(), N'A8C5649E-DB25-4ED3-9148-46CCB97BCDB2', N'Хлеб (белый)', N'Свежий белый хлеб на закваске', GETDATE(), 15.0, 10.0, 25.0),
(NEWID(), N'A8C5649E-DB25-4ED3-9148-46CCB97BCDB2', N'Хлеб (ржаной)', N'Свежий ржаной хлеб на закваске', GETDATE(), 15.0, 10.0, 25.0),
(NEWID(), N'A8C5649E-DB25-4ED3-9148-46CCB97BCDB2', N'Хлеб (с семечками)', N'Свежий хлеб с семечками, вкусный и полезный', GETDATE(), 15.0, 10.0, 25.0);

INSERT INTO dbo.ProductVersion (ID, ProductID, Name, Description, CreatingDate, Width, Height, Length) VALUES
(NEWID(), N'153E0982-FC86-4BDC-B73F-491D157D153C', N'Консервы (Горошек, 400г)', N'Консервированный зелёный горошек в банке 400 грамм.', GETDATE(), 5.0, 4.0, 10.0),
(NEWID(), N'153E0982-FC86-4BDC-B73F-491D157D153C', N'Консервы (Горошек, 800г)', N'Консервированный зелёный горошек в банке 800 грамм.', GETDATE(), 7.0, 5.0, 12.0),
(NEWID(), N'9DA0F18B-823F-4D7C-AA83-4CD9A2882DF9', N'Фен (2100W)', N'Фен для укладки волос мощностью 2100 ватт.', GETDATE(), 12.0, 7.0, 25.0),
(NEWID(), N'9DA0F18B-823F-4D7C-AA83-4CD9A2882DF9', N'Фен (1600W)', N'Фен для укладки волос мощностью 1600 ватт, компактный.', GETDATE(), 10.0, 6.0, 22.0),
(NEWID(), N'31D9AEB0-EC53-4B24-8E4D-535EDECA4AA4', N'Сахар (1 кг)', N'Сахар в пакетах по 1 кг, идеален для чая и выпечки.', GETDATE(), 15.0, 2.0, 20.0),
(NEWID(), N'31D9AEB0-EC53-4B24-8E4D-535EDECA4AA4', N'Сахар (5 кг)', N'Сахар в пакетах по 5 кг, экономичный вариант.', GETDATE(), 25.0, 4.0, 30.0),
(NEWID(), N'AB9199C1-E716-4675-97ED-590E8CC9A975', N'Кошачий корм (с курицей, 1.5 кг)', N'Корм для кошек с курицей в упаковке 1.5 кг.', GETDATE(), 20.0, 10.0, 30.0),
(NEWID(), N'AB9199C1-E716-4675-97ED-590E8CC9A975', N'Кошачий корм (с говядиной, 2 кг)', N'Корм для кошек с говядиной в упаковке 2 кг.', GETDATE(), 22.0, 12.0, 32.0);

INSERT INTO dbo.ProductVersion (ID, ProductID, Name, Description, CreatingDate, Width, Height, Length) VALUES
(NEWID(), N'ADD78760-8C09-4340-A72F-5ADA0948FCFC', N'Зубная паста (тюбик 100 мл)', N'Зубная паста с освежающим эффектом. Идеально подходит для ежедневного использования.', GETDATE(), 5.0, 2.0, 10.0),
(NEWID(), N'ADD78760-8C09-4340-A72F-5ADA0948FCFC', N'Зубная паста (тюбик 75 мл)', N'Компактная зубная паста с освежающим эффектом, удобно брать в поездки.', GETDATE(), 4.5, 2.0, 9.0),
(NEWID(), N'ADD78760-8C09-4340-A72F-5ADA0948FCFC', N'Зубная паста (эконом упаковка 150 мл)', N'Экономичная упаковка зубной пасты с освежающим эффектом.', GETDATE(), 6.0, 3.0, 11.0),
(NEWID(), N'106D7AC7-330A-4B15-918F-5C76F717C982', N'Чай (пакетированный, 20 пакетиков)', N'Ароматный зеленый чай, 20 пакетиков, без добавок.', GETDATE(), 8.0, 3.0, 12.0),
(NEWID(), N'106D7AC7-330A-4B15-918F-5C76F717C982', N'Чай (расфасованный, 100 г)', N'Свежий зеленый чай в расфасовке по 100 грамм.', GETDATE(), 10.0, 5.0, 15.0),
(NEWID(), N'106D7AC7-330A-4B15-918F-5C76F717C982', N'Чай (упаковка 50 пакетиков)', N'Большая упаковка зеленого чая, 50 пакетиков для настоящих ценителей.', GETDATE(), 15.0, 5.0, 18.0),
(NEWID(), N'D32BF7E3-C2DF-4DC5-A824-6B42AEA9BB8D', N'Лампочка (9 Вт, теплый свет)', N'Энергосберегающая LED-лампочка, 9 ватт, теплый свет.', GETDATE(), 6.0, 10.0, 15.0),
(NEWID(), N'D32BF7E3-C2DF-4DC5-A824-6B42AEA9BB8D', N'Лампочка (12 Вт, холодный свет)', N'LED-лампочка, 12 ватт, холодный свет, отлично подходит для работы.', GETDATE(), 6.0, 10.0, 15.0),
(NEWID(), N'D32BF7E3-C2DF-4DC5-A824-6B42AEA9BB8D', N'Лампочка (10 Вт, RGB)', N'LED-лампочка, 10 ватт, с возможностью смены цветов (RGB).', GETDATE(), 6.5, 10.0, 15.5),
(NEWID(), N'C1EC1620-BF53-4D7E-A446-6E0854398026', N'Палатка (2-местная)', N'Легкая палатка для кемпинга, идеально подходит для двух человек.', GETDATE(), 200.0, 100.0, 50.0);

INSERT INTO dbo.ProductVersion (ID, ProductID, Name, Description, CreatingDate, Width, Height, Length) VALUES
(NEWID(), N'4C2732EC-E85A-47BA-9FA6-7F2C17795C57', N'Перчатки (100% шерсть)', N'Теплые шерстяные перчатки для зимы.', GETDATE(), 10.0, 5.0, 15.0),
(NEWID(), N'4C2732EC-E85A-47BA-9FA6-7F2C17795C57', N'Перчатки (водонепроницаемые)', N'Перчатки, которые защитят ваши руки от воды.', GETDATE(), 10.0, 5.0, 15.0),
(NEWID(), N'4C2732EC-E85A-47BA-9FA6-7F2C17795C57', N'Перчатки (с подогревом)', N'Инновационные перчатки с подогревом для максимального комфорта.', GETDATE(), 10.0, 5.0, 15.0),
(NEWID(), N'CDEAC342-A0EC-4476-B0AB-80544187CFEF', N'Паутина для комаров (премиум)', N'Эффективная паутина, защищающая от насекомых в течение 30 дней.', GETDATE(), 20.0, 5.0, 10.0),
(NEWID(), N'CDEAC342-A0EC-4476-B0AB-80544187CFEF', N'Паутина для комаров (экологическая)', N'Безопасная для детей и животных паутина с натуральными компонентами.', GETDATE(), 20.0, 5.0, 10.0),
(NEWID(), N'CDEAC342-A0EC-4476-B0AB-80544187CFEF', N'Паутина для комаров (с ароматом)', N'Паутина с приятным ароматом, защищающая от насекомых.', GETDATE(), 20.0, 5.0, 10.0),
(NEWID(), N'AE4147A7-46F1-4CC9-8793-9582ACC113E6', N'Томатный сок (500 мл)', N'Сок из отборных помидоров, без консервантов.', GETDATE(), 7.0, 20.0, 15.0),
(NEWID(), N'AE4147A7-46F1-4CC9-8793-9582ACC113E6', N'Томатный сок (брутто, 1 л)', N'Большая упаковка томатного сока, отличный для готовки.', GETDATE(), 12.0, 25.0, 15.0),
(NEWID(), N'AE4147A7-46F1-4CC9-8793-9582ACC113E6', N'Томатный сок (с добавками)', N'Сок с добавлением базилика и оливкового масла.', GETDATE(), 7.0, 20.0, 15.0),
(NEWID(), N'9CBA042D-2354-4AD5-8E78-97CA3D364212', N'Ванная принадлежность (набор)', N'Классический набор для ванной с креплениями и аксессуарами.', GETDATE(), 30.0, 15.0, 20.0),
(NEWID(), N'9CBA042D-2354-4AD5-8E78-97CA3D364212', N'Ванная принадлежность (премиум)', N'Роскошный набор для ванной из высококачественных материалов.', GETDATE(), 35.0, 15.5, 22.0);

INSERT INTO dbo.ProductVersion (ID, ProductID, Name, Description, CreatingDate, Width, Height, Length) VALUES
(NEWID(), N'4E18DC21-418E-46F1-B110-9DF9C1AA1B96', N'Тормозные диски (стандартные)', N'Стандартные тормозные диски для легковых автомобилей.', GETDATE(), 30.0, 5.0, 30.0),
(NEWID(), N'4E18DC21-418E-46F1-B110-9DF9C1AA1B96', N'Тормозные диски (вентилируемые)', N'Вентилируемые тормозные диски для улучшенной производительности.', GETDATE(), 30.0, 5.0, 30.0),
(NEWID(), N'4E18DC21-418E-46F1-B110-9DF9C1AA1B96', N'Тормозные диски (для спортивных автомобилей)', N'Специальные диски для спортивных автомобилей с повышенной прочностью.', GETDATE(), 30.0, 5.0, 30.0),
(NEWID(), N'B7B5430F-F4E0-4800-A2EF-A54615E559A4', N'Огурцы (первый сорт)', N'Свежие огурцы высшего качества, без пестицидов.', GETDATE(), 10.0, 5.0, 20.0),
(NEWID(), N'B7B5430F-F4E0-4800-A2EF-A54615E559A4', N'Огурцы (пакет 1 кг)', N'Пакет свежих огурцов, идеален для консервирования.', GETDATE(), 10.0, 5.0, 20.0),
(NEWID(), N'B7B5430F-F4E0-4800-A2EF-A54615E559A4', N'Огурцы (органические)', N'Органические огурцы, выращенные без химии.', GETDATE(), 10.0, 5.0, 20.0),
(NEWID(), N'0C9F20A6-A10E-4EC2-A79D-A9161B2F32C4', N'Шапка-ушанка (меховая)', N'Теплая шапка-ушанка из натурального меха.', GETDATE(), 20.0, 10.0, 15.0),
(NEWID(), N'0C9F20A6-A10E-4EC2-A79D-A9161B2F32C4', N'Шапка-ушанка (пуховая)', N'Легкая шапка-ушанка с пуховым наполнителем.', GETDATE(), 20.0, 10.0, 15.0),
(NEWID(), N'0C9F20A6-A10E-4EC2-A79D-A9161B2F32C4', N'Шапка-ушанка (с подкладкой)', N'Шапка с теплой подкладкой для морозов.', GETDATE(), 20.0, 10.0, 15.0),
(NEWID(), N'FCB4E08E-CA92-48F7-823C-B567CCBA583C', N'Джинсы (классические)', N'Классические джинсы с низкой посадкой и удобным кроем.', GETDATE(), 30.0, 1.0, 40.0),
(NEWID(), N'FCB4E08E-CA92-48F7-823C-B567CCBA583C', N'Джинсы (стрейч)', N'Удобные стрейч-джинсы, сохраняющие форму после стирки.', GETDATE(), 30.0, 1.0, 40.0);

INSERT INTO dbo.ProductVersion (ID, ProductID, Name, Description, CreatingDate, Width, Height, Length) VALUES
(NEWID(), N'57EC6256-0385-4705-B66A-BA542E520FDD', N'Крем для рук (классический)', N'Увлажняющий крем с экстрактом алоэ вера.', GETDATE(), 5.0, 10.0, 5.0),
(NEWID(), N'57EC6256-0385-4705-B66A-BA542E520FDD', N'Крем для рук (дляSensitive кожи)', N'Специально разработан для чувствительной кожи.', GETDATE(), 5.0, 10.0, 5.0),
(NEWID(), N'57EC6256-0385-4705-B66A-BA542E520FDD', N'Крем для рук (с ароматом лаванды)', N'Ароматный крем с нежным ароматом лаванды.', GETDATE(), 5.0, 10.0, 5.0),
(NEWID(), N'BE6DE21D-82BC-4ABE-AAE9-BD3724A5A41F', N'Кофеварка (механическая)', N'Механическая кофеварка для настоящих кофейных гурманов.', GETDATE(), 30.0, 35.0, 30.0),
(NEWID(), N'BE6DE21D-82BC-4ABE-AAE9-BD3724A5A41F', N'Кофеварка (автоматическая)', N'Автоматическая кофеварка с функцией капучино.', GETDATE(), 30.0, 35.0, 30.0),
(NEWID(), N'BE6DE21D-82BC-4ABE-AAE9-BD3724A5A41F', N'Кофеварка (многофункциональная)', N'Кофеварка с множеством функций и настройками.', GETDATE(), 30.0, 35.0, 30.0);

INSERT INTO dbo.ProductVersion (ID, ProductID, Name, Description, CreatingDate, Width, Height, Length) VALUES
(NEWID(), N'2A54C34F-D289-48A6-89D1-BFF5BEED018B', N'Виктория Бэкхэм (объем 30 мл)', N'Парфюм для женщин, объем 30 мл.', GETDATE(), 5.0, 10.0, 5.0),
(NEWID(), N'2A54C34F-D289-48A6-89D1-BFF5BEED018B', N'Виктория Бэкхэм (объем 50 мл)', N'Парфюм для женщин, объем 50 мл.', GETDATE(), 5.0, 10.0, 5.0),
(NEWID(), N'2A54C34F-D289-48A6-89D1-BFF5BEED018B', N'Виктория Бэкхэм (объем 100 мл)', N'Парфюм для женщин, объем 100 мл.', GETDATE(), 5.0, 10.0, 5.0),
(NEWID(), N'CA6CB274-C5C3-4369-89B7-D04305992056', N'Асфальт (щитовой, 2 тонны)', N'Асфальт в коробках весом 2 тонны.', GETDATE(), 20.0, 5.0, 30.0),
(NEWID(), N'CA6CB274-C5C3-4369-89B7-D04305992056', N'Асфальт (рулонный, 10 метров)', N'Рулонный асфальт длиной 10 метров.', GETDATE(), 50.0, 5.0, 50.0),
(NEWID(), N'E9D60828-C616-4B27-A617-D10982E2F14E', N'Кунжутное масло (250 мл)', N'Кунжутное масло, холодного отжима, объём 250 мл.', GETDATE(), 4.0, 12.0, 4.0),
(NEWID(), N'E9D60828-C616-4B27-A617-D10982E2F14E', N'Кунжутное масло (500 мл)', N'Кунжутное масло, холодного отжима, объём 500 мл.', GETDATE(), 5.0, 15.0, 5.0),
(NEWID(), N'665D1465-893F-409C-951E-DAE187792ADB', N'Спортивная куртка (размер S)', N'Легкая куртка для активного отдыха, размер S.', GETDATE(), 10.0, 12.0, 1.0),
(NEWID(), N'665D1465-893F-409C-951E-DAE187792ADB', N'Спортивная куртка (размер M)', N'Легкая куртка для активного отдыха, размер M.', GETDATE(), 10.0, 12.0, 1.0),
(NEWID(), N'665D1465-893F-409C-951E-DAE187792ADB', N'Спортивная куртка (размер L)', N'Легкая куртка для активного отдыха, размер L.', GETDATE(), 10.0, 12.0, 1.0);

INSERT INTO dbo.ProductVersion (ID, ProductID, Name, Description, CreatingDate, Width, Height, Length) VALUES
(NEWID(), N'988F09B8-5B58-4F54-BF85-DBCB21EB09FA', N'Шампунь с аргановым маслом (250 мл)', N'Шампунь с аргановым маслом, объем 250 мл.', GETDATE(), 6.0, 15.0, 6.0),
(NEWID(), N'988F09B8-5B58-4F54-BF85-DBCB21EB09FA', N'Шампунь с аргановым маслом (500 мл)', N'Шампунь с аргановым маслом, объем 500 мл.', GETDATE(), 8.0, 20.0, 8.0),
(NEWID(), N'DC59285D-06AD-4D9C-AF52-E6F1E4DF8485', N'Шорты летние (размер S)', N'Легкие летние шорты, размер S.', GETDATE(), 10.0, 30.0, 1.0),
(NEWID(), N'DC59285D-06AD-4D9C-AF52-E6F1E4DF8485', N'Шорты летние (размер M)', N'Легкие летние шорты, размер M.', GETDATE(), 10.0, 30.0, 1.0),
(NEWID(), N'DC59285D-06AD-4D9C-AF52-E6F1E4DF8485', N'Шорты летние (размер L)', N'Легкие летние шорты, размер L.', GETDATE(), 10.0, 30.0, 1.0),
(NEWID(), N'63FCCC5C-A7DA-428F-B14E-F1B808BD710B', N'Консервы с тунцом (180 г)', N'Консервы с тунцом в масле, объем 180 г.', GETDATE(), 6.0, 10.0, 6.0),
(NEWID(), N'63FCCC5C-A7DA-428F-B14E-F1B808BD710B', N'Консервы с тунцом (400 г)', N'Консервы с тунцом в масле, объем 400 г.', GETDATE(), 8.0, 15.0, 8.0),
(NEWID(), N'EAB6EA19-4713-4A83-9535-F3571CA1F181', N'Корм для собак (1 кг)', N'Сбалансированный корм для собак, объем 1 кг.', GETDATE(), 20.0, 5.0, 30.0),
(NEWID(), N'EAB6EA19-4713-4A83-9535-F3571CA1F181', N'Корм для собак (5 кг)', N'Сбалансированный корм для собак, объем 5 кг.', GETDATE(), 30.0, 10.0, 40.0);

INSERT INTO dbo.ProductVersion (ID, ProductID, Name, Description, CreatingDate, Width, Height, Length) VALUES
(NEWID(), N'5D2328DC-9FB7-46B1-90FD-F7489C7891C1', N'Скотч (50 м)', N'Клейкая лента для упаковки, длина 50 метров.', GETDATE(), 5.0, 5.0, 5.0),
(NEWID(), N'5D2328DC-9FB7-46B1-90FD-F7489C7891C1', N'Скотч (100 м)', N'Клейкая лента для упаковки, длина 100 метров.', GETDATE(), 6.0, 6.0, 6.0),
(NEWID(), N'5D2328DC-9FB7-46B1-90FD-F7489C7891C1', N'Скотч (25 м, цветной)', N'Цветная клейкая лента для упаковки, длина 25 метров.', GETDATE(), 5.0, 5.0, 5.0),
(NEWID(), N'AFF7437C-5FB8-464C-B3CA-F75A2C71B038', N'Очки для плавания (с прозрачными линзами)', N'Защитные очки для плавания с прозрачными линзами.', GETDATE(), 15.0, 5.0, 6.0),
(NEWID(), N'AFF7437C-5FB8-464C-B3CA-F75A2C71B038', N'Очки для плавания (с затемненными линзами)', N'Очки для плавания с затемненными линзами для солнечных дней.', GETDATE(), 15.0, 5.0, 6.0),
(NEWID(), N'AFF7437C-5FB8-464C-B3CA-F75A2C71B038', N'Очки для плавания (с антифогом)', N'Очки, защищенные от запотевания, идеальны для соревнований.', GETDATE(), 15.0, 5.0, 6.0),
(NEWID(), N'B97A35FB-D8B3-46FA-8A6D-F92192C806A3', N'Футляр для очков (пластиковый)', N'Твердый пластиковый футляр для защиты очков.', GETDATE(), 15.0, 6.0, 6.0),
(NEWID(), N'B97A35FB-D8B3-46FA-8A6D-F92192C806A3', N'Футляр для очков (тканевый)', N'Легкий тканевый футляр для переноски очков.', GETDATE(), 15.0, 5.0, 5.0),
(NEWID(), N'B97A35FB-D8B3-46FA-8A6D-F92192C806A3', N'Футляр для очков (с узором)', N'Твердый футляр с оригинальным узором для защиты очков.', GETDATE(), 15.0, 6.0, 6.0);

go

CREATE FUNCTION dbo.get_versions_products (@productName varchar(255), @productVersionName varchar(255), @min_volume real, @max_volume real)
RETURNS @ProductsList Table
	(
		 productVersionUID uniqueidentifier,
		 productName varchar(255),
		 productVersionName varchar(255),
		 Width real, 
		 Height real,
		 Length real
	 )
AS
BEGIN
	INSERT INTO @ProductsList
    SELECT pv.ID, p.Name, pv.Name, pv.Width, pv.Height, pv.Length
    FROM dbo.Product as p
	join dbo.ProductVersion as pv on p.ID = pv.ProductID
	WHERE (pv.Width * pv.Height * pv.Length) between @min_volume and @max_volume and CHARINDEX(@productName, p.Name) > 0 and CHARINDEX(@productVersionName, pv.Name) > 0;
RETURN
END;