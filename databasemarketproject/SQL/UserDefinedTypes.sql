USE [BMCompany]
GO
/****** Object:  UserDefinedTableType [dbo].[selectedItems]    Script Date: 1/19/2024 7:29:18 PM ******/
CREATE TYPE [dbo].[selectedItems] AS TABLE(
	[productCode] [varchar](15) NULL,
	[quantity] [int] NULL,
	[priceOfEach] [decimal](10, 2) NULL
)
GO