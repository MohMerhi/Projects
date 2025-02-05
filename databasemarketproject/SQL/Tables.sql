USE [BMCompany]
GO
/****** Object:  Table [dbo].[customers]    Script Date: 1/21/2024 11:25:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[customers](
	[customerNumber] [int] NOT NULL,
	[customerName] [varchar](50) NOT NULL,
	[contactLastName] [varchar](50) NOT NULL,
	[contactFirstName] [varchar](50) NOT NULL,
	[phone] [varchar](50) NOT NULL,
	[addressLine1] [varchar](50) NOT NULL,
	[addressLine2] [varchar](50) NULL,
	[city] [varchar](50) NOT NULL,
	[state] [varchar](50) NULL,
	[postalCode] [varchar](15) NULL,
	[country] [varchar](50) NOT NULL,
	[salesRepEmployeeNumber] [int] NULL,
	[creditLimit] [decimal](10, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[customerNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[employees]    Script Date: 1/21/2024 11:25:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[employees](
	[employeeNumber] [int] NOT NULL,
	[lastName] [varchar](50) NOT NULL,
	[firstName] [varchar](50) NOT NULL,
	[extension] [varchar](10) NOT NULL,
	[email] [varchar](100) NOT NULL,
	[officeCode] [varchar](10) NOT NULL,
	[reportsTo] [int] NULL,
	[jobTitle] [varchar](50) NOT NULL,
	[Passwords] [varchar](16) NULL,
PRIMARY KEY CLUSTERED 
(
	[employeeNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[offices]    Script Date: 1/21/2024 11:25:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[offices](
	[officeCode] [varchar](10) NOT NULL,
	[city] [varchar](50) NOT NULL,
	[phone] [varchar](50) NOT NULL,
	[addressLine1] [varchar](50) NOT NULL,
	[addressLine2] [varchar](50) NULL,
	[state] [varchar](50) NULL,
	[country] [varchar](50) NOT NULL,
	[postalCode] [varchar](15) NOT NULL,
	[territory] [varchar](10) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[officeCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[orderdetails]    Script Date: 1/21/2024 11:25:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[orderdetails](
	[orderNumber] [int] NOT NULL,
	[productCode] [varchar](15) NOT NULL,
	[quantityOrdered] [int] NOT NULL,
	[priceEach] [decimal](10, 2) NOT NULL,
	[orderLineNumber] [smallint] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[orderNumber] ASC,
	[productCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[orders]    Script Date: 1/21/2024 11:25:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[orders](
	[orderNumber] [int] NOT NULL,
	[orderDate] [date] NOT NULL,
	[requiredDate] [date] NOT NULL,
	[shippedDate] [date] NULL,
	[status] [varchar](15) NOT NULL,
	[comments] [text] NULL,
	[customerNumber] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[orderNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[payments]    Script Date: 1/21/2024 11:25:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[payments](
	[customerNumber] [int] NOT NULL,
	[checkNumber] [varchar](50) NOT NULL,
	[paymentDate] [date] NOT NULL,
	[amount] [decimal](10, 2) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[customerNumber] ASC,
	[checkNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[productlines]    Script Date: 1/21/2024 11:25:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[productlines](
	[productLine] [varchar](50) NOT NULL,
	[textDescription] [varchar](4000) NULL,
	[htmlDescription] [text] NULL,
	[mediumblob] [image] NULL,
PRIMARY KEY CLUSTERED 
(
	[productLine] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[products]    Script Date: 1/21/2024 11:25:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[products](
	[productCode] [varchar](15) NOT NULL,
	[productName] [varchar](70) NOT NULL,
	[productLine] [varchar](50) NOT NULL,
	[productScale] [varchar](10) NOT NULL,
	[productVendor] [varchar](50) NOT NULL,
	[productDescription] [text] NOT NULL,
	[quantityInStock] [smallint] NOT NULL,
	[buyPrice] [decimal](10, 2) NOT NULL,
	[MSRP] [decimal](10, 2) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[productCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[customers] ADD  DEFAULT (NULL) FOR [addressLine2]
GO
ALTER TABLE [dbo].[customers] ADD  DEFAULT (NULL) FOR [state]
GO
ALTER TABLE [dbo].[customers] ADD  DEFAULT (NULL) FOR [postalCode]
GO
ALTER TABLE [dbo].[customers] ADD  DEFAULT (NULL) FOR [salesRepEmployeeNumber]
GO
ALTER TABLE [dbo].[customers] ADD  DEFAULT (NULL) FOR [creditLimit]
GO
ALTER TABLE [dbo].[employees] ADD  DEFAULT (NULL) FOR [reportsTo]
GO
ALTER TABLE [dbo].[offices] ADD  DEFAULT (NULL) FOR [addressLine2]
GO
ALTER TABLE [dbo].[offices] ADD  DEFAULT (NULL) FOR [state]
GO
ALTER TABLE [dbo].[orders] ADD  DEFAULT (NULL) FOR [shippedDate]
GO
ALTER TABLE [dbo].[productlines] ADD  DEFAULT (NULL) FOR [textDescription]
GO
ALTER TABLE [dbo].[customers]  WITH CHECK ADD FOREIGN KEY([salesRepEmployeeNumber])
REFERENCES [dbo].[employees] ([employeeNumber])
GO
ALTER TABLE [dbo].[employees]  WITH CHECK ADD FOREIGN KEY([officeCode])
REFERENCES [dbo].[offices] ([officeCode])
GO
ALTER TABLE [dbo].[employees]  WITH CHECK ADD FOREIGN KEY([reportsTo])
REFERENCES [dbo].[employees] ([employeeNumber])
GO
ALTER TABLE [dbo].[orderdetails]  WITH CHECK ADD FOREIGN KEY([orderNumber])
REFERENCES [dbo].[orders] ([orderNumber])
GO
ALTER TABLE [dbo].[orderdetails]  WITH CHECK ADD FOREIGN KEY([productCode])
REFERENCES [dbo].[products] ([productCode])
GO
ALTER TABLE [dbo].[orders]  WITH CHECK ADD FOREIGN KEY([customerNumber])
REFERENCES [dbo].[customers] ([customerNumber])
GO
ALTER TABLE [dbo].[payments]  WITH CHECK ADD FOREIGN KEY([customerNumber])
REFERENCES [dbo].[customers] ([customerNumber])
GO
ALTER TABLE [dbo].[products]  WITH CHECK ADD FOREIGN KEY([productLine])
REFERENCES [dbo].[productlines] ([productLine])
GO
