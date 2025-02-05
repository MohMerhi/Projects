USE [BMCompany]
GO
/****** Object:  StoredProcedure [dbo].[addNewCustomer]    Script Date: 1/21/2024 11:29:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[addNewCustomer]
@customerNumber int,
@customerName varchar(50),
@contactFirstName varchar(50),
@contactLastName varchar(50),
@phone varchar(50),
@addressLine1 varchar(50),
@addressLine2 varchar(50),
@city varchar(50),
@state varchar(50),
@postalCode varchar(15),
@country varchar(50),
@salesemployee int
as
begin
	if exists(select * from customers where customerNumber = @customerNumber)
	begin
	update customers set customerName = @customerName, contactFirstName = @contactFirstName,
	contactLastName = @contactLastName, phone = @phone, addressLine1 = @addressLine1, addressLine2 = @addressLine2,
	city = @city, state = @state, postalCode = @postalCode, country = @country, salesRepEmployeeNumber = @salesemployee
	where customerNumber = @customerNumber;
	end
	else
	begin
	insert into customers values (@customerNumber, @customerName, @contactFirstName, @contactLastName, @phone,
	 @addressLine1, @addressLine2, @city, @state,@postalCode,@country, @salesemployee, 0.00);
	end
end
GO
/****** Object:  StoredProcedure [dbo].[addOrder]    Script Date: 1/21/2024 11:29:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[addOrder]
@orderProducts selectedItems readonly,
@orderNumber int,
@customerNumber int,
@requiredDate date,
@status varchar(max),
@comment text,
@returnValue int output
as
begin
begin transaction
	declare @temp int;
	set @temp = 0;
	if(@requiredDate < GETDATE())
	begin
	rollback;
	raiserror('date must be a valid date',16,1);
	return;
	end
	if(@status <> 'In Process'  and @status <> 'Requested')
	begin
	rollback;
	raisError ('Order Must be new inorder to be processed',16,1);
	return;
	end;
	exec CheckQuantity @orderProducts = @orderProducts, @InvalidQuantities = @temp output;
	if(@temp > 0 and @status = 'In Process')
	begin
	rollback;
	raisError('quantity no enough to process',16,1);
	return;
	end
	insert into orders values (@orderNumber, GETDATE(), @requiredDate, null, @status, @comment, @customerNumber);
	exec addTableToProductDetails @orderProducts = @orderProducts, @orderNumber = @orderNumber;
	if(@status = 'In Process')
	begin
		set @returnValue = 1;
	end
	else
	begin
		set @returnValue = 0;
	end
	commit;
end

GO
/****** Object:  StoredProcedure [dbo].[AddOrUpdateProduct]    Script Date: 1/21/2024 11:29:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddOrUpdateProduct]
    @productCode varchar(15),
    @productName varchar(70),
    @productLine varchar(50),
    @productScale varchar(10),
    @productVendor varchar(50),
    @productDescription text,
    @quantityInStock smallint,
    @buyPrice decimal(10,2),
    @MSRP decimal(10,2),
	@isNew bit
AS
BEGIN

    DECLARE @existingProductCount INT;

    -- Check if the product already exists
    SELECT @existingProductCount = COUNT(*)
    FROM products
    WHERE productCode = @productCode;

    -- If the product already exists, return a message
    IF (@existingProductCount > 0 and @isNew = 1)
    BEGIN
		raiserror('cannot create a new order because order already exists',16,1);
        RETURN;
    END
	else if (@existingProductCount = 0 and @isNew = 1)
	begin
	INSERT INTO products (
        productCode,
        productName,
        productLine,
        productScale,
        productVendor,
        productDescription,
        quantityInStock,
        buyPrice,
        MSRP
    )
    VALUES (
        @productCode,
        @productName,
        @productLine,
        @productScale,
        @productVendor,
        @productDescription,
        @quantityInStock,
        @buyPrice,
        @MSRP
    );
	end
	else
	begin
		update products set productName = @productName, productLine = @productLine, productScale = @productScale,
		productVendor = @productVendor, productDescription = @productDescription, quantityInStock = @quantityInStock,
		buyPrice = @buyPrice,
		MSRP = @MSRP
		where productCode = @productCode;
		end
END;
GO
/****** Object:  StoredProcedure [dbo].[addTableToProductDetails]    Script Date: 1/21/2024 11:29:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[addTableToProductDetails]
@orderProducts selectedItems readonly,
@orderNumber int
as
begin
		declare @orderLineNumber int;
		set @orderLineNumber = 1;
		declare @productCode varchar(15);
		declare @quantity int;
		declare @priceOfEach decimal(10,2);
		declare productList cursor for
		select productCode, quantity, priceOfEach
		from @orderProducts;
		open productList;
		fetch next from productList into @productCode, @quantity, @priceOfEach;
		while @@FETCH_STATUS = 0
		begin
			insert into orderdetails values (@orderNumber, @productCode,@quantity, @priceOfEach, @orderLineNumber);
			fetch next from productList into @productCode, @quantity, @priceOfEach;
			set @orderLineNumber = @orderLineNumber + 1;
		end
end

GO
/****** Object:  StoredProcedure [dbo].[CancelOrder]    Script Date: 1/21/2024 11:29:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[CancelOrder]
@orderNumber int
as
begin
	declare @status varchar(max);
	select @status = status from orders where orderNumber = @orderNumber;
	if (@status = 'In Process' or @status = 'On Hold')
	begin
	exec removeProductsFromOrderDetails @orderNumber = @orderNumber;
	update orders set status = 'Cancelled' where orderNumber = @orderNumber;
	end
	else if (@status = 'Requested')
	begin
	delete from orderdetails where orderNumber = @orderNumber;
	update orders set status = 'Cancelled' where orderNumber = @orderNumber;
	end;
end
GO
/****** Object:  StoredProcedure [dbo].[ChangePassword]    Script Date: 1/21/2024 11:29:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ChangePassword]
    @EmployeeID INT,
    @OldPassword VARCHAR(MAX),
    @NewPassword VARCHAR(MAX),
    @ConfirmPassword VARCHAR(MAX),
    @returnValue INT OUTPUT -- 1 for success, -1 if old pass and current pass don't match,
	-- -2 if new and confirm new pass don't match, -3 if size of pass is less than 4 or greater than 16,
	-- -4 if other error
AS
BEGIN
    DECLARE @temp INT;
    SET @temp = -4;
    BEGIN TRY
        BEGIN TRANSACTION
        -- Check if the new password and confirm password match
        DECLARE @actualOldPassword VARCHAR(MAX);
        SET @actualOldPassword = (SELECT Passwords FROM employees WHERE employeeNumber = @EmployeeID);

        IF (@actualOldPassword <> @OldPassword)
        BEGIN
            SET @temp = -1;
            RAISERROR('old pass is not correct', 16, 1);
        END;

        IF (@NewPassword <> @ConfirmPassword)
        BEGIN
            SET @temp = -2;
            RAISERROR('New password and confirm password do not match.', 16, 1);
        END;

        DECLARE @passwordLength INT;
        SET @passwordLength = LEN(@NewPassword);

        IF (@passwordLength < 4 OR @passwordLength > 16)
        BEGIN
            SET @temp = -3;
            RAISERROR('Password size must be at least 4 and at most 16 characters', 16, 1);
        END;

        UPDATE employees
        SET Passwords = @NewPassword
        WHERE employeeNumber = @EmployeeID
          AND Passwords = @OldPassword;

        SET @returnValue = 1;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        SET @returnValue = @temp;
        ROLLBACK TRANSACTION;
        RETURN;
    END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[CheckQuantity]    Script Date: 1/21/2024 11:29:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[CheckQuantity]
@orderproducts selectedItems READONLY,
@InvalidQuantities int OUTPUT
as
begin
	set @InvalidQuantities = (select count(*)
	from @orderproducts as o, products as p
	where o.productCode = p.productCode and quantity - quantityInStock > 0)
end
GO
/****** Object:  StoredProcedure [dbo].[deleteCustomer]    Script Date: 1/21/2024 11:29:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[deleteCustomer]
@customerNumber int
as
begin
declare @InProcessOrder int;
declare deletingInProcessOrders cursor for
select orderNumber from orders where customerNumber = @customerNumber and (status = 'In Process' or status = 'On Hold');
open deletingInProcessOrders;
fetch next from deletingInProcessOrders into @InProcessOrder;
while @@FETCH_STATUS = 0
begin
	exec removeProductsFromOrderDetails @orderNumber = @InProcessOrder;
	fetch next from deletingInProcessOrders into @InProcessOrder;
end
delete from orderdetails where orderNumber in (select distinct orderNumber from orders
where customerNumber = @customerNumber)
delete from payments where customerNumber = @customerNumber;
delete from orders where customerNumber = @customerNumber;
delete from customers where customerNumber = @customerNumber;
end
GO
/****** Object:  StoredProcedure [dbo].[displayOrderItems]    Script Date: 1/21/2024 11:29:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[displayOrderItems]
@orderNumber int
as
begin
	select productCode, quantityOrdered as quantity, priceEach as Price
	from orderdetails
	where orderNumber = @orderNumber
	order by orderLineNumber;
end
GO
/****** Object:  StoredProcedure [dbo].[editOrder]    Script Date: 1/21/2024 11:29:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[editOrder]
@orderProducts selectedItems readonly,
@orderNumber int,
@customerNumber int,
@requiredDate date,
@status varchar(max),
@comment text,
@returnValue int output
as
begin
	begin transaction;
	declare @temp int;
	declare @oldstatus varchar(max)
	set @oldstatus = (select status from orders where orderNumber = @orderNumber);
	if(@requiredDate < GETDATE())
	begin
		set @returnValue = -1;
		rollback;
		raiserror('date must be a valid date',16,1);
		return;
	end
	if(@oldstatus <> 'On Hold' and @oldstatus <> 'Requested' and @oldstatus <> 'In Process')
	begin
		set @returnValue = -1;
		rollback;
		raiserror('order is not On hold, Requested or in process',16,1);
		return;
	end
	if(@oldstatus <> 'Requested')
	begin
		exec removeProductsFromOrderDetails @orderNumber = @orderNumber;
	end
	else
	begin
		delete from orderdetails where orderNumber = @orderNumber;
	end;

	exec CheckQuantity @orderProducts = @orderProducts, @InvalidQuantities = @temp output;


	if (@temp != 0 and @status <> 'Requested')
	begin
		set @returnValue = -1;
		rollback;
		raiserror('Quantity Not Enough',16,1);
		return;
	end;
	update orders set status = @status where orderNumber = @orderNumber;
	exec addTableToProductDetails @orderProducts = @orderProducts, @orderNumber = @orderNumber;
	update orders set orderDate = GETDATE(), requiredDate = @requiredDate, status = @status, comments = @comment 
	where orderNumber = @orderNumber;
	if(@status = 'In Process')
	begin
	set @returnValue = 1;
	end
	else
	begin
	set @returnValue = 0;
	end;
	commit;
end
GO
/****** Object:  StoredProcedure [dbo].[fromRequestedToInProcess]    Script Date: 1/21/2024 11:29:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[fromRequestedToInProcess]
@orderNumber int
as
begin
	declare @status varchar(max);
	set @status = (select status from orders where orderNumber = @orderNumber)
	if (@status <> 'Requested')
	begin
		raiserror('the order is not set to be "Requested"',18,1);
	end;
	else
	begin
	declare @temp int;
	set @temp = (select min(quantityInStock - quantityOrdered) from products, orderdetails 
	where products.productCode = orderdetails.productCode and orderNumber = @orderNumber);
	if (@temp < 0)
	begin
		raiserror('Cannot process due to quantity in stock not available',18,2);
	end;
	else
	begin
	update orders set status = 'In Process' where orderNumber = @orderNumber;
	update products set quantityInStock = quantityInStock - quantityOrdered from products, orderdetails
	 where products.productCode = orderdetails.productCode and orderdetails.orderNumber = @orderNumber;
	end;
	end;
end
GO
/****** Object:  StoredProcedure [dbo].[payByCheck]    Script Date: 1/21/2024 11:29:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[payByCheck]
@customerNumber int,
@checkNumber varchar(max),
@amount decimal(10,2)
as
begin
insert into payments values (@customerNumber, @checkNumber, GETDATE(), @amount);
update customers set creditLimit = creditLimit + @amount where customerNumber = @customerNumber;
end
GO
/****** Object:  StoredProcedure [dbo].[removeProductsFromOrderDetails]    Script Date: 1/21/2024 11:29:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[removeProductsFromOrderDetails]
@orderNumber int
as
begin
	update products set quantityInStock = quantityInStock + quantityOrdered
	from products
	inner join orderdetails on products.productCode =orderdetails.productCode
	where  orderNumber = @orderNumber;

	delete from orderdetails where orderNumber = @orderNumber;
end


GO
/****** Object:  StoredProcedure [dbo].[shipOrder]    Script Date: 1/21/2024 11:29:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[shipOrder]
@orderNumber int,
@returnValue int output
as
begin
declare @total decimal(10,2);
declare @customerNumber int;
set @total = (select sum(priceEach * quantityOrdered) from orderdetails where orderNumber = @orderNumber);
declare @creditLimit decimal(10,2);
set @customerNumber = (select customerNumber from orders where orderNumber = @orderNumber);
set @creditlimit = ISNULL((select creditLimit from customers where customerNumber = @customerNumber),0.00);
if @creditLimit > @total
begin
update customers set creditLimit = @creditLimit - @total where customerNumber = @customerNumber;
update orders set status = 'Shipped', shippedDate = GETDATE() where orderNumber = @orderNumber;
set @returnValue = 1;
end
else
begin
update orders set status = 'On Hold' where orderNumber = @orderNumber;
set @returnValue = 0;
end
end


GO
/****** Object:  StoredProcedure [dbo].[ShowTableData]    Script Date: 1/21/2024 11:29:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ShowTableData]
    @TableName NVARCHAR(MAX)
AS
BEGIN
    DECLARE @SqlQuery NVARCHAR(MAX);
    SET @SqlQuery = 'SELECT * FROM ' + @TableName;
    EXEC sp_executesql @SqlQuery;
END;
GO
/****** Object:  StoredProcedure [dbo].[sortByCountry]    Script Date: 1/21/2024 11:29:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sortByCountry]
@country varchar(MAX),
@searchvalue varchar(MAX)
as
begin
	select * from customers
	where country like @country and
	((CAST(customerNumber as varchar(MAX)) like '%'+@searchvalue+'%') or (customerName like '%'+@searchvalue+'%') 
	or (contactFirstName like '%'+@searchvalue+'%') or (contactLastName like '%'+@searchvalue+'%'));
end

GO
/****** Object:  StoredProcedure [dbo].[sortByOrderStatus]    Script Date: 1/21/2024 11:29:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sortByOrderStatus]
@status varchar(MAX),
@searchvalue varchar(MAX)
as
begin
	select * from ordervision
	where status like @status and ((CAST(customerNumber as varchar(MAX)) like '%'+@searchvalue+'%') 
	or (customerName like '%'+@searchvalue+'%') or (cast(orderNumber as varchar(max)) like '%' + @searchvalue + '%'));
end
GO
/****** Object:  StoredProcedure [dbo].[sortByProductLine]    Script Date: 1/21/2024 11:29:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[sortByProductLine]
@search varchar(max),
@productLine varchar(max)
as
begin
declare @searchingFor varchar(max);
set @searchingFor = '%' + @search + '%';
select * from products where (productLine like @productLine and (productCode like @searchingFor 
or productName like @searchingFor));
end
GO
/****** Object:  StoredProcedure [dbo].[UpdateProductQuantityArrival]    Script Date: 1/21/2024 11:29:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateProductQuantityArrival]
    @productCode varchar(15),
    @quantityArrived smallint
AS
BEGIN
        IF (EXISTS (SELECT 1 FROM products WHERE productCode = @productCode) and @quantityArrived > 0)
        BEGIN
            UPDATE products
            SET quantityInStock = quantityInStock + @quantityArrived
            WHERE productCode = @productCode;
        END
END;
GO
