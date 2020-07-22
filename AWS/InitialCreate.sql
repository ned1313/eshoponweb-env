IF OBJECT_ID(N'[__EFMigrationsHistory]') IS NULL
BEGIN
    CREATE TABLE [__EFMigrationsHistory] (
        [MigrationId] nvarchar(150) NOT NULL,
        [ProductVersion] nvarchar(32) NOT NULL,
        CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY ([MigrationId])
    );
END;

GO

CREATE SEQUENCE [catalog_brand_hilo] START WITH 1 INCREMENT BY 10 NO MINVALUE NO MAXVALUE NO CYCLE;

GO

CREATE SEQUENCE [catalog_hilo] START WITH 1 INCREMENT BY 10 NO MINVALUE NO MAXVALUE NO CYCLE;

GO

CREATE SEQUENCE [catalog_type_hilo] START WITH 1 INCREMENT BY 10 NO MINVALUE NO MAXVALUE NO CYCLE;

GO

CREATE TABLE [Baskets] (
    [Id] int NOT NULL IDENTITY,
    [BuyerId] nvarchar(max) NULL,
    CONSTRAINT [PK_Baskets] PRIMARY KEY ([Id])
);

GO

CREATE TABLE [CatalogBrand] (
    [Id] int NOT NULL,
    [Brand] nvarchar(100) NOT NULL,
    CONSTRAINT [PK_CatalogBrand] PRIMARY KEY ([Id])
);

GO

CREATE TABLE [CatalogType] (
    [Id] int NOT NULL,
    [Type] nvarchar(100) NOT NULL,
    CONSTRAINT [PK_CatalogType] PRIMARY KEY ([Id])
);

GO

CREATE TABLE [Orders] (
    [Id] int NOT NULL IDENTITY,
    [BuyerId] nvarchar(max) NULL,
    [OrderDate] datetimeoffset NOT NULL,
    [ShipToAddress_City] nvarchar(max) NULL,
    [ShipToAddress_Country] nvarchar(max) NULL,
    [ShipToAddress_State] nvarchar(max) NULL,
    [ShipToAddress_Street] nvarchar(max) NULL,
    [ShipToAddress_ZipCode] nvarchar(max) NULL,
    CONSTRAINT [PK_Orders] PRIMARY KEY ([Id])
);

GO

CREATE TABLE [BasketItem] (
    [Id] int NOT NULL IDENTITY,
    [BasketId] int NULL,
    [CatalogItemId] int NOT NULL,
    [Quantity] int NOT NULL,
    [UnitPrice] decimal(18, 2) NOT NULL,
    CONSTRAINT [PK_BasketItem] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_BasketItem_Baskets_BasketId] FOREIGN KEY ([BasketId]) REFERENCES [Baskets] ([Id]) ON DELETE NO ACTION
);

GO

CREATE TABLE [Catalog] (
    [Id] int NOT NULL,
    [CatalogBrandId] int NOT NULL,
    [CatalogTypeId] int NOT NULL,
    [Description] nvarchar(max) NULL,
    [Name] nvarchar(50) NOT NULL,
    [PictureUri] nvarchar(max) NULL,
    [Price] decimal(18, 2) NOT NULL,
    CONSTRAINT [PK_Catalog] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_Catalog_CatalogBrand_CatalogBrandId] FOREIGN KEY ([CatalogBrandId]) REFERENCES [CatalogBrand] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_Catalog_CatalogType_CatalogTypeId] FOREIGN KEY ([CatalogTypeId]) REFERENCES [CatalogType] ([Id]) ON DELETE CASCADE
);

GO

CREATE TABLE [OrderItems] (
    [Id] int NOT NULL IDENTITY,
    [OrderId] int NULL,
    [UnitPrice] decimal(18, 2) NOT NULL,
    [Units] int NOT NULL,
    [ItemOrdered_CatalogItemId] int NOT NULL,
    [ItemOrdered_PictureUri] nvarchar(max) NULL,
    [ItemOrdered_ProductName] nvarchar(max) NULL,
    CONSTRAINT [PK_OrderItems] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_OrderItems_Orders_OrderId] FOREIGN KEY ([OrderId]) REFERENCES [Orders] ([Id]) ON DELETE NO ACTION
);

GO

CREATE INDEX [IX_BasketItem_BasketId] ON [BasketItem] ([BasketId]);

GO

CREATE INDEX [IX_Catalog_CatalogBrandId] ON [Catalog] ([CatalogBrandId]);

GO

CREATE INDEX [IX_Catalog_CatalogTypeId] ON [Catalog] ([CatalogTypeId]);

GO

CREATE INDEX [IX_OrderItems_OrderId] ON [OrderItems] ([OrderId]);

GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20171018175735_Initial', N'3.1.5');

GO

DECLARE @var0 sysname;
SELECT @var0 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Orders]') AND [c].[name] = N'ShipToAddress_ZipCode');
IF @var0 IS NOT NULL EXEC(N'ALTER TABLE [Orders] DROP CONSTRAINT [' + @var0 + '];');
ALTER TABLE [Orders] ALTER COLUMN [ShipToAddress_ZipCode] nvarchar(18) NOT NULL;

GO

DECLARE @var1 sysname;
SELECT @var1 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Orders]') AND [c].[name] = N'ShipToAddress_Street');
IF @var1 IS NOT NULL EXEC(N'ALTER TABLE [Orders] DROP CONSTRAINT [' + @var1 + '];');
ALTER TABLE [Orders] ALTER COLUMN [ShipToAddress_Street] nvarchar(180) NOT NULL;

GO

DECLARE @var2 sysname;
SELECT @var2 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Orders]') AND [c].[name] = N'ShipToAddress_State');
IF @var2 IS NOT NULL EXEC(N'ALTER TABLE [Orders] DROP CONSTRAINT [' + @var2 + '];');
ALTER TABLE [Orders] ALTER COLUMN [ShipToAddress_State] nvarchar(60) NULL;

GO

DECLARE @var3 sysname;
SELECT @var3 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Orders]') AND [c].[name] = N'ShipToAddress_Country');
IF @var3 IS NOT NULL EXEC(N'ALTER TABLE [Orders] DROP CONSTRAINT [' + @var3 + '];');
ALTER TABLE [Orders] ALTER COLUMN [ShipToAddress_Country] nvarchar(90) NOT NULL;

GO

DECLARE @var4 sysname;
SELECT @var4 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Orders]') AND [c].[name] = N'ShipToAddress_City');
IF @var4 IS NOT NULL EXEC(N'ALTER TABLE [Orders] DROP CONSTRAINT [' + @var4 + '];');
ALTER TABLE [Orders] ALTER COLUMN [ShipToAddress_City] nvarchar(100) NOT NULL;

GO

DECLARE @var5 sysname;
SELECT @var5 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[OrderItems]') AND [c].[name] = N'ItemOrdered_ProductName');
IF @var5 IS NOT NULL EXEC(N'ALTER TABLE [OrderItems] DROP CONSTRAINT [' + @var5 + '];');
ALTER TABLE [OrderItems] ALTER COLUMN [ItemOrdered_ProductName] nvarchar(50) NOT NULL;

GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20180725190153_AddExtraConstraints', N'3.1.5');

GO

ALTER TABLE [BasketItem] DROP CONSTRAINT [FK_BasketItem_Baskets_BasketId];

GO

ALTER TABLE [BasketItem] DROP CONSTRAINT [PK_BasketItem];

GO

EXEC sp_rename N'[BasketItem]', N'BasketItems';

GO

EXEC sp_rename N'[BasketItems].[IX_BasketItem_BasketId]', N'IX_BasketItems_BasketId', N'INDEX';

GO

ALTER TABLE [BasketItems] ADD CONSTRAINT [PK_BasketItems] PRIMARY KEY ([Id]);

GO

ALTER TABLE [BasketItems] ADD CONSTRAINT [FK_BasketItems_Baskets_BasketId] FOREIGN KEY ([BasketId]) REFERENCES [Baskets] ([Id]) ON DELETE NO ACTION;

GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20190601014740_UpdatingDefaultDataTypes', N'3.1.5');

GO

ALTER TABLE [Catalog] DROP CONSTRAINT [FK_Catalog_CatalogBrand_CatalogBrandId];

GO

ALTER TABLE [Catalog] DROP CONSTRAINT [FK_Catalog_CatalogType_CatalogTypeId];

GO

ALTER TABLE [CatalogType] DROP CONSTRAINT [PK_CatalogType];

GO

ALTER TABLE [CatalogBrand] DROP CONSTRAINT [PK_CatalogBrand];

GO

EXEC sp_rename N'[CatalogType]', N'CatalogTypes';

GO

EXEC sp_rename N'[CatalogBrand]', N'CatalogBrands';

GO

ALTER TABLE [CatalogTypes] ADD CONSTRAINT [PK_CatalogTypes] PRIMARY KEY ([Id]);

GO

ALTER TABLE [CatalogBrands] ADD CONSTRAINT [PK_CatalogBrands] PRIMARY KEY ([Id]);

GO

ALTER TABLE [Catalog] ADD CONSTRAINT [FK_Catalog_CatalogBrands_CatalogBrandId] FOREIGN KEY ([CatalogBrandId]) REFERENCES [CatalogBrands] ([Id]) ON DELETE CASCADE;

GO

ALTER TABLE [Catalog] ADD CONSTRAINT [FK_Catalog_CatalogTypes_CatalogTypeId] FOREIGN KEY ([CatalogTypeId]) REFERENCES [CatalogTypes] ([Id]) ON DELETE CASCADE;

GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20190818191507_UpdatedConstraints', N'3.1.5');

GO

ALTER TABLE [Catalog] DROP CONSTRAINT [FK_Catalog_CatalogBrands_CatalogBrandId];

GO

ALTER TABLE [Catalog] DROP CONSTRAINT [FK_Catalog_CatalogTypes_CatalogTypeId];

GO

ALTER TABLE [CatalogTypes] DROP CONSTRAINT [PK_CatalogTypes];

GO

ALTER TABLE [CatalogBrands] DROP CONSTRAINT [PK_CatalogBrands];

GO

EXEC sp_rename N'[CatalogTypes]', N'CatalogType';

GO

EXEC sp_rename N'[CatalogBrands]', N'CatalogBrand';

GO

DECLARE @var6 sysname;
SELECT @var6 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Baskets]') AND [c].[name] = N'BuyerId');
IF @var6 IS NOT NULL EXEC(N'ALTER TABLE [Baskets] DROP CONSTRAINT [' + @var6 + '];');
ALTER TABLE [Baskets] ALTER COLUMN [BuyerId] nvarchar(max) NULL;

GO

ALTER TABLE [CatalogType] ADD CONSTRAINT [PK_CatalogType] PRIMARY KEY ([Id]);

GO

ALTER TABLE [CatalogBrand] ADD CONSTRAINT [PK_CatalogBrand] PRIMARY KEY ([Id]);

GO

ALTER TABLE [Catalog] ADD CONSTRAINT [FK_Catalog_CatalogBrand_CatalogBrandId] FOREIGN KEY ([CatalogBrandId]) REFERENCES [CatalogBrand] ([Id]) ON DELETE CASCADE;

GO

ALTER TABLE [Catalog] ADD CONSTRAINT [FK_Catalog_CatalogType_CatalogTypeId] FOREIGN KEY ([CatalogTypeId]) REFERENCES [CatalogType] ([Id]) ON DELETE CASCADE;

GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20190911011026_UpdateCatalogModels', N'3.1.5');

GO

ALTER TABLE [Catalog] DROP CONSTRAINT [FK_Catalog_CatalogBrand_CatalogBrandId];

GO

ALTER TABLE [Catalog] DROP CONSTRAINT [FK_Catalog_CatalogType_CatalogTypeId];

GO

ALTER TABLE [CatalogType] DROP CONSTRAINT [PK_CatalogType];

GO

ALTER TABLE [CatalogBrand] DROP CONSTRAINT [PK_CatalogBrand];

GO

EXEC sp_rename N'[CatalogType]', N'CatalogTypes';

GO

EXEC sp_rename N'[CatalogBrand]', N'CatalogBrands';

GO

DECLARE @var7 sysname;
SELECT @var7 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Orders]') AND [c].[name] = N'ShipToAddress_ZipCode');
IF @var7 IS NOT NULL EXEC(N'ALTER TABLE [Orders] DROP CONSTRAINT [' + @var7 + '];');
ALTER TABLE [Orders] ALTER COLUMN [ShipToAddress_ZipCode] nvarchar(max) NULL;

GO

DECLARE @var8 sysname;
SELECT @var8 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Orders]') AND [c].[name] = N'ShipToAddress_Street');
IF @var8 IS NOT NULL EXEC(N'ALTER TABLE [Orders] DROP CONSTRAINT [' + @var8 + '];');
ALTER TABLE [Orders] ALTER COLUMN [ShipToAddress_Street] nvarchar(max) NULL;

GO

DECLARE @var9 sysname;
SELECT @var9 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Orders]') AND [c].[name] = N'ShipToAddress_State');
IF @var9 IS NOT NULL EXEC(N'ALTER TABLE [Orders] DROP CONSTRAINT [' + @var9 + '];');
ALTER TABLE [Orders] ALTER COLUMN [ShipToAddress_State] nvarchar(max) NULL;

GO

DECLARE @var10 sysname;
SELECT @var10 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Orders]') AND [c].[name] = N'ShipToAddress_Country');
IF @var10 IS NOT NULL EXEC(N'ALTER TABLE [Orders] DROP CONSTRAINT [' + @var10 + '];');
ALTER TABLE [Orders] ALTER COLUMN [ShipToAddress_Country] nvarchar(max) NULL;

GO

DECLARE @var11 sysname;
SELECT @var11 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Orders]') AND [c].[name] = N'ShipToAddress_City');
IF @var11 IS NOT NULL EXEC(N'ALTER TABLE [Orders] DROP CONSTRAINT [' + @var11 + '];');
ALTER TABLE [Orders] ALTER COLUMN [ShipToAddress_City] nvarchar(max) NULL;

GO

DECLARE @var12 sysname;
SELECT @var12 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[OrderItems]') AND [c].[name] = N'ItemOrdered_ProductName');
IF @var12 IS NOT NULL EXEC(N'ALTER TABLE [OrderItems] DROP CONSTRAINT [' + @var12 + '];');
ALTER TABLE [OrderItems] ALTER COLUMN [ItemOrdered_ProductName] nvarchar(max) NULL;

GO

DECLARE @var13 sysname;
SELECT @var13 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Baskets]') AND [c].[name] = N'BuyerId');
IF @var13 IS NOT NULL EXEC(N'ALTER TABLE [Baskets] DROP CONSTRAINT [' + @var13 + '];');
ALTER TABLE [Baskets] ALTER COLUMN [BuyerId] nvarchar(40) NOT NULL;

GO

ALTER TABLE [CatalogTypes] ADD CONSTRAINT [PK_CatalogTypes] PRIMARY KEY ([Id]);

GO

ALTER TABLE [CatalogBrands] ADD CONSTRAINT [PK_CatalogBrands] PRIMARY KEY ([Id]);

GO

ALTER TABLE [Catalog] ADD CONSTRAINT [FK_Catalog_CatalogBrands_CatalogBrandId] FOREIGN KEY ([CatalogBrandId]) REFERENCES [CatalogBrands] ([Id]) ON DELETE CASCADE;

GO

ALTER TABLE [Catalog] ADD CONSTRAINT [FK_Catalog_CatalogTypes_CatalogTypeId] FOREIGN KEY ([CatalogTypeId]) REFERENCES [CatalogTypes] ([Id]) ON DELETE CASCADE;

GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20191031185508_Post30Upgrade', N'3.1.5');

GO

DECLARE @var14 sysname;
SELECT @var14 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Orders]') AND [c].[name] = N'ShipToAddress_ZipCode');
IF @var14 IS NOT NULL EXEC(N'ALTER TABLE [Orders] DROP CONSTRAINT [' + @var14 + '];');
ALTER TABLE [Orders] ALTER COLUMN [ShipToAddress_ZipCode] nvarchar(18) NULL;

GO

DECLARE @var15 sysname;
SELECT @var15 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Orders]') AND [c].[name] = N'ShipToAddress_Street');
IF @var15 IS NOT NULL EXEC(N'ALTER TABLE [Orders] DROP CONSTRAINT [' + @var15 + '];');
ALTER TABLE [Orders] ALTER COLUMN [ShipToAddress_Street] nvarchar(180) NULL;

GO

DECLARE @var16 sysname;
SELECT @var16 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Orders]') AND [c].[name] = N'ShipToAddress_State');
IF @var16 IS NOT NULL EXEC(N'ALTER TABLE [Orders] DROP CONSTRAINT [' + @var16 + '];');
ALTER TABLE [Orders] ALTER COLUMN [ShipToAddress_State] nvarchar(60) NULL;

GO

DECLARE @var17 sysname;
SELECT @var17 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Orders]') AND [c].[name] = N'ShipToAddress_Country');
IF @var17 IS NOT NULL EXEC(N'ALTER TABLE [Orders] DROP CONSTRAINT [' + @var17 + '];');
ALTER TABLE [Orders] ALTER COLUMN [ShipToAddress_Country] nvarchar(90) NULL;

GO

DECLARE @var18 sysname;
SELECT @var18 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Orders]') AND [c].[name] = N'ShipToAddress_City');
IF @var18 IS NOT NULL EXEC(N'ALTER TABLE [Orders] DROP CONSTRAINT [' + @var18 + '];');
ALTER TABLE [Orders] ALTER COLUMN [ShipToAddress_City] nvarchar(100) NULL;

GO

DECLARE @var19 sysname;
SELECT @var19 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[OrderItems]') AND [c].[name] = N'ItemOrdered_ProductName');
IF @var19 IS NOT NULL EXEC(N'ALTER TABLE [OrderItems] DROP CONSTRAINT [' + @var19 + '];');
ALTER TABLE [OrderItems] ALTER COLUMN [ItemOrdered_ProductName] nvarchar(50) NULL;

GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20191105161820_AddressAndCatalogItemOrderedChanges', N'3.1.5');

GO

