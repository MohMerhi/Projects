USE [BMCompany]
GO
/****** Object:  View [dbo].[ordervision]    Script Date: 1/19/2024 8:51:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[ordervision]
as
select orderNumber, c.customerNumber, c.customerName, orderDate, requiredDate, status
from customers as c, orders as o
where c.customerNumber = o.customerNumber;
GO

