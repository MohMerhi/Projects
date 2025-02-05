USE [BMCompany]
GO
/****** Object:  Trigger [dbo].[checkCheck]    Script Date: 1/21/2024 12:38:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[checkCheck]
ON [dbo].[payments] 
after INSERT
AS
BEGIN
    DECLARE @CheckNumber VARCHAR(50);
	declare @creditLimit decimal(10,2);
	select @creditLimit = amount from inserted;
    SELECT @CheckNumber = checkNumber FROM inserted;
    IF not(PATINDEX('%[A-Z]%', LEFT(@CheckNumber, PATINDEX('%[0-9]%', @CheckNumber) - 1)) > 0
       AND PATINDEX('%[0-9]%', SUBSTRING(@CheckNumber, PATINDEX('%[0-9]%', @CheckNumber), LEN(@CheckNumber))) > 0
	    and len(@CheckNumber) >= 8 and len(@CheckNumber) <= 16 and @creditLimit > 0)
	   begin
	   raiserror('invalid check number', 16, 1000);
	   end
END;
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create trigger [dbo].[afterOrderDetailsInsert]
On [dbo].[orderdetails]
after insert
as
begin
	declare @temp varchar(max);
	set @temp = (select status from inserted,orders where inserted.orderNumber = orders.orderNumber);
	if(@temp = 'In Process')
	update products set quantityInStock = quantityInStock - i. quantityOrdered 
	from products as p, inserted as i
	where  p.productCode = i.productCode;
end;
GO
